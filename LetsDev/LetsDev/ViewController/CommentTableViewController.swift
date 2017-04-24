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

class CommentTableViewController: UITableViewController {

    enum Component {

        case commentDetail, detail, buttons, comments, commentInput

    }

    let components: [Component] = [.commentDetail, .detail, .buttons, .comments, .commentInput]
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

        IQKeyboardManager.sharedManager().enableAutoToolbar = false

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
    }

    func fetchPhotos() {
        if self.sharedPost.photo.count == 0 { return }

        for string in self.sharedPost.photo {

            DispatchQueue.global().async {

                guard let url = URL(string: string!) else { return }

                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    if let image = image {
                        self.photos.append(SKPhoto.photoWithImage(image))
                        self.tableView.reloadData()
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
        case .commentDetail, .detail, .buttons, .commentInput:
            return 1
        case .comments:
            return self.sharedPost.comment.count
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

            return cell

        case .detail:

            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell

            guard let combination = self.sharedPost.combination else { return UITableViewCell() }

            cell.filmLabel.text = combination.film
            cell.devTimeLabel.text = "\(self.timeExchanger(time: combination.devTime).minute)' \(self.timeExchanger(time: combination.devTime).second)"
            cell.developerLabel.text = combination.dev
            cell.dilutionLabel.text = combination.dilution
            cell.tempLabel.text = "\(combination.temp)ºC"
            cell.preWashTimeLabel.text = "\(self.timeExchanger(time: combination.preWashTime).minute)' \(self.timeExchanger(time: combination.preWashTime).second)"
            cell.stopTimeLabel.text = "\(self.timeExchanger(time: combination.stopTime).minute)' \(self.timeExchanger(time: combination.stopTime).second)"
            cell.fixTimeLabel.text = "\(self.timeExchanger(time: combination.fixTime).minute)' \(self.timeExchanger(time: combination.fixTime).second)"
            cell.washTimeLabel.text = "\(self.timeExchanger(time: combination.washTime).minute)' \(self.timeExchanger(time: combination.washTime).second)"
            cell.devAgitationLabel.text = combination.devAgitation.rawValue
            cell.fixAgitationLabel.text = combination.fixAgitation.rawValue
            cell.noteLabel.text = self.sharedPost.note

            cell.setCollectionViewDataSourceDelegate(self)
            cell.imageCollectionView.collectionViewLayout = self.configLayout()

            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()

            return cell

        case .buttons:

            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsTableViewCell", for: indexPath) as! ButtonsTableViewCell

            cell.commentButton.tintColor = Color.buttonColor

            CommunityManager.shared.getLikes(self.key) { (uids) in
                if uids.contains(self.uid) {
                    cell.likeButton.tintColor = UIColor.orange
                    cell.likeButton.addTarget(self, action: #selector(self.removeLike(_:)), for: .touchUpInside)
                } else {
                    cell.likeButton.tintColor = Color.buttonColor
                    cell.likeButton.addTarget(self, action: #selector(self.likeAction(_:)), for: .touchUpInside)
                }
            }

            if TabBarController.favoriteKeys.contains(self.key) {
                cell.favoriteButton.tintColor = UIColor.orange
                cell.favoriteButton.addTarget(self, action: #selector(removeFavorite(_:)), for: .touchUpInside)
            } else {
                cell.favoriteButton.tintColor = Color.buttonColor
                cell.favoriteButton.addTarget(self, action: #selector(favoriteAction(_:)), for: .touchUpInside)
            }

            return cell

        case .comments:

            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell

            if let uid = self.sharedPost.comment[indexPath.row]?.uid {
                UserManager.shared.getUser(uid, completion: { (user) in

                    if user.profileImage != nil {
                        if let url = URL(string: user.profileImage) {
                            cell.userImageView.kf.setImage(with: url)
                        }
                    } else {
                        cell.userImageView.image = #imageLiteral(resourceName: "anonymous-logo")
                    }

                    cell.usernameButton.setTitle(user.username, for: .normal)
                })
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            if let dateDouble = self.sharedPost.comment[indexPath.row]?.date {
                let date = Date(timeIntervalSince1970: dateDouble / 1000)
                let dateString = dateFormatter.string(from: date)

                cell.timeLabel.text = dateString
            }

            cell.commentLabel.text = self.sharedPost.comment[indexPath.row]?.comment

            return cell

        case .commentInput:

            let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as! InputTableViewCell

            cell.textView.delegate = self

            cell.sendButton.addTarget(self, action: #selector(sentCommentAction(_:)), for: .touchUpInside)

            if self.isFromBotton == true {
                cell.textView.becomeFirstResponder()
            }

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
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

}

extension CommentTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell

        cell.imageView.kf.indicatorType = .activity
        cell.imageView.image = self.photos[indexPath.row].underlyingImage

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

//        guard let cell = textView.superview?.superview?.superview as? UITableViewCell else { return }
//        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
//        
//        if textView.text.characters.count == 0 {
//            self.isSendable = false
//            self.tableView.reloadRows(at: [indexPath], with: .none)
//        } else {
//            self.isSendable = true
//            self.tableView.reloadRows(at: [indexPath], with: .none)
//        }
    }

}

extension CommentTableViewController {
    func timeExchanger(time: Int) -> (minute: Int, second: Int) {
        let minute = time / 60 % 60
        let second = time % 60

        return (minute, second)
    }
}
