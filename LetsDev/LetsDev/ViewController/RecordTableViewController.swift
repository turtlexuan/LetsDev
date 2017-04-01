//
//  RecordTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/24.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import DKImagePickerController
import SKPhotoBrowser

class RecordTableViewController: UITableViewController {

    enum Component {

        case combination, note, photo

    }

    // MARK: Property
    var combination = Combination()
    var recordKey = ""
    var components: [Component] = [ .combination, .note, .photo ]
    var note = ""
    var assets: [DKAsset] = []
    var skImage: [SKPhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = combination.film
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction(_:))), animated: true)

        self.tableView.register(UINib(nibName: "CombinationTableViewCell", bundle: nil), forCellReuseIdentifier: "CombinationTableViewCell")
        self.tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        self.tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(UINib(nibName: "NewDevTableViewCell", bundle: nil), forCellReuseIdentifier: "NewDevTableViewCell")

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.components[indexPath.section]

        switch component {
        case .combination:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinationTableViewCell", for: indexPath) as! CombinationTableViewCell

            let preWashTime = self.timeExchanger(time: self.combination.preWashTime)
            let devTime = self.timeExchanger(time: self.combination.devTime)
            let fixTime = self.timeExchanger(time: self.combination.fixTime)
            let stopTime = self.timeExchanger(time: self.combination.stopTime)
            let washTime = self.timeExchanger(time: self.combination.washTime)

            cell.filmNameLabel.text = self.combination.film
            cell.developerLabel.text = self.combination.dev
            cell.preWashLabel.text = "Pre-Wash : \(preWashTime.minute)' \(preWashTime.second)\""
            cell.devTimeLabel.text = "Develope : \(devTime.minute)' \(devTime.second)\""
            cell.fixTimeLabel.text = "Fix Time : \(fixTime.minute)' \(fixTime.second)\""
            cell.stopTimeLabel.text = "Stop Time : \(stopTime.minute)' \(stopTime.second)\""
            cell.washTimeLabel.text = "Wash Time : \(washTime.minute)' \(washTime.second)\""
            cell.devAgitationLabel.text = "Dev Agitation : \(self.combination.devAgitation.rawValue)"
            cell.fixAgitationLabel.text = "Fix Agitation : \(self.combination.fixAgitation.rawValue)"

            if let temp = self.combination.temp {
                cell.temperatureLabel.text = "Temperature : \(temp) ºC"
            }

            return cell

        case .note:

            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell

            cell.noteLabel.text = self.note
            cell.editButton.addTarget(self, action: #selector(self.showEditView(_:)), for: .touchUpInside)

            return cell

        case .photo:

            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell

            self.tableView.beginUpdates()
            cell.setCollectionViewDataSourceDelegate(self)
            cell.collectionView.collectionViewLayout = self.configLayout()
            self.tableView.rowHeight = cell.collectionView.bounds.height
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            self.tableView.endUpdates()

            cell.addPhotoButton.addTarget(self, action: #selector(showImagePickerAlertSheet(_:)), for: .touchUpInside)

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = self.components[indexPath.section]

        switch component {
        case .combination:
            return 265
        case .note:
            return UITableViewAutomaticDimension
        case .photo:
            return CollectionHeight.getCollectionHeight(itemHeight: (self.view.frame.width - 68) / 3, totalItem: self.skImage.count) + 50
        }
    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: (self.view.frame.width - 68) / 3, height: (self.view.frame.width - 68) / 3)

        return layout
    }

    func showEditView(_ sender: UIButton) {
        // swiftlint:disable force_cast
        let noteVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteVC.delegate = self
        noteVC.note = self.note
        self.navigationController?.present(noteVC, animated: true, completion: nil)
    }

    func showImagePickerAlertSheet(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Image From?", message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Choose from photo library", style: .default) { (_) in
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos

            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")

                self.assets = assets

                for asset in assets {
                    asset.fetchOriginalImage(true, completeBlock: { (imageData, _) in
                        guard let image = imageData else { return }
                        self.skImage.append(SKPhoto.photoWithImage(image))
                    })

                }

                RecordManager.shared.updatePhoto(with: self.skImage, key: self.recordKey)

                self.tableView.reloadData()
            }

            self.present(pickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (_) in
            //
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func doneAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RecordTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.skImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell

        if self.skImage != [] {
            cell.imageView.image = self.skImage[indexPath.row].underlyingImage
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        // swiftlint:enable force_case
        let originImage = cell.imageView.image

        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: self.skImage, animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)

        self.present(browser, animated: true, completion: nil)
    }
}

extension RecordTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}

extension RecordTableViewController: NoteViewControllerDelegate {
    func didReceiveNote(note: String) {
        self.note = note
        RecordManager.shared.updateNote(with: note, key: recordKey)
        self.tableView.reloadData()
    }
}
