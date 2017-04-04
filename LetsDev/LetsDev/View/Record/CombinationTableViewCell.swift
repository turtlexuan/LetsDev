//
//  CombinationTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/28.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class CombinationTableViewCell: UITableViewCell {

    @IBOutlet weak var greyBackgroundView: UIView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var preWashLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var fixTimeLabel: UILabel!
    @IBOutlet weak var washTimeLabel: UILabel!
    @IBOutlet weak var devAgitationLabel: UILabel!
    @IBOutlet weak var fixAgitationLabel: UILabel!
    @IBOutlet weak var dilutionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.greyBackgroundView.layer.cornerRadius = 10
        self.greyBackgroundView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
