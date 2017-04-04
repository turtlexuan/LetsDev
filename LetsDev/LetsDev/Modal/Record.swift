//
//  Record.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/3.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import UIKit

class Record {

    let combination: Combination!
    let note: String?
    let photo: [String?]
    let date: Double!
    let key: String!

    init(combination: Combination, note: String?, photo: [String?], date: Double, key: String) {

        self.combination = combination
        self.note = note
        self.photo = photo
        self.date = date
        self.key = key
    }

}
