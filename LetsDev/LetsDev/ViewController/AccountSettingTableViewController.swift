//
//  AccountSettingTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/19.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Whisper

class AccountSettingTableViewController: UITableViewController {

    enum Component {
        case emailSetting
        case passwordSetting
    }

    let components: [Component] = [ .emailSetting, .passwordSetting ]
    var newEmail = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(showLogInAlert))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.title = "Account"

        self.tableView.register(UINib(nibName: "PrivateSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivateSettingTableViewCell")
        self.tableView.register(UINib(nibName: "PasswordSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "PasswordSettingTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .black
        self.tableView.keyboardDismissMode = .onDrag

        self.newEmail = currentUser.email

    }

    func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func showLogInAlert() {

        self.tableView.endEditing(true)

        let alertController = UIAlertController(title: "Log In Again", message: "For security reason, we need you to enter your original email and password again.", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Enter email"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Password"
            textField.isSecureTextEntry = true
        }

        let loginAction = UIAlertAction(title: "Log In", style: .default) { (_) in

            let activityData = ActivityData(type: .ballRotateChase)

            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

            if let email = alertController.textFields?[0].text, let password = alertController.textFields?[1].text {

                UserManager.shared.updateEmail(with: self.newEmail, oldEmail: email, password: password, completion: { (_, error) in

                    if error != nil {

                        print(error ?? "")

                        return

                    }

                    let newCurrentUser = User(uid: currentUser.uid, email: self.newEmail, username: currentUser.username, profileImage: currentUser.profileImage, bio: currentUser.bio)
                    currentUser = newCurrentUser

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.navigationController?.popViewController(animated: true)

                    let message = Message(title: "Email Updated.", backgroundColor: .darkGray)
                    Whisper.show(whisper: message, to: self.navigationController!, action: .present)
                    hide(whisperFrom: self.navigationController!, after: 3)

                })

            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.components[indexPath.section]

        switch component {

        case .emailSetting:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateSettingTableViewCell", for: indexPath) as! PrivateSettingTableViewCell

            cell.textField.text = currentUser.email

            cell.textField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.textField.iconWidth = 30
            cell.textField.iconMarginBottom = 4
            cell.textField.iconMarginLeft = 8
            cell.textField.iconText = String.fontAwesomeIcon(name: .envelopeO)
            cell.textField.iconColor = .white
            cell.textField.selectedIconColor = .white
            cell.textField.selectedLineColor = .white
            cell.textField.textColor = .white
            cell.textField.placeholder = "Current Email"
            cell.textField.placeholderColor = .lightGray
            cell.textField.setTitleVisible(false)
            cell.textField.title = ""
            cell.textField.selectedTitle = ""
            cell.textField.delegate = self

            return cell

        case .passwordSetting:

            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordSettingTableViewCell", for: indexPath) as! PasswordSettingTableViewCell

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let component = self.components[indexPath.section]

        switch component {

        case .passwordSetting:

            let passwordVC = PasswordSettingTableViewController()
            self.navigationController?.pushViewController(passwordVC, animated: true)

        default:

            return

        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
}

extension AccountSettingTableViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        if let email = textField.text {
            self.newEmail = email
        }

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

}
