//
//  User.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import UIKit

class User {

    let email: String!
    let username: String!
    let uid: String!
    let profileImage: String!

    init(uid: String, email: String, username: String, profileImage: String? = nil) {
        self.uid = uid
        self.email = email
        self.username = username
        self.profileImage = profileImage
    }
}
