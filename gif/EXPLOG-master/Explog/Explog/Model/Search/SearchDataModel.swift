//
//  SearchDataModel.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 30..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire


// MARK: Search API
extension Network {
    
    struct SearchService {
        typealias Completion<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        
        // MARK: Search API
        static func search(targetTitleWord word: String, nextPageURL: String? = nil ,token: String, completion: @escaping Completion<MainDataModel>) {
            let parameters: Parameters = ["word": word]
            let header = ["Authorization":"Token " + token]
            let url: String!
            if nextPageURL == nil {
                url = ServiceType.SearchBot.search.routing
            }else {
                url = nextPageURL
            }
            
            Alamofire.request(url,
                              method: .post,
                              parameters: parameters,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // Search API 요청이 성공한 경우
                                if statusCode == 200 {
                                    print("Search API 요청이 성공 했습니다.")
                                    do {
                                        let searchData = try JSONDecoder().decode(MainDataModel.self, from: response.data!)
                                        completion(true, searchData)
                                    }catch {
                                        completion(false, nil)
                                    }
                                    // Search API 요청이 실패한 경우
                                }else {
                                    print("Search API 요청이 실패 했습니다.")
                                    completion(false, nil)
                                }
            }
        }
    }
}
