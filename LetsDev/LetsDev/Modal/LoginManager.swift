//
//  LoginManager.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SKPhotoBrowser

class LoginManager: NSObject {

    static let shared = LoginManager()
    private let auth = FIRAuth.auth()
    private let databaseRef = FIRDatabase.database().reference()
    private let storageRef = FIRStorage.storage().reference()

    typealias CreateSuccess = (User) -> Void
    typealias CreateError = (Error) -> Void

    func create(withEmail email: String, password: String, username: String, image: UIImage?, success: CreateSuccess?, fail: CreateError? = nil) {

        self.auth?.createUser(withEmail: email, password: password, completion: { (user, error) in

            guard let uid = user?.uid else { return }

            if error?.localizedDescription == "The email address is already in use by another account." {
                print("Create user error: \(String(describing: error?.localizedDescription))")
                fail?(error!)
                return
            } else if error != nil {
                print("Create user error: \(String(describing: error?.localizedDescription))")
                fail?(error!)
                return
            }

            if let image = image {
                self.updatePhoto(with: image, success: { (photoUrl) in
                    self.databaseRef.child("Users").child(uid).setValue(["Email": email, "Username": username, "Profile": photoUrl])

                    self.login(withEmail: email, password: password, success: { (email, uid) in
                        let user = User(uid: uid, email: email, username: username, profileImage: photoUrl)
                        success?(user)
                    }, fail: { (error) in
                        fail?(error)
                    })
                })
            } else {
                self.databaseRef.child("Users").child(user!.uid).setValue(["Email": email, "Username": username])

                self.login(withEmail: email, password: password, success: { (email, uid) in
                    let user = User(uid: uid, email: email, username: username)
                    success?(user)
                }, fail: { (error) in
                    fail?(error)
                })
            }
//            
//            self.updatePhoto(with: image, success: { (photoUrl) in
//                self.databaseRef.child("Users").child(uid).setValue(["Email": email, "Username": username, "Profile": photoUrl])
//
//                self.login(withEmail: email, password: password, success: { (email, uid) in
//                    let user = User(uid: uid, email: email, username: username)
//                    success?(user)
//                }, fail: { (error) in
//                    fail?(error)
//                })
//            })

        })

    }

    typealias LoginSuccess = (_ email: String, _ uid: String) -> Void
    typealias LoginError = (Error) -> Void

    func login(withEmail email: String, password: String, success: LoginSuccess?, fail: LoginError? = nil) {
        self.auth?.signIn(withEmail: email, password: password, completion: { (user, error) in

            if error != nil {
                print("Sign in error: \(String(describing: error))")
                fail?(error!)
                return
            }

            guard let userEmail = user?.email, let uid = user?.uid else { return }

            success?(userEmail, uid)
            print("Success login with user: \(String(describing: user?.email)), uid: \(String(describing: user?.uid))")

        })
        return
    }

    typealias UsernameResult = (_ isDuplicate: Bool) -> Void

    func isUsernameDuplicate(username: String, isDuplicate: @escaping UsernameResult) {

        self.databaseRef.child("Users").observeSingleEvent(of: .value, with: { (snapshots) in
            //
            var duplicate = false

            for snapshot in snapshots.children {

                guard let child = snapshot as? FIRDataSnapshot else { continue }

                print(snapshot)

                guard let user = child.value as? [String: Any] else { continue }

                print(user)

                guard let name = user["Username"] as? String else { continue }

                print(name)

                if name == username {
                    duplicate = true
                    isDuplicate(duplicate)
                    break
                }
            }
            isDuplicate(duplicate)
        })

    }

    func updatePhoto(with image: UIImage, success: @escaping (_ photoUrl: String) -> Void) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        if let uploadData = UIImageJPEGRepresentation(image, 0.5) {

            let storagePath = storageRef.child(uid).child("profileImage.jpg")
            storagePath.put(uploadData, metadata: nil, completion: { (metaData, error) in

                if error != nil {
                    print("Upload Error: \(String(describing: error?.localizedDescription))")
                    return
                }

                guard let photoUrl = metaData?.downloadURL()?.absoluteString else { return }
                success(photoUrl)
            })
        }
    }

    func updatePhotoUrl(with url: String, key: String) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        self.databaseRef.child("Users").child(uid).updateChildValues(["Photo": url])

    }

}
