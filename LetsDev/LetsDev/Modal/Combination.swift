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

    init(film: String, type: String, preWashMinute: Int, preWashSecond: Int, dev: String, dilution: String, devMinute: Int, devSecond: Int, temp: Int, devAgitation: Agigtations, stopMinute: Int, stopSecond: Int, fixMinute: Int, fixSecond: Int, fixAgitation: Agigtations, washMinute: Int, washSecond: Int, bufferMinute: Int, bufferSecond: Int) {
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
