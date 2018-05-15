//
//  PostDeleteModel.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 31..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire


struct DeletePostModel: Codable {
    var detail: String
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
}


extension Network {
    struct Delete {
        typealias Complection<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        
        // MARK: Delete Post -> Post 커서 자체를 삭제함.
        static func post(postPk: Int, completion: @escaping Complection<DeletePostModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.delete(postPk).routing,
                              method: .delete,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 요청이 성공한 경우
                                if statusCode == 204 {
                                    print("UserPostData 삭제 성공!")
                                    completion(true, nil)
                                }else {
                                    print("UserPostData 삭제 실패 ㅠ_ㅠ")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: Delete Reply -> 리플 각각 하나를 삭제함.
        static func reply(replyPk: Int, completion: @escaping Complection<DeletePostModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.delteReply(replyPk).routing,
                              method: .delete,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 요청이 성공한 경우
                                if statusCode == 204 {
                                    print("UserPostData 삭제 성공!")
                                    completion(true, nil)
                                }else {
                                    print("UserPostData 삭제 실패 ㅠ_ㅠ")
                                    completion(false, nil)
                                }
            }
        }
    }
}
