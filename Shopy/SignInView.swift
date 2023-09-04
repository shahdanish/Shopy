
import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var redirectToDashboard = false
    let authService = FirebaseAuthService()
    
    var body: some View {
        NavigationView {
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
                
                Button(action: {
                    authService.signIn(email: self.email, password: self.password) { success, message in
                        if success {
                            // Redirect to the dashboard page
                            redirectToDashboard = true
                        } else {
                            toastMessage = message ?? "An error occurred"
                            showToast = true
                        }
                    }
                }) {
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
            .showToast(isShowing: $showToast, text: toastMessage, duration: 3)
            .background(
                NavigationLink("", destination: DashboardView(), isActive: $redirectToDashboard)
            )
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
