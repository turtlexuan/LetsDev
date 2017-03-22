//
//  NewDevViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/21.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class NewDevViewController: UIViewController {

    let processes = [DevProcess(devTitle: "Film Setting", devDescript: "Film Name\nSelect your film name"),
                     DevProcess(devTitle: "Pre-Wash Bath", devDescript: "Time\nSet the pre-wash time"),
                     DevProcess(devTitle: "Developer Bath", devDescript: "Time\nSet the developer time"),
                     DevProcess(devTitle: "Stop Bath", devDescript: "Time\nSet the stop time"),
                     DevProcess(devTitle: "Fix Bath", devDescript: "Time\nSet the fix time"),
                     DevProcess(devTitle: "Wash Bath", devDescript: "Time\nSet the wash time"),
                     DevProcess(devTitle: "Buffer Time", devDescript: "Time\nSet the time between two processes.")]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()

    }

    @IBAction func startAction(_ sender: Any) {
    }

    @IBAction func cancelAction(_ sender: Any) {
    }

    func setUpTableView() {
        self.tableView.register(UINib(nibName: "NewDevTableViewCell", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCell")
        self.tableView.register(UINib(nibName: "NewDevTableViewCellTwoContent", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCellTwoContent")
        self.tableView.register(UINib(nibName: "NewDevTableViewCellOneContent", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCellOneContent")
        self.tableView.register(UINib(nibName: "NewDevTableViewCellFilm", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCellFilm")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .black
        self.tableView.separatorStyle = .none
    }

}

extension NewDevViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCellFilm", for: indexPath) as? NewDevTableViewCellFilm else { return UITableViewCell() }

            self.tableView.rowHeight = 110

            return cell
        } else if indexPath.row == 2 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCell", for: indexPath) as? NewDevTableViewCell else { return UITableViewCell() }

            self.tableView.rowHeight = 180
            cell.titleLabel.text = processes[indexPath.row].devTitle
            cell.setTimeLabel.text = processes[indexPath.row].devDescript

            return cell

        } else if indexPath.row == 4 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCellTwoContent", for: indexPath) as? NewDevTableViewCellTwoContent else { return UITableViewCell() }

            self.tableView.rowHeight = 110
            cell.titleLabel.text = processes[indexPath.row].devTitle
            cell.setTimeLabel.text = processes[indexPath.row].devDescript

            return cell
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCellOneContent", for: indexPath) as? NewDevTableViewCellOneContent else { return UITableViewCell() }

            self.tableView.rowHeight = 75
            cell.titleLabel.text = processes[indexPath.row].devTitle
            cell.setTimeLabel.text = processes[indexPath.row].devDescript

            return cell
        }

    }
}

extension NewDevViewController: UITableViewDelegate {

}
