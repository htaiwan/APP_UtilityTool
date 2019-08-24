//
//  IAPManager.swift
//  APP_Utility
//
//  Created by Alex Cheng on 2019/8/23.
//  Copyright © 2019 Chien-Tai Cheng. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

public class IAPManager: NSObject {

    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?

    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds

        // 查詢是否已經購買過
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("之前已經購買過: \(productIdentifier)")
            } else {
                print("尚未購買過: \(productIdentifier)")
            }
        }

        super.init()

        SKPaymentQueue.default().add(self)
    }

    public func buyProduct(_ product: SKProduct) {
        print("購買\(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }

    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - StoreKit API

extension IAPManager {

    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPManager: SKProductsRequestDelegate {

    // 金行IAP列讀取
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("讀取IAP列表...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()

        for p in products {
            print("找到IAP商品: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }

    // 若讀取IAP失敗，則會由這裡通知
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("讀取IAP列表失敗")
        print("錯誤: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }

}

// MARK: - SKPaymentTransactionObserver

extension IAPManager: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                print("We don't sell that kind of fruit here.")
            }
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        print("完成交易...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

        print("恢復之前已購買的商品... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func fail(transaction: SKPaymentTransaction) {
        print("交易失敗...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction 錯誤: \(localizedDescription)")
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }

        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }

}
