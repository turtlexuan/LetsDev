//
//  NewDevTableViewCellTwoContent.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/21.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class NewDevTableViewCellTwoContent: UITableViewCell {

    @IBOutlet weak var grayBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var setAgitationLabel: UILabel!
    @IBOutlet weak var timeButton: TTInputButton!
    @IBOutlet weak var agitationButton: TTInputButton!
    @IBOutlet weak var customButton: TTInputButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeButton.tintColor = Color.buttonColor
        self.customButton.tintColor = Color.buttonColor
        self.agitationButton.tintColor = Color.buttonColor
        self.grayBackgroundView.layer.cornerRadius = 10
        self.grayBackgroundView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
