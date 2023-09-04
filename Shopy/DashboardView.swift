import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    @State private var isFiltering = false
    @State private var products: [Product] = [] // Your product data
    @State private var isLoading = false
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
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Welcome to the Dashboard!")
                        .font(.largeTitle)
                        .padding()

                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {
                            isFiltering.toggle()
                        }) {
                            Image(systemName: isFiltering ? "xmark.circle.fill" : "slider.horizontal.3")
                        }
                    }
                    .padding()

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
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Dashboard", displayMode: .large)
            .navigationBarItems(trailing:
                NavigationLink(destination: AddProductView()) {
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
                        print("Error fetching products: \(error.localizedDescription)")
                    } else if let products = products {
                        // Handle the products array
                        self.products = products // Assign fetched products to the state
                        isLoading = false // Set isLoading to false when done
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

