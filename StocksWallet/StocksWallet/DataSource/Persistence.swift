//
//  Persistence.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 29/03/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // TODO: Move to another place
    static var walletPreview: Wallet!
    static var sharePreview: Share!
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        // Broker
        let broker1 = Broker(context: viewContext)
        broker1.name = "Broker 1"
        broker1.accountAgency = "AG6790"
        broker1.accountNumber = "192009309"
        broker1.otherInfo = "main broker"
        let broker2 = Broker(context: viewContext)
        broker2.name = "Broker 2"
        broker2.accountAgency = "AG5555"
        broker2.accountNumber = "890808098"
        broker2.otherInfo = "other broker"
        // Wallet
        for idx in 0..<10 {
            let newItem = Wallet(context: viewContext)
            newItem.timestamp = Date()
            newItem.identifier = UUID()
            newItem.name = "Wallet n:\(newItem.identifier?.uuidString ?? "")"
            newItem.amountTarget = 5.0
            newItem.isPrincipal = false
            if idx == 0 {
                newItem.isPrincipal = true
                newItem.information = "wallet information text"
                newItem.amountTarget = 10.0
                walletPreview = newItem
            }
            newItem.type = "Simulation"
            newItem.broker = idx % 2 > 0 ? broker1 : broker2
        }
        let share = Share(context: viewContext)
        share.timestamp = Date()
        share.identifier = UUID()
        share.name = "Energy of Minas Gerais Co"
        share.symbol = "CMIG4"
        share.maximum = 10.95
        share.minimum = 10.71
        share.average = 16.385
        share.open = 10.63
        share.volume = "10.12M"
        share.updatedDate = Date()
        share.price = 10.89
        share.variation = 2.445
        share.lastPrice = 10.63
        sharePreview = share
        let walletShare = WalletShare(context: viewContext)
        walletShare.share = share
        walletShare.amount = 100
        walletShare.quantity = 100
        walletShare.stockBuyPrice =  Decimal(12.90) as NSDecimalNumber
        walletShare.stopDate = Date().addingTimeInterval(1800)
        walletShare.stopValue = Decimal(12.90) as NSDecimalNumber
        walletShare.stopPercentage = Decimal(10.00) as NSDecimalNumber
        walletShare.wallet = walletPreview
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "StocksWallet")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}