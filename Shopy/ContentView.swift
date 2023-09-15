import SwiftUI

struct ContentView: View {
    @State private var currentView: NavigationViewType = .home
    
    var body: some View {
        ZStack{
            Color(.blue).ignoresSafeArea()
            NavigationView {
                HStack {
                    switch currentView {
                    case .home:
                        HomeView(currentView: $currentView)
                            .navigationBarBackButtonHidden(true)
                    case .signIn:
                        SignInView(currentView: $currentView)
                    case .dashboard:
                        DashboardView(currentView: $currentView)
                    case .signUp:
                        SignUpView(currentView: $currentView)
                    case .addProduct:
                        AddProductView(currentView: $currentView)
                    case .listProduct:
                        ProductListView(currentView: $currentView)
                    }
                }
                .navigationBarHidden(true) // Hide the navigation bar
            }
        }
        
    }
}

enum NavigationViewType {
    case home
    case signIn
    case dashboard
    case signUp
    case addProduct
    case listProduct
}

struct HomeView: View {
    @Binding var currentView: NavigationViewType
    @State private var showSignInView = false
    let authService = FirebaseAuthService()
    init(currentView: Binding<NavigationViewType>) {
        _currentView = currentView

        // Check for stored credentials
        if UserDefaults.standard.bool(forKey: "keepMeSignedIn"),
           let storedEmail = UserDefaults.standard.string(forKey: "storedEmail"),
           let storedPassword = UserDefaults.standard.string(forKey: "storedPassword") {
            // Automatically sign in the user using stored credentials
            authService.signIn(email: storedEmail, password: storedPassword, keepMeSignedIn: true) { success, message in
                if success {
                    currentView.wrappedValue = .dashboard
                }
            }
        } else {
            // Use Timer to navigate to SignInView after 2 seconds
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                currentView.wrappedValue = .signIn
            }
        }
    }


        var body: some View {
            NavigationView {
                ZStack {
                    // Splash screen with logo
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                        .opacity(showSignInView ? 0 : 1) // Show the logo for 2 seconds

                    // NavigationLink to SignInView
                    NavigationLink("", destination: SignInView(currentView: $currentView)
                                        .navigationBarBackButtonHidden(true), isActive: $showSignInView)
                                        .opacity(0) // Hide the NavigationLink visually

                    // Additional content (if any) for SignInView can be added here
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true) // Hide the navigation bar
            }
        }

}

// Other view structures go here, similarly updated with the currentView binding.
