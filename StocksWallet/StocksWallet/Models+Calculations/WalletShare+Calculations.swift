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
        return transactions.filter { $0.type == "Buy" }
    }

    func sellTransactions() -> [Transaction] {
        guard let transactions = transactions?.allObjects as? [Transaction] else {
            return []
        }
        return transactions.filter { $0.type == "Sell" }
    }

    // MARK: Calculations
    private func calculationForTransaction(_ transaction: Transaction) {
        switch transaction.type {
        // TODO: Fix types into static enum
        case "Buy":
            amount = (amount ?? 0).adding(NSDecimalNumber(value: transaction.amount))
            if lastBuyDate == nil && !opened {
                buyFirstPrice = transaction.operationPrice
                buyFirstQtd = transaction.amount
                stockBuyPrice = transaction.operationPrice
                opened = true
            }
            lastBuyDate = transaction.transactionDate
            quantity += transaction.amount
            // TODO: Calculate price middle buy, when more buy transactions are added
            calculateBuyMiddlePrice(transaction)
        case "Sell":
            amount = amount?.subtracting(NSDecimalNumber(value: transaction.amount))
            sellLastPrice = transaction.operationPrice
            sellLastQtd = Decimal(transaction.amount) as NSDecimalNumber
            lastSellDate = transaction.transactionDate
            updatePeformance()
            quantity -= transaction.amount
            if quantity <= 0 {
                opened = false
            }
            // TODO: Fix this operation later, incremental and only difference between buy and sell
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
        self.peformanceValue = Decimal(
            (self.peformance / (self.stockBuyPrice?.doubleValue ?? 0.0)) * 100.0
        ) as NSDecimalNumber
    }
}
