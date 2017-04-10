//
//  ShareNewPostViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class ShareNewPostViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var filmLabel: UILabel!
    @IBOutlet weak var devLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var recordNoteLabel: UILabel!
    @IBOutlet weak var dilutionLabel: UILabel!

    var combination = Combination()
    var note = ""
    var photos: [SKPhoto] = []
    var photoString: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageTextView.text = "Write something about your developement."
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        messageTextView.becomeFirstResponder()

        self.setUpView()

//        print(PersonalTableViewController.currentUser.username)
    }

    func setUpView() {
        self.backgroundView.layer.cornerRadius = 8
        self.messageTextView.layer.cornerRadius = 8
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.width / 2

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        let dateString = dateFormatter.string(from: Date())
        self.dateLabel.text = dateString

        if PersonalTableViewController.currentUser.profileImage == nil {
            self.profileImageView.image = #imageLiteral(resourceName: "anonymous-logo")
        } else {
            let url = URL(string: PersonalTableViewController.currentUser.profileImage)
            self.profileImageView.kf.setImage(with: url)
        }

        self.usernameLabel.text = PersonalTableViewController.currentUser.username

        guard let devTime = self.combination.devTime, let dilution = self.combination.dilution else {
            return
        }

        self.filmLabel.text = self.combination.film
        self.devLabel.text = self.combination.dev
        self.devTimeLabel.text = "Dev Time : \(devTime)"
        self.dilutionLabel.text = "Dilution : \(dilution)"

        if self.photos.count != 0 {
            self.recordImageView.image = self.photos.first?.underlyingImage
        }

        self.recordNoteLabel.text = self.note

    }

    @IBAction func shareAction(_ sender: Any) {

        let sharedPost = SharedPost(message: self.messageTextView.text, combination: combination, note: self.note, photo: self.photoString, date: Date().timeIntervalSince1970 * 1000)

        print(self.photoString)

        CommunityManager.shared.shareRecord(with: sharedPost, success: { (databaseRef) in
            print(databaseRef.key)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print(error)
        }

    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShareNewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something about your developement."
            textView.textColor = UIColor.lightGray
        }
    }
}
