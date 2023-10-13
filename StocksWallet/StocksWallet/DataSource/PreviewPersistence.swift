//
//  PreviewPersistence.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 13/10/23.
//

import CoreData

struct PreviewPersistence {
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
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

}
