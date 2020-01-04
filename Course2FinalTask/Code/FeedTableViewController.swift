//
//  FeedTableViewController.swift
//  Course2FinalTask
//
//  Created by Qsunnx on 07/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedTableViewController: UITableViewController, FeedTableViewCellDelegate {
    
    private var usersLikedPost = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 551
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataProviders.shared.postsDataProvider.feed().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        
        let currentPost = DataProviders.shared.postsDataProvider.feed()[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true;
        
        let postDateAsString = dateFormatter.string(from: currentPost.createdTime)
        
        cell.authorAvatarImageView.image = currentPost.authorAvatar
        cell.authorUsernameLabel.text    = currentPost.authorUsername
        cell.createdTimeLabel.text       = postDateAsString
        cell.postImageView.image         = currentPost.image
        cell.likedByCountLabel.text      = "Likes: \(currentPost.likedByCount)"
        cell.descriptionLabel.text       = currentPost.description
        
        if currentPost.currentUserLikesThisPost {
            cell.likeButton.tintColor = UIColor.blue
        } else {
            cell.likeButton.tintColor = UIColor.lightGray
        }
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - FeedTableViewCellDelegate
    func likePost(cell: FeedTableViewCell, withAnimation: Bool) {
        if let post = findPostFromCell(cell: cell) {
            if !post.currentUserLikesThisPost {
                if DataProviders.shared.postsDataProvider.likePost(with: post.id) {
                    if withAnimation {
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: { [weak cell] in
                            cell?.bigLikeImageView.alpha = 1.0
                        }) { (_) in
                            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: { [weak cell] in
                                cell?.bigLikeImageView.alpha = 0.0
                            }, completion: { [unowned self] (_) in
                                self.tableView.reloadRows(at: [self.tableView.indexPath(for: cell)!], with: .none)
                            })
                        }
                    } else {
                         self.tableView.reloadRows(at: [tableView.indexPath(for: cell)!], with: .none)
                    }
                }
            } else {
                if DataProviders.shared.postsDataProvider.unlikePost(with: post.id) {
                     tableView.reloadRows(at: [tableView.indexPath(for: cell)!], with: .none)
                }
            }
        }
    }
    
    func watchSubsribers(cell: FeedTableViewCell) {
        if let post = findPostFromCell(cell: cell) {
            if let usersID = DataProviders.shared.postsDataProvider.usersLikedPost(with: post.id) {
               usersLikedPost = usersID.compactMap{ currentUserID in
                    DataProviders.shared.usersDataProvider.user(with: currentUserID)
                }
                if usersLikedPost.count > 0 {
                    self.performSegue(withIdentifier: "ShowUsersFromFeed", sender: nil)
                }
            }
        }
    }
    
    func watchProfile(cell: FeedTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let currentPost = DataProviders.shared.postsDataProvider.feed()[indexPath.row]
            if let author = DataProviders.shared.usersDataProvider.user(with: currentPost.author) {
                let authorPosts = DataProviders.shared.postsDataProvider.findPosts(by: author.id)

                let profileCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileCollectionController") as! ProfileCollectionViewController
                
                profileCollectionViewController.user = author
                profileCollectionViewController.posts = authorPosts
                
                self.navigationController?.pushViewController(profileCollectionViewController, animated: true)
            }
        }
    }
    
    private func findPostFromCell(cell: FeedTableViewCell) -> Post? {
        if let indexPath = tableView.indexPath(for: cell) {
            let currentPost = DataProviders.shared.postsDataProvider.feed()[indexPath.row]
            
            return currentPost
        } else {
            return nil
        }
    }

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUsersFromFeed" {
            let usersTableViewController = segue.destination as! UsersTableViewController
            usersTableViewController.users                = usersLikedPost
            usersTableViewController.navigationItemTitle  = "Likes"
        }
     }
}
