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
        NavigationStack(path: $enviroment.path) {
            List(wallets) { wallet in
                NavigationLink {
                    
                } label: {
                    ListWalletRowUIView()
                        .environmentObject(wallet)
                }
            }
            .navigationTitle("Wallets")
            .listStyle(.inset)
            .toolbar {
                EditButton()
                Button("Adicionar") {
                    enviroment.goToCreateView()
                }
            }
            .navigationDestination(for: String.self) { view in
                // TODO: Move to abstraction
                if view == WalletEnviroment.Route.create.rawValue {
                    CreateWalletUIView()
                        .environmentObject(enviroment)
                }
            }
        }
        
    }
    
}

struct ListWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        ListWalletUIView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WalletEnviroment())
    }
}
