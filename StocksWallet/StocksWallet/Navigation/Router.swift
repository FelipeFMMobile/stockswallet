//
//  Router.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 04/08/23.
//

import Foundation
import SwiftUI

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
        lhs.hashValue == rhs.hashValue
    }
}

class Router: ObservableObject {
    static var shared: Router = Router()
    
    var changeRoute: ((RoutePath) -> Void)!
    var backRoute: (() -> Void)!
}
