//
//  NavigationRouteView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 20/04/23.
//

import SwiftUI

enum Routes: String, Equatable {
    case wallet_list, wallet_creation
    case none

    static func ==(lhs: Routes, rhs: Routes) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

struct RoutePath: Hashable {
    var route: Routes = .none
    init(_ route: Routes) {
        self.route = route
    }
}

class Enviroments: ObservableObject {
    private var routeTo: ((RoutePath) -> Void)?
    lazy var wallet: WalletEnviroment = WalletEnviroment(routeTo)

    func route(_ route: @escaping ((RoutePath) -> Void)) -> Self {
        self.routeTo = route
        return self
    }
}

struct NavigationRouteView: View {
    private var enviroment = Enviroments()
    //private var walletEnviroment: WalletEnviroment = WalletEnviroment(changeRoute)
    @State private var path = NavigationPath()
    var rootView: some View {
         ListWalletUIView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(enviroment
            .route(changeRoute).wallet)
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
                case .none:
                    Text("no route")
                default:
                    Text("not found")
                }
            }
        }
    }

    func changeRoute(_ route: RoutePath) {
        path.append(route)
    }
}

struct NavigationRouteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationRouteView()
    }
}
