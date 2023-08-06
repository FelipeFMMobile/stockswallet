//
//  NavigationRouteView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 20/04/23.
//

import SwiftUI
import CoreData

struct NavigationRouteView: View {
    private var enviroment = Environments()
    @State private var path = NavigationPath()
    var rootView: some View {
         ListWalletUIView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(enviroment
            .route(
                Environments.RouteOperation(changeRoute: changeRoute,
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
                case .broker_list:
                    ListBrokerUIView()
                       .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                       .environmentObject(enviroment.broker)
                case .broker_creation:
                    CreateBrokerUIView()
                       .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                       .environmentObject(enviroment.broker)
                case .wallet_stock_add(let wallet):
                    WalletShareAddUIView()
                       .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                       .environmentObject(wallet)
                       .environmentObject(enviroment.walletShare)
                case .error_screen(let error):
                    GenericErrorUIView(apiError: error)
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
