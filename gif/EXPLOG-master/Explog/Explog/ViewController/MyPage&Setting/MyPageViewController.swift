//
//  MyPageViewController.swift
//  Explog
//
//  Created by 주민준 on 2017. 12. 4..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireImage
import ParallaxHeader
import Foundation


class MyPageViewController: UIViewController {
    
    // MARK: Contants - Username, UserEmail, ProfileImage 등등 
    fileprivate var containsView: UIView = {
        let v: UIView = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate var userNameLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "USER NAME"
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    fileprivate var userEmailLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "USER EMAIL"
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    fileprivate var profileImageView: UIImageView = {
        let img: UIImageView = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "logo_blue")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    // MARK: Follower & Following Button
    fileprivate var followerButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("0 FOLLOWER", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.tag = 1
        return btn
    }()
    
    fileprivate var followingButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("0 FOLLOWING", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.tag = 2
        return btn
    }()
    
    // MARK: Setting Button
    fileprivate var settingButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SETTING", for: .normal)
        btn.backgroundColor = UIColor(red:0.94,
                                      green:0.94,
                                      blue:0.96,
                                      alpha:1.00)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    // MARK: FollowingFeedButton
    fileprivate var followingFeedButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("FOLLOWING FEED", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    // MARK: 다른유저에게 접근했을때, Following Button
    fileprivate var otherUserFollowerButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Go Following💫", for: .normal)
        btn.backgroundColor = UIColor.colorConcept
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    // MARK: TableView
    open var underTableView: UITableView = {
        let tv: UITableView = UITableView()
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = true
        return tv
    }()
    
    // MARK: RefreshButton
    private var refreshButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "Refresh"), for: .normal)
        return btn
    }()
    
    // MARK: indicator
    private var indicator: UIActivityIndicatorView = {
        let indi: UIActivityIndicatorView = UIActivityIndicatorView()
        indi.activityIndicatorViewStyle = .gray
        indi.hidesWhenStopped = true
        indi.translatesAutoresizingMaskIntoConstraints = false
        return indi
    }()
    
    // MARK: UserProfile Data
    private var userProfileData: UserDataModel?
    
    // MARK: 다른유저가 접근했는지, 아닌지를 알려주는 Bool 값
    open lazy var isAccessingOtherUser: Bool = false
    open var otherUserPK: Int?
    
    // MARK: RaceCondition 방지하기 위한 SemaPhore
    private lazy var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Network Data Set
        // 기본적으로 그냥 부르고.
        setProfileData()
        
        // 기본 셋팅.
        view.backgroundColor = .white
        self.underTableView.delegate = self
        self.underTableView.dataSource = self
        // Set Add subView
        addsubView()
        
        // Register XIB
        setXIBfile()
        
        // Set Layout
        setLayout()
        
        // Set Button Taget Action
        setButtonTargetAction()
    }
    
    // MARK: 화면 전환시 지속적으로 데이터 체크.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set navigationController
        setNavigationController()
        print("--------------다른 유저상태 확인 \(isAccessingOtherUser)-------------")
        toAccessOtherUserAction(isEnable: isAccessingOtherUser)
        
        // 토큰이 있고, USER EMAIL 이 업데이트 되지 않았을때 호출
        // 다른 유저 Page 일때는 Refresh 호출 하지 않기 위해서 분리 해놓음.
        if isAccessingOtherUser == false{
            if AppDelegate.instance?.token != nil &&
                self.userEmailLabel.text == "USER EMAIL" {
                setProfileData()
                
                // 기존 정보 업데이트 되어 있고, LogOut 했을때 호출.
            }else if AppDelegate.instance?.token == nil &&
                self.userEmailLabel.text != "USER EMAIL"{
                self.view.layoutIfNeeded()
                resetUI()
                print("로그 아웃 이후, UI 처리 하는곳!")
            }else {
                print("현재 유저 정보 데이터는 업데이트 되어있음.")
                if AppDelegate.instance?.token != nil {
                    self.refreshButtonAction(self.refreshButton)
                    print("화면에 들어오면 refresh 실행. ")
                }
            }
        }else {
            self.setProfileData()
        }
        // 화면이 전환될때마다 refresh 버튼 실행
    }
    
    // 다른 유저가 접근했을때, 기본 셋팅, Navigation style 통일.
    private func toAccessOtherUserAction(isEnable: Bool) {
        if isEnable {
            // setting, refresh Button을 hide 해서 사용하지 않음.
            self.refreshButton.isHidden = true
            self.settingButton.isHidden = true
            self.followingFeedButton.isHidden = true
            self.otherUserFollowerButton.isHidden = false
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                    target: self,
                                                                    action: #selector(self.exitNaviBarAction(_:)))
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.tintColor = .colorConcept
        }else {
            // 다른 유저의 접근이 아닐때는, 함수를 탈출 하고, 반환함.
            self.otherUserFollowerButton.isHidden = true
            //return
        }
    }
    
    // MARK; Follwing & Follower Status Button
    private func initailFollowingButtonStatusTitle() {
        guard let userProfileData = self.userProfileData,
            let mypk = AppDelegate.instance?.userPK else {return}
        
        var followerPkList: [Int] = [Int]()
        var followingPkList: [Int] = [Int]()
        
        for followerUser in userProfileData.followers {
            followerPkList.append(followerUser.pk)
        }
        
        for followingUser in userProfileData.followingUsers {
            followingPkList.append(followingUser.pk)
        }
        print("mypk is \(mypk), userfollowingList \(followingPkList), userfollowerList is \(followerPkList)")
        
        // 다른 유저의 follower 리스트에 내가 있으면, 이 유저는 나를 팔로우 하는사람.
        if followingPkList.contains(mypk) && followerPkList.contains(mypk) {
            self.otherUserFollowerButton.setTitle("맞팔 중입니다✨", for: .normal)
        }else if followingPkList.contains(mypk) {
            self.otherUserFollowerButton.setTitle("FOLLOWER🐳", for: .normal)
        }else if followerPkList.contains(mypk) {
            self.otherUserFollowerButton.setTitle("FOLLOWING💫", for: .normal)
        }
    }
    
    // MARK: Exit NavigationBar Button
    @objc func exitNaviBarAction(_ sender: UIBarButtonItem) {
        print("다른 유저를 통해서 접근했을때 navigationBar 생성")
        self.navigationController?.navigationBar.tintColor = .white
        // followerViewController -> PostDetailViewController 전환시, Navigation Style를 맞추어 주기 위해서 실행.
        self.navigationController?.setNavigationBackgroundColor()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Set NavigationController
    private func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.tabBarController?.tabBar.tintColor = UIColor.colorConcept
    }
    
    // MARK: AddsubView Method
    private func addsubView(){
        view.addSubview(containsView)
        view.addSubview(underTableView)
        view.addSubview(refreshButton)
        view.addSubview(indicator)
        indicator.bringSubview(toFront: underTableView)
        refreshButton.bringSubview(toFront: underTableView)
        containsView.addSubview(userNameLabel)
        containsView.addSubview(userEmailLabel)
        containsView.addSubview(profileImageView)
        containsView.addSubview(followerButton)
        containsView.addSubview(followingButton)
        containsView.addSubview(settingButton)
        containsView.addSubview(followingFeedButton)
        containsView.addSubview(otherUserFollowerButton)
    }
    
    // MARK: set XIB file
    private func setXIBfile() {
        let XIB = UINib(nibName: "CustomTableViewCell", bundle: nil)
        underTableView.register(XIB, forCellReuseIdentifier: "cell")
    }
    
    // MARK: Set Layout underTableView, ParallaxHeaderView
    private func setLayout() {
        // tableview 와, ContainView 7:3 정렬
        underTableView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: self.view.frame.size.width,
                                      height: self.view.frame.size.height)
        underTableView.parallaxHeader.view = self.containsView
        underTableView.parallaxHeader.height = self.view.frame.height * 0.6
        underTableView.parallaxHeader.minimumHeight = 0
        underTableView.parallaxHeader.mode = .centerFill
        underTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            self.containsView.alpha = parallaxHeader.progress
        }
        setLayoutOfContents()
    }
    
    // MARK: Set Layout contentns
    private func setLayoutOfContents() {
        // 유저 네임
        self.setLayoutMultiplier(target: self.userNameLabel,
                                 to: self.containsView,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 0.2,
                                 widthMultiplier: 0.5,
                                 heightMultiplier: 0.05)
        // 유저 이미지
        self.setLayoutMultiplier(target: self.profileImageView,
                                 to: self.containsView,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 0.5,
                                 widthMultiplier: 0.25,
                                 heightMultiplier: 0.20)
        self.profileImageView.layer.cornerRadius = 25
        // 유저 이메일
        self.setLayoutMultiplier(target: self.userEmailLabel,
                                 to: self.containsView,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 0.8,
                                 widthMultiplier: 0.5,
                                 heightMultiplier: 0.05)
        // 팔로워
        self.setLayoutMultiplier(target: self.followerButton,
                                 to: self.containsView,
                                 centerXMultiplier: 0.6,
                                 centerYMultiplier: 1.2,
                                 widthMultiplier: 0.4,
                                 heightMultiplier: 0.14)
        // 팔로잉
        self.setLayoutMultiplier(target: self.followingButton,
                                 to: self.containsView,
                                 centerXMultiplier: 1.4,
                                 centerYMultiplier: 1.2,
                                 widthMultiplier: 0.4,
                                 heightMultiplier: 0.14)
        // 팔로잉 피드 버튼
        self.setLayoutMultiplier(target: self.followingFeedButton,
                                 to: self.containsView,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 1.55,
                                 widthMultiplier: 0.6,
                                 heightMultiplier: 0.08)
        // 셋팅 버튼
        self.setLayoutMultiplier(target: self.settingButton,
                                 to: self.containsView,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 1.75,
                                 widthMultiplier: 0.4,
                                 heightMultiplier: 0.08)
        // 다른사람이 나를 팔로우 팔로잉 하는 버튼, 해당 버튼은, settingButton 이랑 같은위치에 놓음, 대신 둘중에 하나만 사용됨
        self.setLayoutMultiplier(target: self.otherUserFollowerButton,
                                 to: self.containsView,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 1.6,
                                 widthMultiplier: 0.4,
                                 heightMultiplier: 0.08)
        // RefreshButton Layout
        refreshButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        refreshButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        // indicator
        self.setLayoutMultiplier(target: self.indicator,
                                 to: self.view,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 1,
                                 widthMultiplier: 0.1,
                                 heightMultiplier: 0.1)
    }
    
    // MARK: Set Button TagetAction
    private func setButtonTargetAction() {
        self.followerButton.addTarget(self,
                                      action: #selector(self.followerButtonAction(_:)),
                                      for: .touchUpInside)
        self.followingButton.addTarget(self,
                                       action: #selector(self.followingButtonAction(_:)),
                                       for: .touchUpInside)
        self.settingButton.addTarget(self,
                                     action: #selector(self.settingButtonAction(_:)),
                                     for: .touchUpInside)
        self.followingFeedButton.addTarget(self,
                                           action: #selector(self.followingFeedButtonAction(_:)),
                                           for: .touchUpInside)
        self.otherUserFollowerButton.addTarget(self,
                                               action: #selector(self.otherFollowingButtonAction(_:)),
                                               for: .touchUpInside)
        self.refreshButton.addTarget(self,
                                     action: #selector(self.refreshButtonAction(_:)),
                                     for: .touchUpInside)
    }
    
    // MARK: 새로운 어떤값(Post 추가, 혹은 변경) 되었을때, UserData를 Update 하도록 해줌
    @objc private func refreshButtonAction(_ sender: UIButton) {
        sender.rotate()
        print("-------------RefreshAction! Strat ----------")
        guard let userprofileDatas = self.userProfileData else {sender.stopZRotation();return}
        print("RefreshAction!--------------> 안으로 들어옴.")
        // Login 이 되어있을때 만 동작할수 있도록
        if AppDelegate.instance?.token != nil {
            let token = AppDelegate.instance?.token
            Network.User.profile(userToken: token, completion: { (isSuccess, data) in
                let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                    self.userProfileData = data
                    // 유저의 데이터가 없을 경우에는, 리턴 혹은 다른 방도 고민 하고 적용해주자.
                    print("------------유저의 데이터를 사용하기 바로직전---------------")
                    guard let data = data else {return}
                    // Server 에서 받아온 post 정보
                    self.userProfileData?.posts = data.posts
                    // UserProfile img 가 다르면 변경
                    if userprofileDatas.imgProfile != data.imgProfile {
                        self.userProfileData?.imgProfile = data.imgProfile
                    }
                    
                    DispatchQueue.main.async {
                        self.underTableView.reloadData()
                        // Button Label 반영
                        let followerString = (String(describing: self.userProfileData!.followernumber)) + " FOLLOWER"
                        let follwingString = (String(describing: self.userProfileData!.followingnumber)) + " FOLLOWING"
                        self.followerButton.setTitle(followerString,
                                                     for: .normal)
                        self.followingButton.setTitle(follwingString,
                                                      for: .normal)
                        self.userNameLabel.text = self.userProfileData?.username
                        
                        if let imageURL = URL(string: (self.userProfileData?.imgProfile)!) {
                            self.profileImageView.af_setImage(withURL: imageURL,
                                                              placeholderImage: UIImage(),
                                                              filter: nil,
                                                              progress: nil,
                                                              progressQueue: DispatchQueue.main,
                                                              imageTransition: .crossDissolve(0.5),
                                                              runImageTransitionIfCached: false)
                        }
                        sender.stopZRotation()
                    }
                })
                DispatchQueue.global().async(execute: asyncItem)
            })
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: following, follower 버튼은 아직 미설정..
    @objc private func followingButtonAction(_ sender: UIButton) {
        print("followingbuttonAction 연결 완료")
        let nextVC: FollowerViewController = UIStoryboard(name: "Tab5",
                                                          bundle: nil).instantiateViewController(withIdentifier: "FollowerViewController") as! FollowerViewController
        nextVC.followingData = self.userProfileData?.followingUsers
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func followerButtonAction(_ sender: UIButton) {
        print("followergbuttonAction 연결 완료")
        let nextVC: FollowerViewController = UIStoryboard(name: "Tab5",
                                                          bundle: nil).instantiateViewController(withIdentifier: "FollowerViewController") as! FollowerViewController
        nextVC.followerData = self.userProfileData?.followers
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: SettingButtonAction
    @objc private func settingButtonAction(_ sender: UIButton) {
        print("button 버튼 연결 완료")
        // Setting 에 접근하기위해서 토큰 유무 체크.
        if AppDelegate.instance?.token != nil {
            let nextVC: MyPageDetailSettingViewController = UIStoryboard(name: "Tab5",
                                                                         bundle: nil).instantiateViewController(withIdentifier: "MyPageDetailSettingViewController") as! MyPageDetailSettingViewController
            nextVC.userProfileData = self.userProfileData
            let naviVC = UINavigationController(rootViewController: nextVC)
            present(naviVC, animated: true, completion: nil)
        }else {
            self.loginAlertMessage()
        }
    }
    
    // MARK: SettingButtonAction
    @objc private func followingFeedButtonAction(_ sender: UIButton) {
        print("button 버튼 연결 완료")
        let nextVC: FollowingFeedViewController = UIStoryboard(name: "Tab5",
                                                               bundle: nil).instantiateViewController(withIdentifier: "FollowingFeedViewController") as! FollowingFeedViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: 다른 사람이 팔로잉 할때 사용되는 버튼
    @objc private func otherFollowingButtonAction(_ sender: UIButton) {
        guard let userPrivateKey = self.otherUserPK else {return}
        Network.User.followerAndFollowing(targetUser:  userPrivateKey, completion: { (isSuccess, data) in
            print("FollwerAndFollowing API Data \(String(describing: data))")
            // API 요청이 성공한 경우
            if isSuccess {
                // unfollowing 인지 아닌지 체크, 아닐경우 상태 변환 해주자.
                // unfollowing 값이 있을때와 없을때를 가지고 분기 처리함.
                if data?.unfollowing != nil {
                    sender.setTitle("UNFOLLOWING💦", for: UIControlState.normal)
                    // unfollowing 해야하는경우..!
                }else {
                    sender.setTitle("FOLLOWING💫", for: UIControlState.normal)
                }
                // API 요청이 실패한 경우
            }else {
                print("팔로우, 팔로잉 API 요청이 실패 했습니다.")
            }
        })
        print("otherFollowingButtonAction 버튼 연결 완료")
    }
    
    // MARK: Set ProfileData by NetWork
    private func setProfileData() {
        self.indicator.startAnimating()
        // 나의 profile Data 를 load 함
        if self.isAccessingOtherUser == false {
            guard let token = AppDelegate.instance?.token else {return}
            Network.User.profile(userToken: token) { (isSuccess, data) in
                // USer API 요청이 성공한 경우
                if isSuccess {
                    // 기본 데이터들을 set 하고, imagecacsh 를 이용해서, 이미지를 따로 저장 -> 사용해보자
                    self.userProfileData = data
                    let asyncItem: DispatchWorkItem = DispatchWorkItem(block: {[unowned self] in
                        DispatchQueue.main.async {
                            self.userNameLabel.text = self.userProfileData?.username
                            guard let userProfileData = self.userProfileData else {return}
                            self.profileImageView.af_setImage(withURL: URL(string: userProfileData.imgProfile!)!,
                                                              placeholderImage: UIImage(),
                                                              filter: nil,
                                                              progress: nil,
                                                              progressQueue: DispatchQueue.main,
                                                              imageTransition: .crossDissolve(0.5),
                                                              runImageTransitionIfCached: false)
                            self.userEmailLabel.text = userProfileData.email
                            let followerString = (String(describing: userProfileData.followernumber)) + " FOLLOWER"
                            let follwingString = (String(describing: userProfileData.followingnumber)) + " FOLLOWING"
                            self.followerButton.setTitle(followerString,
                                                         for: .normal)
                            self.followingButton.setTitle(follwingString,
                                                          for: .normal)
                            
                            // 유저의 Post TableView Reload Data
                            self.indicator.stopAnimating()
                            self.underTableView.reloadData()
                        }
                    })
                    // Data Set 을 Global 에서 하게함.
                    DispatchQueue.global().async(execute: asyncItem)
                    // User API 요청이 실패한 경우
                }else {
                }
            }
            // 다른 User 의 ProfileData 를 로드함!
        }else {
            Network.User.profile(userToken: AppDelegate.instance?.token, otherUser: self.otherUserPK) { (isSuccess, data) in
                self.userProfileData = data
                let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                    // API 요청이 성공한 경우!
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.userNameLabel.text = self.userProfileData?.username
                            guard let userProfileData = self.userProfileData else {return}
                            
                            self.profileImageView.af_setImage(withURL: URL(string: userProfileData.imgProfile!)!,
                                                              placeholderImage: UIImage(),
                                                              filter: nil,
                                                              progress: nil,
                                                              progressQueue: DispatchQueue.main,
                                                              imageTransition: .crossDissolve(0.5),
                                                              runImageTransitionIfCached: false)
                            self.userEmailLabel.text = userProfileData.email
                            let followerString = (String(describing: userProfileData.followernumber)) + " FOLLOWER"
                            let follwingString = (String(describing: userProfileData.followingnumber)) + " FOLLOWING"
                            self.followerButton.setTitle(followerString,
                                                         for: .normal)
                            self.followingButton.setTitle(follwingString,
                                                          for: .normal)
                            
                            // 유저의 Post TableView Reload Data
                            self.indicator.stopAnimating()
                            // followingButtonStatus Setting
                            self.initailFollowingButtonStatusTitle()
                            self.underTableView.reloadData()
                        }
                        // API 요청이 실패한 경우!
                    }else {
                    }
                })
                DispatchQueue.global().async(execute: asyncItem)
            }
        }
    }
    
    // Logout 했을때, 기존에 정보들 초기화..!
    // MARK: resetUI
    private func resetUI() {
        self.userNameLabel.text = "USER NAME"
        self.profileImageView.image = #imageLiteral(resourceName: "logo_blue")
        self.userEmailLabel.text = "USER EMAIL"
        self.followerButton.setTitle("0 FOLLOWER",
                                     for: .normal)
        self.followingButton.setTitle("0 FOLLOWING",
                                      for: .normal)
        self.userProfileData = nil
        self.underTableView.reloadData()
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // UserProfiledData 의 Post 의 개수로, tableViewCell의 개수 정의해놓음..!
        return self.userProfileData?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        guard let userProfiledata = self.userProfileData, userProfileData != nil else {return UITableViewCell()}
        cell.title.text = userProfiledata.posts[indexPath.row].title
        cell.dateTitle.text = userProfiledata.posts[indexPath.row].startDate + " ~ " + userProfiledata.posts[indexPath.row].endDate
        cell.nickNameTitle.text = userProfiledata.username
        cell.numberOfLikeLabel.text = String(describing: userProfiledata.posts[indexPath.row].numLiked)
        
        // 내가 좋아요 누른게 있다면, 좋아요 반영!
        if (userProfileData?.posts[indexPath.row].liked.contains((AppDelegate.instance?.userPK)!))! {
            cell.likeImageView.image = #imageLiteral(resourceName: "like")
        }else {
            cell.likeImageView.image = #imageLiteral(resourceName: "unlike_3")
        }
        
        // MARK: 서버의 기본 이미지 사용시, Category API 에서는 URL 이 들어오는데, 해당 User의 Pk로, UserPK API 요청하면, 서버에서 사용된 이미지가 null 이됨....
        if userProfiledata.posts[indexPath.row].img != nil {
            cell.backGroundImageView.af_setImage(withURL: URL(string: userProfiledata.posts[indexPath.row].img!)!,
                                                     placeholderImage: UIImage(),
                                                     filter: nil,
                                                     progress: nil,
                                                     progressQueue: DispatchQueue.main,
                                                     imageTransition: .crossDissolve(0.5),
                                                     runImageTransitionIfCached: false)
                print("유저프로파일 테이블뷰에서 사용되는, 이미지 캐시 인덱싱 번호, otherUser_image_Index_\(indexPath.row)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight: CGFloat = 150
        return tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // UserProfiled Data 가 nil이 아닐때 호출.
        guard let userProfileData = self.userProfileData else {return}
        
        let nextVC = MainDetailViewController()
        // CoverData 를 넘겨 주자
        nextVC.userPostCoverData = userProfileData.posts[indexPath.row]
        nextVC.postPk = userProfileData.posts[indexPath.row].pk
        nextVC.userProfileImage = userProfileData.imgProfile
        nextVC.usernickName = userProfileData.username
        // 현재 페이지에서 다른유저의 접근인지 아닌지 체크합니다. 체크후, 다음페이지로 가기전에, 다른 유저로 접근인지 아닌지 확인후, ToglleButton을 생성할지, 생성하지 않을지 결정합니다.
        if self.isAccessingOtherUser == true {
            nextVC.isAccessingOtherUser = true
        }else {
            nextVC.isAccessingOtherUser = false
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: Delete TableView Cell -> 실제 데이터와, 유저 서버 데이터를 같이 지워야함.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 다른 유저를 통해서 접근했을때는, 실행을 하지 않도록 방지.
        if isAccessingOtherUser {
            let notDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "NO", handler: { (action, index) in
                self.convenienceAlert(alertTitle: "다른 사람의 포스트는 삭제할수 없습니다✨")
            })
            notDeleteButton.backgroundColor = .red
            return [notDeleteButton]
        }
        
        guard let postPk = self.userProfileData?.posts[indexPath.row].pk else {return nil}
        // Closure 안에, NetWork 통신을 통해서, 삭제 액션을 취해줌!
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            Network.Delete.post(postPk: postPk) { (isSuccess, data) in
                self.indicator.startAnimating()
                if isSuccess {
                    DispatchQueue.main.async {
                        self.userProfileData?.posts.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.indicator.stopAnimating()
                        self.convenienceAlert(alertTitle: "포스트가 삭제되었습니다✨")
                        //imageCache 에서 이미지 삭제!
                        self.refreshButtonAction(self.refreshButton)
                    }
                }else {
                    self.convenienceAlert(alertTitle: "네트워크 환경이 좋지 않습니다✨")
                    self.indicator.stopAnimating()
                }
            }
        } 
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}



