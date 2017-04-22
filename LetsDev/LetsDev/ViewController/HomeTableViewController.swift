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

class HomeTableViewController: UITableViewController {

    var sharedPosts: [(sharedPost: SharedPost, uid: String, key: String)] = []
    var states: [Bool]!
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

        CommunityManager.shared.getPost { (sharedPosts) in
            self.sharedPosts = sharedPosts
            self.states = [Bool](repeating: true, count: sharedPosts.count)
            self.tableView.reloadData()

            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = Date(timeIntervalSince1970: index.sharedPost.date / 1000)
        let dateString = dateFormatter.string(from: date)

        cell.dateLabel.text = dateString
        cell.messageLabel.numberOfLines = 3
        cell.messageLabel.collapsed = states[indexPath.row]
        cell.messageLabel.text = index.sharedPost.message
        cell.filmLabel.text = index.sharedPost.combination.film
        cell.developerLabel.text = index.sharedPost.combination.dev
        cell.devTimeLabel.text = "\(index.sharedPost.combination.devTime)"
        cell.dilutionLabel.text = index.sharedPost.combination.dilution
        cell.noteLabel.text = index.sharedPost.note

        cell.commentButton.tintColor = Color.buttonColor
        cell.commentButton.addTarget(self, action: #selector(commentAction(_:)), for: .touchUpInside)

        CommunityManager.shared.getLikes(index.key) { (uids) in
            if uids.contains(self.uid) {
                cell.likeButton.tintColor = UIColor.orange
                cell.likeButton.addTarget(self, action: #selector(self.removeLike(_:)), for: .touchUpInside)
            } else {
                cell.likeButton.tintColor = Color.buttonColor
                cell.likeButton.addTarget(self, action: #selector(self.likeAction(_:)), for: .touchUpInside)
            }
        }

        if TabBarController.favoriteKeys.contains(index.key) {
            cell.favoriteButton.tintColor = UIColor.orange
            cell.favoriteButton.addTarget(self, action: #selector(removeFavorite(_:)), for: .touchUpInside)
        } else {
            cell.favoriteButton.tintColor = Color.buttonColor
            cell.favoriteButton.addTarget(self, action: #selector(favoriteAction(_:)), for: .touchUpInside)
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
        guard
            let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) else { return }
        let key = self.sharedPosts[indexPath.row].key

        CommunityManager.shared.addFavorite(key) { (_, error) in

            if error != nil {
                print(error ?? "")
                return
            }

            TabBarController.favoriteKeys.append(key)
            FavoriteManager.shared.updateFavorite(with: TabBarController.favoriteKeys)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func removeFavorite(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell,
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
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
