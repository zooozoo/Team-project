//
//  NetworkInfo.swift
//  ExplogFB
//
//  Created by 주민준 on 2017. 11. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation

// baseURL : API 요청시, 기본 URL
let baseURL = "http://explog-shz.ap-northeast-2.elasticbeanstalk.com/"

// Login, Signup 부분 URL
// MARK: ServiceType
enum ServiceType: String{
    case login
    case signup
    
    //    case main
    var routing : String{
        switch self{
        case .login:
            return baseURL + "member/login/"
        case .signup:
            return baseURL + "member/signup/"
        }
    }
}

// Main 부분에 사용되는 Url 을 나누어 놓았습니다.
// ServiceType.Main
// MARK: category API 사용할때, 앞의 부분만 가져다 놓음.
extension ServiceType {
    enum Main {
        case category(Int)
        var routing: String {
            switch self {
            case .category(let continentNumber):
                return baseURL + "post/\(continentNumber)/list/"
            }
        }
    }
}

// MARK: Userprofile API URL
extension ServiceType {
    enum User {
        case profile(Int?)
        case followerAndFollowing
        case updateUserProfiledata
        case updateUserPassword
        case followingFeed
        
        var routing: String {
            switch self {
            case .profile(let userPk):
                if userPk == nil {
                    return baseURL + "member/userprofile/"
                }else {
                    return baseURL + "member/userprofile/\(userPk!)/"
                }
            case .followerAndFollowing:
                return baseURL + "member/following/"
            case .updateUserProfiledata:
                return baseURL + "member/userprofile/update/"
            case .updateUserPassword:
                return baseURL + "member/userpassword/update/"
            case .followingFeed:
                return baseURL + "post/follow/"
            }
        }
    }
}

// MARK: Post API URL
extension ServiceType {
    enum Post {
        case creat
        case textCreat(Int)
        case PhotoCreat(Int)
        case detail(Int)
        // Post 자체를 삭제 해주는 URL
        case delete(Int)
        
        // Post의 Contetns & Cover 를 수정 해주는 URL(Patch)
        case updatePostCover(Int)
        case updatePostText(Int)
        case updatePostPhoto(Int)
        
        // Post 의 contents를 삭제해주는 URL
        case deletePostContents(Int)
        
        case like(Int)
        case reply(Int)
        case delteReply(Int)
        case creatReply(Int)
        var routing: String {
            switch self {
            case .creat:
                return baseURL + "post/create/"
            case .textCreat(let postPk):
                return baseURL + "post/\(postPk)/text/"
            case .PhotoCreat(let postPk):
                return baseURL + "post/\(postPk)/photo/"
            case .detail(let postPk):
                return baseURL + "post/\(postPk)/"
            case .delete(let postPk):
                return baseURL + "post/\(postPk)/update/"
            case .updatePostCover(let postPk):
                return baseURL + "post/\(postPk)/update/"
            case .updatePostText(let textPk):
                return baseURL + "post/text/\(textPk)/"
            case .updatePostPhoto(let photoPk):
                return baseURL + "post/photo/\(photoPk)/"
            case .deletePostContents(let contentsPk):
                return baseURL + "post/content/\(contentsPk)/"
            case .like(let postPk):
                return baseURL + "post/\(postPk)/like/"
            case .reply(let postPk):
                return baseURL + "post/\(postPk)/reply/"
            case .delteReply(let replyPk):
                return baseURL + "post/reply/\(replyPk)/"
            case .creatReply(let postPk):
                return baseURL + "post/\(postPk)/reply/create/"
            
            }
        }
    }
}

// MARK: Search API URL
extension ServiceType {
    enum SearchBot {
        case search
        var routing: String {
            switch self {
            case .search:
                return baseURL + "post/search/"
            }
        }
    }
}

// MARK: Notification API URL
extension ServiceType {
    enum PushNotification {
        case resetBadgeNumber
        case pushList
        case registerDeviceToken
        var routing: String {
            switch self {
            case .resetBadgeNumber:
                return baseURL + "push/reset-badge/"
            case .pushList:
                return baseURL + "push/list/"
            case .registerDeviceToken:
                return baseURL + "push/device-token/"
            }
        }
    }
}
