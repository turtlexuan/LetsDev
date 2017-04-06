//
//  CreateUserViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/5.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {
    
    enum AlertMessage {
        case EmailEmpty
        case InvalidFormat
        case PasswordEmpty
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func continueAction(_ sender: Any) {

        guard let email = self.emailTextField.text else {

            // TODO: show alert

            return
        }

        guard self.isValidEmailAddress(emailAddressString: email) == true else {

            return
        }

        guard let password = self.passwordTextField.text else {

            // TODO: show alert

            return
        }

        // swiftlint:disable force_cast
        let usernameVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameViewController") as! UsernameViewController

        usernameVC.email = email
        usernameVC.password = password

        self.navigationController?.pushViewController(usernameVC, animated: true)

    }
    
    func showCancelAlert(_ alertMessage: AlertMessage) {
        let alertController = UIAlertController(title: "Cancel Process?", message: "Do you want to cancel the timer?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func isValidEmailAddress(emailAddressString: String) -> Bool {

        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))

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
