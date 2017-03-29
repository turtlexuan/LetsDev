//
//  SignUpViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/29.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var logInStackView: UIStackView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createEmailTextFiled: UITextField!
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

    func setUpView() {
        self.subtitleLabel.isHidden = true
        self.signUpStackView.isHidden = true
        self.logInStackView.isHidden = true
        self.createButton.isHidden = true
        self.logInButton.isHidden = true
    }

    @IBAction func showCreateView(_ sender: Any) {
        self.buttonStackView.isHidden = true
        self.subtitleLabel.text = "Sign Up"
        self.subtitleLabel.isHidden = false
        self.signUpStackView.isHidden = false
        self.createButton.isHidden = false
    }

    @IBAction func showSignInView(_ sender: Any) {
        self.buttonStackView.isHidden = true
        self.subtitleLabel.text = "Log In"
        self.subtitleLabel.isHidden = false
        self.logInStackView.isHidden = false
        self.logInButton.isHidden = false
    }

    @IBAction func createAccount(_ sender: Any) {
        
        guard let email = self.createEmailTextFiled.text, let password = self.createPasswordTextField.text, let username = self.usernameTextField.text else { return }
        
        LoginManager.shared.create(withEmail: email, password: password, username: username, success: { (user) in
            //
            print(user)
            
            self.nextVC()
        }) { (error) in
            //
            print(error)
        }
    }

    @IBAction func logInAction(_ sender: Any) {
        
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
        
        LoginManager.shared.login(withEmail: email, password: password, success: { (email, uid) in
            print("\(email), \(uid)")
            self.nextVC()
        }) { (error) in
            print(error)
        }
    }

    func nextVC() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController")
        UIApplication.shared.keyWindow?.rootViewController = navigationController

    }
}
