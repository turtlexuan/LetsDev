//
//  AccountSettingTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/19.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class AccountSettingTableViewController: UITableViewController {

    enum Component {
        case emailSetting
        case passwordSetting
    }

    let components: [Component] = [ .emailSetting, .passwordSetting ]
    var newEmail = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "PrivateSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivateSettingTableViewCell")
        self.tableView.register(UINib(nibName: "PasswordSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "PasswordSettingTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .black
        self.tableView.keyboardDismissMode = .onDrag
        
        self.newEmail = currentUser.email

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

        let component = self.components[indexPath.row]

        switch component {

        case .emailSetting:

            break

        case .passwordSetting:

            let passwordVC = PasswordSettingTableViewController()
            self.navigationController?.pushViewController(passwordVC, animated: true)

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
