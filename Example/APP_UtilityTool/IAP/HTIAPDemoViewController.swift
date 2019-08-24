//
//  HTIAPDemoViewController.swift
//  APP_UtilityTool_Example
//
//  Created by Alex Cheng on 2019/8/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import StoreKit

class HTIAPDemoViewController: UIViewController {

    private var products: [SKProduct] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        HTIAPDemoProducts.store.requestProducts { [weak self] (success, products) in
            guard let self = self else { return }
            if success {
                print("IAP列表:\(String(describing: products))")
                guard let products = products, let product = products.first else { return }
                self.products = products
                if HTIAPDemoProducts.store.isProductPurchased(product.productIdentifier) {
                    print("已經購買過")
                }
            }
        }
    }

    @IBAction func buy(_ sender: Any) {
        guard let product = products.first else { return }
        HTIAPDemoProducts.store.buyProduct(product)
    }

}
