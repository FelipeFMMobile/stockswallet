//
//  WalletDomain.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 05/05/23.
//

import SwiftApiSDK
import Foundation

public struct ServerConfig {
    public static let dateFormat = "yyyy-MM-dd"
    public static let imagesBaseUrl = "https://image.tmdb.org/t/p/w185/"
}

public struct StocksWalletDomain: WebDomainProtocol {
    struct Domain {
        static func prod() -> String {
            return RemoteConfigSDK.shared.getValueFor("prod_domain") ?? ""
        }

        static func debug() -> String {
            return RemoteConfigSDK.shared.getValueFor("debug_domain") ?? ""
        }
    }
    
    public init() { }

    public func domainForBundle() -> String {
        #if DEBUG
        return Domain.prod()
        #endif
        return Domain.prod()
    }
}
