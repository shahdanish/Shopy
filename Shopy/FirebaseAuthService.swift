import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import FirebaseStorage


class FirebaseAuthService {
    
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Validate email and password
        let emailValidationErrors = validateEmail(email)
        let passwordValidationErrors = validatePassword(password)
        
        if emailValidationErrors.isEmpty && passwordValidationErrors.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    completion(false, "Error creating user: \(error.localizedDescription)")
                } else {
                    completion(true, "User created successfully")
                }
            }
        } else {
            var errorMessage = ""
            if !emailValidationErrors.isEmpty {
                errorMessage += emailValidationErrors.joined(separator: "\n")
            }
            if !passwordValidationErrors.isEmpty {
                if !emailValidationErrors.isEmpty {
                    errorMessage += "\n"
                }
                errorMessage += passwordValidationErrors.joined(separator: "\n")
            }
            completion(false, errorMessage)
        }
    }
    
    // Validation functions
    func validateEmail(_ email: String) -> [String] {
        var validationErrors: [String] = []
        
        // Email should match the regex pattern
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            validationErrors.append("Invalid email format.")
        }
        
        // Add more email validation checks here as needed
        
        return validationErrors
    }
    
    func validatePassword(_ password: String) -> [String] {
        var validationErrors: [String] = []
        
        // Password should have at least 8 characters
        if password.count < 8 {
            validationErrors.append("Password should have at least 8 characters.")
        }
        
        // Check for uppercase letter
        if !password.contains { $0.isUppercase } {
            validationErrors.append("Password should contain at least one uppercase letter.")
        }
        
        // Check for lowercase letter
        if !password.contains { $0.isLowercase } {
            validationErrors.append("Password should contain at least one lowercase letter.")
        }
        
        // Check for at least two digits
        let digitCount = password.filter { $0.isNumber }.count
        if digitCount < 2 {
            validationErrors.append("Password should contain at least two digits.")
        }
        
        // Check for symbols
        if !password.contains { "@#$%^&+=".contains($0) } {
            validationErrors.append("Password should contain at least one symbol: @#$%^&+=")
        }
        
        return validationErrors
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { (authResult, error) in
                if let error = error {
                    completion(false, "Error signing in: \(error.localizedDescription)")
                } else {
                    completion(true, "User signed in successfully")
                }
            }
        }
    
    func saveProduct(
        productName: String,
        productType: String,
        purchasePrice: Double,
        salePrice: Double,
        dateAdded: Date,
        image: UIImage,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let db = Firestore.firestore()
        
        // Check if a user is authenticated
        if let user = Auth.auth().currentUser {
            // Convert UIImage to Data
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                completion(false, "Failed to convert image to data")
                return
            }

            // Create a reference to the Firestore collection where you want to store the product
            let storageRef = Storage.storage().reference()
            let imageFileName = UUID().uuidString // Generate a unique filename for the image
            let imageRef = storageRef.child("product_images/\(imageFileName).jpg")

            // Upload the image data to Firestore
            imageRef.putData(imageData, metadata: nil) { (_, error) in
                if let uploadError = error {
                    completion(false, "Error uploading image: \(uploadError.localizedDescription)")
                } else {
                    // Image uploaded successfully, now get the download URL
                    imageRef.downloadURL { (url, urlError) in
                        if let urlError = urlError {
                            completion(false, "Error getting image URL: \(urlError.localizedDescription)")
                        } else if let imageURL = url {
                            // User is authenticated, save the product data
                            let data: [String: Any] = [
                                "productName": productName,
                                "productType": productType,
                                "purchasePrice": purchasePrice,
                                "salePrice": salePrice,
                                "dateAdded": dateAdded,
                                "userId": user.uid, // Include the user's UID
                                "isActive": true,
                                "imageURL": imageURL.absoluteString // Store the image URL as a string
                            ]
                            
                            db.collection("products").addDocument(data: data) { documentError in
                                if let documentError = documentError {
                                    completion(false, "Error saving product: \(documentError.localizedDescription)")
                                } else {
                                    completion(true, "Product saved successfully")
                                }
                            }
                        } else {
                            completion(false, "Image URL is not available")
                        }
                    }
                }
            }

        } else {
            // User is not authenticated
            completion(false, "User is not authenticated. Please sign in.")
        }
    }

    func getProductCount(completion: @escaping (Int, Error?) -> Void) {
        let db = Firestore.firestore()
        
        // Get the current user (ensure the user is authenticated)
        guard let user = Auth.auth().currentUser else {
            // User is not authenticated, handle accordingly
            completion(0, AuthError.notAuthenticated)
            return
        }
        
        // Query the 'products' collection for the current user and count the documents
        db.collection("products")
            .whereField("userId", isEqualTo: user.uid) // Ensure products belong to the current user
            .whereField("isActive", isEqualTo: true)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    // Handle the error
                    completion(0, error)
                } else {
                    // Get the count of documents in the snapshot
                    let productCount = snapshot?.documents.count ?? 0
                    completion(productCount, nil)
                }
            }
    }
    
    func fetchProducts(completion: @escaping ([Product]?, Error?) -> Void) {
            let db = Firestore.firestore()
            
            // Get the current user (ensure the user is authenticated)
            guard let user = Auth.auth().currentUser else {
                // User is not authenticated, handle accordingly
                completion(nil, AuthError.notAuthenticated)
                return
            }

            // Query the 'products' collection for the current user
            db.collection("products")
                .whereField("userId", isEqualTo: user.uid) // Ensure products belong to the current user
                .whereField("isActive", isEqualTo: true)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        // Handle the error
                        completion(nil, error)
                    } else {
                        var products = [Product]()
                        for document in snapshot!.documents {
                            if let productData = document.data() as? [String: Any],
                               let productName = productData["productName"] as? String,
                               let productType = productData["productType"] as? String,
                               let purchasePrice = productData["purchasePrice"] as? Double,
                               let salePrice = productData["salePrice"] as? Double,
                               let imageURL = productData["imageURL"] as? String,
                               let pId = document.documentID as? String,
                               let dateAddedTimestamp = productData["dateAdded"] as? Timestamp {
                                
                                let dateAdded = dateAddedTimestamp.dateValue()
                                let product = Product(name: productName, type: productType, purchasePrice: purchasePrice, salePrice: salePrice, dateAdded: dateAdded, pId : pId, isActive : true, imageURL : imageURL)
                                
                                products.append(product)
                            }
                        }
                        completion(products, nil)
                    }
                }
        }
}
enum AuthError: Error {
    case notAuthenticated
}

func inactivateProduct(documentID: String, completion: @escaping (Bool, Error?) -> Void) {
    let db = Firestore.firestore()
    let productsRef = db.collection("products").document(documentID)

    // Update the 'isActive' field to false to mark the product as inactive
    productsRef.updateData([
        "isActive": false
    ]) { error in
        if let error = error {
            completion(false, error)
        } else {
            completion(true, nil)
        }
    }
}
