//
//  CustomButton.swift
//  ExplogFB
//
//  Created by JU MIN JUN on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

// MARK: CustomButton Type 로 같은 Button 있으면 사용하려고 했던 의도 같음.
class CustomButton: UIButton {
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
    }
}
