import SwiftUI
import Firebase

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Image("Logo.png")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 30)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: signInButtonTapped) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    
    func signInButtonTapped() {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                // Show an alert with the error message
            } else {
                print("User signed in successfully")
                // Show an alert or navigate to another screen
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

