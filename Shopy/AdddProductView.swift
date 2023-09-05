import SwiftUI

struct AddProductView: View {
    @State private var productName = ""
    @State private var productType = ""
    @State private var purchasePrice = ""
    @State private var salePrice = ""
    @State private var dateAdded = Date()
    @State private var isShowingDatePicker = false
    @State private var showToast = false
     @State private var toastMessage = ""
    // Inject your FirebaseAuthService instance here
    let authService = FirebaseAuthService()
    // Presentation mode environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentView: NavigationViewType

    var body: some View {
        Form {
            Section(header: Text("Product Information")) {
                TextField("Product Name", text: $productName)
                TextField("Product Type", text: $productType)
                TextField("Purchase Price", text: $purchasePrice)
                    .keyboardType(.decimalPad)
                TextField("Sale Price", text: $salePrice)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Date Added")) {
                DatePicker(
                    "Select Date",
                    selection: $dateAdded,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .onTapGesture {
                    isShowingDatePicker.toggle()
                }
            }
        }
        .navigationBarTitle("Add Product", displayMode: .inline)
        .navigationBarItems(
            trailing: Button("Save") {
                // Validate and save the product data here
                // You can use the values from @State variables like productName, productType, etc.
                if let purchasePriceDouble = Double(purchasePrice),
                                   let salePriceDouble = Double(salePrice) {
                                    authService.saveProduct(
                                        productName: productName,
                                        productType: productType,
                                        purchasePrice: purchasePriceDouble,
                                        salePrice: salePriceDouble,
                                        dateAdded: Date()
                                    ) { success, message in
                                        if success {
                                            // Product added successfully, show a success toast
                                            showToast = true
                                            toastMessage = "Product added successfully"
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            // Product addition failed, show an error toast
                                            showToast = true
                                            toastMessage = message ?? "An error occurred"
                                        }
                                    }
                                } else {
                                    // Handle input validation errors here
                                    showToast = true
                                    toastMessage = "Invalid input data"
                                }
                // After saving, you can navigate back to the dashboard or perform other actions.
            }
        )
        .sheet(isPresented: $isShowingDatePicker) {
            // This is for displaying the date picker in a sheet when tapped.
            // You can customize the appearance and behavior of the date picker here.
            DatePicker(
                "Select Date",
                selection: $dateAdded,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
        }
        .showToast(isShowing: $showToast, text: toastMessage, duration: 3)
        //.navigationBarTitle("Sign Up")
        //.navigationBarHidden(true) // Hide the navigation bar
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
       
        AddProductView(currentView: .constant(.addProduct))
    }
}
