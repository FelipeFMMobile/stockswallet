//
//  Share+Calculations.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 03/05/23.
//

import CoreData

extension Share {
    func peformanceIndicator() -> Int {
        let peformance = self.variation?.doubleValue ?? 0.0
        return Int(peformance).signum()
    }
}
