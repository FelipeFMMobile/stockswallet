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

struct NavigationRouteView: View {
    @State private var path = NavigationPath([RoutePath(.wallet_list)])

    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                
            }
            .navigationDestination(for: RoutePath.self) { route in
                switch route.route {
                case .wallet_list:
                    ListWalletUIView()
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    .environmentObject(WalletEnviroment())
                case .none:
                    Text("no route")
                default:
                    Text("not found")
                }
            }
        }
    }
}

struct NavigationRouteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationRouteView()
    }
}
