//
//  HTIAPDemoProduct.swift
//  APP_UtilityTool_Example
//
//  Created by Alex Cheng on 2019/8/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import APP_UtilityTool

public struct HTIAPDemoProducts {

    // 正式商品
    public static let HideAdvertisement = "com.htaiwan.WhereIsCar.hideAds"

    private static let productIdentifiers: Set<ProductIdentifier> = [HTIAPDemoProducts.HideAdvertisement]

    public static let store = IAPManager(productIds: productIdentifiers)

}
