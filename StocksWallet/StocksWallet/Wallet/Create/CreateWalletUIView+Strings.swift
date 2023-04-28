//
//  CreateWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 16/04/23.
//

import SwiftUI

// TODO: Move to file 
protocol StringsView {
    func str(_ value: any RawRepresentable<String>) -> String
}

extension StringsView {
    func str(_ value: any RawRepresentable<String>) -> String {
        return value.rawValue
    }
}

extension CreateWalletUIView: StringsView {
    enum Strings: String, RawRepresentable {
        enum Fields: String, RawRepresentable {
            case name = "Name"
            case nameDesc = "Enter wallet name"
            case information = "Information"
            case informationDesc = "Enter some information"
            case broker = "Broker"
            case brokerCreate = "Create a new Broker"
            case brokerInfo = "To new broker creation"
            case amount = "Amount Target Goal"
            case principal = "Is Principal?"
            case principalDesc = "Is Principal"
            case type = "Type"
        }
        case buttonTitle = "CREATE WALLET"
        case alertTitle = "Confirm?"
        case alertDesc = "Create wallet named"
        case title = "New Wallet"
    }
}
