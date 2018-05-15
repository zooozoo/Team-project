//
//  LoginViewController.swift
//  ExplogFB
//
//  Created by JU MIN JUN on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

import Alamofire

class LoginViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    private var indicate: UIActivityIndicatorView?
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var loginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicate()
        initSetting()
        
        // MARK: Textfield AttributedString
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        emailTF.textColor = .colorConcept
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTF.textColor = .colorConcept
        
        // NotificationCenter for keyboard movement
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keywillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keywillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.tapAction(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // Action for keyboard hide when touch
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: initail Setting
    private func initSetting(){
        self.exitButton.setTitleColor(UIColor.colorConcept,
                                      for: UIControlState.normal)
        self.emailTitleLabel.textColor = UIColor.colorConcept
        self.loginButton.setTitleColor(.white,
                                       for:.normal)
        self.loginButton.backgroundColor = .colorConcept
    }
    
    // IBActions
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        indicate?.startAnimating()
        Network.AuthService.login(email: email, password: password) { (isSuccess ,data, error) in
            print("result is \(String(describing: data))")
            
            // 로그인이 성공한 경우
            if isSuccess {
                let token: String = (data?.token)!
                let pk: Int = (data?.pk)!
                let privateKey: [String: Any] = ["token": token, "pk": pk]
                UserDefaults.standard.set(privateKey, forKey: "privateKey")
                let userPrivateKey = UserDefaults.standard.value(forKey: "privateKey") as! [String:Any]
                let userToken = userPrivateKey["token"] as! String
                AppDelegate.instance?.token = userToken
                let userPK = userPrivateKey["pk"] as! Int
                AppDelegate.instance?.userPK = userPK
                self.indicate?.stopAnimating()
                
                // 현재까지 띄워져 있는 모든 `Show` ViewController dismiss 함
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                // 로그인이 실패한 경우
            }else {
                self.indicate?.stopAnimating()
                if error?.message != nil {
                    self.convenienceAlert(alertTitle: "비밀번호가 맞지 않거나 없는 유저입니다✨")
                }else {
                    self.convenienceAlert(alertTitle: "네트워크 상태가 좋지 않습니다✨")
                }
            }
        }
    }
    
    // MARK: Indicate 셋팅.
    private func setIndicate() {
        indicate = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicate?.frame.origin = CGPoint(x: view.center.x,
                                         y: view.center.y)
        view.addSubview(indicate!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Login Keyboard Notification 삭제")
    }
}

// MARK: Keyboard Control
extension LoginViewController {
    // selector methods for keyboard movement
    @objc func keywillShow(notification: Notification) {
        guard let userinfo = notification.userInfo else { return }
        guard let keyboard = userinfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: keyboard.size.height - 200),
                                    animated: true)
    }
    
    @objc func keywillHide(notification: Notification) {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: 0),
                                    animated: true)
    }
}

// MARK: Textfield EnterKey 눌렀을때, 커서 아래로 내려가게만듬
extension LoginViewController: UITextFieldDelegate {
    // Actions for pressing return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
