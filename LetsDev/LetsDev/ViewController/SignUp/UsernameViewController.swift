//
//  UsernameViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/5.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!

    var email = ""
    var password = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func continueAction(_ sender: Any) {

        guard let username = self.usernameTextField.text else {

            // TODO: show alert

            return
        }

        // swiftlint:disable force_cast
        let userPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UserPhotoViewController") as! UserPhotoViewController

        userPhotoVC.email = self.email
        userPhotoVC.password = self.password
        userPhotoVC.username = username

        self.navigationController?.pushViewController(userPhotoVC, animated: true)
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
