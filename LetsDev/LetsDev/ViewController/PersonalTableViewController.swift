//
//  PersonalTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/3.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import NVActivityIndicatorView

class PersonalTableViewController: UITableViewController {

    enum Component {

        case profile, record

    }

    var components: [Component] = [.profile, .record]
    var records: [Record] = []
    var postCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")
        self.tableView.register(UINib(nibName: "RecordListTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordListTableViewCell")

        self.navigationItem.title = currentUser.username
        self.tableView.separatorStyle = .none

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if currentUser.uid == nil {
            let goSignUpView = self.configGoSignUpView()
            self.tableView.addSubview(goSignUpView)

            return
        }

        let activityData = ActivityData(type: .ballRotateChase)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

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

            let noRecordView = self.configNoRecordView()

            if records?.count == 0 {

                self.tableView.addSubview(noRecordView)
            } else {
                noRecordView.removeFromSuperview()
            }
        }

    }

    func configNoRecordView() -> UIView {

        let noReordView = UIView(frame: CGRect(x: 12, y: 150, width: self.tableView.frame.width - 24, height: 150))
        noReordView.backgroundColor = Color.cellColor
        noReordView.layer.cornerRadius = 10

        let titleLabel = UILabel(frame: CGRect(x: 12, y: 18, width: noReordView.frame.width - 24, height: 50))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "You don't have any record.\nLet's start a new development!"
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true

        noReordView.addSubview(titleLabel)

        let startButton = UIButton(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 12, width: 50, height: 50))
        startButton.center.x = titleLabel.center.x
        startButton.setImage(#imageLiteral(resourceName: "plusButton"), for: .normal)
        startButton.backgroundColor = Color.buttonColor
        startButton.layer.cornerRadius = 25
        startButton.addTarget(self, action: #selector(showNewDevVC), for: .touchUpInside)

        noReordView.addSubview(startButton)

        return noReordView

    }

    func configGoSignUpView() -> UIView {

        let goSignUpView = UIView(frame: CGRect(x: 12, y: 150, width: self.tableView.frame.width - 24, height: 150))
        goSignUpView.backgroundColor = Color.cellColor
        goSignUpView.layer.cornerRadius = 10

        let titleLabel = UILabel(frame: CGRect(x: 12, y: 18, width: goSignUpView.frame.width - 24, height: 50))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "Only registered member can store records.\nYou need to Sign Up / Log In."
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true

        goSignUpView.addSubview(titleLabel)

        let signUpButton = UIButton(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 15, width: 100, height: 44))
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = Color.buttonColor
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(showSignUpVC), for: .touchUpInside)

        let logInButton = UIButton(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 15, width: 100, height: 44))
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.backgroundColor = Color.buttonColor
        logInButton.layer.cornerRadius = 10
        logInButton.addTarget(self, action: #selector(showLogInVC), for: .touchUpInside)

        let buttonArray = [signUpButton, logInButton]

        let stackView = UIStackView(arrangedSubviews: buttonArray)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 15, width: 210, height: 44)
        stackView.center.x = titleLabel.center.x

        goSignUpView.addSubview(stackView)

        return goSignUpView

    }

    func showNewDevVC() {

        // swiftlint:disable force_cast
        let newDevVc = self.storyboard?.instantiateViewController(withIdentifier: "NewDevNavigationController")
        self.present(newDevVc!, animated: true, completion: nil)

    }

    func showSignUpVC() {

        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserNavigation")

        self.present(signUpVC!, animated: true, completion: nil)

    }

    func showLogInVC() {

        let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInNavigation")

        self.present(logInVC!, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = self.components[section]

        switch component {
        case .profile: return 1
        case .record: return self.records.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.components[indexPath.section]

        switch component {
        case .profile:

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell

            print(currentUser.username)
            cell.userNameLabel.text = currentUser.username
            cell.recordNumberLabel.text = String(self.records.count)
            cell.postNumberLabel.text = self.postCount.description
            cell.isUserInteractionEnabled = false

            if let imageUrlString = currentUser.profileImage, let imageUrl = URL(string: imageUrlString) {
                cell.userImageView.kf.indicatorType = .activity
                cell.userImageView.kf.setImage(with: imageUrl)
            } else {
                cell.userImageView.image = #imageLiteral(resourceName: "anonymous-logo")
            }

            return cell

        case .record:

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RecordListTableViewCell", for: indexPath) as! RecordListTableViewCell

            let index = self.records[indexPath.row]

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"

            let date = Date(timeIntervalSince1970: index.date / 1000)
            let dateString = dateFormatter.string(from: date)

            cell.selectionStyle = .none
            cell.devloperLabel.text = index.combination.dev
            cell.devTimeLabel.text = "Dev Time : \(self.timeExchanger(time: index.combination.devTime).minute)' \(self.timeExchanger(time: index.combination.devTime).second)\""
            cell.filmLabel.text = index.combination.film
            cell.timeLabel.text = dateString
            cell.noteLabel.text = index.note

            if let imageUrlString = index.photo.first as? String, let imageUrl = URL(string: imageUrlString) {

                cell.imagePreView.kf.setImage(with: imageUrl)
            }

            return cell
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = self.components[indexPath.section]

        switch component {
        case .profile:
            return 130
        case .record:
            return 170
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordTableViewController") as! RecordTableViewController
        recordVC.combination = self.records[indexPath.row].combination
        if
            let note = self.records[indexPath.row].note,
            let photo = self.records[indexPath.row].photo as? [String],
            let key = self.records[indexPath.row].key {
            recordVC.note = note
            recordVC.photos = photo
            recordVC.recordKey = key
        }
        self.navigationController?.pushViewController(recordVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in

            RecordManager.shared.deleteRecord(self.records[indexPath.row].key, completion: { (error) in

                if error != nil {
                    print(error ?? "")
                    return
                }

                self.records.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)

                if self.records.count == 0 {

                    let noRecordView = self.configNoRecordView()
                    self.tableView.addSubview(noRecordView)

                }

            })

        }

        deleteAction.backgroundColor = UIColor(hex: "990000")

        return [deleteAction]
    }

}

extension PersonalTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
