//
//  WalletShare+CalculationsTests.swift
//  StocksWalletTests
//
//  Created by Felipe Menezes on 10/05/23.
//

import XCTest
@testable import StocksWallet

final class WalletShare_CalculationsTests: XCTestCase {
    let context = PreviewPersistence.preview.container.viewContext

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
        // When
        // Then
    }

    func testAddTransactionIsCorrect() throws {
        // Given
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let walletShare = walletShare_stub()
        // When
        walletShare.addTransaction(transaction)
        // Then
        let transactions = walletShare.transactions?.allObjects as? [Transaction] ?? []
        XCTAssertEqual(transactions.first, transaction)
    }

    func testAddTransactionIsCorrectCount() throws {
        // Given
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction2 = createTransaction(type: "Sell", price: 10.0, amount: 100)
        let walletShare = walletShare_stub()
        // When
        walletShare.addTransaction(transaction)
        walletShare.addTransaction(transaction2)
        // Then
        let transactions = walletShare.transactions?.allObjects as? [Transaction] ?? []
        XCTAssertEqual(transactions.count, 2)
    }

    func testBuyTransactionsIsCorrect() throws {
        // Given
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction2 = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let transaction3 = createTransaction(type: "Sell", price: 10.0, amount: 100)
        let walletShare = walletShare_stub()
        // When
        walletShare.addTransaction(transaction)
        walletShare.addTransaction(transaction2)
        walletShare.addTransaction(transaction3)
        // Then
        XCTAssertEqual(walletShare.buyTransactions().count, 2)
    }

    func testBuyTransactionsEmptyIsCorrect() throws {
        // Given
        let walletShare = walletShare_stub()
        // When
        // Then
        XCTAssertEqual(walletShare.buyTransactions().count, 0)
    }

    func testCalculationForBuyTransactionIsCorrect() throws {
        // Given
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 100)
        let walletShare = walletShare_stub()
        // When
        walletShare.addTransaction(transaction)
        // Then
        XCTAssertEqual(walletShare.amount?.doubleValue, 100.0)
        XCTAssertEqual(walletShare.buyFirstPrice?.doubleValue, transaction.operationPrice?.doubleValue)
        XCTAssertEqual(walletShare.buyFirstQtd, transaction.amount)
        XCTAssertEqual(walletShare.lastBuyDate, transaction.transactionDate)
        XCTAssertEqual(walletShare.quantity, transaction.amount)
        XCTAssertEqual(walletShare.stockBuyPrice?.doubleValue, transaction.operationPrice?.doubleValue)
    }

    func testCalculationForBuyTransactionSumIsCorrect() throws {
        // Given
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 10)
        let transaction2 = createTransaction(type: "Buy", price: 7.0, amount: 100)
        let walletShare = walletShare_stub()
        // When
        walletShare.addTransaction(transaction)
        walletShare.addTransaction(transaction2)
        // Then
        XCTAssertEqual(walletShare.amount?.doubleValue, transaction.amount + transaction2.amount)
        XCTAssertEqual(walletShare.buyFirstPrice?.doubleValue, transaction.operationPrice?.doubleValue)
        XCTAssertEqual(walletShare.buyFirstQtd, transaction.amount)
        XCTAssertEqual(walletShare.lastBuyDate, transaction2.transactionDate)
        XCTAssertEqual(walletShare.quantity,  transaction.amount + transaction2.amount)
        // (10 * 10) + (100 * 7) / (10+100) = 10
        XCTAssertEqual(String(format: "%.2f", walletShare.stockBuyPrice?.doubleValue ?? 0.0), "7.14")
    }

    func testCalculationForBuyAndSellTransactionSumIsCorrect() throws {
        // Given
        let transaction = createTransaction(type: "Buy", price: 10.0, amount: 10)
        let transaction2 = createTransaction(type: "Buy", price: 7.0, amount: 100)
        let transaction3 = createTransaction(type: "Sell", price: 10.0, amount: 10)
        let walletShare = walletShare_stub()
        // When
        walletShare.addTransaction(transaction)
        walletShare.addTransaction(transaction2)
        walletShare.addTransaction(transaction3)
        // Then
        XCTAssertEqual(walletShare.amount?.doubleValue, (transaction.amount + transaction2.amount) - transaction3.amount)
        XCTAssertEqual(walletShare.buyFirstPrice?.doubleValue, transaction.operationPrice?.doubleValue)
        XCTAssertEqual(walletShare.buyFirstQtd, transaction.amount)
        XCTAssertEqual(walletShare.lastBuyDate, transaction2.transactionDate)
        XCTAssertEqual(walletShare.quantity,  transaction.amount + transaction2.amount - transaction3.amount)
        // (10 * 10) + (100 * 7) / (10+100) = 10
        XCTAssertEqual(String(format: "%.2f", walletShare.stockBuyPrice?.doubleValue ?? 0.0), "7.14")
        XCTAssertEqual(walletShare.sellLastPrice?.doubleValue, transaction.operationPrice?.doubleValue)
        XCTAssertEqual(walletShare.sellLastQtd?.doubleValue, transaction3.amount)
        XCTAssertEqual(walletShare.lastSellDate, transaction3.transactionDate)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    private func walletShare_stub() -> WalletShare {
        let walletShare = WalletShare(context: context)
        walletShare.share = PreviewPersistence.sharePreview
        walletShare.stopDate = Date().addingTimeInterval(1800)
        walletShare.stopValue = Decimal(12.90) as NSDecimalNumber
        walletShare.stopPercentage = Decimal(10.00) as NSDecimalNumber
        return walletShare
    }
}
