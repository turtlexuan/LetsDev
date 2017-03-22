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
    let minutes = Array(0...120)
    let seconds = Array(0...59)
    var toolBar: UIToolbar? {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let titleLabel = UIBarButtonItem(customView: UILabel())
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))

        toolBar.setItems([cancelButton, spaceButton, titleLabel, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }

    @IBOutlet weak var tableView: UITableView!

    var filmNameInputView = UIPickerView()
    var filmTypeInputView = UIPickerView()
    var preWashTimeInputView = UIPickerView()
    var devTimeInputView = UIPickerView()
    var developerInputView = UIPickerView()
    var tempTimeInputView = UIPickerView()
    var devAgitationInputView = UIPickerView()
    var stopTimeInputView = UIPickerView()
    var fixTimeInputView = UIPickerView()
    var fixAgitationInputView = UIPickerView()
    var washTimeInputView = UIPickerView()
    var bufferTimeInputView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpPickerView()

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

    func setUpPickerView() {
        filmNameInputView.dataSource = self
        filmNameInputView.delegate = self
        filmTypeInputView.dataSource = self
        filmTypeInputView.delegate = self
        preWashTimeInputView.dataSource = self
        preWashTimeInputView.delegate = self
        devTimeInputView.dataSource = self
        devTimeInputView.delegate = self
        developerInputView.dataSource = self
        developerInputView.delegate = self
        tempTimeInputView.dataSource = self
        tempTimeInputView.delegate = self
        devAgitationInputView.dataSource = self
        devAgitationInputView.delegate = self
        stopTimeInputView.dataSource = self
        stopTimeInputView.delegate = self
        fixTimeInputView.dataSource = self
        fixTimeInputView.delegate = self
        fixAgitationInputView.dataSource = self
        fixAgitationInputView.delegate = self
        washTimeInputView.dataSource = self
        washTimeInputView.delegate = self
        bufferTimeInputView.dataSource = self
        bufferTimeInputView.delegate = self
    }

    func showTimePicker(_ sender: TTInputButton) {
        sender.inputView = self.devTimeInputView
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let titleLable = UILabel()
        titleLable.text = "Select a time"
        let titleButton = UIBarButtonItem(customView: titleLable)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))

        toolBar.setItems([cancelButton, spaceButton, titleButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        sender.inputAccessoryView = toolBar
        sender.becomeFirstResponder()
    }

    func donePicker(_ sender: UIBarButtonItem) {

        self.view.endEditing(true)

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

            self.tableView.rowHeight = 215
            cell.titleLabel.text = processes[indexPath.row].devTitle
            cell.setTimeLabel.text = processes[indexPath.row].devDescript
            cell.developerButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
//            cell.developerButton.addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
//            cell.developerButton.inputView = self.devTimeInputView
//            cell.developerButton.inputAccessoryView = self.toolBar

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

extension NewDevViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.minutes.count
        } else {
            return self.seconds.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(minutes[row])'"
        } else {
            return "\(seconds[row])\""
        }
    }

}
