//
//  TransactionShare+Calculations.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 08/05/23.
//

import Foundation

extension WalletShare {
    func addTransaction(_ transaction: Transaction) {
        addToTransactions(transaction)
        self.calculationForTransaction(transaction)
    }

    func buyTransactions() -> [Transaction] {
        guard let transactions = transactions?.allObjects as? [Transaction] else {
            return []
        }
        return transactions.filter { $0.type == WalletTransactionType.buy.rawValue }
    }

    func sellTransactions() -> [Transaction] {
        guard let transactions = transactions?.allObjects as? [Transaction] else {
            return []
        }
        return transactions.filter { $0.type == WalletTransactionType.sell.rawValue }
    }

    // MARK: Calculations
    private func calculationForTransaction(_ transaction: Transaction) {
        let type = WalletTransactionType(rawValue: transaction.type ?? "") ?? .unknown
        switch type {
        case .buy:
            amount = (amount ?? 0).adding(NSDecimalNumber(value: transaction.amount))
            if lastBuyDate == nil && !opened {
                buyFirstPrice = transaction.operationPrice
                buyFirstQtd = transaction.amount
                stockBuyPrice = transaction.operationPrice
                opened = true
            }
            lastBuyDate = transaction.transactionDate
            quantity += transaction.amount
            calculateBuyMiddlePrice(transaction)
        case .sell:
            amount = amount?.subtracting(NSDecimalNumber(value: transaction.amount))
            sellLastPrice = transaction.operationPrice
            sellLastQtd = Decimal(transaction.amount) as NSDecimalNumber
            lastSellDate = transaction.transactionDate
            updatePeformance()
            quantity -= transaction.amount
            opened = (quantity <= 0) ? false : true
            let earningValue = transaction.operationPrice?.doubleValue ?? 0.0 * transaction.amount
            if releaseEarnings == nil {
                self.releaseEarnings = Decimal(0) as NSDecimalNumber
            }
            self.releaseEarnings = self.releaseEarnings?.adding(Decimal(earningValue) as NSDecimalNumber)
        default:
            break
        }
    }

    private func calculateBuyMiddlePrice(_ transaction: Transaction) {
        let transactions = buyTransactions()
        var transactionsAmount = transactions.map { $0.amount }.reduce(0, { $0 + $1 })
        var transactionsSum = transactions.compactMap { ($0.operationPrice?.doubleValue ?? 0.0) * $0.amount }
            .reduce(0, { $0 + $1 })
        transactionsAmount += transaction.amount
        transactionsSum += (transaction.operationPrice?.doubleValue ?? 0.0) * transaction.amount
        guard transactionsAmount > 0 else { return }
        let middlePrice = transactionsSum / transactionsAmount
        self.stockBuyPrice = Decimal(middlePrice) as NSDecimalNumber
    }

    func updatePeformance() {
        let amountValue = (self.amount?.doubleValue ?? 00) * (self.share?.price?.doubleValue ?? 0.0)
        let stockBuyAmount = (self.amount?.doubleValue ?? 00) * (self.stockBuyPrice?.doubleValue ?? 0.0)
        self.peformance = amountValue - stockBuyAmount
        self.peformanceValue = (self.peformance / (self.stockBuyPrice?.doubleValue ?? 0.0)) * 100.0
    }
}
