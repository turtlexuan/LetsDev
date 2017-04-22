//
//  FavoriteTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/4.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FavoriteTableViewController: UITableViewController {

    var favorites: [(combination: Combination, key: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")

        self.tableView.rowHeight = 205
        self.tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let activityData = ActivityData(type: .ballRotateChase)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        FavoriteManager.shared.fetchFavorite { (combinations) in
            self.favorites = combinations
            self.favorites.sort(by: { $0.combination.film < $1.combination.film })
            self.tableView.reloadData()
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            if combinations.count == 0 {
                let noRecordView = self.configNoRecordView()
                self.tableView.addSubview(noRecordView)
            }
        }
    }
    
    func configNoRecordView() -> UIView {
        
        let noReordView = UIView(frame: CGRect(x: 12, y: 20, width: self.tableView.frame.width - 24, height: 150))
        noReordView.backgroundColor = Color.cellColor
        noReordView.layer.cornerRadius = 10
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: noReordView.frame.width, height: 80))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "You don't have any favorite.\nLet's go to the community and\nfind some combinations in your favor."
        titleLabel.textColor = .white
        
        noReordView.addSubview(titleLabel)
        
        return noReordView
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let index = self.favorites[indexPath.row].combination

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell

        cell.selectionStyle = .none

        let preWashTime = self.timeExchanger(time: index.preWashTime)
        let devTime = self.timeExchanger(time: index.devTime)
        let fixTime = self.timeExchanger(time: index.fixTime)
        let stopTime = self.timeExchanger(time: index.stopTime)
        let washTime = self.timeExchanger(time: index.washTime)

        cell.filmNameLabel.text = index.film
        cell.typeLabel.text = index.type
        cell.developerLabel.text = index.dev
        cell.preWashLabel.text = "Pre-Wash : \(preWashTime.minute)' \(preWashTime.second)\""
        cell.devTimeLabel.text = "Develope : \(devTime.minute)' \(devTime.second)\""
        cell.fixTimeLabel.text = "Fix Time : \(fixTime.minute)' \(fixTime.second)\""
        cell.stopTimeLabel.text = "Stop Time : \(stopTime.minute)' \(stopTime.second)\""
        cell.washTimeLabel.text = "Wash Time : \(washTime.minute)' \(washTime.second)\""

        if let dilution = index.dilution {
            cell.dilutionLabel.text = "Dilution : \(dilution)"
        }

        cell.newDevButton.addTarget(self, action: #selector(newProcess(_:)), for: .touchUpInside)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        // TODO : delete favorite

    }

    func newProcess(_ sender: UIButton) {

        guard
            let cell = sender.superview?.superview?.superview as? FavoriteTableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }

        guard
            let newDevNavigation = self.storyboard?.instantiateViewController(withIdentifier: "NewDevNavigationController") as? UINavigationController,
            let newDevVC = newDevNavigation.viewControllers[0] as? NewDevViewController else { return }

        let index = self.favorites[indexPath.row].combination

        newDevVC.selectedFilm = index.film
        newDevVC.selectedType = index.type
        newDevVC.selectedDev = index.dev
        newDevVC.selectedTemp = index.temp
        newDevVC.selectedAgitation = index.devAgitation
        newDevVC.selectedFixAgitation = index.fixAgitation
        newDevVC.preWashTime = index.preWashTime
        newDevVC.devTime = index.devTime
        newDevVC.stopTime = index.stopTime
        newDevVC.fixTime = index.fixTime
        newDevVC.washTime = index.washTime
        newDevVC.bufferTime = index.bufferTime

        self.present(newDevNavigation, animated: true, completion: nil)

    }

}

extension FavoriteTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
