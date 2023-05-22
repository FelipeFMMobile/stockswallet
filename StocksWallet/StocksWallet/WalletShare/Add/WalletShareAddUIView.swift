//
//  WalletStockAddUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 03/05/23.
//

import SwiftUI
import Combine

struct WalletShareAddUIView: View {
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var environment: WalletShareEnvironment
    @State private var data = WalletShareEnvironment.FormData()
    @State private var confirmationAlert = false
    @FetchRequest(
        sortDescriptors: WalletEnvironment.sortDescriptorBroker,
        animation: .default)
    var brokers: FetchedResults<Broker>
    var body: some View {
        VStack {
            Text(str(Strings.subtitle))
            
            Form {
                // MARK: Stock Section
                Section(header: Text(str(Strings.Fields.shareInfo))) {
                    VStack {
                        ShareInfoView(shareData: ShareInfoView.ShareData(shareSymbol: data.shareSymbol, action: { symbol in
                            self.searchSymbol(symbol: symbol)
                        }))
                        .environment(\.managedObjectContext, environment.context)
                        .environmentObject(environment.share)
                    }
                }
                // MARK: Transaction Section
                Section(header: Text(str(Strings.Transaction.transactionTitle))) {
                    DatePicker(
                        str(Strings.Transaction.transactionDate),
                        selection: $data.transactionDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    Picker(selection: $data.operationType, label: Text(str(Strings.Transaction.type))) {
                        ForEach(environment.operationTypes, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    HStack {
                        Text("\(str(Strings.Transaction.operationPrice))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 60.0)
                        // TODO: Transform to a default input value
                        TextFieldCurrencyView(label: str(Strings.Transaction.operationPrice),
                                              value: $data.transactionPrice)
                    }
                    HStack {
                        Text("\(str(Strings.Transaction.amount))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 60.0)
                        TextFieldDecimalView(label: str(Strings.Transaction.amount),
                                              value: $data.transactionAmount)
                    }
                    HStack {
                        Text("\(str(Strings.Transaction.brokage))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 60.0)
                        TextFieldCurrencyView(label: str(Strings.Transaction.brokage),
                                              value: $data.transactionBrokerage)
                    }
                    HStack {
                        Text("\(str(Strings.Transaction.tax))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 60.0)
                        TextFieldCurrencyView(label: str(Strings.Transaction.tax),
                                              value: $data.transactionTax)
                    }
                }
                
                // MARK: Stop Section
                Section(header: Text(str(Strings.Stop.stopTitle))) {
                    DatePicker(
                        str(Strings.Stop.stopDate),
                        selection: $data.stopDate,
                        in: Date().addingTimeInterval(86400)...,
                        displayedComponents: [.date]
                    )
                    HStack {
                        Text("\(str(Strings.Stop.stopPrice))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 60.0)
                        TextFieldCurrencyView(label: str(Strings.Stop.stopPrice),
                                              value: $data.stopPrice)
                    }
                    HStack {
                        Text("\(str(Strings.Stop.stopPercentage))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 20.0)
                        Stepper(value: $data.stopPercentage,
                                in: 0...100, step: 5) {
                            Text("\(NSNumber(value:data.stopPercentage), formatter: WalletEnvironment.decimalFormatter) %")
                        }
                    }
                    HStack {
                        Text("\(str(Strings.Stop.notes))")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 20.0)
                        TextField(str(Strings.Stop.notes), text: $data.notes,
                                  axis: .vertical)
                            .lineLimit(2, reservesSpace: true)
                    }
                }
                
            }
            ConfirmationButtonView(
                confirmationAlert: $confirmationAlert,
                info: ConfirmationButtonView
                    .Info(buttonTitle: str(Strings.buttonTitle),
                          alertTitle: str(Strings.alertTitle),
                          alertMessage: str(Strings.alertDesc)) {
                              environment.createWalletTransaction(data: data, wallet: wallet, share: environment.share)
                              environment.goBack()
                          }
            )
            .disabled(!data.isValid())
        }
        .navigationTitle(str(Strings.title))
    }

    private func searchSymbol(symbol: String) {
        Task {
            do {
                try await environment.getStock(symbol:symbol)
                data.shareSymbol = symbol
            } catch {
                environment.showErrorScreen(error)
            }
        }
    }
}

struct WalletStockAddUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WalletShareAddUIView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(WalletShareEnvironment())
                .environmentObject(PersistenceController.walletPreview)
        }
    }
}
