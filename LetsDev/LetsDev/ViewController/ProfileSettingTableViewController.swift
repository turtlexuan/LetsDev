//
//  ProfileSettingTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/19.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import DKImagePickerController

class ProfileSettingTableViewController: UITableViewController {

    enum Component {
        case profileImage
        case profileInfo
    }

    let component: [Component] = [ .profileImage, .profileInfo ]
    var profileImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileImageTableViewCell")
        self.tableView.register(UINib(nibName: "ProfileSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingTableViewCell")
//        self.tableView.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .black

//        self.profileImage = currentUser.
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
//            cell.usernameTextField.
            cell.emailTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.emailTextField.iconWidth = 30
            cell.emailTextField.iconMarginBottom = 2
            cell.emailTextField.iconMarginLeft = 8
            cell.emailTextField.iconColor = .white
            cell.emailTextField.selectedLineColor = .white
            cell.emailTextField.selectedIconColor = .white
            cell.emailTextField.textColor = .white
            cell.emailTextField.iconText = String.fontAwesomeIcon(name: .envelopeO)
            cell.emailTextField.keyboardType = .emailAddress
            cell.emailTextField.text = currentUser.email
            cell.emailTextField.delegate = self

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
//                    self.imageView.image = image
//                    self.profileImage = image
//                    self.imageChanged = true
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
//                    self.imageView.image = image
//                    self.profileImage = image
//                    self.imageChanged = true
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

}
