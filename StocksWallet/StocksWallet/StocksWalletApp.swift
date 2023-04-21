//
//  StocksWalletApp.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 29/03/23.
//

import SwiftUI

@main
struct StocksWalletApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext,
//                              persistenceController.container.viewContext)
            ListWalletUIView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(WalletEnviroment())
           //NavigationRouteView()
        }
    }
}
