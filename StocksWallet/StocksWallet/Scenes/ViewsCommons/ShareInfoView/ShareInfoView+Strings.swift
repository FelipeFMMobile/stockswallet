//
//  ShareInfoView+Strings.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 05/05/23.
//

extension ShareInfoView: StringsView {
    enum Strings: String, RawRepresentable {
        case share = "Share"
        case averagePrice = "Average price"
        case marketPrice = "Current value"
        case maximumPrice = "Maximum price"
        case minimunPrice = "Minimum price"
        case openPrice = "Opened"
        case updatedDate = "Updated"
        case variation = "Variation"
        case lastPrice = "Last price"
    }
}
