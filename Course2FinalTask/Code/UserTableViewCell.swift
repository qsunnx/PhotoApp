//
//  UserTableViewCell.swift
//  Course2FinalTask
//
//  Created by Qsunnx on 07/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol UserTableViewCellDelegate {
    func showUser(cell: UserTableViewCell)
}

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var delegate: UserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.selectionStyle = .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate?.showUser(cell: self)
        }
    }

}
