//
//  NewDevTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/21.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class NewDevTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var greyBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var setTempLabel: UILabel!
    @IBOutlet weak var agitationImageView: UIImageView!
    @IBOutlet weak var setAgitationLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var agitationButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeButton.tintColor = Color.buttonColor
        self.customButton.tintColor = Color.buttonColor
        self.tempButton.tintColor = Color.buttonColor
        self.agitationButton.tintColor = Color.buttonColor
        self.greyBackgroundView.layer.cornerRadius = 10
        self.greyBackgroundView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
