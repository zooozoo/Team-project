//
//  File.swift
//  Explog
//
//  Created by MIN JUN JU on 2018. 1. 3..
//  Copyright © 2018년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire

extension Network {
    struct UpdatePostContents {
        typealias Completion = (_ isSuccess: Bool) -> Void
        
        // MARK: Modify Text -> type Basic, Highlight
        static func text(textPk: Int, content: String, type: String, completion: @escaping Completion) {
            guard let token = AppDelegate.instance?.token else {return}
            let parameters: Parameters =  ["content": content,
                                           "created_at": Time.todayDate,
                                           "type": type]
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.updatePostText(textPk).routing,
                              method: .patch,
                              parameters: parameters,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 데이터 전달 성공
                                if statusCode == 200 {
                                    completion(true)
                                    // 데이터 전달 실패
                                }else {
                                    completion(false)
                                }
            }
        }
        
        // MARK: Modify Photo
        
        static func photo(photoPk: Int, photo: URL?, completion: @escaping Completion) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            // image니까 multipartform Data 사용해야함..
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                // image는 multipartform Data 로 따로 보냄
                if let imagePath = photo?.path,
                    let image = UIImage(contentsOfFile: imagePath),
                    let multipartImage = UIImageJPEGRepresentation(image, 0.5) {
                    let photoUUID: String = UUID().uuidString
                    let imgfileName: String = photoUUID + "\(photo!)" + ".png"
                    multipartFormData.append(multipartImage,
                                             withName: "photo",
                                             fileName: imgfileName,
                                             mimeType: "image/png")
                }
            }, to: ServiceType.Post.updatePostPhoto(photoPk).routing,
               method: .patch, headers: header
                ,encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let statusCode = response.response?.statusCode {
                                // Network 통신 성공한경우
                                if statusCode == 200 {
                                    print("Creat Photo API 성공")
                                    completion(true)
                                    // Network 통신이 실패한경우..!
                                }else {
                                    print("Creat Post API 실패..! \(String(describing: response.response?.statusCode))")
                                    completion(false)
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print("encodingError is \(encodingError)")
                    }
            })
        }
    }
}


