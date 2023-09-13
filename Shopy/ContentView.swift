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
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: BreadcrumbNavigationView(currentView: $currentView)
                )
            }
        }
        
    }
}

struct BreadcrumbNavigationView: View {
    @Binding var currentView: NavigationViewType
    
    var body: some View {
        HStack {
            Button(action: {
                currentView = .home
            }) {
                Text("")
            }
            .opacity(currentView == .home ? 0.5 : 1.0)
            
            if currentView != .home {
                Spacer()
                Image(systemName: "chevron.right")
                Spacer()
                
                Button(action: {
                    currentView = .signIn
                }) {
                    Text("SignIn")
                }
                .opacity(currentView == .signIn ? 0.5 : 1.0)
            }
            
            if currentView == .dashboard {
                Spacer()
                Image(systemName: "chevron.right")
                Spacer()
                
                Button(action: {
                    // You can add actions for further breadcrumbs here
                }) {
                    Text("Dashboard")
                }
                .opacity(currentView == .dashboard ? 0.5 : 1.0)
            }
        }
        .foregroundColor(.blue)
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

        var body: some View {
            NavigationView {
                ZStack {
                    // Splash screen with logo
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                        .onAppear {
                            // Use Timer to navigate to SignInView after 4 seconds
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                                showSignInView = true
                            }
                        }
                        .opacity(showSignInView ? 0 : 1) // Show the logo for 4 seconds

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
