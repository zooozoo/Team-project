//
//  FollowerViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 28..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class FollowerViewController: UIViewController {
    
    // MARK: TableView, Follower & following Data
    @IBOutlet weak var tableView: UITableView!
    open var followerData: [followerDataModel]?
    open var followingData: [followingDataModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set NavigationController
        setNavigationController()
        
        // TableView setting
        setTableView()
        
    }
    
    // MARK: setTableView
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FollowerTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FollowerTableViewCell")
    }
    
    // MARK: setNavigationController
    private func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        
        if self.followerData != nil {
            self.navigationItem.title = "FOLLOWER"
        }else {
            self.navigationItem.title = "FOllOWING"
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.exitNaviButtonAction(_:)))
        // title 색상 white 로 변경.
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorConcept
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func exitNaviButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.navigationBar.isTranslucent = false
        // navigationBar 의 color 를 사용하지 않는다면 nil을 넣어주자.
        self.navigationController?.navigationBar.barTintColor = nil
        // navigationBar의 아이템 색상 변경 완료, navigationBar의 background 색상 변경하면됨.
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: followerButton Action!
    @objc func followerButton(_ sender: UIButton) {
        print("sender.tag is \(sender.tag)")
        // 하나의 ViewController로, 두개의 화면일때를 컨트롤하기위해서, privateKey 를 나누어 주었습니다.
        var userPrivateKey: Int!
        if self.followerData != nil {
            userPrivateKey = self.followerData![sender.tag].pk
        }else if self.followingData != nil {
            userPrivateKey = self.followingData![sender.tag].pk
        }
        
        // follower,follwing text 를 가지고 분기처리.
        if sender.titleLabel?.text == "FOLLOWER🐳" ||
            sender.titleLabel?.text == "FOLLOWING💫" ||
            sender.titleLabel?.text == "UNFOLLOWING💦"{
            Network.User.followerAndFollowing(targetUser:  userPrivateKey, completion: { (isSuccess, data) in
                print("followerAndFollowing API \(String(describing: data))")
                // API 요청이 성공한 경우
                if isSuccess {
                    // unfollowing 인지 아닌지 체크, 아닐경우 상태 변환 해주자.
                    // unfollowing 값이 있을때와 없을때를 가지고 분기 처리함.
                    if data?.unfollowing != nil {
                        sender.backgroundColor = UIColor.colorConcept
                        sender.tintColor = .white
                        sender.setTitle("UNFOLLOWING💦", for: UIControlState.normal)
                        // unfollowing 해야하는경우..!
                    }else {
                        sender.backgroundColor = UIColor.colorConcept
                        sender.tintColor = .white
                        sender.setTitle("FOLLOWING💫", for: UIControlState.normal)
                    }
                    // API 요청이 실패한 경우
                }else {
                    print("팔로우, 팔로잉 API 요청이 실패 했습니다.")
                }
            })
        }
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension FollowerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.followerData != nil {
            let followerDataCount = self.followerData?.count ?? 0
            return followerDataCount
        }else {
            let followingDataCount = self.followingData?.count ?? 0
            return followingDataCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowerTableViewCell", for: indexPath) as! FollowerTableViewCell
        if self.followerData != nil {
            if let followerData = self.followerData {
                cell.nickNameLabel.text = followerData[indexPath.row].username
                cell.emailLabel.text = followerData[indexPath.row].email
                cell.profileImageView.af_setImage(withURL: URL(string:followerData[indexPath.row].imgProfile)!,
                                                  placeholderImage: UIImage(),
                                                  filter: nil,
                                                  progress: nil,
                                                  progressQueue: DispatchQueue.main,
                                                  imageTransition: .crossDissolve(0.5),
                                                  runImageTransitionIfCached: false)
                // follower 버튼 연결
                cell.followerButton.tag = indexPath.row
                cell.followerButton.setTitle("FOLLOWER🐳", for: UIControlState.normal)
                cell.followerButton.addTarget(self,
                                              action: #selector(self.followerButton(_:)),
                                              for: UIControlEvents.touchUpInside)
            }
        }else if self.followingData != nil {
            if let followingData = self.followingData {
                cell.nickNameLabel.text = followingData[indexPath.row].username
                cell.emailLabel.text = followingData[indexPath.row].email
                cell.profileImageView.af_setImage(withURL: URL(string:followingData[indexPath.row].imgProfile)!,
                                                  placeholderImage: UIImage(),
                                                  filter: nil,
                                                  progress: nil,
                                                  progressQueue: DispatchQueue.main,
                                                  imageTransition: .crossDissolve(0.5),
                                                  runImageTransitionIfCached: false)
                // Cell Button Tag 값을 가지고 구분.
                cell.followerButton.tag = indexPath.row
                cell.followerButton.setTitle("FOLLOWING💫", for: UIControlState.normal)
                cell.followerButton.addTarget(self,
                                              action: #selector(self.followerButton(_:)),
                                              for: UIControlEvents.touchUpInside)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 120
        return cellHeight
    }
}

