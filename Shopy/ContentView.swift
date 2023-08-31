import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var retypePassword = ""
    @State private var email = ""
    @State private var agreedToTerms = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 100, height: 100)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                SecureField("Retype Password", text: $retypePassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Toggle(isOn: $agreedToTerms) {
                    Text("Agree to terms")
                }
                
                Button(action: {
                    // Handle sign up action
                    FirebaseAuthService.signUp(username: username, pass : password, email: email, agreedToTerms: agreedToTerms) { result in
                            switch result {
                            case .success(let documentID):
                                print("Document added with ID: \(documentID)")
                                // Perform any navigation or success action here
                            case .failure(let error):
                                print("Error adding document: \(error)")
                                // Handle the error, e.g., show an alert to the user
                            }
                        }
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
                .disabled(!agreedToTerms)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
