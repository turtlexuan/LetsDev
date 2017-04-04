//
//  RecordListTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/1.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class RecordListTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var devloperLabel: UILabel!
    @IBOutlet weak var filmLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var grayBackgroundView: UIView!
    @IBOutlet weak var imagePreView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.grayBackgroundView.layer.cornerRadius = 10
        self.grayBackgroundView.layer.masksToBounds = true
        self.imagePreView.layer.cornerRadius = 5
        self.imagePreView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
