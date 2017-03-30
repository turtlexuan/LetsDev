//
//  Combination.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/22.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

class Combination {
    let film: String!
    let type: String!
    let dev: String!

    let temp: Int!
    let devAgitation: Agigtations!
    let fixAgitation: Agigtations!
    let dilution: String!

    let bufferTime: Int!
    let preWashTime: Int!
    let devTime: Int!
    let stopTime: Int!
    let fixTime: Int!
    let washTime: Int!

    init(film: String = "Film", type: String = "135 mm", preWashTime: Int = 0, dev: String  = "Developer", dilution: String = "", devTime: Int = 0, temp: Int = 20, devAgitation: Agigtations = Agigtations.Every60Sec, stopTime: Int = 0, fixTime: Int = 0, fixAgitation: Agigtations = Agigtations.Every60Sec, washTime: Int = 0, bufferTime: Int = 0) {
        self.film = film
        self.type = type
        self.preWashTime = preWashTime
        self.dev = dev
        self.dilution = dilution
        self.devTime = devTime
        self.temp = temp
        self.devAgitation = devAgitation
        self.stopTime = stopTime
        self.fixTime = fixTime
        self.fixAgitation = fixAgitation
        self.washTime = washTime
        self.bufferTime = bufferTime
    }
}
