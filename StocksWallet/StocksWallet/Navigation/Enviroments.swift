//
//  Enviroments.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 02/05/23.
//

import Foundation

class Enviroments: ObservableObject {
    private var routeTo: RouteOperation?
    lazy var wallet: WalletEnviroment = WalletEnviroment(routeTo)
    lazy var broker: BrokerEnviroment = BrokerEnviroment(routeTo)

    struct RouteOperation {
        var changeRoute: ((RoutePath) -> Void)
        var backRoute: (() -> Void)
    }

    func route(_ route: RouteOperation) -> Self {
        self.routeTo = route
        return self
    }
}
