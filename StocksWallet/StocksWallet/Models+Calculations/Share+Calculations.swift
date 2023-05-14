//
//  Share+Calculations.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 03/05/23.
//

import Foundation

extension Share {
    func peformanceIndicator() -> Int {
        let peformance = self.variation?.doubleValue ?? 0.0
        if peformance > 0 {
            return 1
        } else if peformance < 0 {
            return -1
        }
        return 0
    }

}
