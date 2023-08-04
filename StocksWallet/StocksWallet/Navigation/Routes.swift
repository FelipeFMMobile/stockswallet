//
//  Routes.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 02/05/23.
//

import Foundation
import CoreData
import SwiftUI

enum Routes {
    
    case wallet_list, wallet_creation, wallet_info(Wallet), wallet_edit(Wallet)
    case broker_list, broker_creation
    case wallet_stock_add(Wallet)
    case error_screen(Error)
    case none
}
