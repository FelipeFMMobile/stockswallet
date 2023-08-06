//
//  Router.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 04/08/23.
//

import Foundation

public struct RoutePath: Hashable {
    public var route: Routes = .none
    var hashValue = { UUID().uuid }
    public init(_ route: Routes) {
        self.route = route
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    public static func == (lhs: RoutePath, rhs: RoutePath) -> Bool {
        lhs.route == rhs.route
    }
}

public class Router: ObservableObject {
    public static var shared: Router = Router()
    
    public var changeRoute: ((RoutePath) -> Void)!
    public var backRoute: (() -> Void)!
}
