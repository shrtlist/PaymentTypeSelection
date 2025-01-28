//
//  Model.swift
//  SwiftUIChallenge
//
//  Created by Marco Abundo on 1/18/25.
//

import SwiftUI
import Combine

@MainActor
class Model: ObservableObject {
    @Published var paymentTypes: [PaymentType] = []
    @Published var timerValue: Int
    var selectedPaymentType: PaymentType? = nil
    let processDurationInSeconds: Int = 60
    var repository: PaymentTypesRepository
    var cancellables: [AnyCancellable] = []
    var isLoading = false

    init(repository: PaymentTypesRepository = PaymentTypesRepositoryImplementation()) {
        self.timerValue = processDurationInSeconds
        self.repository = repository
    }

    func startTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timerValue > 0 {
                    self.timerValue -= 1
                }
            }
            .store(in: &cancellables)
    }

    func resetTimer() {
        timerValue = processDurationInSeconds
    }

    func fetchPaymentTypes() async {
        guard !isLoading else { return }
        isLoading = true

        repository.getTypes { result in
            self.isLoading = false
            switch result {
            case .success(let types):
                self.paymentTypes = types
            case .failure(let error):
                self.paymentTypes = []
                print("Error fetching payment types: \(error)")
            }
        }
    }
}
