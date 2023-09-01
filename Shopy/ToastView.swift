import SwiftUI
struct ToastView<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    let text: String
    let duration: TimeInterval // Duration in seconds
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                self.presenting()

                VStack {
                    Text(self.text)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .transition(.slide)
                        .opacity(isShowing ? 1 : 0)
                        //.animation(.easeInOut(duration: 0.4))
                }
                .frame(width: geometry.size.width)
            }
        }
        .onAppear {
            // Use a Timer to automatically hide the toast after the specified duration
            if isShowing {
                Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
                    withAnimation {
                        self.isShowing = false
                    }
                }
            }
        }
    }
}

extension View {
    func showToast(isShowing: Binding<Bool>, text: String, duration: TimeInterval) -> some View {
        ToastView(isShowing: isShowing, presenting: { self }, text: text, duration: duration)
    }
}
