//
//  InfoWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 21/04/23.
//

import SwiftUI

struct InfoWalletUIView: View {
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var enviroment: WalletEnvironment
    var body: some View {
        List {
            Section
            {
                VStack(alignment: .leading,
                       spacing: 8.0) {
                    Text(wallet.name ?? "")
                        .font(.title)
                    Text(wallet.information ?? "")
                        .font(.body)
                        .lineLimit(0)
                }
                .listRowSeparator(.visible)
                HStack(spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("\(str(Strings.originalAmount))")
                            .font(.caption)
                        Text("\(wallet.originalAmount ?? 0.0, formatter: WalletEnvironment.currencyFormatter)")
                            .font(.title2)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("\(str(Strings.currentAmount))")
                            .font(.caption)
                        Text("\(wallet.amount ?? 0.0, formatter: WalletEnvironment.currencyFormatter)")
                            .font(.title2)
                            .bold()
                    }
                }
                HStack(spacing: 0.0) {
                    VStack(alignment: .leading) {
                        Text("\(str(Strings.goalAmount))")
                            .font(.caption)
                        Text("\(wallet.amountTarget ?? 0.0, formatter: WalletEnvironment.decimalFormatter)%")
                            .font(.title2)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("\(str(Strings.gainAmount))")
                            .font(.caption)
                        Text("\(wallet.getPeformance() ?? 0.0, formatter: WalletEnvironment.decimalFormatter)%")
                            .font(.title2)
                            .bold(wallet.peformanceIndicator() > 0)
                            .italic(wallet.peformanceIndicator() < 0)
                            .foregroundColor(wallet.peformanceIndicator() > 0 ? .green : .red)
                        
                    }
                    .opacity(wallet.hasOriginalAmount() ? 1 : 0)
                }
                HStack(spacing: 4.0) {
                    VStack(alignment: .leading) {
                        Text(str(Strings.totalStocks))
                        Text("\(wallet.walletShares?.count ?? 0)")
                    }
                }
                VStack(alignment: .leading,
                       spacing: 4.0) {
                    Text(wallet.broker?.name ?? "")
                        .font(.title3)
                    HStack(spacing: 0.0) {
                        VStack(alignment: .leading) {
                            Text("\(str(Strings.brokerAgency)) \(wallet.broker?.accountAgency ?? "")")
                                .font(.body)
                            Text("\(str(Strings.brokerAccount)) \(wallet.broker?.accountAgency ?? "")")
                                .font(.body)
                        }
                    }
                }
                .listRowSeparator(.visible)
                VStack(alignment: .trailing,
                       spacing: 12.0) {
                    HStack(spacing: 0.0) {
                        VStack(alignment: .leading) {
                            Text("\(str(Strings.created)) \(wallet.timestamp ?? Date(), formatter: WalletEnvironment.updatedDateFormatter)")
                                .font(.body)
                        }
                        Spacer()
                    }
                    Text("\(str(Strings.typeWallet)) \(wallet.type ?? "")")
                        .font(.body)
                        .bold()
                }
            } header: {
                HStack(spacing: 0.0) {
                    Text("\(wallet.lastUpdate ?? Date(), formatter: WalletEnvironment.updatedDateFormatter)")
                    Spacer()
                    Text("\(wallet.isPrincipal ? str(Strings.principalWallet) : "")")
                }
            }
            .listRowSeparator(.hidden)
            Section(str(Strings.shareSection)) {
                ForEach(Array(wallet.walletShares as? Set<WalletShare> ?? []), id: \.self) { shares in
                    InfoWalletShareRowUIView()
                        .environmentObject(shares)
                }.onDelete { indexSet in
                    enviroment.deleteWalletShares(Array(wallet.walletShares as? Set<WalletShare> ?? []), offsets: indexSet)
                }
            }
        }
        .toolbar {
            EditButton()
            Menu(content: {
                Button(str(Strings.editionButton)) {
                    enviroment.goToEditView(wallet)
                }
                Button(str(Strings.addStockButton)) {
                    enviroment.goAddShareView(wallet)
                }
            }, label: {Text(str(Strings.optionsMenu))})
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
    }
}

struct InfoWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InfoWalletUIView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(PersistenceController.walletPreview)
                .environmentObject(WalletEnvironment())
        }
    }
}
