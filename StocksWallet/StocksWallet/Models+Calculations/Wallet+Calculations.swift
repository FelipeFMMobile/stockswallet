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
        let original = originalAmount()
        guard original > 0.0 else {
            return 0.0
        }
        return Decimal(((value / original) * 100.0)) as NSDecimalNumber
    }

    func getPeformanceValue() -> Double {
        let amount = currentAmount()
        let original = originalAmount()
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
        originalAmount() > 0
    }

    // MARK: Calculations
    func updateCalculations() {
        let walletArray = walletShares?.allObjects as? [WalletShare] ?? []
        // Update all shares peformance
        walletArray.forEach { $0.updatePeformance() }
    }

    func originalAmount() -> Double {
        let walletArray = walletShares?.allObjects as? [WalletShare] ?? []
        let allAmounts = walletArray.map { ($0.stockBuyPrice?.doubleValue ?? 0.0) * $0.quantity }
        return allAmounts.reduce(0, { $0 + $1 } )
    }

    func currentAmount() -> Double {
        let walletArray = walletShares?.allObjects as? [WalletShare] ?? []
        let currentAmounts = walletArray.map { ($0.share?.price?.doubleValue ?? 0.0) * $0.quantity }
        return currentAmounts.reduce(0, { $0 + $1 })
    }

    // MARK: Accessors
    
    func getShares() -> [WalletShare] {
        return Array(walletShares as? Set<WalletShare> ?? [])
    }
}
