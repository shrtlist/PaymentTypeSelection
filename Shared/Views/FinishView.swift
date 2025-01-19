//
//  FinishView.swift
//  SwiftUIChallenge
//
//  Created by Marco Abundo on 1/18/25.
//

import SwiftUI

struct FinishView: View {
    @ObservedObject var model: Model

    var body: some View {
        Text("Congratulations")
            .onAppear {
                model.selectedPaymentType = nil
            }
    }
}
