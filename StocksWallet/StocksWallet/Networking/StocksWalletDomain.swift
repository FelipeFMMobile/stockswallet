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
    enum Domain: String {
    case producao = "https://api.themoviedb.org/3/"
    case homolog = "https://homolog.themoviedb.org/3/"
    case dev = "https://private-388c00-fmmobile.apiary-mock.com/"
    }
    
    public init() { }

    public func domainForBundle() -> String {
        #if DEBUG
            return Domain.dev.rawValue
        #endif
//        if let bundleID = Bundle.main.bundleIdentifier {
//            if bundleID.range(of: "homolog") != nil {
//                return Domain.homolog.rawValue
//            }
//            if bundleID.range(of: "dev") != nil {
//                return Domain.dev.rawValue
//            }
//        }
        return Domain.producao.rawValue
    }
}