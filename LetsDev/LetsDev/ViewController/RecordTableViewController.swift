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
    var components: [Component] = [ .combination, .note, .photo ]
    var note = ""
    var image: [UIImage] = [#imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "oval"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "film-roll"), #imageLiteral(resourceName: "film-reel")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = combination.film

        self.tableView.register(UINib(nibName: "CombinationTableViewCell", bundle: nil), forCellReuseIdentifier: "CombinationTableViewCell")
        self.tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        self.tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(UINib(nibName: "NewDevTableViewCell", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCell")

        let image = #imageLiteral(resourceName: "heart")
        self.image.append(image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.components[section] {
        case .combination, .note: return 1
        case .photo: return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.components[indexPath.section]

        switch component {
        case .combination:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinationTableViewCell", for: indexPath) as! CombinationTableViewCell

            return cell

        case .note:

            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell

            return cell

        case .photo:

            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell

            self.tableView.beginUpdates()
            cell.setCollectionViewDataSourceDelegate(self)
            cell.collectionView.collectionViewLayout = self.configLayout()
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
            return 170
        case .note:
            return UITableViewAutomaticDimension
        case .photo:
            return CollectionHeight.getCollectionHeight(itemHeight: (self.view.frame.width - 68) / 3, totalItem: self.image.count)
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
}

extension RecordTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return self.image.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        // swiftlint:enable force_case

        cell.imageView.image = self.image[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
