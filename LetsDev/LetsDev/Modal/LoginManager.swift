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
    typealias CreateError = (_ message: String) -> Void

    func create(withEmail email: String, password: String, username: String, image: UIImage?, success: CreateSuccess?, fail: CreateError? = nil) {

        self.auth?.createUser(withEmail: email, password: password, completion: { (user, error) in

            guard let uid = user?.uid else { return }

            if let error = error, let errorCode = FIRAuthErrorCode(rawValue: error._code) {
                let message = ErrorHandler.getAuthErrorMessage(with: errorCode)
                fail?(message)
            }

            FIRAnalytics.logEvent(withName: kFIREventSignUp, parameters: [kFIRParameterSignUpMethod: "Email" as NSObject])

            if let image = image {
                self.updatePhoto(with: image, success: { (photoUrl) in
                    self.databaseRef.child("Users").child(uid).setValue(["Email": email, "Username": username, "Profile": photoUrl])

                    self.login(withEmail: email, password: password, success: { (email, uid) in
                        let user = User(uid: uid, email: email, username: username, profileImage: photoUrl)
                        success?(user)
                    }, fail: { (message) in
                        fail?(message)
                    })
                })
            } else {
                self.databaseRef.child("Users").child(user!.uid).setValue(["Email": email, "Username": username])

                self.login(withEmail: email, password: password, success: { (email, uid) in
                    let user = User(uid: uid, email: email, username: username)
                    success?(user)
                }, fail: { (message) in
                    fail?(message)
                })
            }
        })
    }

    typealias LoginSuccess = (_ email: String, _ uid: String) -> Void
    typealias LoginError = (_ message: String) -> Void

    func login(withEmail email: String, password: String, success: LoginSuccess?, fail: LoginError? = nil) {
        self.auth?.signIn(withEmail: email, password: password, completion: { (user, error) in

            if let error = error, let errorCode = FIRAuthErrorCode(rawValue: error._code) {
                let message = ErrorHandler.getAuthErrorMessage(with: errorCode)
                fail?(message)
            }

            FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: [kFIRParameterSignUpMethod: "Email" as NSObject])

            guard let userEmail = user?.email, let uid = user?.uid else { return }

            success?(userEmail, uid)

        })
        return
    }

    typealias LogOutResult = (_ success: String?, _ error: String?) -> Void

    func logOut(_ completion: LogOutResult?) {

        do {
            try self.auth?.signOut()
            completion?("Success", nil)
        } catch {
            completion?(nil, error.localizedDescription)
        }

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

    typealias EmailResult = (_ isInUse: Bool) -> Void

    func isEmailAlreadyInUse(email: String, isInUse: @escaping EmailResult) {

        self.databaseRef.child("Users").observeSingleEvent(of: .value, with: { (snapshots) in
            //
            var duplicate = false

            for snapshot in snapshots.children {

                guard let child = snapshot as? FIRDataSnapshot else { continue }

                print(snapshot)

                guard let user = child.value as? [String: Any] else { continue }

                print(user)

                guard let emailResult = user["Email"] as? String else { continue }

                print(email)

                if emailResult == email {
                    duplicate = true
                    isInUse(duplicate)
                    break
                }
            }
            isInUse(duplicate)
        })
    }

    func updatePhoto(with image: UIImage, success: @escaping (_ photoUrl: String) -> Void) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        if let uploadData = UIImageJPEGRepresentation(image, 0.3) {

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
