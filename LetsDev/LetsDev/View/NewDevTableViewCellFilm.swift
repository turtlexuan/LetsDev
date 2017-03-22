//
//  NewDevTableViewCellFilm.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/22.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class NewDevTableViewCellFilm: UITableViewCell {

    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var greyBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.filmButton.tintColor = Color.buttonColor
        self.typeButton.tintColor = Color.buttonColor
        self.greyBackgroundView.layer.cornerRadius = 10
        self.greyBackgroundView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
