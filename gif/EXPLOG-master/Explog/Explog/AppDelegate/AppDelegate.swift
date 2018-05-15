//
//  AppDelegate.swift
//  ExplogFB
//
//  Created by JU MIN JUN on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK : AppDelegate 인스턴스 변수
    // 아래처럼 사용한 이유, 새롭게 AppDelegate() 를 만들지 않고, 기존에 가지고 있떤 프로퍼티를 이용해서 사용
    var token: String?
    var userPK: Int?
    var deviceToken: String?
    static var instance : AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // window 활용한 처음 Splash 화면 띄우기
        // 유저에게 noti를 사용할건데 허용할것인가 권한 요청 해주어야함
        
        requesetNotiFication()
        // badgeNumber 을 컨트롤 하는 함수.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        self.window = window
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.7
        NetworkActivityIndicatorManager.shared.completionDelay = 0.2


        return true
    }
    
//    //APP 이 켜질때 마다 어떤 Action 을 해주기 위해서 실행해줌, 현재는 APP의 Badge Number 를 초기화 해주는 역활을함.
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("APP 꺼짐!, APPBadgeNumber가 변경 되기전")
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
    
    private func requesetNotiFication() {
        // UN은 User Notification 의 약자
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, .sound, .badge]) { (grant, error) in // 유저가 허용했느냐 안했느냐는 bool 값, error 값을 error 으로
            print("grant is \(grant), error is \(String(describing: error))")
            
            //유저가 grant에 true 가 들어오면, 디바이스 토큰을 받기위해서, 서버에서 token 을 요청 해주어야함.
            DispatchQueue.main.async {
                // 아래의 녀석은 DisPatchQueue Main 에서 실행을 시켜주어야 함. 이유는 얼마전에 생긴 thread Checker 이라는 녀석이 체크해서 알려줌.
                UIApplication.shared.registerForRemoteNotifications()
            }
            // app 이 동작중일때 noti를 받기 위해서 사용함
            UNUserNotificationCenter.current().delegate = self
            
            // notiAction 은 사용자의 인터렉션을 받을수 있는 action임
            // 아래에 action button 을 넣어서 어떤 로직을 추가 해줄수 있음.
            let action = UNNotificationAction(identifier: "action",
                                              title: "확인",
                                              options: .destructive)
            let action2 = UNTextInputNotificationAction(identifier: "action2",
                                                        title: "텍스트전송",
                                                        options: UNNotificationActionOptions.foreground)
            let category = UNNotificationCategory(identifier: "category1",
                                                  actions: [action,action2],
                                                  intentIdentifiers: [],
                                                  options: [.customDismissAction])
            // 여러개의 category 들을 넣을수 있는데, 우리는 한가지만 카테고리 안에 넣어서 실습해봄.
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
    }
    
    // 알람 수신을 허용했을때, 디바이스 토큰을 보내주는 메소드!
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { (data) -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        
        AppDelegate.instance?.deviceToken = token
        print("Device token is \(token) 값을 저장 했습니다.")
        
        
    }
    
    //     토큰을 받지 못했을때, 아래의 메소드가 호출됨, 제대로 받지 못했을때, 어떤 액션을 취해줄것인지에 대한것을 이부분에서 적용함,
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("token 을 받지 못함 ㅠㅠ error 송출\(error)")
    }
    
    func presentToMain() {}
    
    
    
    // APP 이 BACKGROUND 상태일때, 어떤 명령을 내릴수 있는 함수..
    // Pay Load  Key에 "aps" {"conten 1t-available":"1"{ 포함 시켜서, 실행 시킬수있음.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("""
            ------------------------------fetch 실행------------------------------
            userInfo is \(userInfo)
            fetchCompletion \(completionHandler)
            print Badge Number \(UIApplication.shared.applicationIconBadgeNumber)
            ---------------------------------------------------------------------
            """)
        // APP Badge Number 업데이트 -> badgeNumber를, PushNotification Value 로 처리하지않음.
        let badgeNumber: Int = (userInfo["aps"] as! [String:Any])["badge"] as! Int
        UIApplication.shared.applicationIconBadgeNumber += badgeNumber
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // APP 이 Active 상태일때 호출됨.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        
        
        print("app이 실행중일때 실행됨.")
        let swiftTypeUserInfo = notification.request.content.userInfo as! [String:Any]
        
        
        NotificationCenter.default.post(name: NSNotification.Name.init("pushNotification"),
                                        object: swiftTypeUserInfo ,
                                        userInfo: nil)
        
        print("PushNotification 발송! \(swiftTypeUserInfo)")
    }
    
    // APP 이 BackGround 이후, Noti 를 터치하면, 해당 Noti 에 대한 정보를 읽어옴..
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("""
            Noti를 누르고 들어왔을때, 실행.
            center is \(center)
            responser is \(response.notification.request.content)
            """)
    }
}
