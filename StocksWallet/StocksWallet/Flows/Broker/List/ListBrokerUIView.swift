//
//  ListWalletUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 11/04/23.
//

import SwiftUI
import CoreData

struct ListBrokerUIView: View {
    @EnvironmentObject var enviroment: BrokerEnvironment
    @FetchRequest(
        sortDescriptors: BrokerEnvironment.sortDescriptorBroker,
        animation: .default)
    var brokers: FetchedResults<Broker>
    var body: some View {
        List {
            Section {
                ForEach(brokers) { broker in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(broker.name ?? "")")
                                .font(.title2)
                            Spacer()
                            Text("\(broker.accountAgency ?? "") / \(broker.accountNumber ?? "")")
                        }
                        Text("\(broker.otherInfo ?? "")")
                            .font(.body)
                    }
                    .padding(EdgeInsets(top: 8,
                                        leading: 0,
                                        bottom: 8,
                                        trailing: 0))
                }
                .onDelete { indexSet in
                    enviroment.deleteItems(brokers, offsets: indexSet)
                }
            }
            Section {
                if brokers.count == 0 {
                    Section {
                        NavigationLink(value:  RoutePath(.broker_creation)) {
                            HStack {
                                Text(str(Strings.addAction))
                                    .font(.title2)
                                Spacer(minLength: 4.0)
                                Image(systemName: "dollarsign.circle")
                                Image(systemName: "yensign.circle")
                                Image(systemName: "eurosign.circle")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(str(Strings.title))
        .listStyle(.inset)
        .toolbar {
            EditButton()
            Button(str(Strings.addAction)) {
                enviroment.gottoCreateBrokerView()
            }
        }
    }
}

struct ListBrokerUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListBrokerUIView()
                .environment(\.managedObjectContext, PreviewPersistence.preview.container.viewContext)
                .environmentObject(BrokerEnvironment())
        }
    }
}
