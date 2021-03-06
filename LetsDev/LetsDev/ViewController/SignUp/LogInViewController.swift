//
//  LogInViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/9.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
        self.emailTextField.iconWidth = 30
        self.emailTextField.iconMarginBottom = 2
        self.emailTextField.iconMarginLeft = 8
        self.emailTextField.iconColor = .lightGray
        self.emailTextField.selectedLineColor = .white
        self.emailTextField.selectedIconColor = .white
        self.emailTextField.textColor = .white
        self.emailTextField.iconText = String.fontAwesomeIcon(name: .envelopeO)
        self.emailTextField.keyboardType = .emailAddress

        self.passwordTextField.iconFont = UIFont(name: "FontAwesome", size: 20)
        self.passwordTextField.iconWidth = 30
        self.passwordTextField.iconMarginBottom = 2
        self.passwordTextField.iconMarginLeft = 8
        self.passwordTextField.iconColor = .lightGray
        self.passwordTextField.selectedLineColor = .white
        self.passwordTextField.textColor = .white
        self.passwordTextField.selectedIconColor = .white
        self.passwordTextField.iconText = String.fontAwesomeIcon(name: .lock)
        self.passwordTextField.isSecureTextEntry = true

    }

    @IBAction func logInAction(_ sender: Any) {

        self.view.endEditing(true)

        if self.emailTextField.text == nil {
            self.showAlert("Email Empty.")

            return
        }

        if self.passwordTextField.text == nil {
            self.showAlert("Password Empty")

            return
        }

        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }

        LoginManager.shared.login(withEmail: email, password: password, success: { (email, _) in
            self.nextVC()
        }) { (message) in
            self.showAlert(message)
        }

    }

    @IBAction func goSignUpAction(_ sender: Any) {

        // swiftlint:disable force_cast
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserViewController") as! CreateUserViewController

        self.navigationController?.pushViewController(signUpVC, animated: true)

    }

    func showAlert(_ alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func nextVC() {

        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }

        if let tabBarVc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
            tabBarVc.view.frame = rootViewController.view.frame
            tabBarVc.view.layoutIfNeeded()

            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarVc
            })
        }
    }

}
