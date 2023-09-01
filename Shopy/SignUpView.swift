import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    let authService = FirebaseAuthService()
    
    var body: some View {
        ZStack{
            if showToast {
                Text(toastMessage)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .transition(.slide)
                    .showToast(isShowing: $showToast, text: toastMessage, duration: 3)
            }
            
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
                    authService.signUp(email: self.email, password: self.password) { success, message in
                        if success {
                            showToast(message: "User created successfully!", duration: 3)
                        } else {
                            //showToast = true
                            toastMessage = message ?? "An error occurred"
                            showToast(message: toastMessage, duration: 3)
                        }
                    }
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
            }
        }
        .padding()
        //.showToast(isShowing: $showToast, text: toastMessage, duration: 3)
        
        
    }
    private func showToast(message: String, duration: TimeInterval) {
        toastMessage = message
        showToast = true
        
        // Automatically hide the toast after the specified duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                showToast = false
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
