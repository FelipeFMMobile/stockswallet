//
//  ListWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 11/04/23.
//

import SwiftUI
import CoreData

struct ListWalletUIView: View {
    @EnvironmentObject var enviroment: WalletEnvironment
    @FetchRequest(
        sortDescriptors: WalletEnvironment.sortDescriptorList,
        animation: .default)
    var wallets: FetchedResults<Wallet>
    var body: some View {
            List {
                ForEach(wallets) { wallet in
                    NavigationLink(value:  RoutePath(.wallet_info(wallet))) {
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
                Menu(content: {
                    Button(str(Strings.addAction)) {
                        enviroment.goToCreateView()
                    }
                    Button(str(Strings.brokersAction)) {
                        enviroment.goToBrokerListView()
                    }
                }, label: {Text(str(Strings.optionsMenu))})
            }
    }
}

struct ListWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        ListWalletUIView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WalletEnvironment())
    }
}
