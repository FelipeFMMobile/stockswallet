//
//  WalletStockAddUIView+Strings.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 03/05/23.
//

extension WalletShareAddUIView: StringsView {
    enum Strings: String, RawRepresentable {
        case title = "Share Operation"
        case subtitle = "add a new share role into your Wallet"
        case buttonTitle = "REGISTER OPERATION"
        case alertTitle = "Confirm?"
        case alertDesc = "Register new share role"
        enum Fields: String {
            case share = "Share"
            case shareInfo = "Type your share"
        }
        enum Share: String {
            case averagePrice = "Average price"
            case marketPrice = "Current value"
            case maximumPrice = "Maximum price"
            case minimunPrice = "Minimum price"
            case openPrice = "Opened"
            case updatedDate = "Updated"
            case variation = "Variation"
            case lastPrice = "Last price"
        }
        enum Transaction: String {
            case transactionTitle = "Transaction Info"
            case transactionDate = "Transaction Date"
            case amount = "Amount quantity"
            case operationPrice = "Operation price"
            case brokage = "Brokerage"
            case tax = "Tax value"
            case type = "Operation type"
        }
        enum Stop: String {
            case stopTitle = "Goals"
            case stopDate = "Stop date"
            case stopPrice = "Stop price"
            case stopPercentage = "Stop percentage"
            case notes = "Notes"
        }
    }
}
