import SwiftUI

struct DashboardView: View {
    @State private var showToast = false
    @State private var toastMessage = ""
    @Binding var currentView: NavigationViewType
    @State private var productCount: Int = 0 // Store the product count
    let authService = FirebaseAuthService()

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                HStack(spacing: 20) {
                    NavigationLink(destination: ProductListView(currentView: $currentView)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue)
                                .frame(width: 150, height: 150)
                                .shadow(radius: 5)
                            
                            VStack(spacing: 8) { // Adjust the spacing between icon and text
                                Image(systemName: "cube.box.fill") // Product icon
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("Total Products")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(productCount)")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .onAppear {
                        // Fetch product count when the view appears
                        fetchProductCount()
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green)
                            .frame(width: 150, height: 150)
                            .shadow(radius: 5)
                        
                        VStack(spacing: 8) { // Adjust the spacing between icon and text
                            Image(systemName: "cart.fill") // Orders icon
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("Total Orders")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(productCount)") // Replace with actual order count
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }

                    // Add more squares as needed
                }
                .padding()

                
            }


            .navigationBarTitle("Dashboard", displayMode: .inline)
            .alert(isPresented: $showToast) {
                Alert(
                    title: Text("Message"),
                    message: Text(toastMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func fetchProductCount() {
        authService.getProductCount { count, error in
            if let error = error {
                // Handle the error
                self.toastMessage = "Error fetching product count: \(error.localizedDescription)"
                self.showToast.toggle()
            } else {
                // Update the product count
                self.productCount = count
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(currentView: .constant(.dashboard))
    }
}
