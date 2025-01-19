//
//  PaymentInfoView.swift
//  SwiftUIChallenge
//
//  Created by Marco Abundo on 1/18/25.
//
import SwiftUI

struct PaymentInfoView: View {
    @ObservedObject var model: Model
    @State var paymentTypes: [PaymentType] = []
    @State private var searchText = ""
    let onSelect: (PaymentType) -> Void

    init(model: Model, onSelect: @escaping (PaymentType) -> Void) {
        self.model = model
        self.onSelect = onSelect
    }

    var body: some View {
        // Load payment types when presenting the view. Repository has 2 seconds delay.
        // User should select an item.
        // Show checkmark in a selected row.
        //
        // No need to handle error.
        // Use refreshing mechanism to reload the list items.
        // Show loader before response comes.
        // Show search bar to filter payment types
        //
        // Finish button should be only available if user selected payment type.
        // Tapping on Finish button should close the modal.

        Group {
            if model.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                List(searchResults, id: \ .id) { paymentType in
                    HStack {
                        Text(paymentType.name)
                        Spacer()
                        if let selectedPaymentType = model.selectedPaymentType {
                            if selectedPaymentType.id == paymentType.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }.onTapGesture {
                        model.selectedPaymentType = paymentType
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Payment info")
        .navigationBarItems(trailing: Button("Finish") {
            guard let paymentType = model.selectedPaymentType else { return }
            onSelect(paymentType)
        }
            .disabled(model.selectedPaymentType == nil)
        )
        .onAppear() {
            Task {
                paymentTypes = try await model.fetchPaymentTypes()
            }
        }
        .refreshable {
            Task {
                paymentTypes = try await model.fetchPaymentTypes()
            }
        }
    }

    var searchResults: [PaymentType] {
        let contactAddresses = paymentTypes

        if searchText.isEmpty {
            return contactAddresses
        } else {
            return contactAddresses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
