//
//  PrivacyPolicyViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/27.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var privacyTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Privacy Policy"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.privacyTextView.setContentOffset(CGPoint.zero, animated: false)
        self.privacyTextView.layer.cornerRadius = 10

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
