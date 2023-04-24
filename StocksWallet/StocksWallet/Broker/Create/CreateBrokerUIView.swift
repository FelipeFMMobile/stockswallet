//
//  CreateWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 16/04/23.
//

import SwiftUI

struct CreateWalletUIView: View {
    @EnvironmentObject var enviroment: WalletEnviroment
    @State private var data = WalletEnviroment.FormData()
    @State private var confirmationAlert = false
    @FetchRequest(
        sortDescriptors: WalletEnviroment.sortDescriptorBroker,
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
                    if brokers.isEmpty {
                        NavigationLink(str(Strings.Fields.brokerCreate)) {
                            Text(str(Strings.Fields.brokerInfo))
                        }
                    } else {
                        Picker(selection: $data.selectedBrokerIndex,
                               label: Text(str(Strings.Fields.broker))) {
                            ForEach(0..<brokers.count) {
                                Text(brokers[$0].name ?? "")
                            }
                        }
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
                              enviroment.createNewWattet(data: data,
                                                         broker: brokers[data.selectedBrokerIndex])
                              enviroment.path.removeLast()
                          }
            )
            .disabled(!data.isValid())
        }
        .navigationTitle(str(Strings.title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWalletUIView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WalletEnviroment())
    }
}
