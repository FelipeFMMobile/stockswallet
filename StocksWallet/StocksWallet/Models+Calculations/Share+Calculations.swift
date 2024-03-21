//
//  Share+Calculations.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 03/05/23.
//

import CoreData

extension Share {
    /// return true if above 0.0 otherwise false (negative)
    func peformanceIndicator() -> Bool {
        let peformance = self.variation?.doubleValue ?? 0.0
        return peformance > 0.0 ? true : false
    }
}
