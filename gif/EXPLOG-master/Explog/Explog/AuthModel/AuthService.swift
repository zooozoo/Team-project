//
//  AuthService.swift
//  ExplogFB
//
//  Created by 주민준 on 2017. 11. 29..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation
import Alamofire

// MARK: LoginDataModel Set
struct LoginDataModel: Codable {
    var pk: Int
    var username: String
    var email: String
    var imgProfile: String
    var token: String
    var apnsdeviceSet: [DeviceTokenDataModel]?
    
    enum CodingKeys: String, CodingKey {
        case pk
        case username
        case email
        case imgProfile = "img_profile"
        case token
        case apnsdeviceSet = "apnsdevice_set"
    }
}

struct DeviceTokenDataModel: Codable {
    var deviceToken: String?
    enum CodingKeys: String, CodingKey {
        case deviceToken = "registration_id"
    }
}

// MARK: Error Message DataModel 
struct ErrorMessageDataModel: Codable {
    var username: String?
    var email: String?
    var message: String?
}
// Network 라는 keyword 로 각 Network 하는 부분들을 묶어서 사용하자
struct Network {}
extension Network {
    // MARK: 인증 서비스 관리
    struct AuthService  {
        typealias Completion = (_ success: Bool, _ data: LoginDataModel?,_ error: ErrorMessageDataModel?) -> ()
        typealias CompletionForMain = (Any) -> Void
        
        // MARK: Login func
        static func login(email: String, password: String, completion: @escaping Completion){
            let parameters : Parameters!
            if AppDelegate.instance?.deviceToken != nil {
                parameters = [
                    "email": email,
                    "password": password,
                    "device-token": AppDelegate.instance!.deviceToken!
                ]
            }else {
                parameters = [
                    "email": email,
                    "password": password,
                ]
            }
            print("parameter is \(parameters)")
            Alamofire.request(ServiceType.login.routing, method: .post, parameters: parameters).responseJSON { (response) in
                print(response)
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    do {
                        let loginData: LoginDataModel = try JSONDecoder().decode(LoginDataModel.self, from: response.data!)
                        completion(true, loginData, nil)
                        print("loginData 변환 성공")
                    }catch {
                        completion(false, nil, nil)
                        print("loginData 변환 실패ㅠ_ㅠ")
                    }
                }else {
                    do {
                        let errorData: ErrorMessageDataModel = try JSONDecoder().decode(ErrorMessageDataModel.self, from: response.data!)
                        completion(false, nil, errorData)
                        print("Login errorData 변환성공!")
                    }catch {
                        print("Login errorData 변환실패!")
                        completion(false, nil, nil)
                    }
                }
            }
        }
        
        // MARK: SignUp func
        static func signup(email: String, password: String, username: String, imgprofile: URL?, completion: @escaping Completion){
            
            var parameters : Parameters!
            if AppDelegate.instance?.deviceToken != nil {
                parameters = [
                "password": password,
                "img_profile": imgprofile,
                "email": email,
                "username": username,
                "device-token": AppDelegate.instance!.deviceToken!
                ]
            }else {
                parameters  = [
                "password": password,
                "img_profile": imgprofile,
                "email": email,
                "username": username
                ]
            }
            print("parameter is \(parameters)")
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if imgprofile?.path == nil {
                    // 이미지를 선택하지 않은경우.
                    multipartFormData.append(String("").data(using: .utf8)!,
                                             withName: "img_profile")
                    parameters = [
                        "password" : password,
                        "email" : email,
                        "username" : username]
                }else {
                    if let imagePath = imgprofile?.path,
                        let image = UIImage(contentsOfFile: imagePath),
                        let multipartImage = UIImageJPEGRepresentation(image, 0.5) {
                        let photoUUID: String = UUID().uuidString
                        let imgFileName: String = photoUUID + "\(imgprofile!)" + ".png"
                        multipartFormData.append(multipartImage,
                                                 withName: "img_profile",
                                                 fileName: imgFileName,
                                                 mimeType: "image/png")
                    }
                }
                for (key, value) in parameters {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!,
                                             withName: key)
                }
            }, to: ServiceType.signup.routing, method: .post
                ,encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            let statusCode = response.response?.statusCode
                            
                            
                                if statusCode == 200 {
                                    do {
                                        let signUpData: LoginDataModel = try JSONDecoder().decode(LoginDataModel.self, from: response.data!)
                                        completion(true, signUpData, nil)
                                        print("회원가입 데이터 변환에 성공했습니다\(signUpData)")
                                    }catch {
                                        completion(false, nil, nil )
                                        print("회원가입 데이터 변환에 실패 했습니다")
                                    }
                                }else {
                                    print("회원가입 API 오류 발생 ㅠㅠ")
                                    do {
                                        let errorData: ErrorMessageDataModel = try JSONDecoder().decode(ErrorMessageDataModel.self, from: response.data!)
                                        completion(false, nil, errorData)
                                        print("errorData 변환성공!")
                                        
                                    }catch {
                                        print("errorData 변환실패!")
                                        completion(false, nil, nil)
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
