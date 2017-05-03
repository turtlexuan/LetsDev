//
//  ProfileSettingTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/19.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import DKImagePickerController
import NVActivityIndicatorView
import Whisper

class ProfileSettingTableViewController: UITableViewController {

    enum Component {
        case profileImage
        case profileInfo
    }

    let component: [Component] = [ .profileImage, .profileInfo ]
    var profileImage = UIImage()
    var isPhotoChanged = false
    var newUsername = ""
    var newBio = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.title = "Profile"

        self.tableView.register(UINib(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileImageTableViewCell")
        self.tableView.register(UINib(nibName: "ProfileSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .black
        self.tableView.keyboardDismissMode = .onDrag

        self.newUsername = currentUser.username
        if currentUser.bio != nil {
            self.newBio = currentUser.bio
        }

    }

    func saveAction() {

        self.tableView.endEditing(true)

        let activityData = ActivityData(type: .ballRotateChase)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        if self.isPhotoChanged == true {

            RecordManager.shared.updatePhoto(with: self.profileImage, success: { (photoString) in

                UserManager.shared.updateUser(self.newUsername, bio: self.newBio, profileImage: photoString, completion: { (_, error) in

                    if error != nil {
                        print(error ?? "")

                        return
                    }

                    let newCurrentUser = User(uid: currentUser.uid, email: currentUser.email, username: self.newUsername, profileImage: photoString, bio: self.newBio)
                    currentUser = newCurrentUser

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                    
                    let message = Message(title: "Profile Updated.", backgroundColor: .darkGray)
                    Whisper.show(whisper: message, to: self.navigationController!, action: .present)
                    hide(whisperFrom: self.navigationController!, after: 3)

                })
            })

        } else {

            UserManager.shared.updateUser(self.newUsername, bio: self.newBio, profileImage: currentUser.profileImage, completion: { (_, error) in

                if error != nil {
                    print(error ?? "")

                    return
                }

                let newCurrentUser = User(uid: currentUser.uid, email: currentUser.email, username: self.newUsername, profileImage: currentUser.profileImage, bio: self.newBio)
                currentUser = newCurrentUser

                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.navigationController?.popViewController(animated: true)
                
                let message = Message(title: "Profile Updated.", backgroundColor: .darkGray)
                Whisper.show(whisper: message, to: self.navigationController!, action: .present)
                hide(whisperFrom: self.navigationController!, after: 3)

            })

        }

    }

    func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.component.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.component[indexPath.section]

        switch component {
        case .profileImage:

            // swiftlint:disable force_cast
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileImageTableViewCell", for: indexPath) as! ProfileImageTableViewCell

            cell.selectionStyle = .none

            if let imageUrlString = currentUser.profileImage, let imageUrl = URL(string: imageUrlString) {
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: imageUrl)
            } else {
                cell.profileImageView.image = #imageLiteral(resourceName: "anonymous-logo")
            }

            return cell

        case .profileInfo:

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingTableViewCell", for: indexPath) as! ProfileSettingTableViewCell

            cell.selectionStyle = .none

            cell.bioTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.bioTextField.iconWidth = 30
            cell.bioTextField.iconMarginBottom = 2
            cell.bioTextField.iconMarginLeft = 8
            cell.bioTextField.iconColor = .white
            cell.bioTextField.selectedLineColor = .white
            cell.bioTextField.selectedIconColor = .white
            cell.bioTextField.textColor = .white
            cell.bioTextField.iconText = String.fontAwesomeIcon(name: .info)
            cell.bioTextField.placeholder = "Bio"
            cell.bioTextField.placeholderColor = .lightGray
            cell.bioTextField.setTitleVisible(false)
            cell.bioTextField.selectedTitle = ""
            cell.bioTextField.delegate = self

            cell.usernameTextField.errorColor = .red
            cell.usernameTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.usernameTextField.iconWidth = 30
            cell.usernameTextField.iconMarginBottom = 4
            cell.usernameTextField.iconMarginLeft = 8
            cell.usernameTextField.iconText = String.fontAwesomeIcon(name: .user)
            cell.usernameTextField.iconColor = .white
            cell.usernameTextField.selectedIconColor = .white
            cell.usernameTextField.selectedLineColor = .white
            cell.usernameTextField.textColor = .white
            cell.usernameTextField.placeholder = "Username"
            cell.usernameTextField.placeholderColor = .lightGray
            cell.usernameTextField.setTitleVisible(false)
            cell.usernameTextField.selectedTitle = ""
            cell.usernameTextField.text = currentUser.username
            cell.usernameTextField.delegate = self

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let component = self.component[indexPath.section]

        switch component {
        case .profileImage:
            //
            self.showImagePickerAlertSheet(indexPath)

        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let component = self.component[indexPath.section]

        switch component {
        case .profileImage:

            return 155

        case .profileInfo:

            return 90
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }

    func showImagePickerAlertSheet(_ indexPath: IndexPath) {

        let cell = self.tableView.cellForRow(at: indexPath) as! ProfileImageTableViewCell

        let alertController = UIAlertController(title: "Choose Image From?", message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Choose from photo library", style: .default) { (_) in

            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos
            pickerController.maxSelectableCount = 1
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")

                let asset = assets.first
                asset?.fetchOriginalImage(true, completeBlock: { (imageData, _) in
                    guard let image = imageData else { return }

                    cell.profileImageView.image = image

                    self.profileImage = image
                    self.isPhotoChanged = true
                })
            }
            self.present(pickerController, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (_) in

            let pickerController = DKImagePickerController()
            pickerController.sourceType = .camera

            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")

                let asset = assets.first
                asset?.fetchOriginalImage(true, completeBlock: { (imageData, _) in
                    guard let image = imageData else { return }

                    cell.profileImageView.image = image

                    self.profileImage = image
                    self.isPhotoChanged = true
                })
            }
            self.present(pickerController, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension ProfileSettingTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {

        let cell = textField.superview?.superview as! ProfileSettingTableViewCell

        if textField == cell.usernameTextField {
            if let username = textField.text {
                self.newUsername = username
            }

            print("This is username")
        } else {
            if let bio = textField.text {
                self.newBio = bio
            }
            print("This is bio")
        }

    }

}
