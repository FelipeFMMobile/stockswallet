//
//  WalletEnviroment.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 11/04/23.
//

import SwiftUI
import CoreData

// TODO: Could be Data Enviroment or other thing 
class WalletEnviroment: ObservableObject {
    let context = PersistenceController.shared.container.viewContext

    struct FormData {
        var name = ""
        var information = ""
        var selectedBrokerIndex = 0
        var amountTarget = 0
        var isPrincipal = false
        var selectedType = "Operation"
        func isValid() -> Bool {
            return !name.isEmpty && !information.isEmpty && amountTarget > 0
        }
    }

    @Published var path = NavigationPath()
    let walletTypes = ["Simulation", "Operation"]
    
    enum Route: String {
        case create
    }

    // MARK: SortedDescriptors

    static var sortDescriptorList = [
        NSSortDescriptor(keyPath: \Wallet.isPrincipal, ascending: true),
        NSSortDescriptor(keyPath: \Wallet.name, ascending: true)
    ]

    static var sortDescriptorBroker = [
        NSSortDescriptor(keyPath: \Broker.name, ascending: true)
    ]

    // MARK: Formatters

    // TODO: Move to a generic formatter property
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        return formatter
    }()

    // MARK: Navigation
    func goToCreateView() {
        self.path.append(Route.create.rawValue)
    }

    // MARK: Operations
    
    @discardableResult
    func createNewWattet(data: FormData, broker: Broker) -> Bool {
        let wallet = Wallet(context: context)
        wallet.name = data.name
        wallet.information = data.information
        wallet.amountTarget = wallet.amountTarget
        wallet.identifier = UUID()
        wallet.isPrincipal = data.isPrincipal
        wallet.timestamp = Date()
        wallet.type = data.selectedType
        wallet.broker = broker
        do {
            try context.save()
            debugPrint("save \(wallet)")
            return true
        } catch {
            _ = error as NSError
            return false
        }
    }

    @discardableResult
    func deleteItems(_ wallets: FetchedResults<Wallet>, offsets: IndexSet) -> Bool{
        withAnimation {
            offsets.map { wallets[$0] }.forEach(context.delete)
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
