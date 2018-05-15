//
//  ModifyImagePickerViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2018. 1. 3..
//  Copyright © 2018년 becomingmacker. All rights reserved.
//

import UIKit

class ModifyImagePickerViewController: UIImagePickerController {
    
    // 수정되어 질때 사용되어 지는 PhotoPrivate Key 값
    open var photoPk: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
