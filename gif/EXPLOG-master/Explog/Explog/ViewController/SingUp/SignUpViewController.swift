
import UIKit

import Alamofire

class SignUpViewController: UIViewController{
    
    // MARK: IBOutlet Collection
    @IBOutlet weak private var nickNameTextField: CustomTextField!
    @IBOutlet weak private var emailTextfield: CustomTextField!
    @IBOutlet weak private var passwordTextfield: CustomTextField!
    @IBOutlet weak private var confirmPasswordTextfield: CustomTextField!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak private var profileButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    private var imageurl: URL!
    private var indicator: UIActivityIndicatorView?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 기본 유저프로파일 이미지 URL 지정
        self.imageurl = Bundle.main.url(forResource: "DefaultProfileImage", withExtension: "png")
        
        // 기본 레이아웃 설정
        setLayout()
        
        // 인디케이터 생성
        setIndicator()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidShow(noti:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(noti:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        // Add Gesture
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.tapAction(_:)))
        self.scrollView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: TapAction
    @objc func tapAction(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: Keyboard Show & Hide
    @objc func keyboardDidShow(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {return}
        scrollView.contentOffset = CGPoint(x: 0, y: keyFrame.size.height - 200)
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    // MARK: SignUpButton
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let checkTextFieldAlert = UIAlertController(title: "빈 곳을 채워 주세요",
                                                    message: "",
                                                    preferredStyle: .alert)
        let AlertAction = UIAlertAction(title: "OK",
                                        style: .default,
                                        handler: nil)
        checkTextFieldAlert.addAction(AlertAction)
        
        guard let checkNickNameSignal = nickNameTextField.text?.validationOfNickName() else {return}
        
        // TextField 중 한곳이라도 비어 있는 곳이 있을 경우 띄워지는 알럿.
        if (self.nickNameTextField.text?.isEmpty)! ||
            (self.emailTextfield.text?.isEmpty)! ||
            (self.passwordTextfield.text?.isEmpty)! ||
            (self.confirmPasswordTextfield.text?.isEmpty)! {
            present(checkTextFieldAlert, animated: true, completion: nil)
            return
            
            // 이메일 정규식 체크
        }else if self.emailTextfield.text?.validationOfEmail() == false{
            checkTextFieldAlert.title = "이메일 형식이 맞지 않습니다."
            present(checkTextFieldAlert, animated: true, completion: nil)
            return
        }else {
            
            // 비밀번호가 같은지 체크
            if let password = self.passwordTextfield.text,
                let confirmPassword = self.confirmPasswordTextfield.text {
                if password != confirmPassword {
                    checkTextFieldAlert.title = "비밀 번호가 서로 같지 않습니다"
                    present(checkTextFieldAlert, animated: true, completion: nil)
                    
                    // 비밀번호의 길이는 5~16 자를 넘어가면 알럿 걸림.
                }else if (self.confirmPasswordTextfield.text?.count)! < String.CharacterView.IndexDistance(5)
                    || (self.confirmPasswordTextfield.text?.count)! > String.CharacterView.IndexDistance(16)  {
                    checkTextFieldAlert.title = "비밀번호의 길이가 맞지 않습니다"
                    present(checkTextFieldAlert, animated: true, completion: nil)
                }else {
                    // nick name 정규식 체크
                    switch checkNickNameSignal {
                    case 0:
                        checkTextFieldAlert.message = "닉네임 형식이 맞지 않습니다."
                        present(checkTextFieldAlert, animated: true, completion: nil)
                        return
                    case 1:
                        print("닉네임 체크 완료.")
                    case 2:
                        checkTextFieldAlert.message = "특수문자가 있내요"
                        present(checkTextFieldAlert, animated: true, completion: nil)
                        return
                    case 3:
                        checkTextFieldAlert.message = "문자열의 길이는4자 이상이에요"
                        present(checkTextFieldAlert, animated: true, completion: nil)
                        return
                    case 4:
                        checkTextFieldAlert.message = "문자열의 11자를 넘기면안되요!"
                        present(checkTextFieldAlert, animated: true, completion: nil)
                        return
                    default:
                        print("여기는 오면안되요..")
                        return
                    }
                    
                    // 로그인 시도 -> 네트워크 통신 결과에 따라서, 세분화
                    let url: URL? = self.imageurl ?? nil
                    indicator?.startAnimating()
                    Network.AuthService.signup(email: self.emailTextfield.text!,
                                       password: password,
                                       username: self.nickNameTextField.text!,
                                       imgprofile: url) { (isSuccess,data, error) in
                                        
                                        // network 통신 성공, 실패에 따라서 로직 이후 진행되는 액션 분리
                                        if isSuccess {
                                            // myProfile dataModel 후 적용 ->
                                            print("회원가입에 성공 했습니다~!")
                                            // UserDefault 에 token, pk 값 저장하기
                                            let token: String = (data?.token)!
                                            let pk: Int = (data?.pk)!
                                            let privateKey: [String: Any] = ["token": token, "pk": pk]
                                            UserDefaults.standard.set(privateKey, forKey: "privateKey")
                                            let userPrivateKey = UserDefaults.standard.value(forKey: "privateKey") as! [String:Any]
                                            let userToken = userPrivateKey["token"] as! String
                                            let userPK = userPrivateKey["pk"] as! Int
                                            AppDelegate.instance?.token = userToken
                                            AppDelegate.instance?.userPK = userPK
                                            self.indicator?.stopAnimating()
                                            
                                            // window rootView 위에있는 모든 ViewController dissmiss
                                            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                                            self.isEditing = false
                                        }else {
                                            if error!.email != nil {
                                                self.convenienceAlert(alertTitle: "이미 존재하는 EMAIL 입니다✨")
                                                self.indicator?.stopAnimating()
                                            }else if error!.username != nil{
                                                self.convenienceAlert(alertTitle: "이미 존재하는 USERNAME 입니다✨")
                                                self.indicator?.stopAnimating()
                                            }else {
                                                self.convenienceAlert(alertTitle: "네트워크 상태가 좋지 않습니다✨")
                                                self.indicator?.stopAnimating()
                                            }
                                        }
                    }
                }
            }
        }
    }
    
    // MARK: profileButtonAction 세분화
    @IBAction private func profileButtonAction(_ sender: UIButton) {
        let profileImagePickerController = UIImagePickerController()
        profileImagePickerController.delegate = self
        profileImagePickerController.sourceType = .photoLibrary
        present(profileImagePickerController, animated: true, completion: nil)
    }
    
    // Mark: SetTextField property
    private func setLayout() {
        self.exitButton.setTitleColor(.colorConcept, for: .normal)
        self.signUpButton.backgroundColor = .colorConcept
        self.passwordTextfield.isSecureTextEntry = true
        self.confirmPasswordTextfield.isSecureTextEntry = true
        self.signUpButton.layer.cornerRadius = 15
        
        self.profileButton.layer.borderColor = UIColor.colorConcept.cgColor
        self.profileButton.layer.borderWidth = 1
        self.profileButton.backgroundColor = .clear
        signUpLabel.textColor = .colorConcept
        
        self.nickNameTextField.attributedPlaceholder = NSAttributedString(string: "NickName",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.nickNameTextField.textColor = .colorConcept
        self.emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.emailTextfield.textColor = .colorConcept
        self.passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTextfield.textColor = .colorConcept
        self.confirmPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "ConfirmPassword",
                                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.confirmPasswordTextfield.textColor = .colorConcept
    }
    
    // MARK: SignUp BackActionButton
    @IBAction private func backActionButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: setIndicator
    private func setIndicator() {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator?.frame.origin = CGPoint(x: view.center.x,
                                         y: view.center.y)
        view.addSubview(indicator!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("SignUp Keyboard Notification 삭제")
    }
}

// MARK: TextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.nickNameTextField.tag = 1
        self.emailTextfield.tag = 2
        self.passwordTextfield.tag = 3
        self.confirmPasswordTextfield.tag = 4
        if textField.text?.isEmpty == false {
            switch textField.tag {
            case 1:
                self.emailTextfield.becomeFirstResponder()
            case 2:
                self.passwordTextfield.becomeFirstResponder()
            case 3:
                self.confirmPasswordTextfield.becomeFirstResponder()
            default:
                print("버튼Action을 연결하면 바로 실행가능.")
                signUpButtonAction(signUpButton)
            }
        }
        return true
    }
}

// MARK: UIImagePickerDelegate
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {    
        if let imgURL = info[UIImagePickerControllerImageURL] as? URL {
            self.imageurl = imgURL
            let image = UIImage(contentsOfFile: imgURL.path)
            self.profileButton.setImage(image , for: .normal)
        picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //취소했을때 불리는 델리게이트 메소드
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension String{
    /*
     1: 성공
     2: 특수 문자가 있는 경우
     3: 문자열의 길이가 짧은 경우
     4: 문자열의 길이가 긴 경우
     */
    func validationOfNickName() -> Int? {
        //영문 소문자, 한글(ㅁㄴㅇㅊ은 안됨), 5~11자
        let checkNickName = "[/^[/^[가-힣]+$/][a-zA-Z0-9]{5,11}$/;]"
        let regex = try! NSRegularExpression(pattern: checkNickName, options: [])
        let matches = regex.matches(in: self,
                                    options: [],
                                    range: NSRange(location:0,
                                                   length:self.count))
        let checkSpacialString = "[?=.*[!@#$%^*+=-]|.*]"
        let regex1 = try! NSRegularExpression(pattern: checkSpacialString, options: [])
        let matches1 = regex1.matches(in: self,
                                      options: [],
                                      range: NSRange(location:0,
                                                     length:self.count))
        // 글자수 4~12자, 영문 대소문자, 숫자 0~9, 특수문자 X
        var resultSignal: Int = 0
        
        // 특수 문자가 있는 경우
        if matches1.count > 0 {
            resultSignal = 2
            print("특수문자가 있어요##")
            return resultSignal
        }
        
        // 성공한 경우
        if matches.count > 4 && matches.count < 12 && matches.count == self.count {
            resultSignal = 1
            return resultSignal
        }else if matches.count < 5 || self.count < 5 {
            resultSignal = 3
            print("글자 수가 작은 경우 ")
            return resultSignal
        }else if matches.count > 12 || self.count > 12 {
            print("글자수가 많은 경우")
            resultSignal = 4
            return resultSignal
        }
        return resultSignal
    }
    
    // email check 정규식 -> 길이 제한 없음.
    // Bool 값 성공 -> 실패로 구분
    func validationOfEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}",
                                             options: [])
        let matches = regex.matches(in: self,
                                    options: [],
                                    range: NSRange(location:0,length:self.count))
        return matches.count > 0
    }
}












