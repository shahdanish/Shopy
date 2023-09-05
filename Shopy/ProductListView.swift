
import SwiftUI

struct ProductListView: View {
    @State private var searchText = ""
    @State private var isFiltering = false
    @State private var products: [Product] = [] // Your product data
    @State private var isLoading = false
    @State private var showingDeleteConfirmation = false // Add this state variable
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var prodoductdocidtobedeleted = ""
    
    @Binding var currentView: NavigationViewType

    let authService = FirebaseAuthService()
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                return product.name.localizedCaseInsensitiveContains(searchText) ||
                    product.type.localizedCaseInsensitiveContains(searchText) ||
                    String(product.purchasePrice).localizedCaseInsensitiveContains(searchText) ||
                    String(product.salePrice).localizedCaseInsensitiveContains(searchText) ||
                    DateFormatter.localizedString(from: product.dateAdded, dateStyle: .short, timeStyle: .none).localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Products...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                        .padding()
                } else {
                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            isFiltering.toggle()
                        }) {
                            Image(systemName: isFiltering ? "xmark.circle.fill" : "slider.horizontal.3")
                        }
                        .padding()
                    }
                    
                    List(filteredProducts) { product in
                        // Display product information here
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text(product.type)
                                .font(.subheadline)
                            Text("Purchase Price: $\(product.purchasePrice)")
                                .font(.subheadline)
                            Text("Sale Price: $\(product.salePrice)")
                                .font(.subheadline)
                            Text("Date Added: \(DateFormatter.localizedString(from: product.dateAdded, dateStyle: .short, timeStyle: .none))")
                                .font(.subheadline)
                            Button(action: {
                                // Edit action
                                print("Edit clicked")
                            }) {
                                HStack {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 28))
                                    Text("Edit")
                                }
                                .foregroundColor(.blue)
                            }

                            Button(action: {
                                // Show delete confirmation
                                prodoductdocidtobedeleted = product.pId;
                                showingDeleteConfirmation.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.system(size: 28))
                                    Text("Delete")
                                }
                                .foregroundColor(.red)
                            }
                        }
                        .alert(isPresented: $showingDeleteConfirmation) {
                            Alert(
                                title: Text("Are you sure you want to delete this record?"),
                                message: Text("This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    // Perform the delete action here
                                    inactivateProduct(documentID: prodoductdocidtobedeleted) { success, error in
                                        isLoading = true
                                        // Fetch products from Firestore
                                        authService.fetchProducts { products, error in
                                            if let error = error {
                                                // Handle the error
                                                toastMessage = "Error fetching products: \(error.localizedDescription)"
                                                showToast(message: toastMessage, duration: 3)
                                            } else if let products = products {
                                                // Handle the products array
                                                self.products = products // Assign fetched products to the state
                                                isLoading = false // Set isLoading to false when done
                                                toastMessage = "Product inactivated successfully!"
                                                showToast(message: toastMessage, duration: 3)
                                            }
                                        }
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                    }
                }
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline) // Empty title
            .navigationBarItems(trailing:
                NavigationLink(destination: AddProductView(currentView: $currentView)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            )
            .onAppear {
                isLoading = true
                // Fetch products from Firestore
                authService.fetchProducts { products, error in
                    if let error = error {
                        // Handle the error
                        toastMessage = "Error fetching products: \(error.localizedDescription)"
                        showToast(message: toastMessage, duration: 3)
                    } else if let products = products {
                        // Handle the products array
                        self.products = products // Assign fetched products to the state
                        isLoading = false // Set isLoading to false when done
                        toastMessage = "Product inactivated successfully!"
                        showToast(message: toastMessage, duration: 3)
                    }
                }
            }
            //.navigationBarTitle("Dashboard", displayMode: .large)
            //.navigationBarHidden(false) // Hide the navigation bar
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

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(currentView: .constant(.listProduct)) // Pass the binding here
    }
}
