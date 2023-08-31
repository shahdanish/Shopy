import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("Sign In", destination: SignInView())
                    .font(.headline)
                NavigationLink("Create Account", destination: SignUpView())
                    .font(.headline)
            }
            .navigationBarTitle("Authentication")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

