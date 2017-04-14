//
//  Comment.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/13.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

class Comment {

    let comment: String!
    let username: String!
    let userImageUrlString: String!
    let date: Double!

    init(comment: String, username: String, userImageUrlString: String, date: Double) {

        self.comment = comment
        self.username = username
        self.userImageUrlString = userImageUrlString
        self.date = date
    }

}
