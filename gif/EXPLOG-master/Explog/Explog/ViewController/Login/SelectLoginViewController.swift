//
//  SelectLoginViewController.swift
//  ExplogFB
//
//  Created by JU MIN JUN on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

// MARK: Login ViewController
class SelectLoginViewController: UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailButton: CustomButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Color style 통일
        self.exitButton.setTitleColor(.colorConcept, for: .normal) 
        self.logoLabel.textColor = .colorConcept
        self.emailButton.backgroundColor = .colorConcept
        self.signUpButton.setTitleColor(UIColor.colorConcept, for: .normal)
    }
    
    // MARK: Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
