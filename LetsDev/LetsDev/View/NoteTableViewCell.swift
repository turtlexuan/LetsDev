//
//  NoteTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/28.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.editButton.tintColor = Color.buttonColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
