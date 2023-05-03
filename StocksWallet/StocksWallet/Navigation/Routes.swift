//
//  Routes.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 02/05/23.
//

import Foundation
import CoreData

enum Routes: Equatable {
    case wallet_list, wallet_creation, wallet_info(Wallet), wallet_edit(Wallet)
    case broker_list, broker_creation
    case none

    var name: String {
        switch self {
        case.wallet_creation:
            return "wallet_creation"
        case .wallet_list:
            return "wallet_list"
        case .wallet_info:
            return "wallet_info"
        case .wallet_edit:
            return "wallet_edit"
        case .broker_list:
            return "broker_list"
        case .broker_creation:
            return "broker_creation"

        case .none:
            return "none"
        }
    }

    static func ==(lhs: Routes, rhs: Routes) -> Bool {
        lhs.name == rhs.name
    }
}

struct RoutePath: Hashable {
    var route: Routes = .none
    var hashValue = { UUID().uuid }
    init(_ route: Routes) {
        self.route = route
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    static func == (lhs: RoutePath, rhs: RoutePath) -> Bool {
        lhs.route == rhs.route
    }
}
