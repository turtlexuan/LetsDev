//
//  CommentTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Kingfisher
import IQKeyboardManagerSwift
import Firebase
import MessageUI
import Whisper

class CommentTableViewController: UITableViewController {

    enum Component {

        case commentDetail, detail

    }

    let components: [Component] = [.commentDetail, .detail]
    var comments: [Comment] = []
    var sharedPost = SharedPost(combination: Combination(), note: "", photo: [], date: 0, message: "", comment: [], like: [], favorite: [])
    var uid = ""
    var key = ""
    var photos: [SKPhoto] = []
    var commentContent = ""
    var isSendable = false
    var isFromBotton = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.sharedPost.combination.film

        self.tableView.register(UINib(nibName: "CommentDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentDetailTableViewCell")
        self.tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        self.tableView.register(UINib(nibName: "ButtonsTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonsTableViewCell")
        self.tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        self.tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false

        self.fetchPhotos()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        IQKeyboardManager.sharedManager().enableAutoToolbar = true

        KingfisherManager.shared.cache.clearMemoryCache()
    }

    func fetchPhotos() {
        if self.sharedPost.photo.count == 0 { return }

        for (index, string) in self.sharedPost.photo.enumerated() {

            DispatchQueue.global().async {

                guard let url = URL(string: string!) else { return }

                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    if let image = image {

                        let skPhoto = SKPhoto.photoWithImage(image)

                        skPhoto.index = index

                        DispatchQueue.main.async {
                            self.photos.append(skPhoto)
                            self.photos.sort(by: { $0.index < $1.index })

                            print(index)

                        }
                    }
                })

            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch self.components[section] {
        case .commentDetail, .detail:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = self.components[indexPath.section]

        switch component {

        case .commentDetail:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentDetailTableViewCell", for: indexPath) as! CommentDetailTableViewCell

            UserManager.shared.getUser(uid) { (user) in
                if let profileUrlString = user.profileImage, let profileUrl = URL(string: profileUrlString) {
                    cell.profileImageView.kf.setImage(with: profileUrl)
                } else {
                    cell.profileImageView.image = #imageLiteral(resourceName: "anonymous-logo")
                }

                cell.usernameLabel.text = user.username
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            let date = Date(timeIntervalSince1970: self.sharedPost.date / 1000)
            let dateString = dateFormatter.string(from: date)

            cell.messageLabel.text = self.sharedPost.message
            cell.timeLabel.text = dateString

            cell.favoriteButton.tintColor = Color.buttonColor
            cell.moreButton.tintColor = Color.buttonColor
            cell.moreButton.addTarget(self, action: #selector(showReportAlert(_:)), for: .touchUpInside)

            if TabBarController.favoriteKeys.contains(self.key) {
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "bookmark-black-shape"), for: .normal)
                cell.favoriteButton.addTarget(self, action: #selector(removeFavorite(_:)), for: .touchUpInside)
            } else {
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "bookmark-white"), for: .normal)
                cell.favoriteButton.addTarget(self, action: #selector(favoriteAction(_:)), for: .touchUpInside)
            }

            return cell

        case .detail:

            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell

            guard let combination = self.sharedPost.combination else { return UITableViewCell() }

            cell.filmLabel.text = combination.film
            cell.devTimeLabel.text = "Dev Time : \(self.timeExchanger(time: combination.devTime).minute)' \(self.timeExchanger(time: combination.devTime).second)"
            cell.developerLabel.text = combination.dev

            if let dilution = combination.dilution, let temp = combination.temp {
                cell.dilutionLabel.text = "Dilution : \(dilution)"
                cell.tempLabel.text = "Temperature : \(temp)ºC"
            }

            cell.preWashTimeLabel.text = "Pre-Wash : \(self.timeExchanger(time: combination.preWashTime).minute)' \(self.timeExchanger(time: combination.preWashTime).second)"
            cell.stopTimeLabel.text = "Stop Time : \(self.timeExchanger(time: combination.stopTime).minute)' \(self.timeExchanger(time: combination.stopTime).second)"
            cell.fixTimeLabel.text = "Fix Time : \(self.timeExchanger(time: combination.fixTime).minute)' \(self.timeExchanger(time: combination.fixTime).second)"
            cell.washTimeLabel.text = "Wash Time : \(self.timeExchanger(time: combination.washTime).minute)' \(self.timeExchanger(time: combination.washTime).second)"
            cell.devAgitationLabel.text = "Dev Agitation : \(combination.devAgitation.rawValue)"
            cell.fixAgitationLabel.text = "Fix Agitation : \(combination.fixAgitation.rawValue)"
            cell.noteLabel.text = self.sharedPost.note

            cell.setCollectionViewDataSourceDelegate(self)
            cell.imageCollectionView.collectionViewLayout = self.configLayout()

            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()

            return cell
        }

    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.scrollDirection = .horizontal

        return layout
    }

    func sentCommentAction(_ sender: UIButton) {

        guard let cell = sender.superview?.superview?.superview as? UITableViewCell else { return }
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }

        CommunityManager.shared.commentPost(self.key, content: self.commentContent) { (_, error) in

            if error != nil {
                print(error ?? "")
                return
            }

            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }

    }

    func likeAction(_ sender: UIButton) {

        guard
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }

        CommunityManager.shared.likePost(self.key) { (_, error) in
            if error != nil {
                // Show Alert
            }

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func removeLike(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }

        CommunityManager.shared.removeLike(self.key) { (_, error) in
            if error != nil {
                // Show Alert
            }

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }

    }

    func commentAction(_ sender: UIButton) {
    }

    func favoriteAction(_ sender: UIButton) {

        if currentUser.uid == nil {

            self.showNoAccountAlert()

            return

        }

        guard
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }

        CommunityManager.shared.addFavorite(self.key) { (_, error) in

            if error != nil {
                print(error ?? "")
                return
            }

            TabBarController.favoriteKeys.append(self.key)
            FavoriteManager.shared.updateFavorite(with: TabBarController.favoriteKeys)

            FIRAnalytics.logEvent(withName: "Add_Favorite", parameters: [
                "User": currentUser.uid as NSObject,
                "Post": self.key as NSObject])

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func removeFavorite(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }

        CommunityManager.shared.removeFavorite(self.key) { (_, error) in

            if error != nil {
                print(error ?? "")
                return
            }

            guard let indexOfRecord = TabBarController.favoriteKeys.index(of: self.key) else { return }
            TabBarController.favoriteKeys.remove(at: indexOfRecord)
            FavoriteManager.shared.updateFavorite(with: TabBarController.favoriteKeys)

            FIRAnalytics.logEvent(withName: "Remove_Favorite", parameters: [
                "User": currentUser.uid as NSObject,
                "Post": self.key as NSObject])

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func showNoAccountAlert() {

        let alertController = UIAlertController(title: "Sorry", message: "Only registered member can add favorite.", preferredStyle: .alert)
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default) { (_) in

            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserNavigation")

            self.present(signUpVC!, animated: true, completion: nil)

        }
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { (_) in

            let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInNavigation")

            self.present(logInVC!, animated: true, completion: nil)

        }
        let laterAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)

        alertController.addAction(signInAction)
        alertController.addAction(signUpAction)
        alertController.addAction(laterAction)

        self.present(alertController, animated: true, completion: nil)

    }

    func showReportAlert(_ sender: UIButton) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let reportAction = UIAlertAction(title: "Report", style: .default) { (_) in
            //
            if MFMailComposeViewController.canSendMail() {

                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["turtlexuan@gmail.com"])
                mail.setSubject("Report")
                mail.setMessageBody("I want to report post : \(self.key) because", isHTML: false)

                self.present(mail, animated: true)

            } else {
                return
            }

        }

        let deleteAction = UIAlertAction(title: "Delete Post", style: .default) { (_) in
            //
            CommunityManager.shared.removePost(with: self.key) { error in

                if error != nil {

                    print(error ?? "")

                    return
                }

                self.navigationController?.popViewController(animated: true)

                let message = Message(title: "Post Deleted.", backgroundColor: .darkGray)
                Whisper.show(whisper: message, to: self.navigationController!, action: .present)
                hide(whisperFrom: self.navigationController!, after: 3)

            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        if currentUser.uid != nil {
            if currentUser.uid == uid {

                alertController.addAction(deleteAction)

            }

        } else {

            alertController.addAction(reportAction)
        }

        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }

}

extension CommentTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sharedPost.photo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell

        let url = URL(string: self.sharedPost.photo[indexPath.row]!)

        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        // swiftlint:enable force_case
        let originImage = cell.imageView.image

        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: self.photos, animatedFromView: cell)

        browser.initializePageIndex(indexPath.row)

        self.present(browser, animated: true, completion: nil)
    }
}

extension CommentTableViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if error != nil {

            return
        }

        controller.dismiss(animated: true) {

            let message = Message(title: "Email Sent.", backgroundColor: .darkGray)
            Whisper.show(whisper: message, to: self.navigationController!, action: .present)
            hide(whisperFrom: self.navigationController!, after: 3)

        }
    }

}

extension CommentTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            self.commentContent = text
        }

        let currentOffset = self.tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tableView.setContentOffset(currentOffset, animated: false)
    }

}

extension CommentTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
