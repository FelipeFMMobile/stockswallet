//
//  WalletApi.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 05/05/23.
//

import SwiftApiSDK

public enum WalletApi {
    case stockInfo(String)
    case stocks
}

extension WalletApi: EndPoint {
    public func path() -> Path {
        switch self {
        case .stockInfo(let symbol):
            return "stock/\(symbol)"
        case .stocks:
            return "stock"
        }
    }
    public func header() -> Header {
        switch self {
        default:
            // TODO: Solve this better
            return ["API_KEY": "V1hQVE9AMTk4MA=="]
        }
    }

    public func method() -> HttpMethod {
        switch self {
        default:
            return .GET
        }
    }

    public func contentType() -> ContentType {
        switch self {
        default:
            return .json
        }
    }
}
