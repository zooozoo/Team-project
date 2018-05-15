//
//  MainDataModel.swift
//  Explog
//
//  Created by JU MIN JUN on 2017. 12. 12..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Main Category Codable 로 데이터 모델 구현
struct MainDataModel: Codable {
    var posts: [Posts]
    var previous: String?
    var next: String?
}

struct Posts: Codable {
    var pk: Int
    var author: Author
    var title: String
    var startDate: String
    var endDate: String
    var continent: String
    var img: String
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

struct Author: Codable {
    var pk: Int
    var username: String
    var email: String
    var imgProfile: String
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case pk
        case username
        case email
        case imgProfile = "img_profile"
        case token
    }
}

// MARK: Main Category 부분 Network Service
extension Network {
    struct Main {
        typealias Completion<DataModel> = (_ data: DataModel) -> Void
        
        // MARK: Main Category 호출 API
        static func category(tagNum: Int, completion: @escaping Completion<MainDataModel>){
            print(tagNum)
            Alamofire.request(ServiceType.Main.category(tagNum).routing, method: .get).responseJSON { (response) in
                // Main 에 데이터가 없으면 바로 error 을 뱉음..
                if response.response?.statusCode == 200 {
                    print("서버에 요청한 데이터 성공!")
                    do {
                        let mainModel = try JSONDecoder().decode(MainDataModel.self, from: response.data!)
                        completion(mainModel)
                    }catch {
                        print("Main Category 데이터 변환하다가 Error... ㅠㅠ")
                    }
                }else {
                    print("category 서버에러.....!!!!")
                }
            }
        }
        
        // MARK: Main Next Step 호출 API
        static func nextPage(stringURL nextURL: String, completion: @escaping Completion<MainDataModel>) {
            Alamofire.request(nextURL, method: .get).responseJSON { (response) in
                // Main 에 데이터가 없으면 바로 error 을 뱉음..
                if response.response?.statusCode == 200 {
                    print("서버에 요청한 Next 데이터 성공!")
                    do {
                        let mainModel = try JSONDecoder().decode(MainDataModel.self, from: response.data!)
                        let tempData = mainModel 
                        completion(tempData)
                    }catch {
                        print("Next Step page 오류...!")
                    }
                }else {
                    print("Next Stop 서버에러.....!!!!")
                }
            }
        }
        
        // MARK: Main previous Step 호출 API
        static func previousPage(stringURL nextURL: String, completion: @escaping Completion<MainDataModel>) {
            Alamofire.request(nextURL, method: .get).responseJSON { (response) in
                // Main 에 데이터가 없으면 바로 error 을 뱉음..
                if response.response?.statusCode == 200 {
                    print("서버에 요청한 Next 데이터 성공!")
                    do {
                        let mainModel = try JSONDecoder().decode(MainDataModel.self, from: response.data!)
                        let tempData = mainModel 
                        completion(tempData)
                    }catch {
                        print("Next Step page 오류...!")
                    }
                }else {
                    print("Next Stop 서버에러.....!!!!")
                }
            }
        }
    } 
}




