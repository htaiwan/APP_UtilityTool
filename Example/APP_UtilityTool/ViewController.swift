//
//  ViewController.swift
//  APP_UtilityTool
//
//  Created by htaiwan on 08/23/2019.
//  Copyright (c) 2019 htaiwan. All rights reserved.
//

import UIKit
import APP_UtilityTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        AdsManager.say()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

