import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Dashboard!")
                    .font(.largeTitle)
                    .padding()
                
                // Add more content to your dashboard as needed
                
                Spacer()
            }
            .navigationBarTitle("Dashboard", displayMode: .large)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
