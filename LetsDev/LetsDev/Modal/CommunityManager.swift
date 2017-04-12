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

    func shareRecord(with record: SharedPost, recordKey: String, success: SharedSuccess?, fail: SharedFailure?) {

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

        self.databaseRef.child("Community").child(recordKey).setValue(["Date": date, "Uid": uid, "Combination": value, "Message": record.message, "Photo": record.photo, "Note": note]) { (error, databaseRef) in

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
                    let combination     = value["Combination"] as? [String: Any],
                    let millisDate      = value["Date"] as? Double,
                    let message         = value["Message"] as? String,
                    let uid             = value["Uid"] as? String,
                    let note            = value["Note"] as? String else { continue }
                
                var photoString = [""]
                
                if let photos = value["Photo"] as? [String] {
                    photoString = photos
                }

                guard
                    let film                = combination["Film"] as? String,
                    let type                = combination["Type"] as? String,
                    let developer           = combination["Developer"] as? String,
                    let preWashTime         = combination["PreWashTime"] as? Int,
                    let devTime             = combination["DevTime"] as? Int,
                    let devAgitationString  = combination["DevAgitation"] as? String,
                    let devAgitation        = Agigtations(rawValue: devAgitationString),
                    let stopTime            = combination["StopTime"] as? Int,
                    let fixTime             = combination["FixTime"] as? Int,
                    let fixAgitationString  = combination["FixAgitation"] as? String,
                    let fixAgitation        = Agigtations(rawValue: fixAgitationString),
                    let washTime            = combination["WashTime"] as? Int,
                    let bufferTime          = combination["BufferTime"] as? Int,
                    let dilution            = combination["Dilution"] as? String,
                    let temp                = combination["Temp"] as? Int else { continue }

                let combinations = Combination(film: film, type: type, preWashTime: preWashTime, dev: developer, dilution: dilution, devTime: devTime, temp: temp, devAgitation: devAgitation, stopTime: stopTime, fixTime: fixTime, fixAgitation: fixAgitation, washTime: washTime, bufferTime: bufferTime)

                let sharedPost = SharedPost(message: message, combination: combinations, note: note, photo: photoString, date: millisDate)

                sharedPostTuple.append((sharedPost, uid, task.key))

                print(value)
            }

            completion(sharedPostTuple)

        })
    }
    
    typealias LikeActionResult = (_ success: FIRDatabaseReference, _ error: Error?) -> Void

    func likePost(_ key: String, completion: @escaping LikeActionResult) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        let date = Date().timeIntervalSince1970 * 1000
        
        self.databaseRef.child("Community").child(key).child("Like").child(uid).updateChildValues(["Uid": uid, "Date": date]) { (error, databaseRef) in
            completion(databaseRef, error)
        }
        
    }

    func removeLike(_ key: String, completion: @escaping LikeActionResult) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        self.databaseRef.child("Community").child(key).child("Like").child(uid).removeValue { (error, databaseRef) in

            completion(databaseRef, error)
        }
    }

    func commentPost() {

    }

    typealias LikeResult = (_ likes: [String]) -> Void

    func getLikes(_ key: String, completion: @escaping LikeResult) {

        var likes: [String] = []

        self.databaseRef.child("Community").child(key).child("Like").observeSingleEvent(of: .value, with: { (snapshot) in

            for childs in snapshot.children {

                guard let child = childs as? FIRDataSnapshot else { continue }

                let key = child.key

                likes.append(key)

            }

            completion(likes)

        })
    }
}
