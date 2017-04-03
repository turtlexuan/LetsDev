//
//  PersonalTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/3.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class PersonalTableViewController: UITableViewController {

    enum Component {

        case profile, record

    }

    var components: [Component] = [.profile, .record]
    var records: [Record] = []
    var currentUser = User(uid: "", email: "", username: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")
        self.tableView.register(UINib(nibName: "RecordListTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordListTableViewCell")

        UserManager.shared.getUser { (user) in
            self.currentUser = user
        }

//        RecordManager.shared.fetchRecords { (records) in
//            if let record = records {
//                self.records = record
//                self.tableView.reloadData()
//            }
//        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        RecordManager.shared.fetchRecords { (records) in
            if let record = records {
                self.records = record
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

            cell.userNameLabel.text = self.currentUser.username
            cell.recordNumberLabel.text = String(self.records.count)
            cell.isUserInteractionEnabled = false

            return cell

        case .record:

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RecordListTableViewCell", for: indexPath) as! RecordListTableViewCell

            let index = self.records[indexPath.row]

            cell.selectionStyle = .none
            cell.devloperLabel.text = index.combination.dev
            cell.devTimeLabel.text = "Dev Time : \(self.timeExchanger(time: index.combination.devTime).minute)' \(self.timeExchanger(time: index.combination.devTime).second)\""
            cell.filmLabel.text = index.combination.film
            cell.timeLabel.text = index.date

            cell.setCollectionViewDataSourceDelegate(self)
            cell.collectionView.collectionViewLayout = self.configLayout()
            cell.collectionView.tag = indexPath.row
//            self.tableView.setNeedsLayout()
//            self.tableView.layoutIfNeeded()

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = self.components[indexPath.section]

        switch component {
        case .profile:
            return 130
        case .record:
            return 210
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

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.view.frame.width - 76) / 5, height: (self.view.frame.width - 76) / 5)

        return layout
    }

}

extension PersonalTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if self.records[collectionView.tag].photo.count < 5 {
            return self.records[collectionView.tag].photo.count
        } else {
            return 5
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell

        var imageUrls: [URL] = []
        var images: [UIImage] = []

        for string in self.records[collectionView.tag].photo {
            guard let imageUrlString = string, let imageUrl = URL(string: imageUrlString) else { return PhotoCollectionViewCell() }
            imageUrls.append(imageUrl)
        }

        DispatchQueue.global().async {
            for url in imageUrls {
                do {
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                } catch {
                    print(error)
                }
            }

            DispatchQueue.main.async {
                cell.imageView.image = images[indexPath.row]
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

extension PersonalTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
