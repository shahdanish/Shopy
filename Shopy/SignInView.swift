


import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @Binding var currentView: NavigationViewType
    
    //@State private var redirectToDashboard = false
    let authService = FirebaseAuthService()
    
    var body: some View {
        NavigationView {
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
                    Image("logo")
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
                                //redirectToDashboard = true
                                currentView = .dashboard
                            } else {
                                toastMessage = message ?? "An error occurred"
                                showToast(message: toastMessage, duration: 3)
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
            }
            .padding()
            //.showToast(isShowing: $showToast, text: toastMessage, duration: 3)
            .background(
                NavigationLink("", destination: DashboardView(currentView: $currentView))
            )
            //.navigationBarTitle("Sign In")
            //.navigationBarHidden(true) // Hide the navigation bar
        }
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


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(currentView: .constant(.signIn))
    }
}
