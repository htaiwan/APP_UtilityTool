//
//  ShortcutTableViewCell.swift
//  WhereIsCar
//
//  Created by Alex Cheng on 2019/8/3.
//  Copyright © 2019 Chien-Tai Cheng. All rights reserved.
//

import UIKit
import IntentsUI

public class ShortcutTableViewCell: UITableViewCell {

    public static let cellReuseIdentifier = "ShortcutTableViewCell"

    @IBOutlet public weak var buttonView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.initializeCell()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        self.initializeCell()
    }

    private func initializeCell() {
        titleLabel.text = ""
    }

}


