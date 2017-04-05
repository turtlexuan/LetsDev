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
    var image: UIImage!
    var imageChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAction(_ sender: Any) {

        if self.imageChanged == false {
            // TODO: send alert
            // TODO: create user without photo
        }

        // TODO: Sign Up

    }

    @IBAction func addPhotoAction(_ sender: UITapGestureRecognizer) {
        self.showImagePickerAlertSheet()
    }

    func showImagePickerAlertSheet() {
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

}
