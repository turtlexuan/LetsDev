//
//  InputTableViewCell.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/13.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.textView.layer.cornerRadius = 5
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.borderWidth = 1
        self.sendButton.tintColor = Color.buttonColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
