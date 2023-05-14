//
//  WalletShare+CalculationsTests.swift
//  StocksWalletTests
//
//  Created by Felipe Menezes on 10/05/23.
//

import XCTest
@testable import StocksWallet

final class Wallet_CalculationsTests: XCTestCase {
    let context = PersistenceController.preview.container.viewContext

    private func createTransaction(type: String, price: Double, amount: Double) -> Transaction{
        let context = context
        let transaction = Transaction(context: context)
        transaction.amount = amount
        transaction.operationPrice = Decimal(price) as NSDecimalNumber
        transaction.type = type
        transaction.transactionDate = Date()
        return transaction
    }

    override func setUpWithError() throws {
        // Given

//        let walletShare2 = walletShare_stub()
//        walletShare2.addTransaction(transaction)
//        walletShare2.addTransaction(transaction2)
//        walletShare2.wallet = wallet
    }

    func testUpdateCalculationsIsCorrect() throws {
        // Given
        let wallet = wallet_stub()
        // When
        wallet?.updateCalculations()
        // Then
        XCTAssertEqual(wallet?.amount, 2_649)
        XCTAssertEqual(wallet?.originalAmount, 2_470)
        XCTAssertEqual(String(format: "%.2f", wallet?.getPeformance()?.doubleValue ?? 0.0), "7.25")
        XCTAssertEqual(String(format: "%.2f", wallet?.getPeformanceValue() ?? 0.0), "179.00")
    }

    func testPeformanceIndicatorIsNegativeCorrect() throws {
        // Given
        let wallet = wallet_stub_negative()
        // When
        wallet?.updateCalculations()
        // Then
        XCTAssertEqual(wallet?.peformanceIndicator(), -1)
    }

    func testPeformanceIndicatorIsPositiveCorrect() throws {
        // Given
        let wallet = wallet_stub()
        // When
        wallet?.updateCalculations()
        // Then
        XCTAssertEqual(wallet?.peformanceIndicator(), 1)
    }

    func testHasOriginalAmountEmptyIsCorrect() throws {
        // Given
        let wallet = wallet_stub_empty()
        // When
        let hasOriginalAmount = wallet?.hasOriginalAmount()
        // Then
        XCTAssertEqual(hasOriginalAmount, false)
    }

    private func walletShare_stub(symbol: String, price: Double) -> WalletShare {
        let share = Share(context: context)
        share.timestamp = Date()
        share.identifier = UUID()
        share.name = "Energy of Minas Gerais Co"
        share.symbol = symbol
        share.maximum = 10.95
        share.minimum = 10.71
        share.average = 16.385
        share.open = 10.63
        share.volume = "10.12M"
        share.updatedDate = Date()
        share.price = Decimal(price) as NSDecimalNumber
        share.variation = 2.445
        share.lastPrice = 10.63
        let walletShare = WalletShare(context: context)
        walletShare.share = share
        walletShare.amount = 0
        walletShare.quantity = 0
        walletShare.stopDate = Date().addingTimeInterval(1800)
        walletShare.stopValue = Decimal(12.90) as NSDecimalNumber
        walletShare.stopPercentage = Decimal(10.00) as NSDecimalNumber
        return walletShare
    }

    // TODO: Move to a StubClass
    private func wallet_stub() -> Wallet? {
        let wallet = Wallet(context: context)
        wallet.timestamp = Date()
        wallet.identifier = UUID()
        wallet.name = "Wallet n:\(wallet.identifier?.uuidString ?? "")"
        wallet.isPrincipal = true
        wallet.information = "wallet information text"
        wallet.originalAmount = 0.0
        wallet.amount = 0.0
        wallet.amountTarget = 10.0
        wallet.type = "Simulation"
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction2 = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction3 = createTransaction(type: "Sell", price: 12.0, amount: 100)
        let walletShare1 = walletShare_stub(symbol: "CMIG4", price: 10.89)
        walletShare1.addTransaction(transaction)
        walletShare1.addTransaction(transaction2)
        walletShare1.addTransaction(transaction3)
        walletShare1.wallet = wallet
        let walletShare2 = walletShare_stub(symbol: "PETR4", price: 5.20)
        let transaction4 = createTransaction(type: "Buy", price: 4.90, amount: 300)
        walletShare2.addTransaction(transaction4)
        walletShare2.wallet = wallet
        return wallet
    }

    private func wallet_stub_negative() -> Wallet? {
        let wallet = Wallet(context: context)
        wallet.timestamp = Date()
        wallet.identifier = UUID()
        wallet.name = "Wallet n:\(wallet.identifier?.uuidString ?? "")"
        wallet.isPrincipal = true
        wallet.information = "wallet information text"
        wallet.originalAmount = 0.0
        wallet.amount = 0.0
        wallet.amountTarget = 10.0
        wallet.type = "Simulation"
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction2 = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction3 = createTransaction(type: "Sell", price: 12.0, amount: 100)
        let walletShare1 = walletShare_stub(symbol: "CMIG4", price: 9.79)
        walletShare1.addTransaction(transaction)
        walletShare1.addTransaction(transaction2)
        walletShare1.addTransaction(transaction3)
        walletShare1.wallet = wallet
        let walletShare2 = walletShare_stub(symbol: "PETR4", price: 3.70)
        let transaction4 = createTransaction(type: "Buy", price: 4.90, amount: 300)
        walletShare2.addTransaction(transaction4)
        walletShare2.wallet = wallet
        return wallet
    }

    private func wallet_stub_empty() -> Wallet? {
        let wallet = Wallet(context: context)
        wallet.timestamp = Date()
        wallet.identifier = UUID()
        wallet.name = "Wallet n:\(wallet.identifier?.uuidString ?? "")"
        wallet.isPrincipal = true
        wallet.information = "wallet information text"
        wallet.originalAmount = 0.0
        wallet.amount = 0.0
        wallet.amountTarget = 10.0
        wallet.type = "Simulation"
        return wallet
    }

}
