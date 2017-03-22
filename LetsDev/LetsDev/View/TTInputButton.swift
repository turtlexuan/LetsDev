//
//  TTInputButton.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/22.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class TTInputButton: UIButton {

    var ttInputView: UIView?
    var ttInputAccessoryView: UIView?

    override var inputView: UIView? {
        get {
            return self.ttInputView
        }

        set {
            self.ttInputView = newValue
        }
    }

    override var inputAccessoryView: UIView? {
        get {
            return self.ttInputAccessoryView
        }

        set {
            self.ttInputAccessoryView = newValue
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}
