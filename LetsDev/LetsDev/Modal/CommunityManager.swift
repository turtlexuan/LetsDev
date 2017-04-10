//
//  CommunityManager.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase

class CommunityManager {

    static let shared = CommunityManager()
    private let databaseRef = FIRDatabase.database().reference()
    private let storageRef = FIRStorage.storage().reference()
    private let auth = FIRAuth.auth()

    typealias SharedSuccess = (_ databaseRef: FIRDatabaseReference) -> Void
    typealias SharedFailure = (_ error: Error) -> Void

    func shareRecord(with record: SharedPost, success: SharedSuccess?, fail: SharedFailure?) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        guard let date = record.date else { return }
        guard let combination = record.combination else { return }
        guard let note = record.note else { return }

        let value = ["Film": combination.film,
                     "Type": combination.type,
                     "Developer": combination.dev,
                     "BufferTime": combination.bufferTime,
                     "PreWashTime": combination.preWashTime,
                     "DevTime": combination.devTime,
                     "StopTime": combination.stopTime,
                     "FixTime": combination.fixTime,
                     "WashTime": combination.washTime,
                     "DevAgitation": combination.devAgitation.rawValue,
                     "FixAgitation": combination.fixAgitation.rawValue,
                     "Dilution": combination.dilution,
                     "Temp": combination.temp] as [String : Any]

        self.databaseRef.child("Community").childByAutoId().setValue(["Date": date, "Uid": uid, "Combination": value, "Mseeage": record.message, "Photo": record.photo, "Note": note]) { (error, databaseRef) in
            //

            if error != nil {
                print(error)
                fail?(error!)
                return
            }

            success?(databaseRef)
        }
    }
    
    func getPost() {
        
    }

}
