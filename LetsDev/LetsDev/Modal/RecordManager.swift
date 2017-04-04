//
//  RecordManager.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/29.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SKPhotoBrowser

class RecordManager {

    static let shared = RecordManager()
    private let databaseRef = FIRDatabase.database().reference()
    private let storageRef = FIRStorage.storage().reference()
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
            let washTime    = combination.washTime,
            let dilution = combination.dilution,
            let temp = combination.temp else { return }

        let devAgitation = combination.devAgitation.rawValue
        let fixAgitation = combination.fixAgitation.rawValue

        let value = ["Film": film, "Type": type, "Developer": developer, "BufferTime": bufferTime, "PreWashTime": preWashTime, "DevTime": devTime, "StopTime": stopTime, "FixTime": fixTime, "WashTime": washTime, "DevAgitation": devAgitation, "FixAgitation": fixAgitation, "Dilution": dilution, "Temp": temp] as [String : Any]

//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//
//        let date = dateFormatter.string(from: Date())
        
        let date = Date().timeIntervalSince1970 * 1000

        self.databaseRef.child("Records").child(uid).childByAutoId().setValue(["Date": date]) { (error, databaseRef) in
            if error != nil {
                fail?(error!)
            }

            self.databaseRef.child("Records").child(uid).child(databaseRef.key).child("Combination").setValue(value) { (error, databaseRef) in
                if error != nil {
                    fail?(error!)
                }

                success?(databaseRef)
            }
        }

    }

    func updateNote(with note: String, key: String) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        let value = ["Note": note]

        self.databaseRef.child("Records").child(uid).child(key).updateChildValues(value)
    }

    func updatePhoto(with image: SKPhoto, success: @escaping (_ photoUrl: String) -> Void) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        if let uploadData = UIImageJPEGRepresentation(image.underlyingImage, 0.5) {

            let storagePath = storageRef.child(uid).child("\(UUID().uuidString).jpg")
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

    func updatePhotoUrl(with urls: [String], key: String) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        self.databaseRef.child("Records").child(uid).child(key).updateChildValues(["Photo": urls])

    }

    typealias FetchSuccess = (_ value: [Record]?) -> Void

    func fetchRecords(_ completion: @escaping FetchSuccess) {

        guard let uid = self.auth?.currentUser?.uid else { return }

        var records: [Record] = []

        self.databaseRef.child("Records").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            records = []

            for child in snapshot.children {

                guard let task = child as? FIRDataSnapshot else { continue }
                guard let value = task.value as? [String: Any] else { continue }
                guard
                    let combination = value["Combination"] as? [String: Any],
                    let millisDate = value["Date"] as? Double else { continue }
                
                var note = ""
                var photo: [String] = []

                if let notes = value["Note"] as? String {
                    note = notes
                }

                if let photos = value["Photo"] as? [String] {
                    photo = photos
                }

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

                let record = Record(combination: combinations, note: note, photo: photo, date: millisDate, key: task.key)

                records.append(record)
            }
            self.databaseRef.child("Records").child(uid).removeAllObservers()
            completion(records)
        })

//        self.databaseRef.child("Records").child(uid).removeAllObservers()
    }

}
