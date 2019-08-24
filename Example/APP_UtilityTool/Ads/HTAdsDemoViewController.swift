//
//  HTAdsDemoViewController.swift
//  APP_UtilityTool_Example
//
//  Created by Alex Cheng on 2019/8/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import APP_UtilityTool

class HTAdsDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 加載上方廣告
        AdsManager.shared.createAds(adsUnitID:"ca-app-pub-3521523989981143/5779592136", position: .Top, targetVC: self) { (error) in
            if error == nil {
                print("adViewDidReceiveAd success")
            } else {
                print("adView:didFailToReceiveAdWithError: \(error!.localizedDescription)")
            }
        }

    }

    @IBAction func removeAds(_ sender: Any) {
        AdsManager.shared.removeAds()
    }
}
