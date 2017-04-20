//
//  SettingsTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/18.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    enum Component {
        case profile
        case profileSetting
        case accountSetting
        case logout
    }

    let component: [Component] = [ .profile, .profileSetting, .accountSetting, .logout ]
    var records: [Record] = []
    var postCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"

        self.tableView.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")
        self.tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        RecordManager.shared.fetchRecords { (records) in
            if let record = records {
                self.records = record
                self.records.sort(by: { $0.date > $1.date })
                self.tableView.reloadData()
            }
        }

        CommunityManager.shared.fetchCurrentUserPosts { (count) in
            print("Posts: \(count)")

            self.postCount = count
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.component.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.component[indexPath.section]

        switch component {
        case .profile :
            // swiftlint:disable force_cast
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell

            cell.userNameLabel.text = currentUser.username
            cell.recordNumberLabel.text = self.records.count.description
            cell.postNumberLabel.text = self.postCount.description

            return cell

        case .profileSetting:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Profile Seeting"
            cell.accessoryType = .disclosureIndicator

            return cell

        case .accountSetting:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Account Seeting"
            cell.accessoryType = .disclosureIndicator

            return cell

        case .logout:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Log Out"

            return cell

        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let component = self.component[indexPath.section]

        if component == .profileSetting {

            let profileVC = ProfileSettingTableViewController()
            self.navigationController?.pushViewController(profileVC, animated: true)

        } else if component == .accountSetting {

            let accountVC = AccountSettingTableViewController()
            self.navigationController?.pushViewController(accountVC, animated: true)

        } else if component == .logout {

            self.showLogOutAlert()
        }
    }

    func showLogOutAlert() {

        let alertController = UIAlertController(title: "Log Out of Let's Dev?", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Log Out", style: .default) { (_) in

            LoginManager.shared.logOut({ (success, error) in

                if error != nil {
                    self.showTryAgainAlert()

                    return
                } else if success != nil {

                    let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpNavigation")
                    UIApplication.shared.keyWindow?.rootViewController = signUpVC
                }

            })

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }

    func showTryAgainAlert() {

        let alertController = UIAlertController(title: "Something goes wrong, please try again later.", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)
    }

}
