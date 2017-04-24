//
//  HomePageTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/10.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import ExpandableLabel

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var messageLabel: ExpandableLabel!
    @IBOutlet weak var combinationBackground: UIView!
    @IBOutlet weak var filmLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var dilutionLabel: UILabel!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.combinationBackground.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
