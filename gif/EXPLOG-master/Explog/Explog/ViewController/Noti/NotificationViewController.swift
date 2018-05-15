//
//  NotificationViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 12..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notiTableView: UITableView!
    fileprivate var notificationData: PushListDataModel?
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView Delegate, DataSource 설정
        notiTableView.delegate = self
        notiTableView.dataSource = self

        // Registe XIB
        let notiXIB = UINib(nibName: "NotiTableViewCell", bundle: nil)
        notiTableView.register(notiXIB, forCellReuseIdentifier: "NotiCell")
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("pushNotification"),
                                               object: nil,
                                               queue: nil) { (userInfo) in
                                                print("Pushnoti 받았다!")
                                                
                                                let tabbarBadgeNumber: String = String(((userInfo.object as! [String:Any])["aps"] as! [String:Any])["badge"] as! Int)
                                                self.tabBarItem.badgeValue = tabbarBadgeNumber
                                                UIApplication.shared.applicationIconBadgeNumber = Int(tabbarBadgeNumber)!
        }
    }
    
    // Cureent Badge Number 를 초기화 시켜주는 API 호출 & 사용되어질 Noti Data API 호출.
    // 화면이 보일때마다, 새롭게 API CALL 을 해주자.
    override func viewWillAppear(_ animated: Bool) {
        // Noti Data API CALL
        Network.PushNotification.notificationDataList { (isSuccess, data) in
            self.indicator.startAnimating()
            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: {[unowned self] in
                guard let data = data, data.count! > 0 else {return}
                self.notificationData = data
                DispatchQueue.main.async {
                    self.notiTableView.reloadData()
                    print("테이블뷰 리로드 데이터!")
                }
            })
            
            DispatchQueue.global().async(execute: asyncItem)
        }
    }
    
    // 화면이 보였을때, badgeNumber 를 초기화 해주고.
    override func viewDidAppear(_ animated: Bool) {
        Network.PushNotification.resetBadgeNumberInServer { (isSuccess, data) in
            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                if isSuccess {
                    print("성공적으로 badgeNumber 리셋!-> 추후에, AppBadgeNumber, NavigationBar Number 수정을 여기서 해주면 될것 같음.")
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.tabBarItem.badgeValue = nil
                        UIApplication.shared.applicationIconBadgeNumber = 0 
                    }
                }else {
                    print("badgeNumber 리셋실패!")
                }
                
            })
            DispatchQueue.global().async(execute: asyncItem)
        }
    }
    
    private func bottomeScrollingreloadTableView() {
        guard let nextURL = self.notificationData?.next, self.notificationData?.next != nil else {return}
        Network.PushNotification.notificationDataList(nextURL: nextURL) { (isSuccess, data) in
            print("NEXT URL 이 NIL 이 아니면, 다음 줄 호출")
            guard let dataNextURL = data?.next, data?.next != nil else {return}
            self.indicator.startAnimating()
            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                guard let data = data, data.count != 0 else {return}
                if isSuccess {
                    for item in data.results! {
                        self.notificationData?.results?.append(item)
                        self.notificationData?.count! += data.count!
                        if data.next != nil {
                            self.notificationData?.next = dataNextURL
                        }
                    }
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.notiTableView.reloadData()
                    }
                    
                }else {
                    self.indicator.stopAnimating()
                    print("noti User 추가 데이터 불러오기실패 ㅠㅠ")
                }
            })
            DispatchQueue.global().async(execute: asyncItem)
        }
    }
    
    // 예기치 못한 오류가 발생할수 있으니, 사용한 Notification은, 사용하지않을때 삭제해줌.
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("옵져버 삭제!")
    }
}

// MARK: TableViewDelete, TableViewDataSource
extension NotificationViewController: UITableViewDelegate,UITableViewDataSource {
    
    // TableView Row 개수 설정
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationData?.results?.count ?? 0
    }
    
    // TableView Date 설정
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotiTableViewCell
        guard let notificationData = self.notificationData, ((self.notificationData?.count!)! > Int(0)) else {return UITableViewCell()}
        
        let userProfileImageIdentifier: String = notificationData.results![indexPath.row].author.imgProfile
        
        cell.profileImage.af_setImage(withURL: URL(string: userProfileImageIdentifier)!,
                                      placeholderImage: UIImage(),
                                      filter: nil,
                                      progress: nil,
                                      progressQueue: DispatchQueue.main,
                                      imageTransition: .crossDissolve(0.5),
                                      runImageTransitionIfCached: false)
        
        let pickUserName: String = notificationData.results![indexPath.row].author.username
        let pickedTitle: String = notificationData.results![indexPath.row].posttitle
        let notiMessage: String = "\(pickUserName) 님이 `\(pickedTitle)` 포스트를 좋아합니다"
        cell.statusMessageLabel.text = notiMessage
        cell.dateLabel.text = notificationData.results![indexPath.row].likedDate
        
        let lastIndexPath: IndexPath = IndexPath(row: (notificationData.results?.count)!-1,
                                                 section: 0)
        
        if indexPath == lastIndexPath {
            // call someMethod
            bottomeScrollingreloadTableView()
            print("마지막 indexPath")
        }
        return cell
    }
    
    // TableView HegihtOfRow 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let hegihtOfRow: CGFloat = 140
        return hegihtOfRow
    }
    
    // title 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfsection = 1
        return numberOfsection
    }
    
    // title 이름 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "새로운 알림"
        return title
    }
}
