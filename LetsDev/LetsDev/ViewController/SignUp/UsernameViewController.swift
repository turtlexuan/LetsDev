//
//  UsernameViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/5.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FontAwesome_swift

class UsernameViewController: UIViewController {

    enum AlertMessage: String {
        case UsernameDuplicate = "Username is duplicated, Please enter with other name."
        case UsernameEmpty = "Username Can't be Empty."
    }

    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!

    var email = ""
    var password = ""
    var showingTitleInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameTextField.errorColor = .red
        self.usernameTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
        self.usernameTextField.iconWidth = 30
        self.usernameTextField.iconMarginBottom = 4
        self.usernameTextField.iconMarginLeft = 8
        self.usernameTextField.iconText = String.fontAwesomeIcon(name: .user)
        self.usernameTextField.iconColor = .white
        self.usernameTextField.selectedIconColor = .white
        self.usernameTextField.selectedLineColor = .white
        self.usernameTextField.textColor = .white
        self.usernameTextField.delegate = self

    }

    @IBAction func continueActionDown(_ sender: Any) {
        
        self.view.endEditing(true)

        if !self.usernameTextField.hasText {
            self.showingTitleInProgress = true
            self.showAlert(.UsernameEmpty)
        }
    }

    @IBAction func continueAction(_ sender: Any) {

        guard let username = self.usernameTextField.text else { return }

        LoginManager.shared.isUsernameDuplicate(username: username) { (bool) in

            if self.showingTitleInProgress == false && bool == false {
                // swiftlint:disable force_cast
                let userPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UserPhotoViewController") as! UserPhotoViewController

                userPhotoVC.email = self.email
                userPhotoVC.password = self.password
                userPhotoVC.username = self.usernameTextField.text!

                self.navigationController?.pushViewController(userPhotoVC, animated: true)
            } else {
                self.usernameTextField.errorMessage = "Username duplicated."
                self.usernameTextField.text = ""
            }
        }
    }

    @IBAction func validateUsername() {

        self.isValidUserName(self.usernameTextField.text)

    }

    @IBAction func previousAction(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)

    }

    @IBAction func cancelAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func goSignInAction(_ sender: Any) {
        
        let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        
        self.navigationController?.pushViewController(logInVc, animated: true)
        
    }

    func isValidUserName(_ username: String?) {

        if let username = username {

            if username.characters.count == 0 {
                self.usernameTextField.errorMessage = "Username Can't be Empty."
            }

            LoginManager.shared.isUsernameDuplicate(username: username) { (bool) in
                if bool == true {
                    self.usernameTextField.errorMessage = "Username duplicated."
                    self.usernameTextField.text = ""
                }
            }
        }
    }

    func showAlert(_ alertMessage: AlertMessage) {
        let alertController = UIAlertController(title: "Invalid Username", message: alertMessage.rawValue, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension UsernameViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        //
        self.validateUsername()
    }

}
