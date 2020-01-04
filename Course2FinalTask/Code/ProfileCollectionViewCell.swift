//
//  ProfileCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Qsunnx on 20/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var postImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.postImageView = UIImageView.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.postImageView = UIImageView.init()
    }
    
}
