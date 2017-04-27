//
//  SettingsTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/18.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

class SettingsTableViewController: UITableViewController {

    enum Component {
        case profile
        case profileSetting
        case accountSetting
        case privacyPolicy
        case contactUs
        case logout
        case signUp
        case logIn
    }

    var component: [Component] = [ .profile, .profileSetting, .accountSetting, .contactUs, .privacyPolicy, .logout ]
    var records: [Record] = []
    var postCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"

        self.tableView.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")
        self.tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120

        if currentUser.uid == nil {
            self.component = [ .profile, .signUp, .logIn, .contactUs, .privacyPolicy ]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let activityData = ActivityData(type: .ballRotateChase)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        if currentUser.uid == nil {

            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            return
        }

        RecordManager.shared.fetchRecords { (records) in
            CommunityManager.shared.fetchCurrentUserPosts { (count) in
                print("Posts: \(count)")

                self.postCount = count
                self.tableView.reloadData()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            if let record = records {
                self.records = record
                self.records.sort(by: { $0.date > $1.date })

            }
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

            if let imageUrlString = currentUser.profileImage, let imageUrl = URL(string: imageUrlString) {
                cell.userImageView.kf.indicatorType = .activity
                cell.userImageView.kf.setImage(with: imageUrl)
            } else {
                cell.userImageView.image = #imageLiteral(resourceName: "anonymous-logo")
            }

            return cell

        case .profileSetting:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Profile Setting"
            cell.accessoryType = .disclosureIndicator

            return cell

        case .accountSetting:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Account Setting"
            cell.accessoryType = .disclosureIndicator

            return cell

        case .logout:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Log Out"

            return cell

        case .signUp:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Sign Up"

            return cell

        case .logIn:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Log In"

            return cell

        case .privacyPolicy:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Privacy Policy"

            return cell

        case .contactUs:

            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell

            cell.titleLabel.text = "Contact Us"

            return cell

        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let component = self.component[indexPath.section]

        switch component {
        case .profileSetting:

            let profileVC = ProfileSettingTableViewController()
            self.navigationController?.pushViewController(profileVC, animated: true)

        case .accountSetting:

            let accountVC = AccountSettingTableViewController()
            self.navigationController?.pushViewController(accountVC, animated: true)

        case .logout:

            self.showLogOutAlert()

        case .signUp:

            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserNavigation")

            self.present(signUpVC!, animated: true, completion: nil)

        case .logIn:

            let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInNavigation")

            self.present(logInVC!, animated: true, completion: nil)

        case .privacyPolicy:

            let privacyVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController

            self.navigationController?.pushViewController(privacyVC, animated: true)

        case .contactUs:

            self.sendEmail()

        default:

            break
        }
    }

    func sendEmail() {

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["turtlexuan@gmail.com"])

            present(mail, animated: true)
        } else {
            return
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

                    guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }

                    if let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpNavigation") {
                        signUpVC.view.frame = rootViewController.view.frame
                        signUpVC.view.layoutIfNeeded()

                        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            window.rootViewController = signUpVC
                        })
                    }
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

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true)
    }

}
