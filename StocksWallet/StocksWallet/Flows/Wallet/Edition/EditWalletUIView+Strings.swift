//
//  CreateWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 16/04/23.
//

import SwiftUI

extension EditWalletUIView: StringsView {
    enum Strings: String, RawRepresentable {
        enum Fields: String, RawRepresentable {
            case name = "Name"
            case nameDesc = "Enter wallet name"
            case information = "Information"
            case informationDesc = "Enter some information"
            case broker = "Broker"
            case amount = "Amount Target Goal"
            case principal = "Is Principal?"
            case principalDesc = "Is Principal"
            case type = "Type"
        }
        case buttonTitle = "SAVE WALLET"
        case alertTitle = "Confirm?"
        case alertDesc = "Edit wallet named"
        case title = "Edit Wallet"
    }
}
