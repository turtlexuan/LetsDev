//
//  EmailSettingTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/21.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class EmailSettingTableViewController: UITableViewController {

    enum Component {
        case oldEmail
        case newEmail
    }

    let components: [Component] = [ .oldEmail, .newEmail ]

    override func viewDidLoad() {
        super.viewDidLoad()

//        let doneButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = cancelButton
//        self.navigationItem.rightBarButtonItem = doneButton

        self.tableView.register(UINib(nibName: "PrivateSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivateSettingTableViewCell")
        self.tableView.register(UINib(nibName: "ProfileSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .black
        self.tableView.keyboardDismissMode = .onDrag

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let components = self.components[indexPath.section]

        switch components {

        case .oldEmail:

            // swiftlint:disable force_cast
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PrivateSettingTableViewCell", for: indexPath) as! PrivateSettingTableViewCell

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
            cell.textField.selectedTitle = ""
            cell.textField.isUserInteractionEnabled = false
            cell.textField.delegate = self

            return cell

        case .newEmail:

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileSettingTableViewCell", for: indexPath) as! ProfileSettingTableViewCell

            cell.usernameTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.usernameTextField.iconWidth = 30
            cell.usernameTextField.iconMarginBottom = 4
            cell.usernameTextField.iconMarginLeft = 8
            cell.usernameTextField.iconText = String.fontAwesomeIcon(name: .envelopeO)
            cell.usernameTextField.iconColor = .white
            cell.usernameTextField.selectedIconColor = .white
            cell.usernameTextField.selectedLineColor = .white
            cell.usernameTextField.textColor = .white
            cell.usernameTextField.placeholder = "New Email"
            cell.usernameTextField.placeholderColor = .lightGray
            cell.usernameTextField.setTitleVisible(false)
            cell.usernameTextField.selectedTitle = ""
            cell.usernameTextField.isUserInteractionEnabled = false
            cell.usernameTextField.delegate = self

            cell.bioTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
            cell.bioTextField.iconWidth = 30
            cell.bioTextField.iconMarginBottom = 4
            cell.bioTextField.iconMarginLeft = 8
            cell.bioTextField.iconText = String.fontAwesomeIcon(name: .envelopeO)
            cell.bioTextField.iconColor = .white
            cell.bioTextField.selectedIconColor = .white
            cell.bioTextField.selectedLineColor = .white
            cell.bioTextField.textColor = .white
            cell.bioTextField.placeholder = "New Email"
            cell.bioTextField.placeholderColor = .lightGray
            cell.bioTextField.setTitleVisible(false)
            cell.bioTextField.selectedTitle = ""
            cell.bioTextField.isUserInteractionEnabled = false
            cell.bioTextField.delegate = self

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = self.components[indexPath.section]

        switch component {
        case .oldEmail:

            return 45

        case .newEmail:

            return 90
        }

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 30))
        view.backgroundColor = .black

        let titleLabel = UILabel(frame: CGRect(x: 12, y: 10, width: self.tableView.bounds.width, height: 17))
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Helvetica", size: 12)

        if section == 0 {

            titleLabel.text = "Current Email"

        } else if section == 1 {

            titleLabel.text = "New Email"

        }

        view.addSubview(titleLabel)

        return view
    }
}

extension EmailSettingTableViewController: UITextFieldDelegate {

}
