//
//  ProfileCollectionViewController.swift
//  Course2FinalTask
//
//  Created by Qsunnx on 07/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

fileprivate enum Constants: Int {
    case postsPerRow = 3
}

private let reuseIdentifier = "CollectionViewPostCell"
private let reuseHeaderIdentifier = "ProfileCollectionViewHeader"

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileHeaderViewDelegate {
    
    var user: User!
    var posts: [Post]?

    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            user = DataProviders.shared.usersDataProvider.currentUser()
        }
        
        posts = DataProviders.shared.postsDataProvider.findPosts(by: user.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = user.username
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
        
        if let currentPost = posts?[indexPath.row] {
            cell.postImageView.image = currentPost.image
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let profileCollectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileCollectionViewHeader", for: indexPath) as! ProfileCollectionHeaderView
            
            profileCollectionViewHeader.userAvatarImageView.image = user.avatar
            profileCollectionViewHeader.userNameLabel.text = user.fullName
            profileCollectionViewHeader.followersLabel.text = "Followers: \(user.followedByCount)"
            profileCollectionViewHeader.followingLabel.text = "Following: \(user.followsCount)"
            
            profileCollectionViewHeader.delegate = self
            
            return profileCollectionViewHeader
        } else {
            assert(false, "ERROR IN COLLECTION VIEW")
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.width / 3
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: ProfileHeaderViewDelegate
    func watchSubscribers(subscribersType: SubscribersType) {
        var currentSubscribers: [User]? = nil
        var navigationTitle = ""
        
        if subscribersType == .followers {
            currentSubscribers = DataProviders.shared.usersDataProvider.usersFollowingUser(with: user.id)
            navigationTitle = "Followers"
        } else {
            currentSubscribers = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: user.id)
            navigationTitle = "Following"
        }
        
        if let _currentSubscribers = currentSubscribers {
            let usersToWatch = _currentSubscribers.compactMap{ return $0 }
            
            let usersTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableViewController") as! UsersTableViewController
            usersTableViewController.users = usersToWatch
            usersTableViewController.navigationItemTitle = navigationTitle
            
            self.navigationController?.pushViewController(usersTableViewController, animated: true)
        }
    }

}
