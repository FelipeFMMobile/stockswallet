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
    @State var presentSheet = false
    @State var presented = false
    @FetchRequest(
        sortDescriptors: WalletEnvironment.sortDescriptorList,
        animation: .default)
    var wallets: FetchedResults<Wallet>
    var body: some View {
            List {
                Section {
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
                if wallets.count == 0 && presented {
                    Section {
                        NavigationLink(value:  RoutePath(.wallet_creation)) {
                            HStack {
                                Text(str(Strings.addAction))
                                    .font(.title2)
                                Spacer(minLength: 4.0)
                                Image(systemName: "dollarsign.circle")
                                Image(systemName: "yensign.circle")
                                Image(systemName: "eurosign.circle")
                            }
                        }
                    }
                }
            }
            .navigationTitle(str(Strings.title))
            .listStyle(.inset)
            .toolbar {
                EditButton()
                Menu(content: {
                    Button {
                        enviroment.goToCreateView()
                    } label: {
                        Image(systemName: "plus.circle")
                        Text(str(Strings.addAction))
                    }
                    Button {
                        enviroment.goToBrokerListView()
                    } label: {
                        Image(systemName: "dollarsign.circle")
                        Text(str(Strings.brokersAction))
                    }
                }, label: {
                    Image(systemName: "menucard")
                })
            }.sheet(isPresented: $presentSheet) {
                WelcomeSwiftUIView()
            }.task {
                if wallets.count == 0 && !presented {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        presentSheet = true
                        presented = true
                    }
                }
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
