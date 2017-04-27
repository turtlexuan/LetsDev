//
//  PrivacyViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/27.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!

    var isAgree = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.privacyTextView.setContentOffset(CGPoint.zero, animated: false)
    }

    func setUp() {

        self.checkboxButton.layer.cornerRadius = self.checkboxButton.frame.width / 2
        self.checkboxButton.layer.borderWidth = 2
        self.checkboxButton.layer.borderColor = Color.buttonColor.cgColor
        self.checkboxButton.tintColor = Color.buttonColor
        self.checkboxButton.setTitle("", for: .normal)

        self.agreeButton.isEnabled = false
        self.agreeButton.backgroundColor = .black
        self.agreeButton.layer.cornerRadius = 10

        self.disagreeButton.layer.cornerRadius = 10
        self.privacyView.layer.cornerRadius = 10
        self.privacyTextView.layer.cornerRadius = 10

    }

    @IBAction func checkAction(_ sender: Any) {

        if self.isAgree == true {

            self.isAgree = false

            self.checkboxButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)

            self.agreeButton.isEnabled = true
            self.agreeButton.backgroundColor = Color.buttonColor

        } else {

            self.isAgree = true

            self.checkboxButton.setImage(nil, for: .normal)

            self.agreeButton.isEnabled = false
            self.agreeButton.backgroundColor = .black

        }

    }

    @IBAction func disagreeAction(_ sender: Any) {

        self.navigationController?.popToRootViewController(animated: true)

        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func agreeAction(_ sender: Any) {

        // swiftlint:disable force_cast
        let createUserVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserViewController") as! CreateUserViewController
        self.navigationController?.pushViewController(createUserVC, animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
