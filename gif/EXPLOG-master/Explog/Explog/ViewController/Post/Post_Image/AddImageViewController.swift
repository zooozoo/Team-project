
import UIKit

class AddImageViewController: UIViewController {
    
    // MARK: Load ImageView
    let postImage: UIImageView = {
        let img: UIImageView = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = true
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    // MARK: Image 를 업로드 하기위한 imageURL
    var imgURL: URL!
    open var postData: PostDataModel!
    open var toAddPostPk: Int?
    
    internal var modifyPhotoPk: Int?
    internal var isEditingPhoto: Bool = false
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(postImage)
        
        // layout Set
        setLayout()
        
        // navigation set
        setnavigationController()
    }
    
    // MARK: SetLayout
    private func setLayout() {
        let fremaInset: CGFloat = 10
        postImage.frame = CGRect(x: 0,
                                 y: (self.navigationController?.navigationBar.frame.size.height)! + fremaInset,
                                 width: self.view.frame.size.width,
                                 height: self.view.frame.size.height*0.5)
    }
    
    // MARK: Image를 다음 TableView에 추가, 이제, Server 통신 -> 결과 구현해야함
    @objc func addImageButtonAction(_ sender: UIButton) {
        guard let _ = postImage.image,
            postImage.image != nil else {return}
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        // UserProfile 에서 생성하기 위해서 접근 & Post Creat 사용하여 접근할때 사용됨.
        if self.isEditingPhoto == false {
            var postPk: Int!
            // PostPk 값을 어디서 접근 했느냐에 따라서 나누어서 설정해줌
            if self.toAddPostPk != nil {
                postPk = self.toAddPostPk
            }else {
                postPk = postData.pk
            }
            Network.Post.PhotoCreat(postPk: postPk,
                                    photo: self.imgURL) { (isSuccess, data) in
                                        // 성공적으로 데이터 넘어온 경우
                                        if isSuccess {
                                            self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                            self.dismiss(animated: true, completion: nil)
                                            print("Creat Photo API 성공 -> 화면전환")
                                            // 데이터가 제대로 넘어오지 않은 경우
                                        }else {
                                            let alertController: UIAlertController = UIAlertController(title: "네트워크 환경이 좋지 않습니다✨",
                                                                                                       message: "",
                                                                                                       preferredStyle: .alert)
                                            let alertAction: UIAlertAction = UIAlertAction(title: "OK",
                                                                                           style: .default,
                                                                                           handler: { (alert) in
                                                                                            self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                                                            self.dismiss(animated: true, completion: nil)
                                            })
                                            alertController.addAction(alertAction)
                                            self.present(alertController, animated: true, completion: nil)
                                        }
            }
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            // Photo 자체를 수정할때 사용됩니다!
        }else {
            print("수정 로직만 짜면됨. 접근 완료 \(String(describing: self.modifyPhotoPk))")
            Network.UpdatePostContents.photo(photoPk: self.modifyPhotoPk!,
                                             photo: self.imgURL,
                                             completion: { (isSuccess) in
                                                
                                                // API Call 이 성공한 경우
                                                if isSuccess {
                                                    print("Post Photo 이미지 변환이 성공 했습니다!")
                                                    self.dismiss(animated: true, completion: nil)
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                    // API Call 이 실패 한경우
                                                }else {
                                                    self.dismiss(animated: true, completion: nil)
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                    print("Post Photo 이미지 변환이 실패 했습니다!")
                                                }
            })
        }
    }
    
    // backButton 은 구현하지 않았음. 이미지를 계속해서 변경할수 있게 하기 위해서
    // MARK: SetNavigation
    func setnavigationController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(self.addImageButtonAction) )
        self.setNavigationColorOrTitle(title: "사진 추가")
    }
}
