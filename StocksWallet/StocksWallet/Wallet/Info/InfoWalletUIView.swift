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
    @StateObject var sharesUpdateTimer = SharesUpdateTimer()
    @State var openedInfo = true
    var body: some View {
        List {
            // MARK: Wallet
            Section {
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
                        Text("\(wallet.originalAmount().toString(WalletEnvironment.currencyFormatter))")
                            .font(.title2)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("\(str(Strings.currentAmount))")
                            .font(.caption)
                        Text("\(wallet.currentAmount().toString(WalletEnvironment.currencyFormatter))")
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
            }

            // MARK: Expanded Infomartion
            Section {
                if openedInfo {
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
                }
            } header: {
                HStack(spacing: 0.0) {
                    Text("\(wallet.lastUpdate ?? Date(), formatter: WalletEnvironment.updatedDateFormatter)")
                    Spacer()
                    Text("\(wallet.isPrincipal ? str(Strings.principalWallet) : "")")
                    Spacer(minLength: 10.0)
                    Button {
                        openedInfo = !openedInfo
                    } label: {
                        Image(systemName: "arrow.down")
                            .rotationEffect(.degrees(openedInfo ? 0 : -180))
                            .animation(.easeInOut, value: openedInfo)
                    }
                    
                }
            }
            .listRowSeparator(.hidden)

            // MARK: Shares
            Section(str(Strings.shareSection)) {
                let sharesArray = wallet.getShares()
                if sharesArray.count > 0 {
                    ForEach(sharesArray, id: \.id) { share in
                        InfoWalletShareRowUIView(isUpdating: $sharesUpdateTimer.isLoading)
                            .environmentObject(share)
                    }
                    .onDelete { indexSet in
                        enviroment.deleteWalletShares(sharesArray,
                                                      offsets: indexSet)
                    }
                } else {
                    NavigationLink(str(Strings.addStockButton),
                                   value: RoutePath(.wallet_stock_add(wallet)))
                }
            }
        }
        // MARK: ToolBar
        .toolbar {
            EditButton()
                .opacity(wallet.getShares().count > 0 ? 1.0 : 0.0)
            Menu(content: {
                Button(str(Strings.editionButton)) {
                    enviroment.goToEditView(wallet)
                }
                Button(str(Strings.addStockButton)) {
                    enviroment.goAddShareView(wallet)
                }
            }, label: { Text(str(Strings.optionsMenu)) })
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .task {
            sharesUpdateTimer.start()
        }
        .onDisappear {
            sharesUpdateTimer.stop()
        }
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
