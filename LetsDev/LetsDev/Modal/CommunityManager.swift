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

        self.databaseRef.child("Community").childByAutoId().setValue(["Date": date, "Uid": uid, "Combination": value, "Message": record.message, "Photo": record.photo, "Note": note]) { (error, databaseRef) in

            if error != nil {
                print(error)
                fail?(error!)
                return
            }

            success?(databaseRef)
        }
    }

    typealias FetchSuccess = (_ sharedPosts: [(sharedPost: SharedPost, uid: String, key: String)]) -> Void

    func getPost(completion: @escaping FetchSuccess) {

        self.databaseRef.child("Community").observeSingleEvent(of: .value, with: { (snapshot) in

            var sharedPostTuple: [(sharedPost: SharedPost, uid: String, key: String)] = []

            for child in snapshot.children {
                guard let task = child as? FIRDataSnapshot else { continue }
                guard let value = task.value as? [String: Any] else { continue }

                guard
                    let combination = value["Combination"] as? [String: Any],
                    let millisDate = value["Date"] as? Double,
                    let message = value["Message"] as? String,
                    let uid = value["Uid"] as? String,
                    let note = value["Note"] as? String,
                    let photos = value["Photo"] as? [String] else { continue }

                guard
                    let film = combination["Film"] as? String,
                    let type = combination["Type"] as? String,
                    let developer = combination["Developer"] as? String,
                    let preWashTime = combination["PreWashTime"] as? Int,
                    let devTime = combination["DevTime"] as? Int,
                    let devAgitationString = combination["DevAgitation"] as? String,
                    let devAgitation = Agigtations(rawValue: devAgitationString),
                    let stopTime = combination["StopTime"] as? Int,
                    let fixTime = combination["FixTime"] as? Int,
                    let fixAgitationString = combination["FixAgitation"] as? String,
                    let fixAgitation = Agigtations(rawValue: fixAgitationString),
                    let washTime = combination["WashTime"] as? Int,
                    let bufferTime = combination["BufferTime"] as? Int,
                    let dilution = combination["Dilution"] as? String,
                    let temp = combination["Temp"] as? Int else { continue }

                let combinations = Combination(film: film, type: type, preWashTime: preWashTime, dev: developer, dilution: dilution, devTime: devTime, temp: temp, devAgitation: devAgitation, stopTime: stopTime, fixTime: fixTime, fixAgitation: fixAgitation, washTime: washTime, bufferTime: bufferTime)

                let sharedPost = SharedPost(message: message, combination: combinations, note: note, photo: photos, date: millisDate)

                sharedPostTuple.append((sharedPost, uid, task.key))

                print(value)
            }

            completion(sharedPostTuple)

        })

    }

}
