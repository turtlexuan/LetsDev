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

    func getUser(_ uid: String, completion: @escaping GetUserSuccess) {

//        guard let uid = self.auth?.currentUser?.uid else { return }

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

    typealias UpdateResult = (_ databaseRef: FIRDatabaseReference, _ error: Error?) -> Void

    func updateUser(_ username: String, bio: String, profileImage: String, completion: @escaping UpdateResult) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        let value = ["Username": username, "Profile": profileImage, "Bio": bio]

        self.databaseRef.child("Users").child(uid).updateChildValues(value) { (error, databaseRef) in

            completion(databaseRef, error)
        }
    }

    typealias UpdateEmailResult = (_ success: String?, _ error: Error?) -> Void

    func updateEmail(with newEmail: String, oldEmail: String, password: String, completion: @escaping UpdateEmailResult) {

        let credential = FIREmailPasswordAuthProvider.credential(withEmail: oldEmail, password: password)

        self.auth?.currentUser?.reauthenticate(with: credential, completion: { (error) in

            if error != nil {
                print(error ?? "")

                completion(nil, error)

                return
            }

            self.auth?.currentUser?.updateEmail(newEmail, completion: { (error) in

                if error != nil {
                    completion(nil, error)
                    return
                }

                completion("Success", nil)

            })

        })

    }

    typealias UpdatePasswordResult = (_ error: Error?) -> Void

    func updatePassword(with newPassword: String, email: String, currentPassword: String, completion: @escaping UpdatePasswordResult) {

        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: currentPassword)

        self.auth?.currentUser?.reauthenticate(with: credential, completion: { (error) in

            if error != nil {

                print(error ?? "")

                completion(error)

                return

            }

            self.auth?.currentUser?.updatePassword(newPassword, completion: { (error) in

                if error != nil {

                    print(error ?? "")

                    completion(error)

                    return

                }

                completion(nil)
            })
        })

    }

}
