//
//  HTShortcutDemoViewController.swift
//  APP_UtilityTool_Example
//
//  Created by Alex Cheng on 2019/8/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Intents
import APP_UtilityTool

enum ShortcutType: Int, CaseIterable {
    case Demo1 = 0
    case Demo2

    var displayString: String {
        switch self {
        case .Demo1:
            return "這是Demo1 Intent"
        case .Demo2:
            return "這是Demo2 Intent"
        }
    }

    var intent: INIntent {
        switch self {
        case .Demo1:
            let demo1 = Demo1Intent()
            demo1.suggestedInvocationPhrase = "demo1"
            return demo1
        case .Demo2:
            let demo2 = Demo2Intent()
            demo2.suggestedInvocationPhrase = "demo2"
            return demo2
        }
    }
}

class HTShortcutDemoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide empty cell
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: ShortcutTableViewCell.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: ShortcutTableViewCell.cellReuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShortcutType.allCases.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShortcutTableViewCell.cellReuseIdentifier, for: indexPath) as! ShortcutTableViewCell

        guard let shortcutType = ShortcutType(rawValue: indexPath.row) else { return cell }

        cell.titleLabel.text = shortcutType.displayString
        ShortcutManager.shared.addShortcutsButton(to: cell.buttonView, in: self, with: shortcutType.intent)

        return cell
    }

}
