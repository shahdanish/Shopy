import SwiftUI

struct DashboardView: View {
    @State private var showToast = false
    @State private var toastMessage = ""
    @Binding var currentView: NavigationViewType
    @State private var products: [Product] = [] // Your product data
    let authService = FirebaseAuthService()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ProductListView(currentView: $currentView)) {
                    Text("Total Products: 45")
                        .font(.headline)
                }
                .padding()
            }
            .navigationBarTitle("Dashboard", displayMode: .large)
            .alert(isPresented: $showToast) {
                Alert(
                    title: Text("Message"),
                    message: Text(toastMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(currentView: .constant(.dashboard))
    }
}
