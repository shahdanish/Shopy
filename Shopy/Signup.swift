import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI


class FirebaseAuthService {
    
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Validate email and password
        if isValidEmail(email) && isValidPassword(password) {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    completion(false, "Error creating user: \(error.localizedDescription)")
                } else {
                    completion(true, "User created successfully")
                }
            }
        } else {
            completion(false, "Please enter a valid email and password.")
        }
    }
    
    // Validation functions
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // Password should have at least 8 characters and contain at least two of the following: uppercase letters, lowercase letters, numbers, and symbols.
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d.*\\d)(?=.*[@#$%^&+=]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}


