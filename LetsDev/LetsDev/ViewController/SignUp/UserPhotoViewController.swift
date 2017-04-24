//
//  UserPhotoViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/5.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import DKImagePickerController

class UserPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var email = ""
    var password = ""
    var username = ""
    var imageChanged = false
    var profileImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImagePickerAlertSheet(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAction(_ sender: Any) {

        if self.imageChanged == false {
            self.showAlert()
        } else {
            self.signUp()
        }

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

    func signUp() {

        LoginManager.shared.create(withEmail: self.email, password: self.password, username: self.username, image: self.profileImage, success: { (_) in

            self.nextVC()

        }, fail: { (message) in
            print(message)
        })

    }

    func showImagePickerAlertSheet(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Choose Image From?", message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Choose from photo library", style: .default) { (_) in

            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos
            pickerController.maxSelectableCount = 1
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")

                let asset = assets.first
                asset?.fetchOriginalImage(true, completeBlock: { (imageData, _) in
                    guard let image = imageData else { return }
                    self.imageView.image = image
                    self.profileImage = image
                    self.imageChanged = true
                })
            }
            self.present(pickerController, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (_) in

            let pickerController = DKImagePickerController()
            pickerController.sourceType = .camera

            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")

                let asset = assets.first
                asset?.fetchOriginalImage(true, completeBlock: { (imageData, _) in
                    guard let image = imageData else { return }
                    self.imageView.image = image
                    self.profileImage = image
                    self.imageChanged = true
                })
            }
            self.present(pickerController, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func showAlert() {
        let alertController = UIAlertController(title: "Profile Image", message: "You haven't select any picture, do you want to continue?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Upload Later.", style: .default) { (_) in

            self.signUp()
        }

        let cancelAction = UIAlertAction(title: "Upload Now.", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
