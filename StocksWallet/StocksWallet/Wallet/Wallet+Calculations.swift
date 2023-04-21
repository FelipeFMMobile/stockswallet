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
        guard let original = originalAmount?.floatValue, original > 0.0 else {
            return 0.0
        }
        return Decimal(Double((value / original) * 100.0)) as NSDecimalNumber
    }

    func getPeformanceValue() -> Float {
        guard let amount = self.amount?.floatValue, let original = self.originalAmount?.floatValue else {
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
}
