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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func showCreateView(_ sender: Any) {

        // swiftlint:disable force_cast
        let createUserVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        self.navigationController?.pushViewController(createUserVC, animated: true)

    }

    @IBAction func showSignInView(_ sender: Any) {

        let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(logInVC, animated: true)
    }

    @IBAction func signUpLater(_ sender: Any) {

        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        tabBarVC.view.frame = rootViewController.view.frame
        tabBarVC.view.layoutIfNeeded()

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = tabBarVC
        })
    }

    func nextVC() {
        // swiftlint:disable force_cast
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        UIApplication.shared.keyWindow?.rootViewController = navigationController

    }
}
