//
//  UserDataModel.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 24..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire

// MARK: UserDataModel
struct UserDataModel: Codable {
    var pk: Int
    var username: String
    var email: String
    var imgProfile: String?
    
    var followingnumber: Int
    var followernumber: Int
    var followingUsers: [followingDataModel]
    var followers: [followerDataModel]
    
    var posts: [UserPosts]
    
    // enum naming 을 CodingKeys 라고 명명 해야 동착함.
    enum CodingKeys: String, CodingKey {
        case pk
        case username
        case email
        case imgProfile = "img_profile"
        case followingnumber = "following_number"
        case followernumber = "follower_number"
        case followingUsers = "following_users"
        case followers
        case posts
        
    }
}

// followingDataModel 나중에 사용해서 써먹자
struct followingDataModel: Codable {
    var pk: Int
    var email: String
    var imgProfile: String
    var username: String
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case pk
        case email
        case username
        case imgProfile = "img_profile"
        case token
    }
}

// followingDataModel 나중에 써먹자!
struct followerDataModel: Codable {
    var pk: Int
    var email: String
    var imgProfile: String
    var username: String
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case pk
        case email
        case username
        case imgProfile = "img_profile"
        case token
    }
}

// Main 의 Post Codable 을 사용하지 않은 이유는, author 부분때문임. 해당 부분이 Category Post 랑 다르게 응답이 옴.
// author 이 아직은 어떻게 쓰이는지 정확하지 모르겠음.
struct UserPosts: Codable {
    var pk: Int
    var author: Int
    var title: String
    var startDate: String
    var endDate: String
    var continent: String
    var img: String?
    var liked: [Int]
    var numLiked: Int
    
    enum CodingKeys: String, CodingKey {
        case pk
        case author
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case continent
        case img
        case liked
        case numLiked = "num_liked"
    }
}

// MARK: Follower, Following Data Model
struct followerAndFollowingDataModel: Codable {
    var fromUser: Int?
    var toUser: Int?
    var unfollowing: Int?
    
    enum CodingKeys: String, CodingKey {
        case fromUser = "from_user"
        case toUser = "to_user"
        case unfollowing
    }
}

// MARK: UpdateUserDataModel -> Change UserName, UserProfile Image
struct UpdateUserDataModel: Codable {
    var username: String
    var imgProfile: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case imgProfile = "img_profile"
    }
}

// MARK: Change UserPassword
struct UpdateUserPasswordModel: Codable {
    var success: String?
    var detail: String?
    var newPassword: String?
    var oldPassword: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case detail
        case newPassword = "new_password"
        case oldPassword = "old_password"
    }
}

// MARK: FollwoingFedd Data Model
struct FollowingFeedDataModel: Codable {
    var followingPosts: [Posts]
    
    enum CodingKeys: String, CodingKey {
        case followingPosts = "following_posts"
    }
}

// MARK: User API
extension Network {
    struct User {
        typealias Complection<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        
        // MARK: User Profile API
        static func profile(userToken: String?, otherUser pk:Int? = nil, completion: @escaping Complection<UserDataModel>) {
            guard let token = userToken, userToken != nil else {return}
            let header = ["Authorization":"Token " + token]
            Alamofire.request(ServiceType.User.profile(pk).routing,
                              method: .get,
                              headers: header).responseJSON { (response) in
                                
                                
                                if response.response?.statusCode == 200 {
                                    print("유저 프로파일 데이터 로드 성공!")
                                    do {
                                        let profileModel = try JSONDecoder().decode(UserDataModel.self, from: response.data!)
                                        print("유저 프로파일 데이터 성공적으로 변환!")
                                        completion(true, profileModel)
                                    }catch {
                                        print("유저 프로파일 데이터 네트워크 문제로 변환실패 ㅠㅠ")
                                        completion(false, nil)
                                    }
                                }
            }
        }
        
        // MARK: Follower & Following API
        static func followerAndFollowing(targetUser privateKey: Int, completion: @escaping Complection<followerAndFollowingDataModel>) {
            guard let token = AppDelegate.instance?.token, AppDelegate.instance?.token != nil else {return}
            let header = ["Authorization":"Token " + token]
            let parameters: Parameters = ["to_user": privateKey]
            Alamofire.request(ServiceType.User.followerAndFollowing.routing,
                              method: .post,
                              parameters: parameters,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 팔로우 팔로잉 API 성공 한 경우
                                if statusCode == 200 {
                                    print("followerAndFollowing API 요청이 성공 했습니다!")
                                    do {
                                        let followerData = try JSONDecoder().decode(followerAndFollowingDataModel.self, from: response.data!)
                                        print("팔로우 팔로잉 데이터 변환 성공!")
                                        completion(true, followerData)
                                    }catch {
                                        print("팔로우 팔로잉 데이터 변환 성공!")
                                        completion(false, nil)
                                    }
                                    // 팔로우 팔로잉 API 실패 한 경우
                                }else {
                                    print("followerAndFollowing API 요청이 실패 했습니다! ㅠ_ㅠ")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: FollowingFeed API 
        static func followingFeed(userToken: String, completion: @escaping Complection<FollowingFeedDataModel>) {
            let header = ["Authorization":"Token " + userToken]
            Alamofire.request(ServiceType.User.followingFeed.routing,
                              method: .get,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 팔로우 팔로잉 API 성공 한 경우
                                if statusCode == 200 {
                                    print("followerAndFollowing API 요청이 성공 했습니다!")
                                    do {
                                        let followerData = try JSONDecoder().decode(FollowingFeedDataModel.self, from: response.data!)
                                        print("팔로우 로잉 데이터 변환 성공!")
                                        completion(true, followerData)
                                    }catch {
                                        print("팔로우 팔로잉 데이터 변환 성공!")
                                        completion(false, nil)
                                    }
                                    // 팔로우 팔로잉 API 실패 한 경우
                                }else {
                                    print("followerAndFollowing API 요청이 실패 했습니다! ㅠ_ㅠ")
                                    completion(false, nil)
                                }
            }
        }
    }
}


