import SwiftUI

struct ContentView: View {
    @State private var currentView: NavigationViewType = .home
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentView {
                case .home:
                    HomeView(currentView: $currentView)
                case .signIn:
                    SignInView(currentView: $currentView)
                case .dashboard:
                    DashboardView(currentView: $currentView)
                case .signUp:
                    SignUpView(currentView: $currentView)
                case .addProduct:
                    AddProductView(currentView: $currentView)
                case .listProduct:
                    AddProductView(currentView: $currentView)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: BreadcrumbNavigationView(currentView: $currentView)
            )
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
                Text("Homepage")
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
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo") // Replace "ShopyLogo" with your logo image asset name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: SignInView(currentView: $currentView)) {
                    Text("Sign In")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                NavigationLink(destination: SignUpView(currentView: $currentView)) {
                    Text("Create Account")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        //.navigationBarTitle("Homepage")
        //.navigationBarHidden(true) // Hide the navigation bar
    }
}

// Other view structures go here, similarly updated with the currentView binding.

