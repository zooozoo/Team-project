//
//  CustomTextField.swift
//  ExplogFB
//
//  Created by JU MIN JUN on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit
import Foundation

// MARK: Textfield Under Line 만들어주는 class
class CustomTextField: UITextField, UITextFieldDelegate{
    let border = CALayer()
    let width = CGFloat(2.0)
    
    // MARK: 여러가지 방법으로 초기화 하는 이유 한번 찾아봐야 겠음.
    required init?(coder aDecoder: (NSCoder!)){
        super.init(coder: aDecoder)
        self.borderStyle = .none
        
        // Color
        let setUnderLineColor = UIColor.colorConcept.cgColor
        border.borderColor = setUnderLineColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    override func draw(_ rect: CGRect) {
        self.borderStyle = .none
        
        // Color
        let setUnderLineColor = UIColor.colorConcept.cgColor
        border.borderColor = setUnderLineColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderStyle = .none
        
        // Color
        let setUnderLineColor = UIColor.colorConcept.cgColor
        border.borderColor = setUnderLineColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

