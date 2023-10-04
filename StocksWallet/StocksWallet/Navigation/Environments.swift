//
//  Enviroments.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 02/05/23.
//

import SwiftUI

class Environments {
    lazy var wallet = WalletEnvironment()
    lazy var broker = BrokerEnvironment()
    lazy var walletShare = WalletShareEnvironment()
}
