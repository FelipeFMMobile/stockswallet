//
//  GenericErrorUIView+Strings.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 07/05/23.
//

extension GenericErrorUIView: StringsView {
    enum Strings: String, RawRepresentable {
        case navTitle = ""
        case title = "Connection Error"
        case connectionMessage = "Please check your connection and try again"
        case serverMessage = "Something got wrong, try again later"
        case buttonTitle = "Ok"
    }
}
