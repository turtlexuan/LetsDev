//
//  UserManager.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/3.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase

class UserManager {

    static let shared = UserManager()
    private let databaseRef = FIRDatabase.database().reference()
    private let storageRef = FIRStorage.storage().reference()
    private let auth = FIRAuth.auth()

    typealias GetUserSuccess = (_ user: User) -> Void

    func getUser(completion: @escaping GetUserSuccess) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        self.databaseRef.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //
            guard let data = snapshot.value as? [String: Any] else { return }

            guard
                let username = data["Username"] as? String,
                let email = data["Email"] as? String else { return }

            if let photoUrl = data["Profile"] as? String {
                let user = User(uid: uid, email: email, username: username, profileImage: photoUrl)

                completion(user)
            } else {
                let user = User(uid: uid, email: email, username: username)

                completion(user)
            }

        })
    }

}
