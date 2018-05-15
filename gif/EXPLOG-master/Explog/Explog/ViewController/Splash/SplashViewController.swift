//
//  SplashViewController.swift
//  ExplogFB
//
//  Created by 주민준 on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    
    // MARK : 1 - UI Properties
    fileprivate let actiIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate var splashLogoView: UIImageView!
    fileprivate var splashLogoLabel: UILabel = {
        var splashLabel = UILabel()
        splashLabel.text = "EXPLOG"
        splashLabel.textColor =  UIColor.colorConcept
        splashLabel.font = UIFont.boldSystemFont(ofSize: 60)
        return splashLabel
    }()
    
    fileprivate var backgroundImgView: UIImageView = {
        var backgroundImg = UIImageView()
        backgroundImg.image = #imageLiteral(resourceName: "background")
        return backgroundImg
    }()
    
    // MARK : 2 - Other Properties
    // MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // blur 효과 넣기 기존 로직에서 변경.
        self.backgroundImgView.blurView.alpha = 1
        
        // indicator setup
        self.view.addSubview(actiIndicator)
        self.backgroundImgView.addSubview(splashLogoLabel)
        actiIndicator.snp.makeConstraints { (actiIndicator) in
            actiIndicator.center.equalToSuperview()
        }
        
        self.view.addSubview(backgroundImgView)
        backgroundImgView.snp.makeConstraints { (backgroundImg) in
            backgroundImg.top.equalToSuperview()
            backgroundImg.bottom.equalToSuperview()
            backgroundImg.leading.equalToSuperview()
            backgroundImg.trailing.equalToSuperview()
        }
        makeSplashLogo()
        setupLogoLabel()
        logoAnimation()
    }
    
    // MARK : 5 - splash 로고 만들기
    private func makeSplashLogo() {
        splashLogoView = UIImageView()
        self.backgroundImgView.addSubview(splashLogoView)
        splashLogoView.image = UIImage(named: "logo_blue")
        splashLogoView.snp.makeConstraints { (splashlogo) in
            splashlogo.center.equalToSuperview()
            splashlogo.width.equalTo(150)
            splashlogo.height.equalTo(150)
        }
    }
    
    private func setupLogoLabel() {
        splashLogoLabel.snp.makeConstraints { (splashLabel) in
            splashLabel.center.equalToSuperview()
        }
        splashLogoLabel.alpha = 0
    }
    
    // type method 속에서는 self 사용 못함. 그것에 따라서 static, class 사용 고려 해야함.
    func presentToLogin(){
        let storyboard = UIStoryboard(name: "Master", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let nextViewController = storyboard
        AppDelegate.instance?.window?.rootViewController = nextViewController
        // Push Notification 을 받아서, BadgeNumber 가 쌓여있다면, app 을 켰을때, PushNoti있는곳으로 가줌.
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            nextViewController.selectedViewController = nextViewController.viewControllers?[3]
        }
    }
    
    // Login Check, Token ckeck
    // MARK: Login Check..!
    func checkToken() {
        // Token 이 존재하는 경우 Token 값을 Setting 함.
        if let token = UserDefaults.standard.value(forKey: "privateKey") as? [String:Any] {
            print("토큰, UserPK 가 존재합니다")
            // AppDelegate 의 token 값과, UserPk 값을 정해줌.
            AppDelegate.instance?.token = token["token"] as? String
            AppDelegate.instance?.userPK = token["pk"] as? Int
            print("-----------------------device token is \(String(describing: AppDelegate.instance?.deviceToken))")
            if AppDelegate.instance?.deviceToken != nil {
                Network.PushNotification.registeDeviceToken(deviceToken: (AppDelegate.instance?.deviceToken)!,
                                                            completion: { (isSuccess, data) in
                                                                if isSuccess { print("-----------------------device token is \(String(describing: AppDelegate.instance?.deviceToken))")
                                                                }else {
                                                                    print("-----------------------device token is \(String(describing: AppDelegate.instance?.deviceToken))")
                                                                }
                })
                // token 값이 존재 하지 않을때 아래의부분이 실행됨
            }
        }else {
            print("토큰이 nil 입니다.")
        }
    }
    
    // MARK : 6 - splash 로고 애니메이션
    private func logoAnimation() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 2.0, animations: {
            self.view.backgroundColor = .white
            self.splashLogoView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        }) { (_) in
            UIView.animate(withDuration: 0.8, animations: {
                self.splashLogoLabel.alpha = 1
                self.splashLogoView.alpha = 0
                self.splashLogoView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
                self.backgroundImgView.image = nil
            }, completion: { (_) in
                // 토큰 체크후, ViewController Present
                self.checkToken()
                self.presentToLogin()
            })
        }
    }
}
