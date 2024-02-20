//
//  CreateWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 16/04/23.
//

extension CreateBrokerUIView: StringsView {
    enum Strings: String, RawRepresentable {
        enum Fields: String, RawRepresentable {
            case name = "Name"
            case nameDesc = "Enter broker name"
            case other = "Other information"
            case informationDesc = "Enter some additional information"
            case agency = "Agency"
            case agencyDesc = "type agency account number"
            case account = "Account"
            case accountDesc = "type account number"
        }
        case buttonTitle = "CREATE BROKER"
        case alertTitle = "Confirm?"
        case alertDesc = "Create broker named"
        case title = "New Broker"
    }
}
