//
//  UsersTableViewController.swift
//  Course2FinalTask
//
//  Created by Qsunnx on 07/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class UsersTableViewController: UITableViewController, UserTableViewCellDelegate {
    
    var users: [User]?
    var navigationItemTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _navigationItemTitle = navigationItemTitle {
            self.navigationItem.title = _navigationItemTitle
        }

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        if let currentUser = users?[indexPath.row] {
            cell.userAvatarImageView.image = currentUser.avatar
            cell.userNameLabel.text = currentUser.fullName
            
            cell.delegate = self
        }

        return cell
    }
    
    @objc func backBarButtonItemPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showUser(cell: UserTableViewCell) {
        if let userToShow = findUserFromCell(cell: cell) {
            let profileColectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileCollectionController") as! ProfileCollectionViewController
            profileColectionViewController.user = userToShow
            
            if let userPosts = DataProviders.shared.postsDataProvider.findPosts(by: userToShow.id) {
                profileColectionViewController.posts = userPosts
            }
            
            navigationController?.pushViewController(profileColectionViewController, animated: true)
        }
    }
    
    private func findUserFromCell(cell: UserTableViewCell) -> User? {
        if let indexPath = findIndexPathFor(cell: cell) {
            if let currentUsers = users {
                return currentUsers[indexPath.row]
            }
            
            return nil
        } else {
            return nil
        }
    }
    
    private func findIndexPathFor(cell: UserTableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
}
