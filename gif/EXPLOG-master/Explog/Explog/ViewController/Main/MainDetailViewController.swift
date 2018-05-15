//
//  MainDetailViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 25..
//  Copyright © 2017년 becomingmacker. All rights reserved


import UIKit
import ParallaxHeader

class MainDetailViewController: UIViewController {
    
    // MARK: Get Post Contents
    var getTitleImage: UIImageView = {
        let img: UIImageView = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.alpha = 0.9
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    open var getTitleTV: UITextView = {
        let tv: UITextView = UITextView()
        tv.textAlignment = .center
        tv.text = "미정"
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
        tv.text = "미정"
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
        tv.text = "미정"
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
    
    // MARK: 해당 버튼을 통해서, User Page 로 이동후, 팔로우, 팔로잉 가능하게 구현.
    open var getProfileImageButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 1
        btn.contentMode = .scaleAspectFit
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 35
        btn.backgroundColor = .white
        return btn
    }()
    
    open var getProfileNickName: UILabel = {
        let lb: UILabel = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.alpha = 1
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textAlignment = .center
        lb.text = "이름 공간"
        return lb
        
    }()
    
    var postTableView: UITableView = {
        let tv: UITableView = UITableView()
        tv.separatorStyle = .none
        tv.isUserInteractionEnabled = true
        tv.allowsSelection = true
        // TableView 는 frema base 로 frema 을 설정했기 때문에, autolayoutConstraints 이 기본적으로 true 지만, 명시적으로 하기 위해서 true 값을 넣어줌.
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
    
    // 현재 페이지에 들어온 유저가 Post의 해당 유저인지, 다른 유저인지 판별
    open var isAccessingOtherUser: Bool = true
    
    // postViewControllerData
    open var postCoverData: Posts?
    open var postDetailData: PostDetailModel?
    open var postPk: Int!
    
    // User에서 접근할때 Post DetailViewController 분리
    open var userPostCoverData: UserPosts?
    open var userProfileImage: String?
    open var usernickName: String?
    
    // Search에서 접근할때 PostDetailViewController 분리
    open var searchPostCoverData: PostDataModel?
    
    // 다른 User 에게 접근하기 위해서 필요한 pk값
    open var otherUserPk: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // post Contents 초기화,
        self.view.backgroundColor = .white
        
        // Set TableView Delegate, DataSource
        setTableView()
        
        // Set AddSubViews
        allAddSubView()
        
        // parallax Header View
        setParallax()
        
        // SetNavigatio
        setNavigationController()
        
        // SetCoverData
        setCoverData()
        setUserCoverData()
        
        // Set toggleView
        // 다른 유저의 페이지를 보러왔을때는, 실행하지 않고, Button을 생성하지 않습니다!
        // 현재 페이지에서, 다른유저의 접근인지 아닌지 확인하고, 이전 페이지에서 다른유저의 접근인지 아닌지를 확인하고, Boll 값을 넘겨줍니다.
        if self.isAccessingOtherUser == false {
            // ToggleView생성
            setToggleView()
            
            // Text, HighLight, Photo 버튼 함수 연결
            addTextButton.addTarget(self,
                                    action: #selector(self.postTextButtonAction),
                                    for: .touchUpInside)
            addHighlightTextButton.addTarget(self,
                                             action: #selector(self.postHighlightTextButtonAction(_:)),
                                             for: .touchUpInside)
            addImageButton.addTarget(self,
                                     action: #selector(self.postImageButtonAction),
                                     for: .touchUpInside)
            
            // Toggle Button 이 생성될때, PostCover 삭제 & 수정 할수 있는 로직 구현해주자
            // More Button 추가.
            let moreInforMationNaviBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more"),
                                                                                style: .plain,
                                                                                target: self,
                                                                                action: #selector(self.modifyPostCoverOrDeletePostCover(_:)))
            self.navigationItem.rightBarButtonItems?.append(moreInforMationNaviBarButton)
        }
        // Set UserProfile Button Action
        self.getProfileImageButton.addTarget(self,
                                             action: #selector(self.userProfileButtonAction(_:)),
                                             for: .touchUpInside)
    }
    
    // PostDetail 부분은, 데이터가 변경 되었을때, 서버에 있는 데이터를 지속적으로 사용합니다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Network.Post.detail(self.postPk) { (isSuccess, data) in
            let asyncItem: DispatchWorkItem = DispatchWorkItem { [unowned self] in
                // 성공 적으로 값이 넘어온 경우
                if isSuccess {
                    guard let postDetailData = data, data != nil else {return}
                    self.postDetailData = data
                    print("postDetaliData 성공적을 변환 완료.")
                    DispatchQueue.main.async {
                        self.postTableView.reloadData()
                    }
                    // 값이 변환되지 않은 경우.
                }else {
                    print("PostDetail API 자료변환 실패해서, 다음 화면으로 넘어가지 않음.. ㅠ_ㅠ network 에 대한 대응 필요..")
                }
            }
            DispatchQueue.global().async(execute: asyncItem)
        }
    }
    
    // Text를 수정 & 추가 하기 위해서 설정.
    // MARK: PostTextButtonAction
    @objc private func postTextButtonAction(_ sender:UIButton) {
        let nextVC = AddTextViewController()
        // MainDetail에서 PostPk 값 전달.
        nextVC.toAddPostPk = self.postPk
        let nextNavigationView = UINavigationController(rootViewController: nextVC)
        present(nextNavigationView, animated: true, completion: nil)
        self.toggleViewOriginFrame()
    }
    
    // MARK: HightTextButton Action
    @objc private func postHighlightTextButtonAction(_ sender:UIButton) {
        let nextVC = AddHighlightTextViewController()
        nextVC.toAddPostPk = self.postPk
        let nextNavigationView = UINavigationController(rootViewController: nextVC)
        present(nextNavigationView, animated: true, completion: nil)
        self.toggleViewOriginFrame()
    }
    
    // MARK: PostImageButton Action
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
    
    // MARK: Set Toggle View
    private func setToggleView() {
        toggleViewOriginFrame()
        view.addSubview(toggleView)
        toggleView.addSubview(toggleLable)
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(buttonTappedForToggleSize))
        toggleView.addGestureRecognizer(gesture)
    }
    
    // MARK: Button Tapped For Toggle Size
    @objc private func buttonTappedForToggleSize(_ sender: UIGestureRecognizer) {
        // gesture Animation 설정
        // 버튼을 펼칠때
        if isToggle == false {
            toggleLable.removeFromSuperview()
            // 전체 뷰에 제스쳐는, toggleView가 활성화 되어있을때만 사용할수 있음.
            let fremaGesture = UITapGestureRecognizer(target: self,
                                                      action: #selector(frameGestureAction))
            view.addGestureRecognizer(fremaGesture)
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
            // toggle 버튼이 활성화 되었을때, 재스쳐를 사용하면, 제스쳐 삭제해줌.
            for item in self.view.gestureRecognizers! {
                self.view.removeGestureRecognizer(item)
            }
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
        
        // 버튼을 원래 모습으로 돌릴떄, view에 걸려있는 gesture 삭제
        if self.view.gestureRecognizers?.count != nil {
            for item in self.view.gestureRecognizers! {
                self.view.removeGestureRecognizer(item)
            }
        }
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
    
    // MARK: 기본 메인 화면에서 접근했을때 실행! in Main Cover
    private func setCoverData() {
        guard let imgStringURL = self.postCoverData?.img else {return}
        guard let postCoverData = self.postCoverData else {return}
        // Main 에서 접근했을때, 기본 cover Image, Profile Image 를 Image Cache 처리.
        self.getTitleImage.af_setImage(withURL: URL(string: imgStringURL)!,
                                       placeholderImage: UIImage(),
                                       filter: nil,
                                       progress: nil,
                                       progressQueue: DispatchQueue.main,
                                       imageTransition: .crossDissolve(0.5),
                                       runImageTransitionIfCached: false)
        self.getTitleTV.text = postCoverData.title
        self.getDateTV.text = postCoverData.startDate + " ~ " + postCoverData.endDate
        self.getContinentTV.text = self.returnContinentName(continentString: postCoverData.continent)
        self.getProfileImageButton.af_setImage(for: .normal, url: URL(string: postCoverData.author.imgProfile)!)
        self.getProfileNickName.text = postCoverData.author.username
        
        // 내가 이전에 좋아요를 눌렀다면, tintColor 수정
        if AppDelegate.instance?.userPK != nil {
            if postCoverData.liked.contains((AppDelegate.instance?.userPK)!) {
                self.navigationItem.rightBarButtonItems![0].tintColor = .red
            }
        }
    }
    
    // MARK: 유저 화면에서 접근 했을때 실행 in User Cover
    private func setUserCoverData() {
        guard let imgStringURL = self.userPostCoverData?.img else {return}
        guard let postCoverData = self.userPostCoverData else {return}
        self.getTitleImage.af_setImage(withURL: URL(string: imgStringURL)!,
                                       placeholderImage: UIImage(),
                                       filter: nil,
                                       progress: nil,
                                       progressQueue: DispatchQueue.main,
                                       imageTransition: .crossDissolve(0.5),
                                       runImageTransitionIfCached: false)
        self.getTitleTV.text = postCoverData.title
        self.getDateTV.text = postCoverData.startDate + " ~ " + postCoverData.endDate
        self.getContinentTV.text = self.returnContinentName(continentString: postCoverData.continent)
        self.getProfileImageButton.af_setImage(for: .normal, url: URL(string: self.userProfileImage!)!)
        self.getProfileNickName.text = self.usernickName
        // 내가 이전에 좋아요를 눌렀다면, tint!Color 수정
        if AppDelegate.instance?.userPK != nil {
            if postCoverData.liked.contains((AppDelegate.instance?.userPK)!) {
                self.navigationItem.rightBarButtonItems![0].tintColor = .red
            }
        }
    }
    
    private func setNavigationController() {
        self.navigationController?.setNavigationBackgroundColor()
        // Custom NavigationBar 로 변경 해야함.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.exitNavigationItemButtonAction(_:)))
        
        // 기본으로 이렇게 하고, 내가 좋아요를 누른 조건에 따라서 값을 변경 해주는 형식으로 변경 해야할것 같음.
        // Navigation Item 연결
        let likeBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "unlike"),
                                                             style: UIBarButtonItemStyle.plain,
                                                             target: self,
                                                             action: #selector(self.likeNaviItemButtonAction))
        let replyBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "reply"),
                                                              style: .plain,
                                                              target: self,
                                                              action: #selector(self.replyNaviItemButtonAction(_:)))
        self.navigationController?.navigationBar.tintColor = .white
        // Navi Item 2개!
        self.navigationItem.rightBarButtonItems = [likeBarButton,
                                                   replyBarButton]
        //self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.view.bringSubview(toFront: postTableView)
    }
    
    // MARK: Like NaviBar Item Action
    @objc private func likeNaviItemButtonAction(_ sender: UIBarButtonItem) {
        print("likeButton Action \(sender)")
        // PostPk 유무 확인.
        guard let postPk = self.postPk, self.postPk != nil else {return}
        guard let userPK = AppDelegate.instance?.userPK else {
            // 로그인 하지 않았을떄, 라이크 버튼을 누르면, 알럿 메세지를 띄워줌
            self.loginAlertMessage()
            return}
        Network.Post.like(postPk: postPk) { (isSuccess, data) in
            // 좋아요 요청 성공한 경우
            if isSuccess {
                // NavigationBarItem tintColor 변경.
                // Like 누른 경우
                if (data?.liked?.contains(userPK))! {
                    // UnLike 한 경우!
                    DispatchQueue.main.async {
                        sender.tintColor = .red
                        // 기존의 방법 self.navigationItem.rightBarButtonItems![0].tintColor = .redd
                    }
                    print("\(userPK) 님이 좋아요를 눌렀습니다!")
                }else {
                    DispatchQueue.main.async {
                        self.navigationItem.rightBarButtonItems![0].tintColor = .white
                    }
                    print("\(userPK) 님이 좋아요를 취소 했습니다!")
                }
            }else {
                print("좋아요 API 요청이 실패했습니다.")
                //실패한 경우.
            }
        }
    }
    
    // MARK: Reply NaviBar Item Action
    @objc private func replyNaviItemButtonAction(_ sender: UIBarButtonItem) {
        // Login 하지 않은상태에서 리플 버튼을 누르면 알럿 메세지 띄워줌
        if AppDelegate.instance?.token == nil {
            self.loginAlertMessage()
            return
        }
        guard let postPK = self.postPk else {return}
        let nextVC = UIStoryboard(name: "Tab1", bundle: nil).instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        
        nextVC.postPK = postPK
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: Exit Post Button
    @objc private func exitNavigationItemButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: 해당 유저의 페이지로 이동.
    @objc private func userProfileButtonAction(_ sender: UIButton) {
        print("내토큰 값 \(String(describing: AppDelegate.instance?.userPK)), 다른 유저의 토큰값 \(self.otherUserPk)")
        // 내 이미지 프로파일을 터치 했을때, 나의 userProfile Page로 넘어가지 않게 하기 위해서, PrivateKey 값이 같은 경우에는 아래 액션을 취하지 않음.
        // my page 에서는 다른유저의 token 값을 nil 을 만들어서, 내페이지에서 내페이지로 가는것을 방어하고.
        // 다른 유저 페이지에서 -> 다시 다른 유저 페이지로 들어갈때는, 처음에 Main-> 다른 유저 페이지로 갈떄는, UserPk 값을 넘겨주는데, 그 다음 Post-> 다음유저로 넘어갈때는 UserPk 값을 넘겨주지 않아서, 해당 유저페이지 이동을 방어함.
        guard let myPk = AppDelegate.instance?.userPK,
            let otherUserPk = self.otherUserPk,
            // 로그인 이전이면, 내 pk 값이 있을수도 있고, 없을수도 있음. 
            myPk != nil
            else {return}
        if myPk != otherUserPk {
            let nextVC: MyPageViewController = MyPageViewController()
            nextVC.isAccessingOtherUser = true
            nextVC.otherUserPK = self.otherUserPk
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // MARK: Modify PostCover NavigationBar Item
    @objc private func modifyPostCoverOrDeletePostCover(_ sender: UIBarButtonItem) {
        let alertController: UIAlertController = UIAlertController(title: "POST COVER",
                                                                   message: "",
                                                                   preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
            Network.Delete.post(postPk: self.postPk, completion: { (isSuccess, data) in
                let alertController: UIAlertController = UIAlertController(title: "포스트가 삭제되었습니다✨", message: "", preferredStyle: .alert)
                let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                
                if isSuccess {
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    alertController.title = "네트워크 환경이 좋지 않습니다✨"
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            print("DeleteAlert Action Button")}
        let modifyPostCoverAction: UIAlertAction = UIAlertAction(title: "Modify", style: .default) { (alert) in
            let nextVC: PostViewController = PostViewController()
            nextVC.titleTV.text = self.getTitleTV.text
            nextVC.titleImage.image = self.getTitleImage.image
            nextVC.startDateButton.setTitle(self.userPostCoverData?.startDate, for: .normal)
            nextVC.endDateButton.setTitle(self.userPostCoverData?.endDate, for: .normal)
            nextVC.selectorContinentButton.setTitle(self.getContinentTV.text, for: .normal)
            nextVC.isEditingPostCover = true
            nextVC.editingPostCoverPk = self.postPk
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(modifyPostCoverAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Add Sub View Func
    private func allAddSubView() {
        self.view.addSubview(postTableView)
    }
    
    // MARK: Registe XIB
    private func setTableView() {
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(UINib(nibName: "TextViewXIB",bundle: nil),forCellReuseIdentifier: "TextViewCell")
        postTableView.register(UINib(nibName: "ImageViewXIB", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        postTableView.register(UINib(nibName: "HighlightTextViewXIB", bundle: nil), forCellReuseIdentifier: "HighlightTextViewCell")
        postTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // Set ParallexView
    // MARK: Set ParallexView
    func setParallax() {
        postTableView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.frame.size.width,
                                     height: self.view.frame.size.height)
        postTableView.parallaxHeader.view = self.getTitleImage
        let headerImageViewHeight: CGFloat = self.view.frame.height * 1.0
        postTableView.parallaxHeader.height = headerImageViewHeight
        postTableView.parallaxHeader.minimumHeight = 0
        postTableView.parallaxHeader.view.isUserInteractionEnabled = true 
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
                
                // BarItem[1] -> reply
                self.navigationController?.navigationBar.barTintColor = UIColor.colorConcept
            }
            
            // Post 스크롤시, blur 처리
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            self.getTitleTV.alpha = parallaxHeader.progress
            self.getDateTV.alpha = parallaxHeader.progress
            self.getContinentTV.alpha = parallaxHeader.progress
            self.getProfileImageButton.alpha = parallaxHeader.progress
            self.getProfileNickName.alpha = parallaxHeader.progress
        }
        
        // set parallaxHeaderView 의 하위계층 추가 및, layout 작업
        containViewInParallaxHeader()
    }
    
    // PostTableView 의 ParallaxHeaderView 추가하고, layout 설정
    // MARK: ContainVier In ParallaxHeader
    func containViewInParallaxHeader() {
        postTableView.parallaxHeader.view.addSubview(getTitleTV)
        postTableView.parallaxHeader.view.addSubview(getDateTV)
        postTableView.parallaxHeader.view.addSubview(getProfileImageButton)
        postTableView.parallaxHeader.view.addSubview(getProfileNickName)
        postTableView.parallaxHeader.view.addSubview(getContinentTV)
        
        // 각 타이틀 들, AutoLayout
        // MARK: Set Layout
        self.setLayoutMultiplier(target: getTitleTV,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 0.9,
                                 widthMultiplier: 1.0,
                                 heightMultiplier: 0.1)
        self.setLayoutMultiplier(target: getDateTV,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 1.0,
                                 widthMultiplier: 1.0,
                                 heightMultiplier: 0.05)
        self.setLayoutMultiplier(target: getContinentTV,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 1.08,
                                 widthMultiplier: 0.6,
                                 heightMultiplier: 0.05)
        self.setLayoutMultiplier(target: getProfileImageButton,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 1.2,
                                 widthMultiplier: 0.185,
                                 heightMultiplier: 0.07)
        // profileImageButton 원으로 고정!
        self.getProfileImageButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.getProfileImageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.setLayoutMultiplier(target: getProfileNickName,
                                 to: self.postTableView.parallaxHeader.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 1.30,
                                 widthMultiplier: 0.6,
                                 heightMultiplier: 0.05)
    }
}


// MARK: Extension tableViewDelegate, TablevEiw DataSource
extension MainDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDetailData?.postContents!.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postDetailData = self.postDetailData, self.postDetailData != nil else {return UITableViewCell()}
        let crushCell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let contentType: String = postDetailData.postContents![indexPath.row].contentType
        switch contentType {
        case "txt":
            print("txt")
            // Contents Type 가 text 일때, type 이 basic, highlight 인지 구분후, 적용
            // 일단 text 일때
            if postDetailData.postContents![indexPath.row].contents.type == "b" {
                let textCellOfTableView = tableView.dequeueReusableCell(withIdentifier: "TextViewCell") as! TextViewXIB
                let text = postDetailData.postContents![indexPath.row].contents.content
                textCellOfTableView.LabelOfPostTableViewCell.text = text
                tableView.rowHeight = UITableViewAutomaticDimension
                return textCellOfTableView
                // highlight 일떄!
            }else if postDetailData.postContents![indexPath.row].contents.type == "h" {
                print("highText")
                let highlightTextCellOfTableView = tableView.dequeueReusableCell(withIdentifier: "HighlightTextViewCell") as! HighlightTextViewXIB
                let text = postDetailData.postContents![indexPath.row].contents.content
                highlightTextCellOfTableView.LabelOfhighlightText.text = text
                tableView.rowHeight = UITableViewAutomaticDimension
                return highlightTextCellOfTableView
            }
        case "img":
            print("Image")
            let imageCellOfTableView = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewXIB
            
            imageCellOfTableView.imageViewOfPostTableViewCell.af_setImage(withURL: URL(string: postDetailData.postContents![indexPath.row].contents.photo!)!,
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 나일때만 접근 가능하게.
        if self.isAccessingOtherUser == false {
            let alertController: UIAlertController = UIAlertController(title: "POST DETAIL", message: "", preferredStyle: .actionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert) in
                // Text Type 에서 -> basic, highlight 타입으로 분기.
                
                print("일반 글자 타입")
                // 현재 삭제 쪽에 오류있음. 잠시 잠금
                Network.DeletePostContents.contentsInPost(postContentsPk: (self.postDetailData?.postContents![indexPath.row].contents.postContentPk)!,
                                                          completion: { (isSuccess) in
                                                            let alertController: UIAlertController = UIAlertController(title: "성공적으로 삭제 되었습니다✨", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                                            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                                                self.postDetailData?.postContents?.remove(at: indexPath.row)
                                                                self.postTableView.deleteRows(at: [indexPath], with: .fade)
                                                                self.postTableView.reloadData()
                                                            })
                                                            alertController.addAction(alertAction)
                                                            
                                                            // 삭제가 성공한 경우
                                                            if isSuccess {
                                                                DispatchQueue.main.async {
                                                                    self.present(alertController, animated: true, completion: nil)
                                                                }
                                                                // 삭제가 실패한 경우
                                                            }else {
                                                                self.convenienceAlert(alertTitle: "네트워크 환경이 좋지 않습니다✨")
                                                            }
                })
            })
            
            // Detail TableView 에서, 해당 cell 을 클릭했을때, 띄워주는 알럿, 수정에 해당 됨
            let modifyAction: UIAlertAction = UIAlertAction(title: "Modify", style: .default, handler: { (alert) in
                // Text Type 에서 -> basic, highlight 타입으로 분기.
                if self.postDetailData?.postContents![indexPath.row].contentType == "txt" {
                    if self.postDetailData?.postContents![indexPath.row].contents.type == "b" {
                        print("일반 글자 타입")
                        let nextVC: AddTextViewController = AddTextViewController()
                        nextVC.modifyTextPk = self.postDetailData?.postContents![indexPath.row].contents.pk
                        nextVC.textView.text = self.postDetailData?.postContents![indexPath.row].contents.content
                        nextVC.isEditingText = true
                        nextVC.modifyTextPk = self.postDetailData?.postContents![indexPath.row].contents.pk
                        let navigationViewController: UINavigationController = UINavigationController(rootViewController: nextVC)
                        self.present(navigationViewController, animated: true, completion: nil)
                    }else if self.postDetailData?.postContents![indexPath.row].contents.type == "h"{
                        print("강조 글자 타입")
                        let nextVC: AddHighlightTextViewController = AddHighlightTextViewController()
                        nextVC.modifyTextPk = self.postDetailData?.postContents![indexPath.row].contents.pk
                        nextVC.textView.text = self.postDetailData?.postContents![indexPath.row].contents.content
                        nextVC.isEditingText = true
                        nextVC.modifyTextPk = self.postDetailData?.postContents![indexPath.row].contents.pk
                        let navigationViewController: UINavigationController = UINavigationController(rootViewController: nextVC)
                        self.present(navigationViewController, animated: true, completion: nil)
                    }
                }else if self.postDetailData?.postContents![indexPath.row].contentType == "img" {
                    let addImagePickerController = ModifyImagePickerViewController()
                    addImagePickerController.delegate = self
                    addImagePickerController.photoPk = self.postDetailData?.postContents![indexPath.row].contents.pk
                    addImagePickerController.sourceType = .photoLibrary
                    addImagePickerController.navigationBar.tintColor = UIColor.white
                    addImagePickerController.navigationBar.barTintColor = UIColor.colorConcept
                    
                    let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                                          NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
                    addImagePickerController.navigationBar.titleTextAttributes = textAttributes
                    self.present(addImagePickerController, animated: true, completion: nil)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            alertController.addAction(modifyAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// image를 선택할떄 불리는 이미지 피커
// MARK: extension ImagePicker View
extension MainDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진을 선택 후 불리는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imgURL = info[UIImagePickerControllerImageURL] as? URL {
            if picker is ModifyImagePickerViewController{
                print("\(picker)일때 ModifyImagePickerViewController")
                let nextVC = AddImageViewController()
                nextVC.postImage.image = img
                nextVC.modifyPhotoPk = (picker as! ModifyImagePickerViewController).photoPk
                nextVC.isEditingPhoto = true
                nextVC.imgURL = imgURL
                picker.pushViewController(nextVC, animated: true)
            }else {
                // 이미지를 multipartform data 로 던지기 위해서, url 전달
                let nextVC = AddImageViewController()
                nextVC.postImage.image = img
                nextVC.toAddPostPk = self.postPk
                nextVC.imgURL = imgURL
                picker.pushViewController(nextVC, animated: true)
            }
        }
    }
    //취소했을때 불리는 델리게이트 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}






