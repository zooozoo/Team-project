//
//  TabBarController.swift
//  Explog
//
//  Created by 주민준 on 2017. 12. 4..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

// Main에 사용되는 TabbarController
class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = UIColor.colorConcept
        
        // Like Viewcontroller의 badgeValue 변경
        // badgeNumber 가 0 보다 크면 해당 숫자르 반영 해줍니다.
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            self.viewControllers![3].tabBarItem.badgeValue = "\(UIApplication.shared.applicationIconBadgeNumber)"
        }
    }
}

// MARK: TabbarController Delegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController)
        let alertController: UIAlertController = UIAlertController(title: "로그인이 필요합니다",
                                                                   message: "",
                                                                   preferredStyle: UIAlertControllerStyle.alert)
        let LoginAlertAction: UIAlertAction = UIAlertAction(title: "OK",
                                                            style: UIAlertActionStyle.default){ (alert) in
                                                                let LoginVC = UIStoryboard(name: "Master", bundle: nil).instantiateViewController(withIdentifier: "SelectLoginViewController") as! SelectLoginViewController
                                                                self.present(LoginVC, animated: true, completion: nil)
        }
        let cancelAlertAction: UIAlertAction = UIAlertAction(title: "CANCEL💦",
                                                             style: UIAlertActionStyle.default,
                                                             handler: nil)
        alertController.addAction(LoginAlertAction)
        alertController.addAction(cancelAlertAction)
        
        // 로그인이 되어있느냐 안되어 있느냐에 따른 분기처리
        switch viewController {
        case is MainNavigationViewController:
            print("Main 페이지 아잉")
            return true
        // SearchViewController 부분
        case is MyPageViewController:
            print("마이 페이지 아잉")
            return true
        case is UINavigationController:
            if AppDelegate.instance?.token != nil {
                return true
            }else {
                present(alertController, animated: true, completion: nil)
                return false
            }
        // Post ViewControlelr 부분
        case is PostViewController:
            if AppDelegate.instance?.token != nil {
                let nextVC = PostViewController()
                let nextNavigationView = UINavigationController(rootViewController: nextVC)
                present(nextNavigationView, animated: true, completion: nil)
                return false
            }else {
                present(alertController, animated: true, completion: nil)
                return false
            }
        // Notification ViewController
        case is NotificationViewController:
            if AppDelegate.instance?.token != nil {
                return true
            }else {
                present(alertController, animated: true, completion: nil)
                return false
            }
        default:
            print("여기에 올일이 없어요~!, 무슨 viewController 일때 오는거야?\(viewController)")
        }
        return true
    }
    
}


