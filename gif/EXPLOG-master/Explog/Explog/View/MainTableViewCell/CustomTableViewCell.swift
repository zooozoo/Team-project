//
//  CustomTableViewCell.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 1..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

// MARK: Main tableView에 사용되는 XIB 파일
class CustomTableViewCell: UITableViewCell {
    @IBOutlet open weak var backGroundImageView: UIImageView!
    @IBOutlet open weak var dateTitle: UILabel!
    @IBOutlet open weak var title: UILabel!
    @IBOutlet open weak var nickNameTitle: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var numberOfLikeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
