//
//  HTDemoTableViewController.swift
//  APP_UtilityTool_Example
//
//  Created by Alex Cheng on 2019/8/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum DemoCase: String, CaseIterable {
    case Ads = "廣告串接"
    case IAP = "In App Purchase"
    case Shortcut = "捷徑使用"
    case Map = "簡易map使用"
    case Tracking = "Firebase Tracking"
}

class HTDemoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoCase.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)

        let demoCase = DemoCase.allCases[indexPath.item]

        cell.textLabel?.text = demoCase.rawValue

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let demoCase = DemoCase.allCases[indexPath.item]
        guard let demo =  DemoCase(rawValue: demoCase.rawValue), let storyboard = storyboard else { return }

        var identifier = ""
        switch demo {
        case .Ads:
            identifier = "HTAdsDemoViewController"
        case .IAP:
            identifier = "HTIAPDemoViewController"
        case .Shortcut:
            identifier = "HTShortcutDemoViewController"
        default:
            return
        }

        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.navigationItem.title = demo.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }

}
