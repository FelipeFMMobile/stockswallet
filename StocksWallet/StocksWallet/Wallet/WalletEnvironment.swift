//
//  WalletEnviroment.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 11/04/23.
//

import SwiftUI
import CoreData

// TODO: Could be Data Enviroment or other thing 
class WalletEnvironment: ObservableObject {
    private var router: Environments.RouteOperation?
    let context = PersistenceController.shared.container.viewContext

    struct FormData {
        var name = ""
        var information = ""
        var selectedBrokerIndex = 0
        var amountTarget = 0.0
        var isPrincipal = false
        var selectedType = "Operation"
        func isValid() -> Bool {
            return !name.isEmpty && !information.isEmpty && amountTarget > 0
        }

        mutating func fill(wallet: Wallet) {
            name = wallet.name ?? ""
            information = wallet.information ?? ""
            amountTarget = wallet.amountTarget?.doubleValue ?? 0.0
            isPrincipal = wallet.isPrincipal
            selectedType = wallet.type ?? ""
        }
    }
    let walletTypes = ["Simulation", "Operation"]

    init(_ route: Environments.RouteOperation? = nil) {
        self.router = route
    }
    
    // MARK: SortedDescriptors

    static var sortDescriptorList = [
        NSSortDescriptor(keyPath: \Wallet.isPrincipal, ascending: true),
        NSSortDescriptor(keyPath: \Wallet.name, ascending: true)
    ]

    static var sortDescriptorBroker = [
        NSSortDescriptor(keyPath: \Broker.name, ascending: true)
    ]

    static var updatedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    static var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: Formatters

    // TODO: Move to a generic formatter property
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        return formatter
    }()

    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    // MARK: Navigation
    func goToCreateView() {
        router?.changeRoute(RoutePath(.wallet_creation))
    }

    func goToEditView(_ wallet: Wallet) {
        router?.changeRoute(RoutePath(.wallet_edit(wallet)))
    }

    func goAddShareView(_ wallet: Wallet) {
        router?.changeRoute(RoutePath(.wallet_stock_add(wallet)))
    }

    func goBack() {
        router?.backRoute()
    }

    func goToBrokerCreationView() {
        router?.changeRoute(RoutePath(.broker_creation))
    }

    func goToBrokerListView() {
        router?.changeRoute(RoutePath(.broker_list))
    }

    // MARK: Operations
    
    @discardableResult
    func createNewWattet(data: FormData, broker: Broker) -> Bool {
        let wallet = Wallet(context: context)
        wallet.name = data.name
        wallet.information = data.information
        wallet.amountTarget = Decimal(data.amountTarget) as NSDecimalNumber
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
    func updateWattet(data: FormData, wallet: Wallet, broker: Broker) -> Bool {
        wallet.name = data.name
        wallet.information = data.information
        wallet.amountTarget = Decimal(data.amountTarget) as NSDecimalNumber
        wallet.isPrincipal = data.isPrincipal
        wallet.type = data.selectedType
        wallet.broker = broker
        do {
            try wallet.managedObjectContext?.save()
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
