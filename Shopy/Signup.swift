import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseAuthService {
    static func signUp(username: String, pass: String, email: String, agreedToTerms: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        guard agreedToTerms else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please agree to the terms before signing up"])))
            return
        }

        let userDocument = Firestore.firestore().collection("Users").document()

        userDocument.setData([
            "username": username,
            "email": email,
            "agreetoterms": true,
            "password": pass
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added to Firestore")
                // Perform any navigation or success action here
            }
        }

    }
}
