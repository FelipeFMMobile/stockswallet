//
//  ListWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 11/04/23.
//

import SwiftUI
import CoreData

struct ListWalletUIView: View {
    @EnvironmentObject var enviroment: WalletEnviroment
    @FetchRequest(
        sortDescriptors: WalletEnviroment.sortDescriptorList,
        animation: .default)
    var wallets: FetchedResults<Wallet>
    var body: some View {
        //NavigationStack(path: $enviroment.path) {
            List {
                ForEach(wallets) { wallet in
                    NavigationLink(value:  RoutePath(.wallet_creation)) {
                        ListWalletRowUIView()
                            .environmentObject(wallet)
                    }
                }
                .onDelete { indexSet in
                    enviroment.deleteItems(wallets, offsets: indexSet)
                }
            }
            .navigationTitle(str(Strings.title))
            .listStyle(.inset)
            .toolbar {
                EditButton()
                Button(str(Strings.addAction)) {
                    enviroment.goToCreateView()
                }
            }
//            .navigationDestination(for: WalletEnviroment.Route.self) { (view: WalletEnviroment.Route) in
//                switch view {
//                case .create:
//                    CreateWalletUIView()
//                        .environmentObject(enviroment)
//                case .info(let wallet):
//                    InfoWalletUIView()
//                        .environmentObject(wallet)
//                        .environmentObject(enviroment)
//                case .edition(let wallet):
//                    EditWalletUIView()
//                        .environmentObject(wallet)
//                        .environmentObject(enviroment)
//                }
//            }
//        }
    }
}

struct ListWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        ListWalletUIView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WalletEnviroment())
    }
}
