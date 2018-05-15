//
//  PostCreateModel.swift
//  TestPost
//
//  Created by 주민준 on 2017. 12. 12..
//  Copyright © 2017년 주민준 All rights reserved.
//

import Foundation
import Alamofire

// MARK: Post표지 Model
struct PostDataModel: Codable {
    var pk: Int
    var author: Author
    var title: String?
    var startDate: String?
    var endDate: String?
    var img: String?
    var continent: String
    var liked: [Int]
    var numLiked: Int
    
    enum CodingKeys: String, CodingKey {
        case pk
        case author
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case img
        case continent
        case liked
        case numLiked = "num_liked"
    }
}

// MARK: PostCreatText API Model
struct PostCreatTextModel: Codable {
    var pk: Int
    var contents: Contents
    
    enum CodingKeys: String, CodingKey {
        case pk
        case contents = "content"
    }
}
struct Contents: Codable {
    var pk: Int
    var content: String
    var createdAt: String?
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case pk
        case content
        case createdAt = "created_at"
        case type
    }
}

// MARK: PostCreatPhoto API Model
struct PostCreatPhotoModel:Codable {
    var pk: Int
    var contents: PhotoContents
    
    enum CodingKeys: String, CodingKey {
        case pk
        case contents = "content"
    }
}

struct PhotoContents: Codable {
    var pk: Int
    var photo: String
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case pk
        case photo
        case createdAt = "created_at"
    }
}

// MARK: PostDetail API Model
struct PostDetailModel: Codable {
    var postContents: [PostdetailContents]?
    
    enum CodingKeys: String, CodingKey {
        case postContents = "post_content"
    }
}

struct PostdetailContents: Codable {
    var post: Int
    var order: Int
    var contentType: String
    var contents: PostContentsType
    
    enum CodingKeys: String, CodingKey {
        case post
        case order
        case contentType = "content_type"
        case contents = "content"
    }
}

struct PostContentsType:Codable {
    var pk: Int
    var content: String?
    var photo: String?
    var createdAt: String?
    var type: String?
    var postContentPk: Int
    
    enum CodingKeys: String, CodingKey {
        case pk
        case content
        case photo
        case createdAt = "created_at"
        case type
        case postContentPk = "post_content"
    }
}

// MARK: Like API Model
struct PostLikeModel: Codable {
    var liked: [Int]?
    var numLiked: Int?
    
    enum CodingKeys: String,CodingKey {
        case liked
        case numLiked = "num_liked"
    }
}

// MARK: Reply API Model
struct PostReplyModel: Codable {
    
    // author 부분 수정 필요함. 현재는 숫자만 날라오는데, 해당 숫자만 가지고 할수 있는게 없음
    //var author: Author
    var pk: Int
    var post: Int
    var content: String
    var author: Author?
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        //case author
        case pk
        case post 
        case content
        case author
        case createdAt = "created_at"
    }
}

// Reply API
struct PostCreatReplyModel: Codable {
    var pk: Int
    var author: Author?
    var content: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case pk
        case author
        case content
        case createdAt = "created_at"
    }
}

// MARK: Creat Post API
extension Network {
    struct Post {
        typealias Complection<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        
        // MARK: Creat Post Cover API
        static func creatPost(title: String,
                              startDate: String,
                              endDate: String,
                              continent: String,
                              titleImg: URL?,
                              completion: @escaping Complection<PostDataModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let parameters: Parameters = ["title": title,
                                          "start_date": startDate,
                                          "end_date": endDate ,
                                          "continent": continent]
            let header = ["Authorization":"Token " + token]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                // image는 multipartform Data 로 따로 보냄
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
                for (key, value) in parameters {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!,
                                             withName: key)
                }
            }, to: ServiceType.Post.creat.routing,
               method: .post, headers: header
                ,encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let statusCode = response.response?.statusCode {
                                // Network 통신 성공한경우
                                if statusCode == 201 {
                                    print("Creat Post API 성공")
                                    do {
                                        let creatPostData = try JSONDecoder().decode(PostDataModel.self, from: response.data!)
                                        completion(true, creatPostData)
                                    }catch {
                                        print("Creat Post Data 변환 실패 ㅠ_ㅠ")
                                    }
                                    // Network 통신이 실패한경우..!
                                }else {
                                    print("Creat Post API 실패..! \(String(describing: response.response?.statusCode))")
                                    completion(false, nil)
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print("encodingError is \(encodingError)")
                    }
            })
        }
        
        // MARK: TextCreat API
        static func textCreat(postPk:Int, contents: String, type: String,  completion: @escaping Complection<PostCreatTextModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let parameters: Parameters = ["content": contents,
                                          "created_at": Time.todayDate,
                                          "type": type]
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.textCreat(postPk).routing,
                              method: .post,
                              parameters: parameters,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 데이터 전달 성공
                                if statusCode == 201 {
                                    do {
                                        let data = try JSONDecoder().decode(PostCreatTextModel.self, from: response.data!)
                                        completion(true, data)
                                    }catch {
                                        print("Post Creat Text Model 변환 실패!")
                                        completion(false, nil)
                                    }
                                    // 데이터 전달 실패
                                }else {
                                }
            }
        }
        
        // MARK: PhotoCrat API
        static func PhotoCreat(postPk: Int, photo: URL?, completion: @escaping Complection<PostCreatPhotoModel>) {
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
            }, to: ServiceType.Post.PhotoCreat(postPk).routing,
               method: .post, headers: header
                ,encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let statusCode = response.response?.statusCode {
                                // Network 통신 성공한경우
                                if statusCode == 201 {
                                    print("Creat Photo API 성공")
                                    do {
                                        let creatPostData = try JSONDecoder().decode(PostCreatPhotoModel.self, from: response.data!)
                                        completion(true, creatPostData)
                                    }catch {
                                        print("Creat Post Data 변환 실패 ㅠ_ㅠ")
                                    }
                                    // Network 통신이 실패한경우..!
                                }else {
                                    print("Creat Post API 실패..! \(String(describing: response.response?.statusCode))")
                                    completion(false, nil)
                                }
                            }
                        }
                    case .failure(let encodingError):
                        print("encodingError is \(encodingError)")
                    }
            })
        }
        
        // MARK: PostDetail API
        static func detail(_ postPk: Int, completion: @escaping Complection<PostDetailModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.detail(postPk).routing,
                              method: .get,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 요청이 성공한 경우
                                if statusCode == 200 {
                                    do {
                                        let detailPostData = try JSONDecoder().decode(PostDetailModel.self, from: response.data!)
                                        completion(true, detailPostData)
                                        print("Post Detail API 자료변환이 성공 하였습니다.")
                                    }catch {
                                        print("""
                                            PostDetail API 자료 변환이 실패 하였습니다.
                                            statusCode is \(String(describing: response.response?.statusCode))
                                            url is \(String(describing: response.response?.url))
                                            """)
                                        completion(false, nil)
                                    }
                                    // 요청이 실패한 경우
                                }else {
                                    
                                    print("Post Detail 요청이 실패했습니다-> StatusCode is \(String(describing: response.response?.statusCode))")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: Post Like API
        static func like(postPk: Int, completion: @escaping Complection<PostLikeModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.like(postPk).routing,
                              method: .post,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 요청이 성공한 경우
                                if statusCode == 200 {
                                    print("좋아요 API 요청이 성공했습니다!")
                                    do {
                                        let likeList = try JSONDecoder().decode(PostLikeModel.self,from: response.data!)
                                        completion(true, likeList)
                                        print("like Data API 변환에 성공했습니다!")
                                    }catch {
                                        print("like Data API 변환에 실패 했습니다..ㅠ.ㅠ했습니다!")
                                        completion(false , nil)
                                    }
                                    // 요청이 실패한경우
                                }else {
                                    print("좋아요 API 요청이 실패했습니다!")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: Post Reply API
        static func reply(postPk: Int, completion: @escaping Complection<[PostReplyModel]>) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            
            Alamofire.request(ServiceType.Post.reply(postPk).routing,
                              method: .get,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 요청이 성공한 경우
                                if statusCode == 200 {
                                    print("Reply API 요청이 성공했습니다!")
                                    do {
                                        let replyList = try JSONDecoder().decode([PostReplyModel].self,from: response.data!)
                                        completion(true, replyList)
                                        print("Reply Data API 변환에 성공했습니다!")
                                    }catch {
                                        print("Reply Data API 변환에 실패 했습니다..ㅠ.ㅠ했습니다!")
                                        completion(false , nil)
                                    }
                                    // 요청이 실패한경우
                                }else {
                                    print("Reply API 요청이 실패했습니다!")
                                    completion(false, nil)
                                }
            }
        }
        
        // MARK: Post Reply Creat API
        static func creatReply(postPk: Int, comments: String, completion: @escaping Complection<PostReplyModel>) {
            guard let token = AppDelegate.instance?.token else {return}
            let header = ["Authorization":"Token " + token]
            let parameters: Parameters = ["content": comments]
            
            Alamofire.request(ServiceType.Post.creatReply(postPk).routing,
                              method: .post,
                              parameters: parameters,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 요청이 성공한 경우
                                if statusCode == 201 {
                                    print("Creat Reply API 요청이 성공했습니다!")
                                    do {
                                        let reply = try JSONDecoder().decode(PostReplyModel.self,from: response.data!)
                                        completion(true, reply)
                                        print("Creat Reply Data API 변환에 성공했습니다!")
                                    }catch {
                                        print("Creat Reply Data API 변환에 실패 했습니다..ㅠ.ㅠ했습니다!")
                                        completion(false , nil)
                                    }
                                    // 요청이 실패한경우
                                }else {
                                    print("Creat Reply API 요청이 실패했습니다!")
                                    completion(false, nil)
                                }
            }
        }
    }
}

