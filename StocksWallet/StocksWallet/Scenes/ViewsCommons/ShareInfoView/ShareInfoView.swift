//
//  ConfirmationButtonView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 18/04/23.
//

import SwiftUI
import Combine

struct ShareInfoView: View {
    struct ShareData {
        var shareSymbol: String = ""
        var isEditing = false
        var action: (String) -> Void
    }
    @EnvironmentObject var share: Share
    @State var shareData: ShareData
    var body: some View {
        VStack(spacing: 12.0) {
            HStack {
                TextField(str(Strings.share),
                          text: $shareData.shareSymbol)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .textCase(.uppercase)
                .autocapitalization(.allCharacters)
                .multilineTextAlignment(.center)
                .submitLabel(.search)
                .onReceive(Just(shareData.shareSymbol), perform: { text in
                    self.shareData.shareSymbol = self.removeSpecialCharactes(text)
                })
                .onSubmit {
                    self.shareData.action(self.shareData.shareSymbol)
                }
                .disabled(shareData.isEditing)
            }
            VStack(alignment: .leading,
                   spacing: 8.0) {
                Text(share.name ?? "")
                    .font(.body)
                    .bold()
            }
            HStack(spacing: 0.0) {
                VStack(alignment: .leading) {
                    Text("\(str(Strings.openPrice))")
                        .font(.caption)
                    Text("\(share.open ?? 0.0, formatter: Formatters.currency)")
                        .font(.title2)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(str(Strings.marketPrice))")
                        .font(.caption)
                    Text("\(share.price ?? 0.0, formatter: Formatters.currency)")
                        .font(.title2)
                        .bold()
                }
            }
            HStack(spacing: 0.0) {
                VStack(alignment: .leading) {
                    Text("\(str(Strings.maximumPrice))")
                        .font(.caption)
                    Text("\(share.maximum ?? 0.0, formatter: Formatters.currency)")
                        .font(.title2)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(str(Strings.variation))")
                        .font(.caption)
                    Text("\(share.variation ?? 0.0, formatter: Formatters.decimal)%")
                        .font(.title2)
                        .bold(share.peformanceIndicator() > 0)
                        .italic(share.peformanceIndicator() < 0)
                        .foregroundColor(share.peformanceIndicator() > 0 ? .accentColor : .red)
                }
            }
            HStack(spacing: 0.0) {
                VStack(alignment: .leading) {
                    Text("\(str(Strings.minimunPrice))")
                        .font(.caption)
                    Text("\(share.minimum ?? 0.0, formatter: Formatters.currency)")
                        .font(.title2)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(str(Strings.lastPrice))")
                        .font(.caption)
                    Text("\(share.lastPrice ?? 0.0, formatter: Formatters.currency)")
                        .font(.title2)
                }
            }
        }
    }
    
    private func removeSpecialCharactes(_ inputString: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]", options: [])
        let outputString = regex.stringByReplacingMatches(in: inputString, options: [],
                                                          range: NSMakeRange(0, inputString.count), withTemplate: "")
        return outputString
    }
}

struct ShareInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ShareInfoView(shareData: ShareInfoView.ShareData(action: { symbol in
                debugPrint("get a symbol \(symbol)")
            }))
            .environment(\.managedObjectContext, PreviewPersistence.preview.container.viewContext)
            .environmentObject(PreviewPersistence.sharePreview)
        }.padding(40)
    }
}
