//
//  PaymentModalView.swift
//  SwiftUIChallenge
//
//  Created by Marco Abundo on 1/18/25.
//

import SwiftUI

struct PaymentModalView : View {
    @ObservedObject var model: Model
    let onSelect: (PaymentType) -> Void

    var body: some View {
        NavigationView {
            VStack {
                PaymentInfoView(model: model, onSelect: onSelect)
            }
        }
    }
}
