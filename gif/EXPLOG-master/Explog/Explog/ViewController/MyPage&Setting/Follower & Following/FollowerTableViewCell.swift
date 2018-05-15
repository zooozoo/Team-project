//
//  FollowerTableViewCell.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class FollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 30
        followerButton.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

