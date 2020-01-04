//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Qsunnx on 07/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol FeedTableViewCellDelegate : AnyObject {
    func likePost(cell: FeedTableViewCell, withAnimation: Bool)
    func watchSubsribers(cell: FeedTableViewCell)
    func watchProfile(cell: FeedTableViewCell)
}

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likedByCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bigLikeImageView: UIImageView!
    
    weak var delegate: FeedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizers()
        bigLikeImageView.alpha = 0.0
    }
    
    @IBAction func likePostButtonPressed(_ sender: UIButton) {
        delegate?.likePost(cell: self, withAnimation: false)
    }
    
    @objc func tapOnImageGestureRecognizerPressed() {
        delegate?.likePost(cell: self, withAnimation: true)
    }
    
    @objc func tapToWatchProfileGestureRecognizerPressed() {
        delegate?.watchProfile(cell: self)
    }
    
    @objc func tapToWatchSubscribersGestureRecognizerPressed() {
        delegate?.watchSubsribers(cell: self)
    }
    
    func addGestureRecognizers() {
        let tapOnImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnImageGestureRecognizerPressed))
        tapOnImageGestureRecognizer.numberOfTapsRequired = 2
        
        let tapToWatchSubscribersGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToWatchSubscribersGestureRecognizerPressed))
        tapToWatchSubscribersGestureRecognizer.numberOfTapsRequired = 1
        
        postImageView.addGestureRecognizer(tapOnImageGestureRecognizer)
        likedByCountLabel.addGestureRecognizer(tapToWatchSubscribersGestureRecognizer)
        
        addTapToWatchProfileGestureRecognizer(element: authorAvatarImageView)
        addTapToWatchProfileGestureRecognizer(element: authorUsernameLabel)
        addTapToWatchProfileGestureRecognizer(element: createdTimeLabel)
    }
    
    func addTapToWatchProfileGestureRecognizer(element: UIView) {
        let tapToWatchProfileGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToWatchProfileGestureRecognizerPressed))
        tapToWatchProfileGestureRecognizer.numberOfTapsRequired = 1
        
        element.addGestureRecognizer(tapToWatchProfileGestureRecognizer)
    }
}
