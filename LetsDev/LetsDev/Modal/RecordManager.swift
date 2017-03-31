//
//  RecordManager.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/29.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase

class RecordManager {

    static let shared = RecordManager()
    private let databaseRef = FIRDatabase.database().reference()
    private let auth = FIRAuth.auth()

    typealias UploadSuccess = (_ databaseRef: FIRDatabaseReference) -> Void
    typealias UploadError = (_ error: Error) -> Void

    func uploadRecord(with combination: Combination, success: UploadSuccess?, fail: UploadError?) {

        guard
            let film        = combination.film,
            let type        = combination.type,
            let developer   = combination.dev,
            let uid         = self.auth?.currentUser?.uid,
            let bufferTime  = combination.bufferTime,
            let preWashTime = combination.preWashTime,
            let devTime     = combination.devTime,
            let stopTime    = combination.stopTime,
            let fixTime     = combination.fixTime,
            let washTime    = combination.washTime else { return }

        let devAgitation = combination.devAgitation.rawValue
        let fixAgitation = combination.fixAgitation.rawValue

        let value = ["Film": film, "Type": type, "Developer": developer, "BufferTime": bufferTime, "PreWashTime": preWashTime, "DevTime": devTime, "StopTime": stopTime, "FixTime": fixTime, "WashTime": washTime, "DevAgitation": devAgitation, "FixAgitation": fixAgitation] as [String : Any]

        self.databaseRef.child("Records").childByAutoId().setValue(["Uid": uid]) { (error, databaseRef) in
            if error != nil {
                fail?(error!)
            }
            self.databaseRef.child("Records").child(databaseRef.key).child("Combination").setValue(value) { (error, databaseRef) in
                if error != nil {
                    fail?(error!)
                }

                success?(databaseRef)
            }
        }
    }

    func updateNote(with note: String, key: String) {

        let value = ["Note": note]

        self.databaseRef.child("Records").child(key).updateChildValues(value)
    }

}
