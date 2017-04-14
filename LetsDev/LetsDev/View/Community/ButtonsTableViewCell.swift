//
//  ButtonsTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
