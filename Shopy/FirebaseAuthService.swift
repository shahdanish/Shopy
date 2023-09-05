import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

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
            completion: @escaping (Bool, String?) -> Void
        ) {
            let db = Firestore.firestore()
            
            // Create a new product document with a generated ID
            if let user = Auth.auth().currentUser {
                let ref = db.collection("products").addDocument(data: [
                    "productName": productName,
                    "productType": productType,
                    "purchasePrice": purchasePrice,
                    "salePrice": salePrice,
                    "dateAdded": dateAdded,
                    "userId": user.uid, // Include the user's UID
                    "isActive" : true
                ]) { error in
                    if let error = error {
                        // Handle the error, e.g., display a toast message
                        completion(false, "Error saving product: \(error.localizedDescription)")
                    } else {
                        // Document added successfully, you can display a success message
                        completion(true, "Product saved successfully")
                    }
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
                               let pId = document.documentID as? String,
                               let dateAddedTimestamp = productData["dateAdded"] as? Timestamp {
                                
                                let dateAdded = dateAddedTimestamp.dateValue()
                                let product = Product(name: productName, type: productType, purchasePrice: purchasePrice, salePrice: salePrice, dateAdded: dateAdded, pId : pId, isActive : true)
                                
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
