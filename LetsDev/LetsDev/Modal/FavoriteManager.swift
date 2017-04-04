//
//  FavoriteManager.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/4.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase

class FavoriteManager {

    static let shared = FavoriteManager()
    private let databaseRef = FIRDatabase.database().reference()
    private let storageRef = FIRStorage.storage().reference()
    private let auth = FIRAuth.auth()

    func updateFavorite(with recordKey: [String]) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        self.databaseRef.child("Favorite").updateChildValues([uid: recordKey]) { (error, _) in
            //
            if error == nil {
                print("Success")
            }
        }
    }

    func getFavorite(_ completion: @escaping (_ favoriteKeys: [String]) -> Void) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        var favoriteKeys: [String] = []

        self.databaseRef.child("Favorite").child(uid).observeSingleEvent(of: .value, with: { (snapshots) in

            for snapshot in snapshots.children {
                if let child = snapshot as? FIRDataSnapshot {
                    if let favoriteKey = child.value as? String {
                        favoriteKeys.append(favoriteKey)
                    }
                }
            }

            completion(favoriteKeys)

        })
    }

    func fetchFavorite(_ completion: @escaping (_ favorites: [Combination]) -> Void) {

        var combinationArray: [Combination] = []

        self.databaseRef.child("Records").observeSingleEvent(of: .value, with: { (snapshots) in

            for snapshot in snapshots.children {

                guard let child = snapshot as? FIRDataSnapshot else { continue }

                for kid in child.children {

                    guard let boy = kid as? FIRDataSnapshot else { continue }

                    print(boy.key)

                    if TabBarController.favoriteKeys.contains(boy.key) {
                        print("Yes")

                        guard let value = boy.value as? [String: Any] else { continue }

                        guard let combination = value["Combination"] as? [String: Any] else { continue }

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

                        combinationArray.append(combinations)
                    }
                }
            }

            print(combinationArray.count)
            completion(combinationArray)
        })

//        for favoriteKey in TabBarController.favoriteKeys {
//            
//            
//        }
    }
}
