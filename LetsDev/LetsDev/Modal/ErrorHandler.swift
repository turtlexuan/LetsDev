//
//  ErrorHandler.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase

class ErrorHandler {

    static func getAuthErrorMessage(with error: FIRAuthErrorCode) -> String {

        var message = ""

        switch error {
        case .errorCodeEmailAlreadyInUse:
            message = "This Email Address is Already be Registered."
        case .errorCodeWrongPassword:
            message = "Wrong Password."
        case .errorCodeInvalidEmail:
            message = "Invalid Email."
        case .errorCodeNetworkError:
            message = "Network Error"
        case .errorCodeUserNotFound:
            message = "User Not Found."
        default:
            message = "Unknown Error."
        }

        return message
    }

}
