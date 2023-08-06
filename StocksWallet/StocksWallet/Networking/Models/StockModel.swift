//
//  Stocks.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 05/05/23.
//

import Foundation

/// StockModel
final public class StockModel: Codable, Identifiable {
    public var id: String
    public var symbol: String
    public var name: String
    public var maximum: Double
    public var minimum: Double
    public var average: Double
    public var open: Double
    public var volum: String
    public var updated: String
    public var price: Double
    public var variantion: Double
    public var last_price: Double
    
    public static func == (lhs: StockModel, rhs: StockModel) -> Bool {
        return lhs.id == rhs.id
    }
}
