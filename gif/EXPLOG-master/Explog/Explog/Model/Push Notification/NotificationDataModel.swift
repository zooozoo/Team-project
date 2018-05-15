

import Foundation
import Alamofire

// MARK: BadgeNumber Data Model
struct BadgeNumberDataModel: Codable {
    var user: String
    var badge: Int
}

// Noti List API Data Model
struct PushListDataModel: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [PickMyPostUserList]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}

struct PickMyPostUserList: Codable {
    var likedDate: String
    var author: NotiUser
    var posttitle: String
    
    enum CodingKeys: String, CodingKey {
        case likedDate = "liked_date"
        case author
        case posttitle = "post"
    }
}

struct NotiUser: Codable {
    var username: String
    var imgProfile: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case imgProfile = "img_profile"
    }
}

// MARK: Registe DeviceToken API



// MARK: Push Notification API
extension Network {
    struct PushNotification {
        typealias Completion<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        
        
        typealias CompletionForBadgeNumber = (_ isSuccess: Bool,_ data: BadgeNumberDataModel?) -> Void
        typealias CompletionForNotificationData = (_ isSuccess: Bool,_ data: PushListDataModel?) -> Void
        //typealias Completion = (_ isSuccess: Bool) -> Void
        
        // MARK: Reset BadgeNumber
        static func resetBadgeNumberInServer(completion: @escaping Completion<BadgeNumberDataModel>) {
            guard let token = AppDelegate.instance?.token, AppDelegate.instance?.token != nil else {return}
            let header = ["Authorization":"Token " + token]
            Alamofire.request(ServiceType.PushNotification.resetBadgeNumber.routing,
                              method: .get,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // BadgeNumber API 요청이 성공한 경우
                                if statusCode == 200 {
                                    print("BadgeNumber API 요청이 성공했습니다")
                                    do {
                                        let badgeNumberModel = try JSONDecoder().decode(BadgeNumberDataModel.self, from: response.data!)
                                        completion(true, badgeNumberModel)
                                        print("BadgeNumber API 데이터 변환이 성공했습니다")
                                    }catch {
                                        completion(false, nil)
                                        print("BadgeNumber API 데이터 변환이 실패 했습니다")
                                    }
                                    // BadgeNumber API 요청이 실패한 경우
                                }else {
                                    print("BadgeNumber API 요청이 실패 했습니다")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: Notification Data List
        static func notificationDataList(nextURL: String? = nil, completion: @escaping Completion<PushListDataModel>) {
            guard let token = AppDelegate.instance?.token, AppDelegate.instance?.token != nil else {return}
            let header = ["Authorization":"Token " + token]
            let url: String!
            
            if nextURL == nil {
                url = ServiceType.PushNotification.pushList.routing
            }else {
                url = nextURL!
            }
            Alamofire.request(url,
                              method: .get,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // Notification Data List API 요청이 성공한 경우
                                if statusCode == 200 {
                                    print("Notification Data List API 요청이 성공했습니다")
                                    do {
                                        let notiUserList = try JSONDecoder().decode(PushListDataModel.self, from: response.data!)
                                        completion(true, notiUserList)
                                        print("Notification Data List API 데이터 변환이 성공했습니다")
                                    }catch {
                                        completion(false, nil)
                                        print("Notification Data List API 데이터 변환이 실패 했습니다")
                                    }
                                    // Search API 요청이 실패한 경우
                                }else {
                                    print("Notification Data List API 요청이 실패 했습니다")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: Registe Device Token API
        static func registeDeviceToken(deviceToken: String, completion: @escaping Completion<PushListDataModel>) {
            guard let token = AppDelegate.instance?.token, AppDelegate.instance?.token != nil else {return}
            let header = ["Authorization":"Token " + token]
            let parameters: Parameters = ["device-token": deviceToken]
            
            Alamofire.request(ServiceType.PushNotification.registerDeviceToken.routing,
                             method: .patch,
                             parameters: parameters,
                             headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode// Regester Device Token API 요청이 성공한 경우
                                if statusCode == 200 {
                                    print("device Token API 요청, 등록이 성공 했습니다!")
                                    completion(true, nil)
                                // Regester Device Token API 요청이 실패한 경우
                                }else {
                                    print("device Token API 요청, 등록이 실패 했습니다!")
                                    completion(false, nil)
                                }
            }
        }
    }
}
