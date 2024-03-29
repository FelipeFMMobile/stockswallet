//
//  CreateWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 16/04/23.
//

import SwiftUI

struct CreateBrokerUIView: View {
    @EnvironmentObject var enviroment: BrokerEnvironment
    @State private var data = BrokerEnvironment.FormData()
    @State private var confirmationAlert = false
    var body: some View {
        VStack {
            Form {
                Section(header: Text(str(Strings.Fields.name))) {
                    TextField(str(Strings.Fields.nameDesc), text: $data.name)
                }
                
                Section(header: Text(str(Strings.Fields.other))) {
                    TextField(str(Strings.Fields.informationDesc), text: $data.otherInfo)
                }

                Section(header: Text(str(Strings.Fields.agency))) {
                    TextField(str(Strings.Fields.agencyDesc), text: $data.agency)
                        .keyboardType(.numbersAndPunctuation)
                }

                Section(header: Text(str(Strings.Fields.account))) {
                    TextField(str(Strings.Fields.accountDesc), text: $data.account)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
            FormButtonView(
                confirmationAlert: $confirmationAlert,
                info: FormButtonView
                    .Info(title: str(Strings.buttonTitle),
                          alertTitle: str(Strings.alertTitle),
                          alertMessage: str(Strings.alertDesc)) {
                              enviroment.createNewBroker(data: data)
                              enviroment.goBack()
                          }
            )
            .disabled(!data.isValid())
        }
        .navigationTitle(str(Strings.title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateBrokerUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBrokerUIView()
            .environment(\.managedObjectContext, PreviewPersistence.preview.container.viewContext)
            .environmentObject(BrokerEnvironment())
    }
}
