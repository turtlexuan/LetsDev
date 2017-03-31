//
//  RecordTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/24.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController {

    enum Component {

        case combination, note, photo

    }

    // MARK: Property
    var combination = Combination()
    var recordKey = ""
    var components: [Component] = [ .combination, .note, .photo ]
    var note = ""
    var image: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = combination.film

        self.tableView.register(UINib(nibName: "CombinationTableViewCell", bundle: nil), forCellReuseIdentifier: "CombinationTableViewCell")
        self.tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        self.tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(UINib(nibName: "NewDevTableViewCell", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCell")

        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.components[indexPath.section]

        switch component {
        case .combination:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinationTableViewCell", for: indexPath) as! CombinationTableViewCell

            let preWashTime = self.timeExchanger(time: self.combination.preWashTime)
            let devTime = self.timeExchanger(time: self.combination.devTime)
            let fixTime = self.timeExchanger(time: self.combination.fixTime)
            let stopTime = self.timeExchanger(time: self.combination.stopTime)
            let washTime = self.timeExchanger(time: self.combination.washTime)

            cell.filmNameLabel.text = self.combination.film
            cell.developerLabel.text = self.combination.dev
            cell.preWashLabel.text = "Pre-Wash : \(preWashTime.minute)' \(preWashTime.second)\""
            cell.devTimeLabel.text = "Develope : \(devTime.minute)' \(devTime.second)\""
            cell.fixTimeLabel.text = "Fix Time : \(fixTime.minute)' \(fixTime.second)\""
            cell.stopTimeLabel.text = "Stop Time : \(stopTime.minute)' \(stopTime.second)\""
            cell.washTimeLabel.text = "Wash Time : \(washTime.minute)' \(washTime.second)\""
            cell.devAgitationLabel.text = "Dev Agitation : \(self.combination.devAgitation.rawValue)"
            cell.fixAgitationLabel.text = "Fix Agitation : \(self.combination.fixAgitation.rawValue)"

            if let temp = self.combination.temp {
                cell.temperatureLabel.text = "Temperature : \(temp) ºC"
            }

            return cell

        case .note:

            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell

            cell.noteLabel.text = self.note
            cell.editButton.addTarget(self, action: #selector(self.showEditView(_:)), for: .touchUpInside)

            return cell

        case .photo:

            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell

            self.tableView.beginUpdates()
            cell.setCollectionViewDataSourceDelegate(self)
            cell.collectionView.collectionViewLayout = self.configLayout()
            if self.image.count == 0 {
                cell.collectionView.isHidden = true
            }
            self.tableView.rowHeight = cell.collectionView.bounds.height
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            self.tableView.endUpdates()

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = self.components[indexPath.section]

        switch component {
        case .combination:
            return 230
        case .note:
            return UITableViewAutomaticDimension
        case .photo:
            return CollectionHeight.getCollectionHeight(itemHeight: (self.view.frame.width - 68) / 3, totalItem: self.image.count) + 50
        }
    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: (self.view.frame.width - 68) / 3, height: (self.view.frame.width - 68) / 3)

        return layout
    }

    func showEditView(_ sender: UIButton) {
        // swiftlint:disable force_cast
        let noteVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteVC.delegate = self
        noteVC.note = self.note
        self.navigationController?.present(noteVC, animated: true, completion: nil)
    }
}

extension RecordTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return self.image.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        // swiftlint:enable force_case

        if self.image != [] {
            cell.imageView.image = self.image[indexPath.row]
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

extension RecordTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }

    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

extension RecordTableViewController: NoteViewControllerDelegate {
    func didReceiveNote(note: String) {
        self.note = note
        RecordManager.shared.updateNote(with: note, key: recordKey)
        self.tableView.reloadData()
    }
}