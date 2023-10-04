//
//  SharesUpdate.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 22/05/23.
//

import CoreData

actor SharesUpdate {
    let context = PersistenceController.shared.container.newBackgroundContext()
    private var service = WalletService()
    private let request: NSFetchRequest<Share> = Share.fetchRequest()
    private(set) var loadingError: Error?

    func getUpdatedShares() async throws -> Bool {
        typealias ApiContinuation = CheckedContinuation<Bool, Error>
        return try await withCheckedThrowingContinuation { (continuation: ApiContinuation) in
            service.getStocks { result in
                switch result {
                case .success(let model):
                    self.updateShares(model: model)
                    continuation.resume(returning: true)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func updateShares(model: [StockModel]) {
        guard let shares = try? context.fetch(request) else { return }
        shares.forEach { share in
            if let model = model.first(where: { $0.symbol == (share.symbol ?? "") }) {
                share.symbol = model.symbol
                share.name = model.name
                share.maximum = Decimal(model.maximum) as NSDecimalNumber
                share.minimum = Decimal(model.minimum) as NSDecimalNumber
                share.average = Decimal(model.average) as NSDecimalNumber
                share.lastPrice = Decimal(model.last_price) as NSDecimalNumber
                share.price = Decimal(model.price) as NSDecimalNumber
                share.open =  Decimal(model.open) as NSDecimalNumber
                share.variation = Decimal(model.variantion) as NSDecimalNumber
                share.volume = model.volum
                share.updatedDate =  date(from: model.updated,
                                          withFormat: "yyyy-MM-dd'T'HH:mm:ss") ?? Date()
                let wallets = Array(share.walletShare as? Set<WalletShare> ?? [])
                wallets.forEach { wallet in
                    wallet.lastUpdateDate = share.updatedDate
                }
            }
        }
        try? context.save()
    }

    private func date(from dateString: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
}
