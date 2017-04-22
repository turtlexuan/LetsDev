//
//  PasswordSettingTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/21.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PasswordSettingTableViewController: UITableViewController {

    enum Component {
        case oldPassword
        case newPassword
    }

    let components: [Component] = [ .oldPassword, .newPassword ]
    var currentPassword = ""
    var newPassword = ""
    var secondNewPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.title = "Password"

        self.tableView.register(UINib(nibName: "PrivateSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivateSettingTableViewCell")
        self.tableView.register(UINib(nibName: "ProfileSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .black
        self.tableView.keyboardDismissMode = .onDrag

    }

    func saveAction() {

        self.tableView.endEditing(true)

        let activityData = ActivityData(type: .ballRotateChase)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        if self.newPassword.characters.count < 8 {

            self.showValidateAlert()

            return
        }

        if self.newPassword != self.secondNewPassword {

            self.showDifferentAlert()

            return

        }

        UserManager.shared.updatePassword(with: self.newPassword, email: currentUser.email, currentPassword: self.currentPassword) { (error) in

            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            if error != nil {

                print(error ?? "")

                return

            }

            self.navigationController?.popToRootViewController(animated: true)
        }

        print("Current : \(self.currentPassword)")
        print("New : \(self.newPassword)")
        print("Second : \(self.secondNewPassword)")

    }

    func cancelAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func showValidateAlert() {

        let alertController = UIAlertController(title: "Password Invalidate", message: "Password should contain at least 8 characters", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }

        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)

    }

    func showDifferentAlert() {

        let alertController = UIAlertController(title: "Password Invalidate", message: "Password not match", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }

        alertController.addAction(doneAction)

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

        let components = self.components[indexPath.section]

        switch components {
        case .oldPassword:

            //swiftlint:disable force_cast
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PrivateSettingTableViewCell", for: indexPath) as! PrivateSettingTableViewCell

            cell.textField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.textField.iconWidth = 30
            cell.textField.iconMarginBottom = 2
            cell.textField.iconMarginLeft = 8
            cell.textField.iconColor = .lightGray
            cell.textField.selectedLineColor = .white
            cell.textField.textColor = .white
            cell.textField.selectedIconColor = .white
            cell.textField.iconText = String.fontAwesomeIcon(name: .lock)
            cell.textField.isSecureTextEntry = true
            cell.textField.placeholder = "Current Password"
            cell.textField.placeholderColor = .lightGray
            cell.textField.setTitleVisible(false)
            cell.textField.title = ""
            cell.textField.selectedTitle = ""
            cell.textField.delegate = self

            return cell

        case .newPassword:

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingTableViewCell", for: indexPath) as! ProfileSettingTableViewCell

            cell.usernameTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.usernameTextField.iconWidth = 30
            cell.usernameTextField.iconMarginBottom = 2
            cell.usernameTextField.iconMarginLeft = 8
            cell.usernameTextField.iconColor = .lightGray
            cell.usernameTextField.selectedLineColor = .white
            cell.usernameTextField.textColor = .white
            cell.usernameTextField.selectedIconColor = .white
            cell.usernameTextField.iconText = String.fontAwesomeIcon(name: .lock)
            cell.usernameTextField.isSecureTextEntry = true
            cell.usernameTextField.placeholder = "New Password"
            cell.usernameTextField.placeholderColor = .lightGray
            cell.usernameTextField.setTitleVisible(false)
            cell.usernameTextField.title = ""
            cell.usernameTextField.selectedTitle = ""
            cell.usernameTextField.delegate = self

            cell.bioTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.bioTextField.iconWidth = 30
            cell.bioTextField.iconMarginBottom = 2
            cell.bioTextField.iconMarginLeft = 8
            cell.bioTextField.iconColor = .lightGray
            cell.bioTextField.selectedLineColor = .white
            cell.bioTextField.textColor = .white
            cell.bioTextField.selectedIconColor = .white
            cell.bioTextField.iconText = String.fontAwesomeIcon(name: .lock)
            cell.bioTextField.isSecureTextEntry = true
            cell.bioTextField.placeholder = "New Password, Again"
            cell.bioTextField.placeholderColor = .lightGray
            cell.bioTextField.setTitleVisible(false)
            cell.bioTextField.title = ""
            cell.bioTextField.selectedTitle = ""
            cell.bioTextField.delegate = self

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let components = self.components[indexPath.section]

        switch components {
        case .oldPassword:
            return 44
        case .newPassword:
            return 90
        }
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

extension PasswordSettingTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let superViewClass = textField.superview?.superview?.classForCoder.description() else { return }

        if superViewClass == PrivateSettingTableViewCell.description() {

            guard let cell = textField.superview?.superview as? PrivateSettingTableViewCell else { return }

            if let text = cell.textField.text {
                self.currentPassword = text
            }

        } else {

            guard let cell = textField.superview?.superview as? ProfileSettingTableViewCell else { return }

            if let newText = cell.usernameTextField.text, let secondText = cell.bioTextField.text {
                self.newPassword = newText
                self.secondNewPassword = secondText
            }

        }

    }

}
