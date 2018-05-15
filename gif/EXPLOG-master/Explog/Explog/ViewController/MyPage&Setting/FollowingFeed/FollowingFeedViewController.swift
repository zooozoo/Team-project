//
//  FollowingFeedViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2018. 1. 4..
//  Copyright © 2018년 becomingmacker. All rights reserved.
//

import UIKit
import Foundation

class FollowingFeedViewController: UIViewController {

    // MARK: TableView & Indicator
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: FollowingFeed Data
    var followingFeedData: FollowingFeedDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidesWhenStopped = true
        // Set TableView
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavigationController()
        guard let token = AppDelegate.instance?.token else {return}
        self.indicator.startAnimating()
        Network.User.followingFeed(userToken: token) { (isSuccess, data) in
            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                if isSuccess {
                    self.followingFeedData = data
                    if data != nil {
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }else {
                    self.indicator.stopAnimating()
                }
            })
            DispatchQueue.global().async(execute: asyncItem)
        }
    }
    
    // MARK: setNavigationController
    private func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "FOLLOWING FEED"
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
    
    // back Navigation Button 을 눌렀을때, Navigation 셋팅.
    // MARK: ExitNavigationButton
    @objc func exitNaviButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.navigationBar.isTranslucent = false
        // navigationBar 의 color 를 사용하지 않는다면 nil을 넣어주자.
        self.navigationController?.navigationBar.barTintColor = nil
        // navigationBar의 아이템 색상 변경 완료, navigationBar의 background 색상 변경하면됨.
        self.navigationController?.popViewController(animated: false)
    }

    // MARK: setTableView
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "cell")
    }
}

// MARK: TableViewDelete & TableViewDataSource
extension FollowingFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRow = self.followingFeedData?.followingPosts.count ?? 0
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let followingFeedData = self.followingFeedData else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let date = followingFeedData.followingPosts[indexPath.row].startDate + " ~ " + followingFeedData.followingPosts[indexPath.row].endDate
        if let imgIdentifer: String = followingFeedData.followingPosts[indexPath.row].img {
            cell.backGroundImageView.af_setImage(withURL: URL(string:imgIdentifer)!,
                                                 placeholderImage: UIImage(),
                                                 filter: nil,
                                                 progress: nil,
                                                 progressQueue: DispatchQueue.main,
                                                 imageTransition: .crossDissolve(0.5),
                                                 runImageTransitionIfCached: false)
        }
        
        cell.title.text = followingFeedData.followingPosts[indexPath.row].title
        cell.dateTitle.text = date
        cell.nickNameTitle.text = followingFeedData.followingPosts[indexPath.row].author.username
        cell.numberOfLikeLabel.text = String(followingFeedData.followingPosts[indexPath.row].numLiked)
        if followingFeedData.followingPosts[indexPath.row].liked.contains((AppDelegate.instance?.userPK)!) {
            cell.likeImageView.image = #imageLiteral(resourceName: "like")
        }else {
            cell.likeImageView.image = #imageLiteral(resourceName: "unlike")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let followingFeedData = self.followingFeedData else {return}
        let nextVC = MainDetailViewController()
        // detailPost 로 가기위해서, 현재 가지고 있는 표지 정보와, pk 값을 넘겨주고, 나머지 부분을 DetailViewController 에서 처리 할수 있게 해줌.
        nextVC.postCoverData = followingFeedData.followingPosts[indexPath.row]
        nextVC.postPk = followingFeedData.followingPosts[indexPath.row].pk
        nextVC.otherUserPk = followingFeedData.followingPosts[indexPath.row].author.pk
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 150
        return cellHeight
    }
}
