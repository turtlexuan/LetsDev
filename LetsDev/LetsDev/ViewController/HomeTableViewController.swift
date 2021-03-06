//
//  HomeTableViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/11.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Crashlytics
import MessageUI
import Whisper

class HomeTableViewController: UITableViewController {

    var sharedPosts: [(sharedPost: SharedPost, uid: String, key: String)] = []
    private var uid = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Let's Dev"

        self.tableView.register(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "HomePageTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = .none

        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.uid = uid
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let activityData = ActivityData(type: .ballRotateChase)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        if self.uid != "" {

            UserManager.shared.getBlockUser { (blockList) in
                //
                var blockUid: [String] = []
                for item in blockList {
                    blockUid.append(item.uid)
                }

                CommunityManager.shared.getPost(with: blockUid, completion: { (sharedPosts) in
                    self.sharedPosts = sharedPosts
                    self.tableView.reloadData()

                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                })
            }
        } else {

            CommunityManager.shared.getPost { (sharedPosts) in
                self.sharedPosts = sharedPosts
                self.tableView.reloadData()

                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sharedPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let index = self.sharedPosts[indexPath.row]

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell", for: indexPath) as! HomePageTableViewCell

        cell.selectionStyle = .none

        UserManager.shared.getUser(index.uid) { (user) in
            if let profileUrlString = user.profileImage, let profileUrl = URL(string: profileUrlString) {
                cell.profileImageView.kf.setImage(with: profileUrl)
            } else {
                cell.profileImageView.image = #imageLiteral(resourceName: "anonymous-logo")
            }

            cell.usernameLabel.text = user.username
        }

        if let imageUrlString = index.sharedPost.photo.first as? String, let imageUrl = URL(string: imageUrlString) {

            cell.filmImageView.kf.setImage(with: imageUrl)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = Date(timeIntervalSince1970: index.sharedPost.date / 1000)
        let dateString = dateFormatter.string(from: date)

        cell.dateLabel.text = dateString
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.text = index.sharedPost.message
        cell.filmLabel.text = index.sharedPost.combination.film
        cell.developerLabel.text = index.sharedPost.combination.dev
        cell.devTimeLabel.text = "Dev Time : \(self.timeExchanger(time: index.sharedPost.combination.devTime).minute)'\(self.timeExchanger(time: index.sharedPost.combination.devTime).second)"
        if let dilution = index.sharedPost.combination.dilution {
            cell.dilutionLabel.text = "Dilution : \(dilution)"
        }
        cell.noteLabel.text = index.sharedPost.note

        cell.moreButton.tintColor = Color.buttonColor
        cell.reportButton.tintColor = Color.buttonColor
        cell.reportButton.addTarget(self, action: #selector(showReportAlert(_:)), for: .touchUpInside)

        if TabBarController.favoriteKeys.contains(index.key) {
            cell.moreButton.setImage(#imageLiteral(resourceName: "bookmark-black-shape"), for: .normal)
            cell.moreButton.addTarget(self, action: #selector(removeFavorite(_:)), for: .touchUpInside)
        } else {
            cell.moreButton.setImage(#imageLiteral(resourceName: "bookmark-white"), for: .normal)
            cell.moreButton.addTarget(self, action: #selector(favoriteAction(_:)), for: .touchUpInside)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // push to detail view
        let key = self.sharedPosts[indexPath.row].key

        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentTableViewController") as! CommentTableViewController

        print(self.sharedPosts[indexPath.row].sharedPost.comment.count)

        commentVC.sharedPost = self.sharedPosts[indexPath.row].sharedPost
        commentVC.key = key
        commentVC.uid = self.sharedPosts[indexPath.row].uid

        self.navigationController?.pushViewController(commentVC, animated: true)
    }

    func likeAction(_ sender: UIButton) {

        guard
            let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }
        let key = self.sharedPosts[indexPath.row].key

        CommunityManager.shared.likePost(key) { (_, error) in
            if error != nil {
                // Show Alert
            }

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func removeLike(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }
        let key = self.sharedPosts[indexPath.row].key

        CommunityManager.shared.removeLike(key) { (_, error) in
            if error != nil {
                // Show Alert
            }

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }

    }

    func commentAction(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }
        let key = self.sharedPosts[indexPath.row].key

        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentTableViewController") as! CommentTableViewController

        print(self.sharedPosts[indexPath.row].sharedPost.comment.count)
        commentVC.sharedPost = self.sharedPosts[indexPath.row].sharedPost
        commentVC.key = key
        commentVC.uid = self.sharedPosts[indexPath.row].uid
        commentVC.isFromBotton = true

        self.navigationController?.pushViewController(commentVC, animated: true)
    }

    func favoriteAction(_ sender: UIButton) {

        if currentUser.uid == nil {

            self.showNoAccountAlert()

            return
        }

        guard
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }
        let key = self.sharedPosts[indexPath.row].key

        CommunityManager.shared.addFavorite(key) { (_, error) in

            if error != nil {
                print(error ?? "")
                return
            }

            TabBarController.favoriteKeys.append(key)
            FavoriteManager.shared.updateFavorite(with: TabBarController.favoriteKeys)

            FIRAnalytics.logEvent(withName: "Add_Favorite", parameters: [
                "User": currentUser.uid as NSObject,
                "Post": key as NSObject])

            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func removeFavorite(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }
        let key = self.sharedPosts[indexPath.row].key

        CommunityManager.shared.removeFavorite(key) { (_, error) in

            if error != nil {
                print(error ?? "")
                return
            }

            guard let indexOfRecord = TabBarController.favoriteKeys.index(of: key) else { return }
            TabBarController.favoriteKeys.remove(at: indexOfRecord)
            FavoriteManager.shared.updateFavorite(with: TabBarController.favoriteKeys)

            FIRAnalytics.logEvent(withName: "Remove_Favorite", parameters: [
                "User": currentUser.uid as NSObject,
                "Post": key as NSObject])

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

        let cell = sender.superview?.superview?.superview as! HomePageTableViewCell
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let uid = self.sharedPosts[indexPath.row].uid

        var username = ""

        UserManager.shared.getUser(uid) { (user) in
            username = user.username
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let reportAction = UIAlertAction(title: "Report", style: .default) { (_) in
            //
            if MFMailComposeViewController.canSendMail() {

                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["turtlexuan@gmail.com"])
                mail.setSubject("Report")
                mail.setMessageBody("I want to report post : \(self.sharedPosts[indexPath.row].key) because", isHTML: false)

                self.present(mail, animated: true)

            } else {
                return
            }

        }

        let deleteAction = UIAlertAction(title: "Delete Post", style: .default) { (_) in
            //
            CommunityManager.shared.removePost(with: self.sharedPosts[indexPath.row].key) { error in

                if error != nil {

                    print(error ?? "")

                    return
                }

                self.sharedPosts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)

                let message = Message(title: "Post Deleted.", backgroundColor: .darkGray)
                Whisper.show(whisper: message, to: self.navigationController!, action: .present)
                hide(whisperFrom: self.navigationController!, after: 3)

            }
        }

        let blockAction = UIAlertAction(title: "Block \(username)", style: .default) { (_) in

            UserManager.shared.blockUser(with: username, userUid: self.sharedPosts[indexPath.row].uid, completion: { (error) in
                print(error ?? "")

                let message = Message(title: "\(username) Blocked.", backgroundColor: .darkGray)
                Whisper.show(whisper: message, to: self.navigationController!, action: .present)
                hide(whisperFrom: self.navigationController!, after: 3)

            })
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        if currentUser.uid != nil {
            if currentUser.uid == uid {

                alertController.addAction(deleteAction)

            } else {
                alertController.addAction(blockAction)
                alertController.addAction(reportAction)
            }

        } else {

            alertController.addAction(reportAction)
        }

        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }

}

extension HomeTableViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true) {

            let message = Message(title: "Email Sent.", backgroundColor: .darkGray)
            Whisper.show(whisper: message, to: self.navigationController!, action: .present)
            hide(whisperFrom: self.navigationController!, after: 3)

        }
    }

}

extension HomeTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
