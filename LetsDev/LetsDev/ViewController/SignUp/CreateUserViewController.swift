//
//  CreateUserViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/5.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FontAwesome_swift

class CreateUserViewController: UIViewController {

    enum AlertMessage: String {
        case EmailEmpty = "Email Can't be Empty."
        case EmailAlreadyInUse = "This Email Address is Already be Registered."
        case InvalidFormat = "Email Invalid."
        case PasswordEmpty = "Password Can't be empty."
        case PasswordInvalid = "Password Must Contains at Least 8 Charactors."
    }

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var continueButton: UIButton!

    var isSubmitButtonPressed = false
    var showingTitleInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.errorColor = .red
        self.emailTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
        self.emailTextField.iconWidth = 30
        self.emailTextField.iconMarginBottom = 2
        self.emailTextField.iconMarginLeft = 8
        self.emailTextField.iconText = String.fontAwesomeIcon(name: .envelopeO)
        self.emailTextField.selectedIconColor = .black
        self.emailTextField.delegate = self
        self.emailTextField.keyboardType = .emailAddress

        self.passwordTextField.errorColor = .red
        self.passwordTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
        self.passwordTextField.iconWidth = 30
        self.passwordTextField.iconMarginBottom = 2
        self.passwordTextField.iconMarginLeft = 8
        self.passwordTextField.iconText = String.fontAwesomeIcon(name: .lock)
        self.passwordTextField.selectedIconColor = .black
        self.passwordTextField.delegate = self
        self.passwordTextField.isSecureTextEntry = true
    }

    @IBAction func continueActionDown(_ sender: Any) {

        if !self.emailTextField.hasText {
            self.showingTitleInProgress = true
            self.showAlert(.EmailEmpty)
        }

        guard let email = self.emailTextField.text else { return }

        self.isSubmitButtonPressed = true
        self.showingTitleInProgress = false

        if !self.isValidEmailAddress(email) {
            self.showingTitleInProgress = true
            self.showAlert(.InvalidFormat)
            return
        }

        if !self.passwordTextField.hasText {
            self.showingTitleInProgress = true
            self.showAlert(.PasswordEmpty)
        }

        guard let password = self.passwordTextField.text else { return }

        if password.characters.count < 8 {
            self.showingTitleInProgress = true
            self.showAlert(.PasswordInvalid)
            return
        }

    }

    @IBAction func continueAction(_ sender: Any) {

        guard let email = self.emailTextField.text else { return }

        self.isSubmitButtonPressed = false

        LoginManager.shared.isEmailAlreadyInUse(email: email) { (bool) in
            if bool == false && self.showingTitleInProgress == false {
                // swiftlint:disable force_cast
                let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameViewController") as! UsernameViewController

                usernameVC.email = self.emailTextField.text!
                usernameVC.password = self.passwordTextField.text!

                self.navigationController?.pushViewController(usernameVC, animated: true)
            } else if bool == true {
                self.showAlert(.EmailAlreadyInUse)
            } else {
                return
            }
        }
    }

    @IBAction func validateEmail() {

        self.validateEmailTextFieldWithText(email: self.emailTextField.text)

    }

    @IBAction func validatePassword() {

        self.validatePasswordTextFieldWithText(password: self.passwordTextField.text)

    }

    func validateEmailTextFieldWithText(email: String?) {
        if let email = email {
            if email.characters.count == 0 {
                self.emailTextField.errorMessage = "Email can't be empty."
            } else if self.isValidEmailAddress(email) == false {
                self.emailTextField.errorMessage = "Email not valid"
            } else {
                self.emailTextField.errorMessage = nil
            }
        } else {
            self.emailTextField.errorMessage = "Email not valid"
        }
    }

    func validatePasswordTextFieldWithText(password: String?) {
        if let password = password {
            if password.characters.count == 0 {
                self.passwordTextField.errorMessage = "Password can't be empty."
            } else if password.characters.count < 8 {
                self.passwordTextField.errorMessage = "Password not valid"
            } else {
                self.passwordTextField.errorMessage = nil
            }
        } else {
            self.passwordTextField.errorMessage = "Password not valid"
        }
    }

    func showAlert(_ alertMessage: AlertMessage) {
        let alertController = UIAlertController(title: "Erro", message: alertMessage.rawValue, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func isValidEmailAddress(_ email: String) -> Bool {

        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let string = email as String
            let results = regex.matches(in: email, range: NSRange(location: 0, length: string.characters.count))

            if results.count == 0 {
                returnValue = false
            }

        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }

        return  returnValue
    }
}

extension CreateUserViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {

            self.validateEmail()

        } else if textField == self.passwordTextField {

            self.validatePassword()

        }

        return false
    }

}
