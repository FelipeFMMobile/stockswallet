//
//  Wallet+Calculations.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 21/04/23.
//

import Foundation

extension Wallet {
    func getPeformance() -> NSDecimalNumber? {
        let value = getPeformanceValue()
        guard let original = originalAmount?.doubleValue, original > 0.0 else {
            return 0.0
        }
        return Decimal(((value / original) * 100.0)) as NSDecimalNumber
    }

    func getPeformanceValue() -> Double {
        guard let amount = self.amount?.doubleValue, let original = self.originalAmount?.doubleValue else {
            return 0.0
        }
        return amount - original
    }

    func peformanceIndicator() -> Int {
        let peformance = getPeformance()?.doubleValue ?? 0.0
        if peformance > 0 {
            return 1
        } else if peformance < 0 {
            return -1
        }
        return 0
    }

    func hasOriginalAmount() -> Bool {
        guard let originalAmount = originalAmount else { return false }
        return !originalAmount.doubleValue.isZero
    }

    // MARK: Calculations
    func updateCalculations() {
        let walletArray = walletShares?.allObjects as? [WalletShare] ?? []
        let allAmounts = walletArray.map { ($0.stockBuyPrice?.doubleValue ?? 0.0) * $0.quantity }
        // Original Amount
        self.originalAmount = Decimal(allAmounts.reduce(0, { $0 + $1 } )) as NSDecimalNumber
        // Amount
        let currentAmounts = walletArray.map { ($0.share?.price?.doubleValue ?? 0.0) * $0.quantity }
        self.amount = Decimal(currentAmounts.reduce(0, { $0 + $1 })) as NSDecimalNumber
        // Update all shares peformance
        walletArray.forEach { $0.updatePeformance() }
    }
}
