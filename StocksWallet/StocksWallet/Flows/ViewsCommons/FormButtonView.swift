//
//  ConfirmationButtonView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 18/04/23.
//

import SwiftUI

struct FormButtonView: View {
    struct Info {
        var title: String
        var alertTitle: String
        var alertMessage: String
        var action: () -> Void
    }
    @Binding var confirmationAlert: Bool
    var info: Info
    var body: some View {
        HStack {
            Button(action: {
                confirmationAlert = !confirmationAlert
            }, label: {
                Text(info.title)
                    .frame(minWidth: 300.0,
                           alignment: .center)
                    .padding(8.0)
            })
            .buttonStyle(.borderedProminent)
            .padding(24.0)
        }
        .alert(info.alertTitle, isPresented: $confirmationAlert) {
            Button(info.title) {
                info.action()
            }
            Button("NO", role: .cancel) {}
        } message: {
            Text(info.alertMessage)
        }
    }
}

struct ConfirmationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FormButtonView(confirmationAlert: .constant(false),
                               info: FormButtonView
            .Info(title: "CREATE WALLET",
                  alertTitle: "Confirm?",
                  alertMessage: "Create wallet named",
                  action: {}))
    }
}
