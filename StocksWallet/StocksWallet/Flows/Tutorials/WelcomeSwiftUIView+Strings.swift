//
//  WelcomeSwiftUIView+Strings.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 09/08/23.
//

extension WelcomeSwiftUIView: StringsView {
    enum Strings: String, RawRepresentable {
        case nameTitle = "Stocks"
        case nameDesc = "Wallet"
        case welcomeText = "This is your Wallet to hold your investments annotation!"
        case tutorial1 = "Start by creating your first wallet, and add stocks to it"
        case tutorial2 = "The value will be updated, and all calculations of your peformance will be easy on your hand!"
        case tutorial3 = "Enjoy"
    }
}
