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
        AdsManager.say()
    }

}
