import Foundation
import Alamofire

// MARK: Update UserProfile Data -> UserName, UserPassword
extension Network {
    struct UpdateUserProfile {
        typealias Complection<DataModel> = (_ isSuccess: Bool,_ data: DataModel?) -> Void
        
        //MARK: UpdateUserProfiledata
        static func userNameAndUserProfileImage(username: String? = nil, img imgURL: URL? = nil, completion: @escaping Complection<UpdateUserDataModel>)  {
            guard let token = AppDelegate.instance?.token, AppDelegate.instance?.token != nil else {return}
            let url = ServiceType.User.updateUserProfiledata.routing
            let header = ["Authorization":"Token " + token]
            var parameters : Parameters!
            
            // 일반 alamofire 데이터를 이용함. 그렇지 않을 경우에는 multipartformData 사용해야함..
            if username != nil {
                parameters = ["username" : username!]//, "img_profile": url]
                Alamofire.request(url,
                                  method: .patch,
                                  parameters: parameters,
                                  headers: header).responseJSON { (response) in
                                    let statusCode = response.response?.statusCode
                                    // 데이터 전달 성공
                                    if statusCode == 200 {
                                        print("Update UserProfile Data API 요청에 성공 했습니다")
                                        do {
                                            let updateUserData = try JSONDecoder().decode(UpdateUserDataModel.self, from: response.data!)
                                            completion(true, updateUserData)
                                            print("userData 변경에 성공했습니다!")
                                        }catch {
                                            print("userData 변경에 실패했습니다 ㅠㅠ 했습니다!")
                                            completion(false, nil)
                                        }
                                        // 데이터 전달 실패
                                    }else {
                                        print("Update UserProfile Data API 요청에 실패 했습니다")
                                        completion(false, nil)
                                    }
                }
                // image Update 부분.
            }else {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    // image는 multipartform Data 로 따로 보냄
                    if let imagePath = imgURL?.path,
                        let image = UIImage(contentsOfFile: imagePath),
                        let multipartImage = UIImageJPEGRepresentation(image, 0.5) {
                        multipartFormData.append(multipartImage,
                                                 withName: "img_profile",
                                                 fileName: "file.png",
                                                 mimeType: "image/png")
                    }
                }, to: url,
                   method: .patch, headers: header
                    ,encodingCompletion: {
                        encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                let statusCode = response.response?.statusCode
                                // API 요청이 성공한 경우 -> User Profiled Img 변경된것 적용
                                if statusCode == 200 {
                                    print("Update UserProfile Data API 요청에 성공 했습니다")
                                    do {
                                        let updateUserData = try JSONDecoder().decode(UpdateUserDataModel.self, from: response.data!)
                                        completion(true, updateUserData)
                                        print("userData Profile img 변경에 변경에 성공했습니다!")
                                    }catch {
                                        print("userData 변경에 실패했습니다 ㅠㅠ 했습니다!")
                                        completion(false, nil)
                                    }
                                    // API 요청이 실패한 경우 -> 알럿 메세지 출력.
                                }else {
                                    print("Update UserProfile Data API 요청에 실패 했습니다")
                                    completion(false, nil)
                                }
                            }
                        case .failure(let encodingError):
                            print("encodingError is \(encodingError)")
                        }
                })
            }
        }
        
        // MARK: User Password Update API 비밀번호 변경 API
        static func password(oldPassword: String!, newPassword: String!, completion: @escaping Complection<UpdateUserPasswordModel>) {
            guard let token = AppDelegate.instance?.token, AppDelegate.instance?.token != nil else {return}
            let url = ServiceType.User.updateUserPassword.routing
            let header = ["Authorization":"Token " + token]
            let parameters : Parameters! = ["old_password": oldPassword,
                                            "new_password": newPassword]
            Alamofire.request(url,
                              method: .patch,
                              parameters: parameters,
                              headers: header).responseJSON { (response) in
                                let statusCode = response.response?.statusCode
                                // 데이터 전달 성공
                                if statusCode == 200 {
                                    do {
                                        let updateUserPasswordData = try JSONDecoder().decode(UpdateUserPasswordModel.self, from: response.data!)
                                        completion(true, updateUserPasswordData)
                                        print("UserPassword Data 변경에 성공했습니다!")
                                    }catch {
                                        print("UserPassword Data 변경에 실패 했습니다!")
                                        completion(false, nil)
                                    }
                                    // 비밀번호가 틀린경우
                                }else if statusCode == 400 {
                                    do {
                                        let updateUserPasswordData = try JSONDecoder().decode(UpdateUserPasswordModel.self, from: response.data!)
                                        completion(false, updateUserPasswordData)
                                        print("UserPassword 비밀번호 변경에 실패했습니다. 하지만 데이터 변환 성공 -> 실패한 이유가 있을것임..")
                                    }catch {
                                        print("UserPassword Data 변경에 실패 했습니다!")
                                        completion(false, nil)
                                    }
                                    
                                    // 변환이 완전히 실패한 경우
                                }else {
                                    print("UserPassword 변경시 알수없는 에러가 발생했습니다...")
                                    
                                }
            }
        }
    }
}
