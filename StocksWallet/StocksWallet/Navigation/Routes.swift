//
//  Routes.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 02/05/23.
//

import Foundation
import CoreData
import SwiftUI

enum Routes: Equatable {
    case wallet_list, wallet_creation, wallet_info(Wallet), wallet_edit(Wallet)
    case broker_list, broker_creation
    case wallet_stock_add(Wallet)
    case error_screen(any Error)
    case none

    static func == (lhs: Routes, rhs: Routes) -> Bool {
            switch (lhs, rhs) {
            case (.wallet_list, .wallet_list),
                 (.wallet_creation, .wallet_creation),
                 (.broker_list, .broker_list),
                 (.broker_creation, .broker_creation),
                 (.none, .none):
                return true
                
            case let (.wallet_info(wallet1), .wallet_info(wallet2)),
                 let (.wallet_edit(wallet1), .wallet_edit(wallet2)),
                 let (.wallet_stock_add(wallet1), .wallet_stock_add(wallet2)):
                return wallet1 == wallet2
                
            case let (.error_screen(error1), .error_screen(error2)):
                return error1.localizedDescription == error2.localizedDescription
                
            default:
                return false
            }
        }
}

