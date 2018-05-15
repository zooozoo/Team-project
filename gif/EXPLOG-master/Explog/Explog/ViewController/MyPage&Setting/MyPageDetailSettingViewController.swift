//
//  MyPageDetailSettingViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 21..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class MyPageDetailSettingViewController: UIViewController {
    
    // MARK: StoryBoard 인스턴스들
    @IBOutlet weak var usernameHoderLabel: UILabel!
    @IBOutlet weak var usernameTextfield: CustomTextField!
    @IBOutlet weak var userEmailHoderLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userProfileImageButton: UIButton!
    @IBOutlet weak var oldPasswordTextfield: CustomTextField!
    @IBOutlet weak var newPasswordTextfield: CustomTextField!
    @IBOutlet weak var modifiedPasswordButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    open var userProfileData: UserDataModel!
    
    // MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation
        setNavigationControler()
        
        // Set Button color
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .colorConcept
        
        // Set TableView
        setTableView()
        
        // 기본 image 설정
        setImage()
        
        //초기 데이터 설정
        initalData()
    }
    
    // MARK: User의 기본 데이터를 View에 뿌려주기
    private func initalData() {
        self.usernameTextfield.text = self.userProfileData.username
        self.userEmailLabel.text = self.userProfileData.email
        self.modifiedPasswordButton.setTitleColor(UIColor.colorConcept, for: .normal)
        
        if self.userProfileData.imgProfile != nil {
            
            self.userProfileImageButton.af_setImage(for: .normal,
                                                    url: URL(string:self.userProfileData.imgProfile!)!)
        }
        self.usernameTextfield.delegate = self
        self.oldPasswordTextfield.delegate = self
        self.newPasswordTextfield.delegate = self
    }
    
    // MARK: Set NavigationViewController
    func setNavigationControler(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self.detailButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.exitButtonAction(_:)))
        self.setNavigationColorOrTitle(title: "SETTING")
    }
    
    // MARK: NavigationBackButtonAction
    @objc private func detailButtonAction(_ sender: UIBarButtonItem) {
        print("detailbutton 연결 ")
    }
    
    // MARK: ExitbuttonAction
    @objc private func exitButtonAction(_ sender: UIBarButtonItem) {
        print("exitButton 연결 ")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: TableView Set
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Set Profiled Image
    private func setImage() {
        userProfileImageButton.layer.cornerRadius = 40
    }
    
    // MARK: UserProfileAction 변경 하는 부분을 설정하고 로직을 짜놓아야 할것 같음.
    @IBAction func userProfileButtonAction(_ sender: UIButton) {
        // ImagePicker Controller 호출.
        let alertController: UIAlertController = UIAlertController(title: "프로필 이미지를 변경 하시겠습니까?✨",
                                                                   message: "",
                                                                   preferredStyle: UIAlertControllerStyle.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            let addImagePickerController = UIImagePickerController()
            addImagePickerController.delegate = self
            addImagePickerController.sourceType = .photoLibrary
            addImagePickerController.navigationBar.tintColor = UIColor.white
            addImagePickerController.navigationBar.barTintColor = UIColor.colorConcept
            let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                                  NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
            addImagePickerController.navigationBar.titleTextAttributes = textAttributes
            self.present(addImagePickerController, animated: true, completion: nil)
        }
        let alertAction1: UIAlertAction = UIAlertAction(title: "CANCLE", style: .default, handler: nil)
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Logout 시 실행되는 액션
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: "privateKey")
        AppDelegate.instance?.token = nil
        AppDelegate.instance?.userPK = nil 
        print("로그아웃 완료")
        self.dismiss(animated: true,
                     completion: nil)
    }
    
    // MARK: 비밀번호 변경
    @IBAction func modifiedPasswordButtonAction(_ sender: UIButton) {
        print("비밀번호 변경 버튼 호출!")
        let oldPasswordTextCount: Int = (self.oldPasswordTextfield.text?.count)!
        let newPasswordTextCount: Int = (self.newPasswordTextfield.text?.count)!
        if oldPasswordTextCount < 6 &&
            newPasswordTextCount < 6 {
            self.convenienceAlert(alertTitle: "비밀번호는 6자 이상입니다✨")
            
            // 비밀번호의 길이는 8자 이상 ,24 자 이하!
        }else if oldPasswordTextCount >= 6 &&
            newPasswordTextCount >= 6 &&
            oldPasswordTextCount <= 24 &&
            newPasswordTextCount <= 24 {
            
            // 비밀번호 값들 한번더 걸러서 확인해줌.
            guard let oldPassword = self.oldPasswordTextfield.text, let newPassword = self.newPasswordTextfield.text else {return}
            
            Network.UpdateUserProfile.password(oldPassword: oldPassword, newPassword: newPassword, completion: { (isSuccess, data) in
                if isSuccess {
                    let alertController: UIAlertController = UIAlertController(title: "비밀번호 변경에 성공했습니다✨",
                                                                               message: "",
                                                                               preferredStyle: .alert)
                    let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                        // logout Action 실행! -> token 값이 변경되어서 실행되어야 함.
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    if data?.oldPassword != nil {
                        self.convenienceAlert(alertTitle: "기존의 비밀번호가 맞지 않습니다✨")
                    }else if data == nil {
                        self.convenienceAlert(alertTitle: "네트워크 환경이 좋지 않습니다✨")
                    }
                }
            })
        }else {
            self.convenienceAlert(alertTitle: "비밀번호는 6자 이상 24 자 미만 입니다✨")
        }
    }
}

// MARK: TableView 에 대한 버전정보 추가한것, 추후에 보완 예정
extension MyPageDetailSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var settingCellTitle: [String] = ["버전정보" ,"도움말", "문의하기"]
        cell.textLabel?.text = settingCellTitle[indexPath.row]
        if indexPath.row == 0 {
            cell.accessoryType = .none
            let version: UILabel = UILabel()
            version.textAlignment = .right
            version.frame = CGRect(x: 0,
                                   y: 0,
                                   width: 50,
                                   height: 50)
            version.text = "1.0"
            version.textColor = .black
            cell.accessoryView = version
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "고객지원"
        return title
    }
}


extension MyPageDetailSettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        // nickName 을 변경 하려고 하는경우에 여기에서 걸러주자.
        case 1:
            print("tag1 textfield \(textField)")
            let textCount: Int = (textField.text?.count)!
            if textCount != 0 && textCount <= 11 {
                Network.UpdateUserProfile.userNameAndUserProfileImage(username: textField.text, img: nil, completion: { (isSuccess, data) in
                    print("유저 데이터 업데이트(UserName, UserProfileImage) API \(String(describing: data))")
                    if isSuccess {
                        print("UserProfile Nick 변경에 성공 했습니다!")
                        self.convenienceAlert(alertTitle: "닉네임이 변경되었습니다✨")
                    }else {
                        print("UserProfile Nick 변경에 실패 했습니다!")
                        self.convenienceAlert(alertTitle: "네트워크 환경이 좋지 않습니다✨")
                    }
                })
            }else {
                self.convenienceAlert(alertTitle: "닉네임 길이는 11자 미만입니다✨")
            }
            return true
        // 비밀번호 변경 Textfield 로직
        case 2:
            self.newPasswordTextfield.becomeFirstResponder()
            return true
        case 3:
            // 비밀번호 변경 button 호출.
            modifiedPasswordButtonAction(modifiedPasswordButton)
            return true
        default:
            print("textfield tag 가 없는놈.")
        }
        return true
    }
}

// image를 선택할떄 불리는 이미지 피커
// MARK: extension ImagePicker View
extension MyPageDetailSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진을 선택 후 불리는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let _ = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imgURL = info[UIImagePickerControllerImageURL] as? URL {
            Network.UpdateUserProfile.userNameAndUserProfileImage(username: nil,
                                                                  img: imgURL,
                                                                  completion: { (isSuccess,data) in
                                                                    
                                                                    // API 요청과, 데이터 변환이 성공한 경우
                                                                    if isSuccess {
                                                                        let identifier: String = (data?.imgProfile)!
                                                                        self.userProfileImageButton.af_setImage(for: .normal,
                                                                                                                url: URL(string:identifier)!)
                                                                        print("변경된 profile Image 이미지캐시에 저장완료!")
                                                                        DispatchQueue.main.async {
                                                                            picker.dismiss(animated: true, completion: nil)
                                                                            
                                                                            print("이미지 변환성공 -> 탈출!")
                                                                        }
                                                                        // API 요청과, 데이터 변환이 실패한 경우.
                                                                    }else {
                                                                        picker.convenienceAlert(alertTitle: "네트워크 환경이 좋지 않습니다✨")
                                                                    }
            })
        }
    }
    //취소했을때 불리는 델리게이트 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




