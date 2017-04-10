//
//  SharedPost.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import UIKit

class SharedPost {

    let combination: Combination!
    let note: String?
    let photo: [String?]
    let date: Double!
    let message: String!

    init(message: String?, combination: Combination, note: String?, photo: [String?], date: Double) {

        self.combination = combination
        self.note = note
        self.photo = photo
        self.date = date
        self.message = message
    }

}
