//
//  User.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

class User {

    let email: String!
    let username: String!
    let uid: String!

    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
    }
}
