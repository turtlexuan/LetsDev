//
//  PrivateSettingTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/19.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PrivateSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: SkyFloatingLabelTextFieldWithIcon!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
