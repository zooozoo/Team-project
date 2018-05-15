//
//  UpdatePostDataModel.swift
//  Explog
//
//  Created by MIN JUN JU on 2018. 1. 3..
//  Copyright © 2018년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire
struct UpdatePostCoverModel: Codable {
    var pk: Int
    var author: Int
    var title: String?
    var startDate: String?
    var endDate: String?
    var img:String?
    var continent: String?
    
    enum CodingKeys: String, CodingKey {
        case pk
        case author
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case img
        case continent
        
    }
}


extension Network {
    struct UpdatePostCover {
        typealias Complection<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        static func updatePostCover(postPk: Int,
                                    title: String,
                                    startDate: String,
                                    endDate: String,
                                    continent: String,
                                    titleImg: URL?,
                                    completion: @escaping Complection<UpdatePostCoverModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let parameters: Parameters =  ["title": title,
                                           "start_date": startDate,
                                           "end_date": endDate ,
                                           "continent": continent]
            let header = ["Authorization":"Token " + token]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                // image는 multipartform Data 로 따로 보냄
                if titleImg != nil {
                    if let imagePath = titleImg?.path,
                        let image = UIImage(contentsOfFile: imagePath),
                        let multipartImage = UIImageJPEGRepresentation(image, 0.5) {
                        let photoUUID: String = UUID().uuidString
                        let imgFileName: String = photoUUID + "\(titleImg!)" + ".png"
                        multipartFormData.append(multipartImage,
                                                 withName: "img",
                                                 fileName: imgFileName,
                                                 mimeType: "image/png")
                    }
                }
                for (key, value) in parameters {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!,
                                             withName: key)
                }
            }, to: ServiceType.Post.updatePostCover(postPk).routing,
               method: .patch, headers: header
                ,encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let statusCode = response.response?.statusCode {
                                // Network 통신 성공한경우
                                if statusCode == 200 {
                                    print("Update Post API 성공")
                                    do {
                                        let creatPostData = try JSONDecoder().decode(UpdatePostCoverModel.self, from: response.data!)
                                        completion(true, creatPostData)
                                    }catch {
                                        print("Update Post Data 변환 실패 ㅠ_ㅠ")
                                    }
                                    // Network 통신이 실패한경우..!
                                }else {
                                    print("Update Post API 실패..! \(String(describing: response.response?.statusCode))")
                                    completion(false, nil)
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


