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
    @State private var successAlert = false
    @FetchRequest(
        sortDescriptors: WalletEnviroment.sortDescriptorBroker,
        animation: .default)
    var brokers: FetchedResults<Broker>
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter wallet name", text: $data.name)
                }
                
                Section(header: Text("Information")) {
                    TextField("Enter some information", text: $data.information)
                }

                Section(header: Text("Broker")) {
                    if brokers.isEmpty {
                        NavigationLink("Create a new Broker") {
                            Text("To new broker creation")
                        }
                    } else {
                        Picker(selection: $data.selectedBrokerIndex,
                               label: Text("Broker")) {
                            ForEach(brokers, id: \.self) {
                                Text($0.name ?? "").tag($0.id?.hashValue ?? 0)
                            }
                        }
                    }
                }

                Section(header: Text("Amount Target Goal")) {
                    Stepper(value: $data.amountTarget,
                            in: 0...100, step: 5) {
                        Text("\(data.amountTarget) %")
                    }
                }

                Section(header: Text("Is Principal?")) {
                    Toggle(isOn: $data.isPrincipal) {
                        Text("Is Principal")
                    }
                }

                Section(header: Text("Type")) {
                    Picker(selection: $data.selectedType, label: Text("Type")) {
                        ForEach(enviroment.walletTypes, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
            }
            Button(action: {
                confirmationAlert = !confirmationAlert
            }) {
                Text("CREATE")
                    .frame(minWidth: 300.0,
                           alignment: .center)
                    .padding(8.0)
            }
            .buttonStyle(.borderedProminent)
            .padding(24.0)
            .disabled(!data.isValid())
        }
        .navigationTitle("New Wallet")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm?", isPresented: $confirmationAlert) {
            Button("CREATE") {
                successAlert = enviroment.createNewWattet(data: data,
                                                          broker: brokers[data.selectedBrokerIndex])
                enviroment.path.removeLast()
            }
            Button("NO", role: .cancel) {}
        } message: {
            Text("Confirm creation of \(data.name)")
        }
//        .alert("Success!", isPresented: $successAlert) {
//            Button("Ok") {
//
//            }
//        } message: {
//            Text("Wallet \(data.name) created")
//        }
    }
}

struct CreateWalletUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWalletUIView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(WalletEnviroment())
    }
}
