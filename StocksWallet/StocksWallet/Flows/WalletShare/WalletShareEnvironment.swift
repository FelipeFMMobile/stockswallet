//
//  WalletShareEnvironment.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 03/05/23.
//
import SwiftUI
import CoreData
import SwiftApiSDK

class WalletShareEnvironment: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    let router = Router.shared
    @Published var share: Share = Share(context: PersistenceController.shared.container.viewContext)
    let operationTypes = ["Buy", "Sell"]

    private var service = WalletService()

    struct FormData {
        var shareSymbol: String = ""
        var operationType = "Buy"
        var transactionPrice = ""
        var transactionAmount = ""
        var transactionBrokerage = ""
        var transactionTax = ""
        var stopDate: Date = Date().addingTimeInterval(86400)
        var transactionDate = Date()
        var stopPrice = ""
        var stopPercentage = 0.0
        var notes = ""
        
        func isValid() -> Bool {
            // TODO: Fix this for mask
            return !shareSymbol.isEmpty && !transactionPrice.isEmpty && !transactionAmount.isEmpty
        }
    }

    // MARK: Operations

    @MainActor
    func getStock(symbol: String) async throws {
        self.share = try await stockInfo(symbol: symbol)
    }

    // MARK: Requests
    private func stockInfo(symbol: String) async throws -> Share {
        typealias ApiContinuation = CheckedContinuation<Share, Error>
        return try await withCheckedThrowingContinuation { (continuation: ApiContinuation) in
            service.getStockInfo(symbol: symbol) { result in
                switch result {
                case .success(let model):
                    continuation.resume(returning: self.parseStock(model: model))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func parseStock(model: StockModel) -> Share {
        let share: Share = findLocalSymbol(model.symbol) ?? Share(context: context)
        share.identifier = UUID()
        share.timestamp = Date()
        share.symbol = model.symbol
        share.name = model.name
        share.maximum = Decimal(model.maximum) as NSDecimalNumber
        share.minimum = Decimal(model.minimum) as NSDecimalNumber
        share.average = Decimal(model.average) as NSDecimalNumber
        share.lastPrice = Decimal(model.last_price) as NSDecimalNumber
        share.price = Decimal(model.price) as NSDecimalNumber
        share.open =  Decimal(model.open) as NSDecimalNumber
        share.variation = Decimal(model.variantion) as NSDecimalNumber
        share.volume = model.volum
        // TODO: Fix conversion
        share.updatedDate = Date() // model.updated
        return share
    }

    // MARK: Operations
    func removeSpecialCharactes(_ inputString: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]", options: [])
        let outputString = regex.stringByReplacingMatches(in: inputString, options: [],
                                                          range: NSMakeRange(0, inputString.count), withTemplate: "")
        return outputString
    }

    private func findLocalSymbol(_ symbol: String) -> Share? {
        let request: NSFetchRequest<Share> = Share.fetchRequest()
        if let shares = try? context.fetch(request) {
            return shares.first { $0.symbol == symbol }
        }
        return nil
    }

    private func findWalletShareInWallet(_ share: Share, in wallet: Wallet) -> WalletShare? {
        let walletShares = wallet.walletShares?.allObjects as? [WalletShare] ?? []
        return walletShares.first(where: { $0.share?.symbol == share.symbol })
    }

    @discardableResult
    func createWalletTransaction(data: FormData, wallet: Wallet, share: Share) -> Bool {
        let currencyFormatter = Formatters.currency
        let decimalFormatter = Formatters.decimal
        let transaction = Transaction(context: context)
        transaction.type = data.operationType
        transaction.operationPrice = currencyFormatter.number(from: data.transactionPrice)?.decimalValue as? NSDecimalNumber
        transaction.amount = decimalFormatter.number(from: data.transactionAmount)?.doubleValue ?? 0.0
        transaction.brokerage = currencyFormatter.number(from: data.transactionBrokerage)?.decimalValue as? NSDecimalNumber
        transaction.tax = currencyFormatter.number(from: data.transactionTax)?.decimalValue as? NSDecimalNumber
        transaction.transactionDate = data.transactionDate
        let walletShare = findWalletShareInWallet(share, in: wallet) ?? WalletShare(context: context)
        walletShare.share = share
        walletShare.addTransaction(transaction)
        walletShare.notes = data.notes
        walletShare.stopDate = data.stopDate
        walletShare.stopValue = currencyFormatter.number(from: data.stopPrice)?.decimalValue as? NSDecimalNumber
        walletShare.stopPercentage = Decimal(data.stopPercentage) as NSDecimalNumber
        walletShare.wallet = wallet
        if wallet.firstOperationDate == nil {
            wallet.firstOperationDate = transaction.transactionDate
        }
        wallet.updateCalculations()
        do {
            try context.save()
            debugPrint("save \(walletShare)")
            return true
        } catch {
            _ = error as NSError
            return false
        }
    }

    // MARK: Navigation

    func showErrorScreen(_ error: Error) {
        router.changeRoute(RoutePath(.error_screen(error)))
    }

    func goBack() {
        router.backRoute()
    }
}
