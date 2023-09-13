import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @Binding var currentView: NavigationViewType
    @State private var isKeepMeSignedIn = false // Add a state variable for "Keep me signed in"

    //@State private var redirectToDashboard = false
    let authService = FirebaseAuthService()
    
    var body: some View {
        
        ZStack {
            Color(
                red: Double(0xFF) / 255.0,
                green: Double(0xFC) / 255.0,
                blue: Double(0xF2) / 255.0
            ).edgesIgnoringSafeArea(.all)
           
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 10) // Adjust logo padding
                
                Text("Join millions of people using Knewald App every day to stay on top of global social media") // Add the title
                    .font(.system(size: 20)) // Increase font size to 20
                    .foregroundColor(Color(red: 0, green: 0, blue: 0)) // Black color
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 20) // Add space above and below the text
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(
                        red: Double(0xF9) / 255.0,
                        green: Double(0xF0) / 255.0,
                        blue: Double(0xD5) / 255.0
                    ))
                    .cornerRadius(0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color("YourBorderColor"), lineWidth: 1)
                    )
                    .foregroundColor(Color("YourTextColor"))
                    .font(.system(size: 16))
                    .padding(.horizontal)
                    .textFieldStyle(PlainTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(
                        red: Double(0xF9) / 255.0,
                        green: Double(0xF0) / 255.0,
                        blue: Double(0xD5) / 255.0
                    ))
                    .cornerRadius(0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color("YourBorderColor"), lineWidth: 1)
                    )
                    .foregroundColor(Color("YourTextColor"))
                    .font(.system(size: 16))
                    .padding(.horizontal)
                    .textFieldStyle(PlainTextFieldStyle())
                
                HStack {
                    Toggle("", isOn: $isKeepMeSignedIn)
                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                        .foregroundColor(Color(red: 0, green: 0, blue: 0))
                        .padding(.horizontal)
                    
                    Text("Keep me signed in")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0, green: 0, blue: 0))
                        .frame(maxWidth: .infinity, alignment: .leading) // Align the text to the left
                    
                    Button(action: {
                        // Add action for "Forgot password?"
                        // You can implement this logic
                    }) {
                        Text("Forgot password?")
                            .foregroundColor(Color(red: 0, green: 0, blue: 0))
                            .frame(maxWidth: .infinity, alignment: .leading) // Align the text to the left
                    }
                }
                .padding(.horizontal)
                
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
                    Text("Login") // Change button text to "Login"
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0, green: 0, blue: 0))
                        .cornerRadius(0) // Make the button sharp-edged
                }
                .padding()
                
                Spacer() // Add spacer at the bottom
                
                Text("Don’t have an account?") // "Don't have an account?" text
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0, green: 0, blue: 0))
                
                NavigationLink(destination: SignUpView(currentView: $currentView)) {
                    Text("Sign Up Now")
                        .font(Font.custom("Abhaya Libre Medium", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 343, height: 48)
                        .overlay(
                            Rectangle()
                                .inset(by: 0.5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                
                .padding(.bottom, 20)
            }
            .overlay(
                GeometryReader { geometry in
                    if showToast {
                        Text(toastMessage)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .transition(.slide)
                            .offset(x: 0, y: 0) // Adjust the Y offset as needed
                            .zIndex(1) // Bring the toast message to the front
                            .showToast(isShowing: $showToast, text: toastMessage, duration: 3)
                    }
                }
            )
        }
        
        //.padding()
        //.showToast(isShowing: $showToast, text: toastMessage, duration: 3)
        .background(
            NavigationLink("", destination: DashboardView(currentView: $currentView))
        )
        //.navigationBarTitle("Sign In")
        //.navigationBarHidden(true) // Hide the navigation bar
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
