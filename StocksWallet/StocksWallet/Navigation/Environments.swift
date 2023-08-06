//
//  Enviroments.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 02/05/23.
//

import Foundation

class Environments: ObservableObject {
    private var routeTo: RouteOperation?
    lazy var wallet: WalletEnvironment = WalletEnvironment(routeTo)
    lazy var broker: BrokerEnvironment = BrokerEnvironment(routeTo)
    lazy var walletShare: WalletShareEnvironment = WalletShareEnvironment(routeTo)

    struct RouteOperation {
        var changeRoute: ((RoutePath) -> Void)
        var backRoute: (() -> Void)
    }

    func route(_ route: RouteOperation) -> Self {
        self.routeTo = route
        return self
    }
}
