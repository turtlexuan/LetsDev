//
//  CollectionHeight.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/28.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class CollectionHeight {

    static let totalItem: CGFloat = 20

    static let column: CGFloat = 3

    static let minLineSpacing: CGFloat = 14
    static let minItemSpacing: CGFloat = 14

    static let offset: CGFloat = 14

    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {

        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)

        return totalWidth / column
    }

    static func getCollectionHeight(itemHeight: CGFloat, totalItem: Int) -> CGFloat {
        let totalRow = ceil(CGFloat(totalItem) / column)
        let totalTopBottomOffset = offset * 2
        let totalSpacing = CGFloat(totalRow - 1) * minLineSpacing
        let totalHeight = (itemHeight * CGFloat(totalRow)) + totalTopBottomOffset + totalSpacing

        return totalHeight
    }
}
