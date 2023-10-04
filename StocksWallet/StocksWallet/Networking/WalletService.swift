//
//  WalletApi.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 05/05/23.
//

import SwiftApiSDK

protocol WalletServiceProtocol {
    typealias RequetsResult<T> = (_ result: Result<T, ApiError>) -> Void
    func getStockInfo(symbol: String, complete: @escaping RequetsResult<StockModel>)
}

final class WalletService: WalletServiceProtocol {
    
    private let api = ApiRest()
    
    func getStockInfo(symbol: String, complete: @escaping RequetsResult<StockModel>) {
        let endpoint = WalletApi.stockInfo(symbol)
        let apiParam = ApiParamFactory.basic.generate(domain: StocksWalletDomain.self,
                                                      endPoint: endpoint,
                                                      params: GetParams(params: [:]))
        api.run(param: apiParam, StockModel.self) { result, _ in
            switch result {
            case .success(let model):
                complete(.success(model))
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }

    func getStocks(complete: @escaping RequetsResult<[StockModel]>) {
        let endpoint = WalletApi.stocks
        let apiParam = ApiParamFactory.basic.generate(domain: StocksWalletDomain.self,
                                                      endPoint: endpoint,
                                                      params: GetParams(params: [:]))
        api.run(param: apiParam, [StockModel].self) { result, _ in
            switch result {
            case .success(let model):
                complete(.success(model))
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
}
