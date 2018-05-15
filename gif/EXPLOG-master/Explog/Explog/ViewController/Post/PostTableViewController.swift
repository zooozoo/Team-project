
import Foundation
import UIKit
import ParallaxHeader

class PostTableViewController: UIViewController {
    
    // MARK: Get Post Contents
    var getTitleImage: UIImageView = {  
        let img: UIImageView = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = true
        img.alpha = 0.9
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    open var getTitleTV: UITextView = {
        let tv: UITextView = UITextView()
        tv.textAlignment = .center
        tv.text = "아직 미정"
        tv.alpha = 1
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.adjustsFontForContentSizeCategory = true
        tv.textColor = UIColor.white
        tv.backgroundColor = .clear
        tv.textContainer.maximumNumberOfLines = 2
        tv.isEditable = false
        tv.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tv.font = UIFont.boldSystemFont(ofSize: 28)
        return tv
    }()
    
    open var getDateTV: UITextView = {
        let tv: UITextView = UITextView()
        tv.textAlignment = .center
        tv.text = "아직 미정"
        tv.alpha = 1
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.adjustsFontForContentSizeCategory = true
        tv.textColor = UIColor.white
        tv.backgroundColor = .clear
        tv.textContainer.maximumNumberOfLines = 2
        tv.textAlignment = .center
        tv.isEditable = false
        tv.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tv.font = UIFont.systemFont(ofSize: 18,
                                    weight: UIFont.Weight.semibold)
        return tv
    }()
    
    open var getContinentTV: UITextView = {
        let tv: UITextView = UITextView()
        tv.textAlignment = .center
        tv.text = "아직 미정"
        tv.alpha = 1
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.adjustsFontForContentSizeCategory = true
        tv.textColor = UIColor.white
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        tv.textContainer.maximumNumberOfLines = 2
        tv.isEditable = false
        tv.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tv.font = UIFont.systemFont(ofSize: 18,
                                    weight: UIFont.Weight.semibold)
        return tv
    }()
    
    var postTableView: UITableView = {
        let tv: UITableView = UITableView()
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = true
        return tv
    }()
    
    // MARK: Toggle button (Text, Image, Path...)
    let addTextButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 40
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.setImage(#imageLiteral(resourceName: "text"), for: .normal)
        return btn
    }()
    
    let addHighlightTextButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 40
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.setTitle("강조 글", for: .normal)
        btn.setImage(#imageLiteral(resourceName: "highLightText"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let addImageButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 40
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.setTitle("사진 추가", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(#imageLiteral(resourceName: "whiteCamera"), for: UIControlState.normal)
        return btn
    }()
    
    let addPathButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 40
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.setTitle("경로 추가", for: .normal)
        btn.setImage(#imageLiteral(resourceName: "Shape"), for: UIControlState.normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    // postViewControllerData
    internal var postData: PostDataModel?
    internal var postDetailData: PostDetailModel?
    
    // Toggle Contents
    open var postContents: [Any]?
    
    // toggleView 생성
    private var isToggle: Bool = false
    
    // MARK: Toggle View, StackView, UILabel
    private var toggleView: UIView = {
        var v: UIView = UIView()
        v.backgroundColor = UIColor.colorConcept
        v.alpha = 0.4
        v.layer.cornerRadius = 40
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var toggleLable: UILabel = {
        var lb: UILabel = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 25)
        lb.textAlignment = .center
        lb.text = "+"
        return lb
    }()
    
    private var stackViewLists: UIStackView = {
        let st: UIStackView = UIStackView()
        st.axis = .horizontal
        st.distribution = .fillEqually
        st.layer.borderColor = UIColor.darkGray.cgColor
        st.layer.borderWidth = 2
        st.layer.cornerRadius = 40
        st.spacing = 30
        st.backgroundColor = .white
        st.alpha = 1
        return st
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // post Contents 초기화,
        self.postContents = []
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBackgroundColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(self.detailNavigationItemButtonAction(_:)) )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.exitNavigationItemButtonAction(_:)))
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.view.bringSubview(toFront: postTableView)
        
        // Set AddSubViews
        allAddSubView()
        
        // parallax Header View
        setParallax()
        
        // tableView 와 toggle View Set
        setTableView()
        setToggleView()
        
        addTextButton.addTarget(self,
                                action: #selector(self.postTextButtonAction),
                                for: .touchUpInside)
        addHighlightTextButton.addTarget(self,
                                         action: #selector(self.postHighlightTextButtonAction(_:)),
                                         for: .touchUpInside)
        addImageButton.addTarget(self,
                                 action: #selector(self.postImageButtonAction),
                                 for: .touchUpInside)
        addPathButton.addTarget(self,
                                action: #selector(self.postPathButtonAction),
                                for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let postPk = self.postData?.pk else {return}
        
        Network.Post.detail(postPk) { (isSuccess, data) in
            // 요청이 성공했을떄.
            if isSuccess {
                guard let postDetailData = data else {return}
                self.postDetailData = postDetailData
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                    self.moveToTableViewLow()
                }
            }else {
                print("PostDetail API 요청이 실패했습니다 ㅠㅠ")
            }
        }
    }
    
    // MARK: DetailNavigationItemButton Action
    @objc private func detailNavigationItemButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Exit Post Button
    @objc private func exitNavigationItemButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: PostTextButtonAction
    @objc private func postTextButtonAction(_ sender:UIButton) {
        let nextVC = AddTextViewController()
        nextVC.postData = self.postData
        let nextNavigationView = UINavigationController(rootViewController: nextVC)
        present(nextNavigationView, animated: true, completion: nil)
        self.toggleViewOriginFrame()
    }
    
    // MARK: Post HighlightText Button Action
    @objc private func postHighlightTextButtonAction(_ sender:UIButton) {
        let nextVC = AddHighlightTextViewController()
        nextVC.postData = self.postData
        let nextNavigationView = UINavigationController(rootViewController: nextVC)
        present(nextNavigationView, animated: true, completion: nil)
        self.toggleViewOriginFrame()
    }
    
    // MARK: Post Image Button Action
    @objc private func postImageButtonAction(_ sender:UIButton) {
        let addImagePickerController = UIImagePickerController()
        addImagePickerController.delegate = self
        addImagePickerController.sourceType = .photoLibrary
        addImagePickerController.navigationBar.tintColor = UIColor.white
        addImagePickerController.navigationBar.barTintColor = UIColor.colorConcept
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        addImagePickerController.navigationBar.titleTextAttributes = textAttributes
        present(addImagePickerController, animated: true, completion: nil)
        self.toggleViewOriginFrame()
    }
    
    // MARK: Post PathButtonAction
    @objc private func postPathButtonAction(_ sender:UIButton) {
        let nextVC = AddPathViewController()
        let nextNavigationView = UINavigationController(rootViewController: nextVC)
        present(nextNavigationView, animated: true, completion: nil)
        self.toggleViewOriginFrame()
    }
    
    // MARK: Add Sub View Func
    private func allAddSubView() {
        self.view.addSubview(postTableView)
        self.view.addSubview(getTitleImage)
        self.view.addSubview(getDateTV)
        self.view.addSubview(getContinentTV)
    }
    
    // MARK: Registe XIB
    private func setTableView() {
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(UINib(nibName: "TextViewXIB", bundle: nil), forCellReuseIdentifier: "TextViewCell")
        postTableView.register(UINib(nibName: "ImageViewXIB", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        postTableView.register(UINib(nibName: "HighlightTextViewXIB", bundle: nil), forCellReuseIdentifier: "HighlightTextViewCell")
        postTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: Set Toggle View
    private func setToggleView() {
        toggleViewOriginFrame()
        view.addSubview(toggleView)
        toggleView.addSubview(toggleLable)
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(buttonTappedForToggleSize))
        toggleView.addGestureRecognizer(gesture)
        let fremaGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(frameGestureAction))
        view.addGestureRecognizer(fremaGesture)
    }
    
    // MARK: Button Tapped For Toggle Size
    @objc private func buttonTappedForToggleSize(_ sender: UIGestureRecognizer) {
        // gesture Animation 설정
        // 버튼을 펼칠때
        if isToggle == false {
            toggleLable.removeFromSuperview()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.toggleViewChangeFrame()
            }, completion: { (complete) in
            })
            // 버튼이 펼쳐지고 난 이후에
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.toggleViewOriginFrame()
            }, completion: nil)
            self.toggleView.addSubview(self.toggleLable)
            self.stackViewLists.removeFromSuperview()
        }
    }
    
    // MARK: Frame Gesture Action
    @objc private func frameGestureAction(_ sender: UIGestureRecognizer) {
        if isToggle {
            UIView.animate(withDuration: 0.35, animations: {
                self.toggleViewOriginFrame()
            }, completion: nil)
            self.toggleView.addSubview(self.toggleLable)
            self.stackViewLists.removeFromSuperview()
        }
    }
    
    // 원래의 모습으로 토글뷰를 만들어줌.
    // MARK: ToggleViewOrigin Frame
    private func toggleViewOriginFrame() {
        self.isToggle = false
        let pointX = self.view.frame.size.width - 100
        let pointY = self.view.frame.size.height - 100
        toggleView.frame = CGRect(x: pointX,
                                  y: pointY,
                                  width: 80,
                                  height: 80)
        toggleView.alpha = 0.4
        toggleLable.frame = CGRect(x: 0,
                                   y: 0,
                                   width: toggleView.frame.size.width,
                                   height: toggleView.frame.size.height)
        self.toggleView.addSubview(self.toggleLable)
        self.stackViewLists.removeFromSuperview()
    }
    
    // 토글 버튼 터치시, 토글 View 변경 값
    // MARK: ToggleViewChangeFrema
    private func toggleViewChangeFrame() {
        self.isToggle = true
        self.toggleView.frame = CGRect(x: 0,
                                       y: self.view.frame.size.height-100,
                                       width: self.view.frame.size.width,
                                       height: 80)
        self.toggleView.alpha = 1.0
        self.toggleView.addSubview(self.stackViewLists)
        
        // StackView frame, 내부 버튼 설정
        self.stackViewLists.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.view.frame.size.width,
                                           height: 80)
        self.stackViewLists.addArrangedSubview(self.addTextButton)
        self.stackViewLists.addArrangedSubview(self.addHighlightTextButton)
        self.stackViewLists.addArrangedSubview(self.addImageButton)
        self.stackViewLists.addArrangedSubview(self.addPathButton)
    }
    
    // Set ParallexView
    // MARK: Set ParallexView
    func setParallax() {
        postTableView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.frame.size.width,
                                     height: self.view.frame.size.height*1.0)
        postTableView.parallaxHeader.view = self.getTitleImage
        postTableView.parallaxHeader.height = self.view.frame.height*1.0
        postTableView.parallaxHeader.minimumHeight = 0
        postTableView.parallaxHeader.mode = .centerFill
        postTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            self.view.layoutIfNeeded()
            // navigation color white 그 이후는 색상 입히자.
            if parallaxHeader.progress > 0.1 {
                self.navigationController?.setNavigationBackgroundColor()
            }else {
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = nil
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationItem.leftBarButtonItem?.tintColor = .white
                self.navigationItem.rightBarButtonItem?.tintColor = .white
                self.navigationController?.navigationBar.tintColor = .white
                self.navigationController?.navigationBar.barTintColor = UIColor.colorConcept
            }
            
            // Post 스크롤시, blur 처리
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            self.getTitleTV.alpha = parallaxHeader.progress
            self.getDateTV.alpha = parallaxHeader.progress
            self.getContinentTV.alpha = parallaxHeader.progress
        }
        // set parallaxHeaderView 의 하위계층 추가 및, layout 작업
        containViewInParallaxHeader()
    }
    
    // PostTableView 의 ParallaxHeaderView 추가하고, layout 설정
    // MARK: ContainVier In ParallaxHeader
    func containViewInParallaxHeader() {
        postTableView.parallaxHeader.view.addSubview(getTitleTV)
        postTableView.parallaxHeader.view.addSubview(getDateTV)
        postTableView.parallaxHeader.view.addSubview(getContinentTV)
        
        // 각 타이틀 들, AutoLayout
        // MARK: Set Layout
        self.setLayoutMultiplier(target: getTitleTV,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 1.0,
                                 widthMultiplier: 0.9,
                                 heightMultiplier: 0.2 * 2)
        self.setLayoutMultiplier(target: getDateTV,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 0.88,
                                 widthMultiplier: 1.0,
                                 heightMultiplier: 0.05 * 2 )
        self.setLayoutMultiplier(target: getContinentTV,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 0.94,
                                 widthMultiplier: 0.6,
                                 heightMultiplier: 0.05 * 2 )
    }
    
    // 콘텐츠가 추가되면 해당 low 로 이동
    // MARK: Move to TableView Low
    private func moveToTableViewLow() {
        guard let scrollCount = self.postDetailData?.postContents?.count,
            self.postDetailData?.postContents?.count != Int(0)  else {return}
        let lastIndexPath = IndexPath(row: scrollCount - 1, section: 0)
        self.view.layoutIfNeeded()
        self.postTableView.scrollToRow(at: lastIndexPath,
                                       at: UITableViewScrollPosition.bottom,
                                       animated: false)
    }
}


// MARK: Extension tableViewDelegate, TablevEiw DataSource
extension PostTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDetailData?.postContents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let crushCell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        guard let postDetailContetns = self.postDetailData else {return UITableViewCell()}
        
        let contentsType = postDetailContetns.postContents![indexPath.row].contentType
        switch contentsType {
        case "txt":
            let checkTextType = postDetailContetns.postContents![indexPath.row].contents.type
            // 일단 Text 글,
            if checkTextType == "b" {
                print("Text")
                let textCellOfTableView = tableView.dequeueReusableCell(withIdentifier: "TextViewCell") as! TextViewXIB
                let text = postDetailContetns.postContents![indexPath.row].contents.content
                textCellOfTableView.LabelOfPostTableViewCell.text = text
                tableView.rowHeight = UITableViewAutomaticDimension
                return textCellOfTableView
                // Highlight 글
            }else if checkTextType == "h" {
                print("highText")
                let highlightTextCellOfTableView = tableView.dequeueReusableCell(withIdentifier: "HighlightTextViewCell") as! HighlightTextViewXIB
                let text = postDetailContetns.postContents![indexPath.row].contents.content
                highlightTextCellOfTableView.LabelOfhighlightText.text = text
                tableView.rowHeight = UITableViewAutomaticDimension
                return highlightTextCellOfTableView
            }
        //case is [String]:
        case "img":
            print("Image")
            let imageCellOfTableView = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewXIB
            let img = postDetailContetns.postContents![indexPath.row].contents.photo
            imageCellOfTableView.imageViewOfPostTableViewCell.af_setImage(withURL: URL(string: img!)!,
                                                                          placeholderImage: UIImage(),
                                                                          filter: nil,
                                                                          progress: nil,
                                                                          progressQueue: DispatchQueue.main,
                                                                          imageTransition: .crossDissolve(0.5),
                                                                          runImageTransitionIfCached: false)
            tableView.rowHeight = 400
            return imageCellOfTableView
        default:
            print("default")
        }
        return crushCell!
    }
}

// image를 선택할떄 불리는 이미지 피커
// MARK: extension ImagePicker View
extension PostTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진을 선택 후 불리는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imgURL = info[UIImagePickerControllerImageURL] as? URL {
            
            // 이미지를 multipartform data 로 던지기 위해서, url 전달
            let nextVC = AddImageViewController()
            nextVC.postImage.image = img
            nextVC.imgURL = imgURL
            nextVC.postData = self.postData
            picker.pushViewController(nextVC, animated: true)
        }
    }
    //취소했을때 불리는 델리게이트 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
