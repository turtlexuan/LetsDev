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
    let devMinute: Int!
    let devSecond: Int!
    let preWashMinute: Int!
    let preWashSecond: Int!
    let stopMinute: Int!
    let stopSecond: Int!
    let fixMinute: Int!
    let fixSecond: Int!
    let washMinute: Int!
    let washSecond: Int!
    let bufferMinute: Int!
    let bufferSecond: Int!
    let dilution: String!

    init(film: String = "Film", type: String = "135 mm", preWashMinute: Int = 0, preWashSecond: Int = 0, dev: String  = "Developer", dilution: String = "", devMinute: Int = 0, devSecond: Int = 0, temp: Int = 20, devAgitation: Agigtations = Agigtations.Every60Sec, stopMinute: Int = 0, stopSecond: Int = 0, fixMinute: Int = 0, fixSecond: Int = 0, fixAgitation: Agigtations = Agigtations.Every60Sec, washMinute: Int = 0, washSecond: Int = 0, bufferMinute: Int = 0, bufferSecond: Int = 0) {
        self.film = film
        self.type = type
        self.preWashMinute = preWashMinute
        self.preWashSecond = preWashSecond
        self.dev = dev
        self.dilution = dilution
        self.devMinute = devMinute
        self.devSecond = devSecond
        self.temp = temp
        self.devAgitation = devAgitation
        self.stopMinute = stopMinute
        self.stopSecond = stopSecond
        self.fixMinute = fixMinute
        self.fixSecond = fixSecond
        self.fixAgitation = fixAgitation
        self.washMinute = washMinute
        self.washSecond = washSecond
        self.bufferMinute = bufferMinute
        self.bufferSecond = bufferSecond
    }
}
