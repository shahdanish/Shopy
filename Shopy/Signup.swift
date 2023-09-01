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
}

