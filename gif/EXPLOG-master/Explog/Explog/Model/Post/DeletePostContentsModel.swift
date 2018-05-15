//
//  DeletePostContents.swift
//  Explog
//
//  Created by MIN JUN JU on 2018. 1. 3..
//  Copyright © 2018년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire

extension Network {
    struct DeletePostContents {
        typealias Completion = (_ isSuccess: Bool) -> Void
        
        // MARK: Delete PostContents
        static func contentsInPost(postContentsPk: Int, completion: @escaping Completion) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.deletePostContents(postContentsPk).routing,
                              method: .delete,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                
                                // 요청이 성공한 경우
                                if statusCode == 204 {
                                    print("basicText 삭제 성공!")
                                    completion(true)
                                }else {
                                    print("basicText 삭제 실패 ㅠ_ㅠ")
                                    completion(false)
                                }
            }
        }
    }
}
