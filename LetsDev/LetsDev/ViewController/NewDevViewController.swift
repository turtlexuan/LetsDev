//
//  NewDevViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/21.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class NewDevViewController: UIViewController {

    enum Component {
        case Film, PreWash, Develope, Stop, Fix, Wash, Buffer
    }

    var components: [Component] = [.Film, .PreWash, .Develope, .Stop, .Fix, .Wash, .Buffer]

    @IBOutlet weak var tableView: UITableView!

    var filmNameInputView = UIPickerView()
    var filmTypeInputView = UIPickerView()
    var preWashTimeInputView = UIPickerView()
    var devTimeInputView = UIPickerView()
    var developerInputView = UIPickerView()
    var tempInputView = UIPickerView()
    var devAgitationInputView = UIPickerView()
    var stopTimeInputView = UIPickerView()
    var fixTimeInputView = UIPickerView()
    var fixAgitationInputView = UIPickerView()
    var washTimeInputView = UIPickerView()
    var bufferTimeInputView = UIPickerView()

    var selectedFilm = "Film"
    var selectedType = "Type"
    var selectedDev = "Developer"
    var dilution = ""
    var selectedTemp = 20
    var selectedAgitation = Agigtations.Every60Sec
    var selectedFixAgitation = Agigtations.Every60Sec

    var bufferTime = 00
    var preWashTime = 00
    var devTime = 00
    var stopTime = 00
    var fixTime = 00
    var washTime = 00

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpPickerView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if currentUser.uid == nil {
            self.showNoAccountAlert()
        }

    }

    @IBAction func startAction(_ sender: Any) {
        let combination = Combination(film: self.selectedFilm, type: self.selectedType, preWashTime: self.preWashTime, dev: self.selectedDev, dilution: self.dilution, devTime: self.devTime, temp: self.selectedTemp, devAgitation: self.selectedAgitation, stopTime: self.stopTime, fixTime: self.fixTime, fixAgitation: self.selectedFixAgitation, washTime: self.washTime, bufferTime: self.bufferTime)

        // swiftlint:disable force_cast
        let timerVC = self.storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        timerVC.combination = combination
        self.navigationController?.pushViewController(timerVC, animated: true)
        // swiftlint:enable force_cast
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        self.tableView.allowsSelection = false
    }

    func setUpPickerView() {
        self.filmNameInputView.dataSource = self
        self.filmNameInputView.delegate = self
        self.filmTypeInputView.dataSource = self
        self.filmTypeInputView.delegate = self
        self.preWashTimeInputView.dataSource = self
        self.preWashTimeInputView.delegate = self
        self.devTimeInputView.dataSource = self
        self.devTimeInputView.delegate = self
        self.developerInputView.dataSource = self
        self.developerInputView.delegate = self
        self.tempInputView.dataSource = self
        self.tempInputView.delegate = self
        self.devAgitationInputView.dataSource = self
        self.devAgitationInputView.delegate = self
        self.stopTimeInputView.dataSource = self
        self.stopTimeInputView.delegate = self
        self.fixTimeInputView.dataSource = self
        self.fixTimeInputView.delegate = self
        self.fixAgitationInputView.dataSource = self
        self.fixAgitationInputView.delegate = self
        self.washTimeInputView.dataSource = self
        self.washTimeInputView.delegate = self
        self.bufferTimeInputView.dataSource = self
        self.bufferTimeInputView.delegate = self
    }

    func showPicker(_ sender: TTInputButton) {
        let titleButton = UIBarButtonItem(title: "Select a time", style: .plain, target: self, action: nil)
        titleButton.isEnabled = false
        titleButton.tintColor = .black

        guard let cell = sender.superview?.superview as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) else { return }

        switch indexPath.row {
        case 0:
            if sender.tag == 0 {
                sender.inputView = self.filmNameInputView
                titleButton.title = "Select Your Film"
            } else {
                sender.inputView = self.filmTypeInputView
                titleButton.title = "Select Your Film Type"
            }
        case 1:
            sender.inputView = self.preWashTimeInputView
            titleButton.title = "Select Pre-Wash Time"
        case 2:
            if sender.tag == 0 {
                sender.inputView = self.developerInputView
                titleButton.title = "Select Your Developer"
            } else if sender.tag == 1 {
                sender.inputView = self.devTimeInputView
                titleButton.title = "Select Develope Time"
            } else if sender.tag == 2 {
                sender.inputView = self.tempInputView
                titleButton.title = "Select Dev Temperature"
            } else {
                sender.inputView = self.devAgitationInputView
                titleButton.title = "Select Agitation"
            }
        case 3:
            sender.inputView = self.stopTimeInputView
            titleButton.title = "Select Stop Time"
        case 4:
            if sender.tag == 0 {
                sender.inputView = self.fixTimeInputView
                titleButton.title = "Select Fix Time"
            } else {
                sender.inputView = self.fixAgitationInputView
                titleButton.title = "Select Agitation"
            }
        case 5:
            sender.inputView = self.washTimeInputView
            titleButton.title = "Select Wash Time"
        case 6:
            sender.inputView = self.bufferTimeInputView
            titleButton.title = "Select Buffer Time"
        default: break
        }

        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker(_:)))

        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, spaceButton, titleButton, spaceButton2, doneButton], animated: false)

        sender.inputAccessoryView = toolBar
        sender.becomeFirstResponder()
    }

    func showNoAccountAlert() {

        let alertController = UIAlertController(title: "You haven't sign up / in yet!", message: "We will not save your record after you finish develop\nWe highly recommend you to sign up / sign in and keep your records!", preferredStyle: .alert)
        let signUpButton = UIAlertAction(title: "Sign Up", style: .default) { (_) in

            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserNavigation")

            self.present(signUpVC!, animated: true, completion: nil)

        }
        let logInButton = UIAlertAction(title: "Log In", style: .default) { (_) in

            let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInNavigation")

            self.present(logInVC!, animated: true, completion: nil)

        }
        let notNowButton = UIAlertAction(title: "Not Now", style: .default, handler: nil)

        alertController.addAction(signUpButton)
        alertController.addAction(logInButton)
        alertController.addAction(notNowButton)

        self.present(alertController, animated: true, completion: nil)

    }

    func donePicker(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.tableView.reloadData()
    }

    func cancelPicker(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }

}

extension NewDevViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.components.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch self.components[indexPath.row] {
        case .Film:

            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCellFilm", for: indexPath) as? NewDevTableViewCellFilm else { return UITableViewCell() }

            cell.filmButton.tag = 0
            cell.typeButton.tag = 1
            cell.filmButton.setTitle(self.selectedFilm, for: .normal)
            cell.typeButton.setTitle(self.selectedType, for: .normal)
            cell.filmButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
            cell.typeButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)

            return cell

        case .Develope:

            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCell", for: indexPath) as? NewDevTableViewCell else { return UITableViewCell() }

            if self.selectedAgitation != .Custom {
                cell.customButton.isHidden = true
            } else {
                cell.customButton.isHidden = false
            }
            cell.titleLabel.text = Film.processes[indexPath.row].devTitle
            cell.setTimeLabel.text = Film.processes[indexPath.row].devDescript
            cell.developerButton.tag = 0
            cell.timeButton.tag = 1
            cell.tempButton.tag = 2
            cell.agitationButton.tag = 3
            cell.dilutionTextField.delegate = self
            cell.developerButton.setTitle(self.selectedDev, for: .normal)
            cell.timeButton.setTitle("\(self.timeExchanger(time: self.devTime).minute)'\(self.timeExchanger(time: self.devTime).second)", for: .normal)
            cell.tempButton.setTitle(String(self.selectedTemp), for: .normal)
            cell.agitationButton.setTitle(self.selectedAgitation.rawValue, for: .normal)
            cell.developerButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
            cell.timeButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
            cell.tempButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
            cell.agitationButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)

            return cell

        case .Fix:

            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCellTwoContent", for: indexPath) as? NewDevTableViewCellTwoContent else { return UITableViewCell() }

            if self.selectedFixAgitation != .Custom {
                cell.customButton.isHidden = true
            } else {
                cell.customButton.isHidden = false
            }
            cell.titleLabel.text = Film.processes[indexPath.row].devTitle
            cell.setTimeLabel.text = Film.processes[indexPath.row].devDescript
            cell.timeButton.tag = 0
            cell.agitationButton.tag = 1
            cell.timeButton.setTitle("\(self.timeExchanger(time: self.fixTime).minute)'\(self.timeExchanger(time: self.fixTime).second)", for: .normal)
            cell.agitationButton.setTitle(self.selectedFixAgitation.rawValue, for: .normal)
            cell.timeButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
            cell.agitationButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)

            return cell

        case .Buffer, .PreWash, .Stop, .Wash:

            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewDevTableViewCellOneContent", for: indexPath) as? NewDevTableViewCellOneContent else { return UITableViewCell() }
            cell.titleLabel.text = Film.processes[indexPath.row].devTitle
            cell.setTimeLabel.text = Film.processes[indexPath.row].devDescript
            cell.timeButton.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)

            switch indexPath.row {
            case 1:
                cell.timeButton.setTitle("\(self.timeExchanger(time: self.preWashTime).minute)'\(self.timeExchanger(time: self.preWashTime).second)", for: .normal)
            case 3:
                cell.timeButton.setTitle("\(self.timeExchanger(time: self.stopTime).minute)'\(self.timeExchanger(time: self.stopTime).second)", for: .normal)
            case 5:
                cell.timeButton.setTitle("\(self.timeExchanger(time: self.washTime).minute)'\(self.timeExchanger(time: self.washTime).second)", for: .normal)
            default:
                cell.timeButton.setTitle("\(self.timeExchanger(time: self.bufferTime).minute)'\(self.timeExchanger(time: self.bufferTime).second)", for: .normal)
            }

            return cell
        }
    }
}

extension NewDevViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.components[indexPath.row] {
        case .Develope : return 220
        case .Fix, .Film : return 110
        case .Buffer, .PreWash, .Stop, .Wash : return 75
        }
    }
}

extension NewDevViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case self.filmNameInputView, self.filmTypeInputView, self.developerInputView, self.tempInputView,
             self.devAgitationInputView, self.fixAgitationInputView:
            return 1
        default: return 2
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.filmNameInputView:
            return Film.films.count
        case self.filmTypeInputView:
            return Film.types.count
        case self.developerInputView:
            return Film.developers.count
        case self.tempInputView:
            return Film.temperature.count
        case self.devAgitationInputView, self.fixAgitationInputView:
            return Film.agitations.count
        default:
            if component == 0 {
                return Film.minutes.count
            } else {
                return Film.seconds.count
            }
        }

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.filmNameInputView:
            return Film.films[row]
        case self.filmTypeInputView:
            return Film.types[row]
        case self.developerInputView:
            return Film.developers[row]
        case self.tempInputView:
            return String(Film.temperature[row])
        case self.devAgitationInputView, self.fixAgitationInputView:
            return Film.agitations[row].rawValue
        default:
            if component == 0 {
                return "\(Film.minutes[row])'"
            } else {
                return "\(Film.seconds[row])\""
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch pickerView {
        case self.filmNameInputView:
            self.selectedFilm = Film.films[row]
        case self.filmTypeInputView:
            self.selectedType = Film.types[row]
        case self.developerInputView:
            self.selectedDev = Film.developers[row]
        case self.tempInputView:
            self.selectedTemp = Film.temperature[row]
        case self.devAgitationInputView:
            self.selectedAgitation = Film.agitations[row]
        case self.fixAgitationInputView:
            self.selectedFixAgitation = Film.agitations[row]
        case self.preWashTimeInputView:
            self.preWashTime = self.timeExchanger(minute: pickerView.selectedRow(inComponent: 0), second: pickerView.selectedRow(inComponent: 1))
        case self.devTimeInputView:
            self.devTime = self.timeExchanger(minute: pickerView.selectedRow(inComponent: 0), second: pickerView.selectedRow(inComponent: 1))
        case self.stopTimeInputView:
            self.stopTime = self.timeExchanger(minute: pickerView.selectedRow(inComponent: 0), second: pickerView.selectedRow(inComponent: 1))
        case self.fixTimeInputView:
            self.fixTime = self.timeExchanger(minute: pickerView.selectedRow(inComponent: 0), second: pickerView.selectedRow(inComponent: 1))
        case self.washTimeInputView:
            self.washTime = self.timeExchanger(minute: pickerView.selectedRow(inComponent: 0), second: pickerView.selectedRow(inComponent: 1))
        case self.bufferTimeInputView:
            self.bufferTime = self.timeExchanger(minute: pickerView.selectedRow(inComponent: 0), second: pickerView.selectedRow(inComponent: 1))
        default:
            break
        }
    }
}

extension NewDevViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil {
            self.dilution = textField.text!
        }
        textField.resignFirstResponder()
    }
}

extension NewDevViewController {
    func timeExchanger(minute: Int, second: Int) -> Int {
        return minute * 60 + second
    }

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
