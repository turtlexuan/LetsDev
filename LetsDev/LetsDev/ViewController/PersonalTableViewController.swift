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

            // swiftlint:disable force_cast
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
}

extension PersonalTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
