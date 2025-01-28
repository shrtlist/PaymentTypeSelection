// Your task is to finish this application to satisfy requirements below and make it look like on the attached screenshots. Try to use 80/20 principle.
// Good luck! 🍀

// 1. Setup UI of the ContentView. Try to keep it as similar as possible.
// 2. Subscribe to the timer and count seconds down from 60 to 0 on the ContentView.
// 3. Present PaymentModalView as a sheet after tapping on the "Open payment" button.
// 4. Load payment types from repository in PaymentInfoView. Show loader when waiting for the response. No need to handle error.
// 5. List should be refreshable.
// 6. Show search bar for the list to filter payment types. You can filter items in any way.
// 7. User should select one of the types on the list. Show checkmark next to the name when item is selected.
// 8. Show "Done" button in navigation bar only if payment type is selected. Tapping this button should hide the modal.
// 9. Show "Finish" button on ContentScreen only when "payment type" was selected.
// 10. Replace main view with "FinishView" when user taps on the "Finish" button.

import SwiftUI

struct ContentView: View {
    @StateObject private var model = Model()
    @State var showPaymentModal = false
    @State var showFinishModal = false

    var body: some View {
        VStack {
            Spacer()

            // Seconds should count down from 60 to 0
            Text("You have only \(model.timerValue) seconds left to get the discount")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            VStack {
                Button("Open payment") {
                    showPaymentModal = true
                }
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity, maxHeight: 44.0)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(.horizontal, 10)

                if model.selectedPaymentType != nil {
                    // Visible only if payment type is selected
                    Button("Finish") {
                        showFinishModal = true
                    }
                    .buttonStyle(.borderless)
                    .frame(maxWidth: .infinity, maxHeight: 44.0)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.horizontal, 10)
                }
            }
            .padding(.bottom, 44.0)
        }
        .background(Color.blue.edgesIgnoringSafeArea(.all))
        .onAppear {
            model.startTimer()
        }
        .sheet(isPresented: $showPaymentModal) {
            PaymentModalView(model: model, onSelect: { selectedType in
                model.selectedPaymentType = selectedType
                showPaymentModal = false
            })
        }
        .sheet(isPresented: $showFinishModal, onDismiss: {
            model.resetTimer()
        }) {
            FinishView(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
