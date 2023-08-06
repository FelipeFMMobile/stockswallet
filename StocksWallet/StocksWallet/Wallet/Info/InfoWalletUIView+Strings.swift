//
//  InfoWalletUIView+Strings.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 21/04/23.
//

extension InfoWalletUIView: StringsView {
    enum Strings: String, RawRepresentable {
        case originalAmount = "Original Value"
        case currentAmount = "Current Value"
        case goalAmount = "Goal"
        case gainAmount = "Peformance"
        case brokerAgency = "Agency: "
        case brokerAccount = "Account: "
        case principalWallet = "Main wallet"
        case typeWallet = "Type: "
        case created = "Created at: "
        case totalStocks = "Total stocks:"
        case editionButton = "Edit this wallet"
    }
}
