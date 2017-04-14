//
//  SharedPost.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

struct SharedPost {

    let combination: Combination!
    let note: String?
    let photo: [String?]
    let date: Double!
    let message: String!
    let comment: [PostComments?]
    let like: [PostLikes?]
    let favorite: [PostFavorites?]

//    init(message: String?, combination: Combination, note: String?, photo: [String?], date: Double) {
//
//        self.combination = combination
//        self.note = note
//        self.photo = photo
//        self.date = date
//        self.message = message
//    }

}

struct PostComments {

    let uid: String!
    let comment: String!
    let date: Double!

}

struct PostLikes {

    let uid: String!
    let date: Double!

}

struct PostFavorites {

    let uid: String!
    let date: Double!

}
