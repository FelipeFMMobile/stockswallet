//
//  BrokerEnviroment.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 24/04/23.
//

import SwiftUI
import CoreData

class BrokerEnviroment: ObservableObject {
    let context = PersistenceController.shared.container.viewContext

    struct FormData {
        var name = ""
        var otherInfo = ""
        var account = ""
        var agency = ""
        func isValid() -> Bool {
            return !name.isEmpty && !account.isEmpty && !agency.isEmpty
        }
    }
    
    enum Route: Hashable {
        case create
    }

    // MARK: SortedDescriptors

    // TODO: Duplicate sortDescriptor definition
    static var sortDescriptorBroker = [
        NSSortDescriptor(keyPath: \Broker.name, ascending: true)
    ]

    // MARK: Operations
    
    @discardableResult
    func createNewBroker(data: FormData) -> Bool {
        let broker = Broker(context: context)
        broker.name = data.name
        broker.otherInfo = data.otherInfo
        broker.id = UUID()
        broker.accountAgency = data.agency
        broker.accountNumber = data.account
        do {
            try context.save()
            debugPrint("save \(broker)")
            return true
        } catch {
            _ = error as NSError
            return false
        }
    }

    @discardableResult
    func deleteItems(_ brokers: FetchedResults<Broker>, offsets: IndexSet) -> Bool{
        withAnimation {
            offsets.map { brokers[$0] }.forEach(context.delete)
            do {
                try context.save()
                return true
            } catch {
                _ = error as NSError
                return false
            }
        }
    }
}
