//
//  ListWalletRowUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 13/04/23.
//

import SwiftUI
import CoreData

struct ListWalletRowUIView: View {
    @EnvironmentObject var wallet: Wallet
    var body: some View {
        HStack(alignment: .top,
               spacing: 12.0) {
            VStack(alignment: .leading,
                   spacing: 4.0) {
                HStack(alignment: .top) {
                    Text(wallet.name ?? "")
                        .font(.title2)
                        .lineLimit(2)
                    Spacer(minLength: 24)
                    Text(wallet.amount ?? 0.0, formatter: WalletEnviroment.currencyFormatter)
                        .font(.title2)
                }.padding(.bottom, 8)
                HStack {
                    Text("\(str(Strings.originalAmount))\(wallet.amount ?? 0.0, formatter: WalletEnviroment.currencyFormatter)")
                    Spacer()
                    Text("\(wallet.broker?.name ?? "")")
                }
            }
        }.padding(EdgeInsets(top: 8, leading: 16.0, bottom: 8, trailing: 16.0))
    }
}

struct ListWalletRowUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListWalletRowUIView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(PersistenceController.walletPreview)
            ListWalletRowUIView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(PersistenceController.walletPreview)
        }.previewLayout(.fixed(width: 345, height: 90))
    }
}

extension ListWalletRowUIView: StringsView {
    enum Strings: String, RawRepresentable {
        case originalAmount = "Original: "
    }
}
