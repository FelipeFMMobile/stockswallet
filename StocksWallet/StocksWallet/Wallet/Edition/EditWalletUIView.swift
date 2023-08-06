//
//  CreateWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 16/04/23.
//

import SwiftUI

struct EditWalletUIView: View {
    @EnvironmentObject var enviroment: WalletEnvironment
    @EnvironmentObject var wallet: Wallet
    @State private var data = WalletEnvironment.FormData()
    @State private var confirmationAlert = false
    @State private var selectedBrokerIndex = 0
    @FetchRequest(
        sortDescriptors: WalletEnvironment.sortDescriptorBroker,
        animation: .default)
    var brokers: FetchedResults<Broker>
    var body: some View {
        VStack {
            Form {
                Section(header: Text(str(Strings.Fields.name))) {
                    TextField(str(Strings.Fields.nameDesc), text: $data.name)
                }
                
                Section(header: Text(str(Strings.Fields.information))) {
                    TextField(str(Strings.Fields.informationDesc), text: $data.information)
                }
                
                Section(header: Text(str(Strings.Fields.broker))) {
                    Picker(selection: $data.selectedBrokerIndex,
                           label: Text(str(Strings.Fields.broker))) {
                        ForEach(0..<brokers.count) {
                            Text(brokers[$0].name ?? "")
                        }
                    }.onAppear {
                        data.selectedBrokerIndex = brokers.firstIndex(where: { $0.objectID == wallet.broker?.objectID }) ?? 0
                        debugPrint(data.selectedBrokerIndex)
                    }
                }
                
                Section(header: Text(str(Strings.Fields.amount))) {
                    Stepper(value: $data.amountTarget,
                            in: 0...100, step: 5) {
                        Text("\(data.amountTarget) %")
                    }
                }
                
                Section(header: Text(str(Strings.Fields.principal))) {
                    Toggle(isOn: $data.isPrincipal) {
                        Text(str(Strings.Fields.principalDesc))
                    }
                }
                
                Section(header: Text(str(Strings.Fields.type))) {
                    Picker(selection: $data.selectedType, label: Text(str(Strings.Fields.type))) {
                        ForEach(enviroment.walletTypes, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
            }
            ConfirmationButtonView(
                confirmationAlert: $confirmationAlert,
                info: ConfirmationButtonView
                    .Info(buttonTitle: str(Strings.buttonTitle),
                          alertTitle: str(Strings.alertTitle),
                          alertMessage: str(Strings.alertDesc)) {
                              enviroment.updateWattet(data: data,
                                                      wallet: wallet,
                                                      broker: brokers[data.selectedBrokerIndex])
                              enviroment.goBack()
                          }
            )
            .disabled(!data.isValid())
        }
        .navigationTitle(str(Strings.title))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            data.fill(wallet: wallet)
        }
    }
}

struct EditWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        EditWalletUIView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(PersistenceController.walletPreview)
            .environmentObject(WalletEnvironment())
    }
}
