//
//  CommentDetailTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import ExpandableLabel

class CommentDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: ExpandableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
