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
    private var viewContext = PersistenceController.shared.container.viewContext
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                make(ListWalletUIView()
                    .environmentObject(enviroment.wallet))
                .task {
                     Router.shared.changeRoute = changeRoute
                     Router.shared.backRoute = backRoute
                }
            }
            .navigationDestination(for: RoutePath.self) { route in
                switch route.route {
                case .wallet_list:
                    make(ListWalletUIView())
                        .environmentObject(enviroment.wallet)
                case .wallet_creation:
                    make(CreateWalletUIView())
                        .environmentObject(enviroment.wallet)
                case .wallet_info(let wallet):
                    make(InfoWalletUIView())
                        .environmentObject(enviroment.wallet)
                        .environmentObject(wallet)
                case .wallet_edit(let wallet):
                    make(EditWalletUIView())
                        .environmentObject(enviroment.wallet)
                        .environmentObject(wallet)
                case .broker_list:
                    make(ListBrokerUIView())
                        .environmentObject(enviroment.broker)
                case .broker_creation:
                    make(CreateBrokerUIView())
                        .environmentObject(enviroment.broker)
                case .wallet_stock_add(let wallet):
                    make(WalletShareAddUIView())
                        .environmentObject(enviroment.walletShare)
                        .environmentObject(wallet)
                case .error_screen(let error):
                    GenericErrorUIView(apiError: error)
                case .none:
                    Text("no route")
                }
            }
        }
    }

    private func make(_ view: some View) -> some View {
        return view
            .environment(\.managedObjectContext, viewContext)
    }

    // MARK: Route
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
