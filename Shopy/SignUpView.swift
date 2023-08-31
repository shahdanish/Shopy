import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Image("your_logo_image")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 30)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: signUpButtonTapped) {
                Text("Sign Up")
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
    
    func signUpButtonTapped() {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                // Show an alert with the error message
            } else {
                print("User created successfully")
                // Show an alert for successful registration
                // You can also navigate to another screen here
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
