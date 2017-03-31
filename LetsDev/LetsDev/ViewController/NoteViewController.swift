//
//  NoteViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/31.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate: class {
    func didReceiveNote(note: String)
}

class NoteViewController: UIViewController {

    @IBOutlet weak var textField: UITextView?
    weak var delegate: NoteViewControllerDelegate!

    var note = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textField?.text = self.note
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveAction(_ sender: Any) {
        guard let text = self.textField?.text else { return }
        self.note = text
        self.delegate.didReceiveNote(note: text)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
