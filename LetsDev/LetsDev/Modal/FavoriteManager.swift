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
}
