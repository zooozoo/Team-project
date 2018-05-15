

import UIKit

class AddTextViewController: UIViewController {
    
    // MARK: Text를 작성하는 TextView
    internal let textView: UITextView = {
        let tv: UITextView = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "내용을 입력 하세요!"
        
        return tv
    }()
    
    // MARK: Indicator
    private var indicator: UIActivityIndicatorView = {
        let indi: UIActivityIndicatorView = UIActivityIndicatorView()
        indi.activityIndicatorViewStyle = .gray
        indi.hidesWhenStopped = true
        indi.translatesAutoresizingMaskIntoConstraints = false
        return indi
    }()
    
    // MARK: Text의 표지 정보
    internal var postData: PostDataModel!
    internal var toAddPostPk: Int?
    internal var modifyTextPk: Int?
    internal var isEditingText: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" in AddTextViwController \(postData)")
        self.view.backgroundColor = .white
        // Navigation Setting
        setnavigationController()
        textView.delegate = self
        addsubView()
        // Set TextView Layout
        setLayout()
    }
    
    // MARK: SetLayout
    private func addsubView() {
        self.view.addSubview(textView)
        self.view.addSubview(indicator)
    }
    
    // MARK: Set Layout
    private func setLayout() {
        let statusHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let naviHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)!
        let originY = statusHeight + naviHeight
        self.textView.frame = CGRect(x: 8,
                                     y: originY + 8,
                                     width: self.view.frame.size.width - 16,
                                     height: self.view.frame.size.height * 0.5)
        self.setLayoutMultiplier(target: self.indicator,
                                 to: self.view,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 1,
                                 widthMultiplier: 0.1,
                                 heightMultiplier: 0.1)
        self.indicator.bringSubview(toFront: self.textView)
    }
    
    // MARK: Add Post Action
    @objc func addpostButtonAction(_ sender: UIButton) {
        guard let text = textView.text, textView.text.count != 0 else {return}
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        if self.isEditingText == false {
            var postPk: Int?
            
            // PostPk 값을, Post 작성시에 사용했던 Pk 값을 사용할건지, 수정하기 위해서 사용되어지는 Pk 값을 사용할것인지 결정함.
            if self.toAddPostPk != nil {
                postPk = self.toAddPostPk
            }else {
                postPk = postData.pk
            }
            
            Network.Post.textCreat(postPk: postPk!,
                                   contents: text,
                                   type: "b") { (isSuccess, data) in
                                    // 성공적으로 데이터 넘어온 경우
                                    if isSuccess {
                                        // TableView에 실제로 적용시키고, 화면 전환
                                        // dismiss 는 Main Thread 에서 굳이 하지 않아도 되는것같음..!
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                        self.dismiss(animated: true, completion: nil)
                                        // 데이터가 넘어오지 못한 경우..
                                    }else {
                                        print("Post Text Creat 실패...ㅠ.ㅠ")
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                    }
            }
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }else {
            // 수정중일떄 실행되는 곳.
            Network.UpdatePostContents.text(textPk: self.modifyTextPk!,
                                            content: text,
                                            type: "b",
                                            completion: {  (isSuccess) in
                                                if isSuccess {
                                                    print("basic text 수정 완료!")
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                    self.dismiss(animated: true, completion: nil)
                                                }else {
                                                    print("basic text 수정 실패!!")
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                    self.dismiss(animated: true, completion: nil)
                                                }
            })
        }
    }
    
    // MARK: backButton Action
    @objc func backPostButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: navigation setting
    private func setnavigationController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(self.addpostButtonAction(_:)) )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.backPostButtonAction(_:)))
        // Extention 사용해서, 색상 컨셉트 통일.
        self.setNavigationColorOrTitle(title: "글 추가")
    }
}

// MARK: TextviewDelegate -> 글 작성시 커서가 화면을 따라감.
extension AddTextViewController: UITextViewDelegate {
    
    // TextView PlaceHolder
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDid Begin Editing")
        if (textView.text == "내용을 입력 하세요!") {
            textView.text = ""
            textView.textColor = .black
        }
        //Optional
        textView.becomeFirstResponder()
    }
    
    // Text를 작성할때 커서가 앤터키에 맞추어서 따라감.
    func textViewDidChange(_ textView: UITextView) {
        print("같은 함수 한번더 호출")
        textView.setContentOffset(CGPoint.zero, animated: true)
    }
}
