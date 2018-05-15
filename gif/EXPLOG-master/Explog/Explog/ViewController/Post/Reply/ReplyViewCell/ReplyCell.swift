//
//  YourBubbleCellTableViewCell.swift
//  17-11-19-KaKaoTalk
//
//  Created by MIN JUN JU on 2017. 11. 26..
//  Copyright © 2017년 MIN JUN JU. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
    
    @IBOutlet internal weak var comments: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        comments.layer.cornerRadius = 10 
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
