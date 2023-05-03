//
//  NavigationRouteView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 20/04/23.
//

import SwiftUI
import CoreData

enum Routes: Equatable {
    case wallet_list, wallet_creation, wallet_info(Wallet), wallet_edit(Wallet)
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

class Enviroments: ObservableObject {
    private var routeTo: RouteOperation?
    lazy var wallet: WalletEnviroment = WalletEnviroment(routeTo)

    struct RouteOperation {
        var changeRoute: ((RoutePath) -> Void)
        var backRoute: (() -> Void)
    }

    func route(_ route: RouteOperation) -> Self {
        self.routeTo = route
        return self
    }
}

struct NavigationRouteView: View {
    private var enviroment = Enviroments()
    @State private var path = NavigationPath()
    var rootView: some View {
         ListWalletUIView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(enviroment
            .route(
                Enviroments.RouteOperation(changeRoute: changeRoute,
                                           backRoute: backRoute)
            ).wallet)
    }
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                rootView
            }
            .navigationDestination(for: RoutePath.self) { route in
                switch route.route {
                case .wallet_list:
                    rootView
                case .wallet_creation:
                    CreateWalletUIView()
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                        .environmentObject(self.enviroment.wallet)
                case .wallet_info(let wallet):
                    InfoWalletUIView()
                       .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                       .environmentObject(wallet)
                       .environmentObject(enviroment.wallet)
                case .wallet_edit(let wallet):
                    EditWalletUIView()
                       .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                       .environmentObject(wallet)
                       .environmentObject(enviroment.wallet)
                case .none:
                    Text("no route")
                }
            }
        }
    }

    func changeRoute(_ route: RoutePath) {
        path.append(route)
    }

    func backRoute() {
        path.removeLast()
    }
}

struct NavigationRouteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationRouteView()
    }
}
