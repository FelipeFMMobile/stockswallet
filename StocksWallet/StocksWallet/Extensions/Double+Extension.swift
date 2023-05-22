//
//  Double+Extension.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 22/05/23.
//

import Foundation

extension Double {
    func toString(_ formatter: NumberFormatter) -> String {
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
