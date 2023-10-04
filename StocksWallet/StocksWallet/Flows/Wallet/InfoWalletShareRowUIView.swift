//
//  ListWalletRowUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 13/04/23.
//

import SwiftUI
import CoreData
import Combine

struct InfoWalletShareRowUIView: View {
    @EnvironmentObject var share: WalletShare
    @Binding var isUpdating: Bool
    var body: some View {
        HStack(alignment: .top,
               spacing: 12.0) {
            VStack(alignment: .leading,
                   spacing: 4.0) {
                HStack(alignment: .bottom) {
                    Text(share.share?.symbol ?? "")
                        .font(.title2)
                        .lineLimit(2)
                    Spacer()
                    Text("\(share.amount ?? 0.0, formatter: WalletEnvironment.decimalFormatter) \(str(Strings.unitSymbol))")
                        .font(.title3)
                    Text(share.share?.price ?? 0.0, formatter: WalletEnvironment.currencyFormatter)
                        .font(.title2)
                        .redacted(reason: isUpdating ? .placeholder : [])
                }.padding(.bottom, 8)
                HStack {
                    VStack(alignment: .leading){
                        Text("\(str(Strings.buyPrice))")
                            .monospacedDigit()
                        Text("\(share.stockBuyPrice ?? 0.0, formatter: WalletEnvironment.currencyFormatter)")
                            .monospacedDigit()
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(str(Strings.lastDate))")
                            .monospacedDigit()
                        Text("\(share.share?.updatedDate ?? Date(), formatter: WalletEnvironment.updatedDateFormatter)")
                            .monospacedDigit()
                            .redacted(reason: isUpdating ? .placeholder : [])
                    }
                }
            }
        }.padding(EdgeInsets(top: 8, leading: 8.0, bottom: 8, trailing: 8.0))
    }
}

struct InfoWalletShareRowUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfoWalletShareRowUIView(isUpdating: .constant(false))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(PersistenceController.walletPreview.walletShares?.allObjects.first as! WalletShare)
        }.previewLayout(.fixed(width: 345, height: 90))
    }
}

extension InfoWalletShareRowUIView: StringsView {
    enum Strings: String, RawRepresentable {
        case buyPrice = "buy: "
        case lastDate = "last date: "
        case unitSymbol = "un"
    }
}
