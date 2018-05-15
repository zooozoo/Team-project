//
//  ViewController.swift
//  Test
//
//  Created by JU MIN JUN on 2017. 12. 1..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MainViewController: UIViewController {
    // MARK: IBOutlet 으로 정의한 ScrollView Top, Bottom
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    // MARK: Image, CurrentIndex, imageView, TableView 변수
    lazy var images : [UIImage] = [#imageLiteral(resourceName: "Asia"), #imageLiteral(resourceName: "Europe"), #imageLiteral(resourceName: "North America"), #imageLiteral(resourceName: "South America"), #imageLiteral(resourceName: "Africa"), #imageLiteral(resourceName: "Austrailia")]
    lazy var currentIndex: Int = 0
    lazy var imageViews: [UIImageView] = [UIImageView]()
    lazy var tableViews: [UITableView] = [UITableView]()
    
    // MARK: Continent Data
    var asiaData: MainDataModel?
    var europeData: MainDataModel?
    var northAmericaData: MainDataModel?
    var southAmericaData: MainDataModel?
    var AfricaData: MainDataModel?
    var oceaniaData: MainDataModel?
    var dataManager: [MainDataModel]?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // NavigationViewController hide, 두개의 차이 다시 한번 찾아보자.
        self.navigationController?.isNavigationBarHidden = true

        // 인디케이터 속성 추가
        self.indicator.hidesWhenStopped = true
        self.indicator.activityIndicatorViewStyle = .gray
        
        // 대륙별 데이터 초기화.
        setContinentData()
        
        // 스크롤뷰의 Delegate 를 MainViewController 에 추가
        topScrollView.delegate = self
        topScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        bottomScrollView.delegate = self
        bottomScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // ImageView와 tableView 생성
        makeContinentsSelection()
        makeContinentTableView()
        
        // top, bottom Layout 생성
        layoutContinentsSelection()
        layoutContinentTableView()
        
        
    }
    
    // MARK: tab을 통해서 다른 ViewController 이동후, 돌아왔을때 새로운 데이터 있으면 추가.
    // 현재 추가되어야 하는 사항으로, Like Number, contents의 IndexPath를 새로 추가된 글로 넣을것인지 판단후 적용
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 해당 화면에 왔을때, 새로운 data가 추가되었나 체크!
        // 처음에 로드할때 실행되는것을 방지하기 위해서, DataManger 가 nil, 그리고 indicator 활성화 되지 않을때만 실행됨!
        if dataManager != nil,
            self.indicator.isAnimating == false  {
            pullRefreshAction(refreshButton)
        }
    }
    
    // Post 에 갔다가, 돌아왔을때, navigationController 없어지는 현상 방지.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: Check Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("이녀석이 호출 되면..... memory..")
    }
    
    // Network 를 통해서 각각 대륙별 데이터 업로드
    func setContinentData() {
        self.indicator.startAnimating()
        self.dataManager = []
        // 원인 찾아냈음.. for 문에서 item에 넣는 값이 1~6으로 들어가지 않음.. 뭐지?
        for item in 1..<7 {
            Network.Main.category(tagNum: item) { (data) in
                self.dataManager?.append(data)
                print("대륙 데이터 들어가는 순서 \(data.posts[0].continent), 이때의 item 값, URL 요청값 \(item)")
                if self.dataManager?.count == 6 {
                    // 순서 정렬하고.
                    self.dataManager?.sort(by: { (sortData, targetSort) -> Bool in
                        sortData.posts[0].continent < targetSort.posts[0].continent
                    })
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        for item in self.tableViews{
                            item.reloadData()
                        }
                    }
                }
            }
        }
        print("--------------------------------------------------------------")
    }
    
    // MARK: 1. ImageView에 Image 넣고 만들기.
    func makeContinentsSelection(){
        for num in 0..<6 {
            let imageContinent = UIImageView()
            imageContinent.clipsToBounds = true
            topScrollView.addSubview(imageContinent)
            imageContinent.image = images[num]
            imageViews.append(imageContinent)
        }
    }
    
    // MARK: Top scrollView image 셋팅 !
    func layoutContinentsSelection(){
        var contentWidth: CGFloat = self.topScrollView.frame.width / 2
        for num in 0..<6 {
            let scrollViewWidth = self.topScrollView.frame.width
            contentWidth += scrollViewWidth / 2
            let newX = scrollViewWidth / 2 + (scrollViewWidth / 2 * CGFloat(num))
            imageViews[num].frame = CGRect(x: newX - 75,
                                           y: (self.topScrollView.frame.height / 2) - 75,
                                           width: 150,
                                           height: 150)
        }
        topScrollView.clipsToBounds = false
        topScrollView.contentSize = CGSize(width: contentWidth,
                                           height: self.view.frame.height * 0.3)
    }
    
    // MARK: 2. tableView 생성 이때 해당 tableView의 XIB Cell 파일 등록
    func makeContinentTableView() {
        var tagNum = 1
        for num in 0..<6 {
            let tableView: UITableView = UITableView()
            // tableViwe의 scroll이 경계 자리에 마주했을때, 튀는(?) 현상 방지
            tableView.bounces = false
            tableView.showsVerticalScrollIndicator = false
            tableView.tag = tagNum
            bottomScrollView.addSubview(tableView)
            tableViews.append(tableView)
            tableViews[num].delegate = self
            tableViews[num].dataSource = self
            tableView.separatorStyle = .none
            
            //아래 두개의 값을 해제하고 tableView의 row 값을 풀어놓으면,
            tableViews[num].rowHeight = 150
            tableViews[num].estimatedRowHeight = 150
            tableViews[num].register(UINib.init(nibName: "CustomTableViewCell", bundle: nil),
                                     forCellReuseIdentifier: "cell")
            tagNum += 1
        }
    }
    
    // MARK: Continent 테이블뷰 생성
    func layoutContinentTableView() {
        var contentWidth: CGFloat = 0
        for num in 0..<6 {
            let scrollViewWidth = self.bottomScrollView.frame.width
            contentWidth += scrollViewWidth
            
            let newX: CGFloat = scrollViewWidth * CGFloat(num)
            tableViews[num].frame = CGRect(x: newX + 10,
                                           y: 0,
                                           width: self.bottomScrollView.frame.width - 20,
                                           height: self.bottomScrollView.frame.height)
        }
        bottomScrollView.contentSize = CGSize(width: contentWidth,
                                              height: self.bottomScrollView.frame.height)
    }
    
    // MARK: ReFreshController 함수 정의 -> 레이아웃이 맞지않아서, ReFreshController 작동하지 않음. 그래서 Refresh버튼으로 대체!
    @IBAction func pullRefreshAction(_ sender: UIButton) {
        sender.rotate()
        print("pullRefreshAction!")
        self.view.layoutIfNeeded()
        
        // Main UI 가 멈추는 현상을 조금 방지 하기 위해서 network 처리를 비동기로 던지고, 해당 부분에서 UI 변경시에 Main 호출.
        Network.Main.category(tagNum: self.currentIndex+1) { (data) in
            // data 는 이미 type 변환되어서 넘어옴.
            sender.rotate()
            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                // 서버에서 가져온 Post 개수가 없으면, 반환. if 인데 guard let 처럼 사용함..
                if self.dataManager![self.currentIndex].posts.count == 0 {return}
                var existPk: [Int] = []
                for i in self.dataManager![self.currentIndex].posts {
                    existPk.append(i.pk)
                }
                for item in data.posts {
                    // pk 값이 존재 혹은, 존재 하지 않으면
                    if existPk.contains(item.pk) == false  {
                        self.dataManager![self.currentIndex].posts.insert(item, at: 0)
                        print("cache image 저장 완료")
                        DispatchQueue.main.async {
                            self.tableViews[self.currentIndex].reloadData()
                        }
                    }else {
                        print("해당 pk 값 존재함!")
                    }
                }
                // like NumBer && like List 수정.
                // 기존데이터와 가져옴.
                // 추가된 포스트가 없을때.
                if self.dataManager![self.currentIndex].posts.count == data.posts.count {
                    // likeList Set 으로 변환
                    for index in 0...data.posts.count-1 {
                        var uselikeList: Set<Int> = Set<Int>()
                        var responseLikeList: Set<Int> = Set<Int>()
                        
                        // Set 으로 변환 과정.
                        for item in self.dataManager![self.currentIndex].posts[index].liked {
                            uselikeList.insert(item)
                        }
                        for item in data.posts[index].liked {
                            responseLikeList.insert(item)
                        }
                        
                        // like를 Set 으로 나눌때, 두가지 경우 필요함. Set
                        if uselikeList.intersection(responseLikeList) != responseLikeList ||
                            uselikeList.intersection(responseLikeList) != uselikeList {
                            self.dataManager![self.currentIndex].posts[index].liked = data.posts[index].liked
                            print("liked List 변경 적용!")
                        }
                        // 값을 수정하고.
                        if self.dataManager![self.currentIndex].posts[index].numLiked != data.posts[index].numLiked {
                            self.dataManager![self.currentIndex].posts[index].numLiked = data.posts[index].numLiked
                            print("liked number 변경 적용!")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableViews[self.currentIndex].reloadData()
                        sender.stopZRotation()
                    }
                }else {
                    // Post 가 6개 이상 되었을때, refresh 처리.
                    // NextURL 을 만들어 주기 위해서, 전체 포스트의 개수를 6개로 나누었을때. 6.0 보다 높다면, 반올림하여서, 다음 URL 만큼 가져옴.
                    let urlCountRounded: Double = (Double(self.dataManager![self.currentIndex].posts.count)/6).rounded(FloatingPointRoundingRule.awayFromZero)
                    let useUrlCount: Int = Int(urlCountRounded)
                    var posts: [Posts] = []
                    
                    // 원래 기본 데이터 가져옴.
                    for item in data.posts {
                        posts.append(item)
                    }
                    // post 의 개수만큼, request 요청후 -> 서버에서 받은 데이터와, 현재 local 에 가지고 있는 데이터를 비교후, 변한 부분이 있으면, 적용함.
                    // 현재 가지고 있는 Post 의 개수만큼 비교함, 6개면 1번, 12개면 2번... 이런식으로 비교해서 바뀐값을 업데이트해줌
                    for index in 2...useUrlCount {
                        let url: String = ServiceType.Main.category(self.currentIndex+1).routing + "?page=\(index)"
                        Network.Main.previousPage(stringURL: url, completion: { (data) in
                            for item in data.posts{
                                posts.append(item)
                            }
                            // 해당 부분일때는 Posts의 개수와, self.dataManger의 post 개수의 집개가 완료된 상태.
                            if self.dataManager![self.currentIndex].posts.count <= posts.count {
                                print("----------dataManger Post 의 count 개수 보다 post count 개수가 많아서 연산 시작--------")
                                // Race Condition 으로 인해서, 불규칙적으로 들어간 데이터들을 sort를 통해서 정리 후 -> 사용함.
                                posts.sort(by: { (value1, value2) -> Bool in
                                    value1.pk > value2.pk
                                })
                                for index in 0...(self.dataManager![self.currentIndex].posts.count-1) {
                                    var uselikeList: Set<Int> = Set<Int>()
                                    var responseLikeList: Set<Int> = Set<Int>()
                                    
                                    // dataManager 와, posts 의 싱크가 맞지 않을때 호출. -> 디버깅 용도
                                    if self.dataManager![self.currentIndex].posts[index].pk != posts[index].pk {
                                        print("""
                                            *************** 싱크가 맞지 않음 ***************
                                            index is \(index)
                                            싱크 확인, dataManger 의 pk 값 확인 \(self.dataManager![self.currentIndex].posts[index].pk)
                                            post 의 pk 값 확인 \(posts[index].pk)
                                            """)
                                    }
                                    if posts.count % 6 != 0 {
                                        print("""
                                            ==================== 레이스 컨디션 현상 체크 =================
                                            index is \(index)
                                            싱크 확인, dataManger 의 pk 값 확인 \(self.dataManager![self.currentIndex].posts[index].pk)
                                            post 의 pk 값 확인 \(posts[index].pk)
                                            post 의 count 개수가 6의 배수 인지, 확인.
                                            """)
                                    }
                                    
                                    // Set 으로 변환 과정.
                                    for item in self.dataManager![self.currentIndex].posts[index].liked {
                                        uselikeList.insert(item)
                                    }
                                    for item in posts[index].liked {
                                        responseLikeList.insert(item)
                                    }
                                    
                                    // likeList를 Set 으로 나눌때, 두가지 경우 필요함. Set
                                    if uselikeList.intersection(responseLikeList) != responseLikeList ||
                                        uselikeList.intersection(responseLikeList) != uselikeList {
                                        self.dataManager![self.currentIndex].posts[index].liked = posts[index].liked
                                        print("Post 개수가 6개 이상일때 liked List 변경 적용!")
                                        
                                    }
                                    // 아래의 해당하는 부분 변경되는 like 적용!
                                    if self.dataManager![self.currentIndex].posts[index].numLiked != posts[index].numLiked {
                                        self.dataManager![self.currentIndex].posts[index].numLiked = posts[index].numLiked
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.refreshButton.stopZRotation()
                                    self.tableViews[self.currentIndex].reloadData()
                                }
                            }
                        })
                    }
                }
            })
            DispatchQueue.global().async(execute: asyncItem)
        }
    }
    
    func bottomScrollingReloadTableView(){
        guard let nextURL = self.dataManager![currentIndex].next else {return}
        self.indicator.startAnimating()
        Network.Main.nextPage(stringURL: nextURL) { (data) in
            // 다음 페이지 넣어두고!
            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                self.dataManager![self.currentIndex].next = data.next
                self.dataManager![self.currentIndex].previous = data.previous
                
                var postPk: [Int] = [Int]()
                for index in 0...(self.dataManager![self.currentIndex].posts.count-1) {
                    postPk.append(self.dataManager![self.currentIndex].posts[index].pk)
                }
                
                for item in data.posts {
                    // post 들을 기존의 DataManager 에 추가하고,
                    if postPk.contains(item.pk) == false  {
                        self.dataManager![self.currentIndex].posts.append(item)
                    }
                }
                DispatchQueue.main.async {
                    // 데이터 리로드!
                    self.tableViews[self.currentIndex].reloadData()
                    self.indicator.stopAnimating()
                }
            })
            DispatchQueue.global().async(execute: asyncItem)
        }
        
    }
}

// MARK: Extension UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    // Custom scrollview paging
    // MARK: 위아래 스크롤 동기화 처리.
    // 일정 비율로, Top, Bottom ScrollView가 pageNation 되는것처럼 보이게 해줌
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 위의 Scroll이 스크롤 되면 호출
        if scrollView === topScrollView {
            let pageWidth = self.topScrollView.frame.width / 2
            let pageIndex = Int(targetContentOffset.pointee.x / pageWidth + 0.5)

            // currentIndex를 페이징할때 마다 변경시켜줌.
            currentIndex = pageIndex
            DispatchQueue.main.async {
                self.topCustomPaging()
                print("스크롤시 current Idex \(self.currentIndex)")
                self.pullRefreshAction(self.refreshButton)
            }

            // 아래의 Scroll이 스크롤 되면 호출.
        }else if scrollView == bottomScrollView {
            let pageWidth = self.bottomScrollView.frame.width
            let pageIndex = Int(targetContentOffset.pointee.x / pageWidth + 0.5)

            currentIndex = pageIndex
            DispatchQueue.main.async {
                self.bottomCustomPaging()
                print("스크롤시 current Idex \(self.currentIndex)")
                self.pullRefreshAction(self.refreshButton)
            }
        }
    }
    
    // MARK: top ScrollView를 스크롤할때, bottom ScrollView의 width 비율만큼, 계산후, 스크롤링 됨
    func topCustomPaging() {
        let newOffset = CGPoint(x: topGetNewOffsetX(), y: 0)
        self.topScrollView.setContentOffset(newOffset, animated: true)
    }
    
    func topGetNewOffsetX() -> CGFloat {
        let pageWidth = self.topScrollView.frame.width * 0.5
        return pageWidth * CGFloat(currentIndex)
    }
    
    // MARK: 위의 방식과 동일
    func bottomCustomPaging() {
        let newOffset = CGPoint(x: bottomGetNewOffsetX(), y: 0)
        self.bottomScrollView.setContentOffset(newOffset, animated: true)
    }
    
    func bottomGetNewOffsetX() -> CGFloat {
        let pageWidth = self.bottomScrollView.frame.width
        return pageWidth * CGFloat(currentIndex)
    }
    
    
    // topScrollView, bottomScrollView scrolling together
    // top,bottom ScrollView가 같이 스크롤 되게 해줌
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === topScrollView {
            self.upperDidScrolled()
        } else if scrollView === bottomScrollView {
            self.bottomDidScrolled()
        }
    }
    
    func upperDidScrolled(){
        let ratio = self.bottomScrollView.frame.width / (self.topScrollView.frame.width / 2)
        bottomScrollView.contentOffset = CGPoint(x: topScrollView.contentOffset.x * ratio,
                                                 y: bottomScrollView.contentOffset.y)
    }
    
    func bottomDidScrolled(){
        let ratio = (self.topScrollView.frame.width / 2) / self.bottomScrollView.frame.width
        topScrollView.contentOffset = CGPoint(x: bottomScrollView.contentOffset.x * ratio,
                                              y: topScrollView.contentOffset.y)
    }
}

// MARK: Extesion TableViewDelegate, TableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: tableView Section 개수 정의
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TableView numberOfRow")
        let IDX = tableView.tag - 1
        if let dataManager = self.dataManager, dataManager.count >= 6 {
            switch tableView.tag {
            case 1:
                return dataManager[IDX].posts.count
            case 2:
                return dataManager[IDX].posts.count
            case 3:
                return dataManager[IDX].posts.count
            case 4:
                return dataManager[IDX].posts.count
            case 5:
                return dataManager[IDX].posts.count
            case 6:
                return dataManager[IDX].posts.count
            default:
                print("tableView numberOfRow Default 부분 ")
            }
        }
        let initPostCount: Int = 6
        return initPostCount
    }
    
    // MARK: TableView Low 당 DatSource 정의
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndex = tableView.tag - 1
        let cell =  tableViews[cellIndex].dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.selectionStyle = .none
        let initializeDataManagerCount: Int = 6
        guard let dataManager = self.dataManager, (self.dataManager?.count)! >= initializeDataManagerCount else {return UITableViewCell()}
        // date 더하기..!
        print("cellIndex is \(cellIndex)")
        let date = dataManager[cellIndex].posts[indexPath.row].startDate + " ~ " + dataManager[currentIndex].posts[indexPath.row].endDate
        
        cell.title.text = dataManager[cellIndex].posts[indexPath.row].title
        cell.dateTitle.text = date
        cell.nickNameTitle.text = dataManager[cellIndex].posts[indexPath.row].author.username
        cell.numberOfLikeLabel.text = String(dataManager[cellIndex].posts[indexPath.row].numLiked)
        
        // Post 에 좋아요 누른 흔적이 있으면 좋아요 표시!
        if AppDelegate.instance?.userPK != nil {
            // 내가 누른 좋아요 Post
            if dataManager[cellIndex].posts[indexPath.row].liked.contains((AppDelegate.instance?.userPK!)!) {
                cell.likeImageView.image = #imageLiteral(resourceName: "like")
                // 누르지 않은 좋아요 Post는 기본 처리
            }else {
                cell.likeImageView.image = #imageLiteral(resourceName: "unlike")
            }
        }
        // image 를 이미지 캐시에서 로드해서 사용해주자.
        if let identifier: URL = URL(string: dataManager[cellIndex].posts[indexPath.row].img) {
            cell.backGroundImageView.af_setImage(withURL: identifier,
                                                 placeholderImage: UIImage(),
                                                 filter: nil,
                                                 progress: nil,
                                                 progressQueue: DispatchQueue.main,
                                                 imageTransition: .crossDissolve(0.5),
                                                 runImageTransitionIfCached: false)
        }
        // 마지막 부분에서, 이전 데이터들 불러와서 추가 하는 곳!
        let lastIndexPath = IndexPath(row: dataManager[cellIndex].posts.count - 1,
                                      section: 0)
        if indexPath == lastIndexPath {
            print("해당 부분에서, Data Request 후, 데이터 리로드!, 현재 대륙은, \(cellIndex)")
            bottomScrollingReloadTableView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // github.com/kif-framework/KIF/issues/1007 iOS 11 bug when fixed valphaue
        //        return (self.bottomScrollView.frame.height - (self.tabBarController?.tabBar.frame.size.height)! - 20) / 2
        // 아래값을 해제하고, 위의 tableView.row 설정 해주는 값을 해제 해놓으면, IOS 10 버전에서 사용가능
        let tableViewheight: CGFloat = 150
        return tableViewheight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테이블뷰 호출 확인")
        if AppDelegate.instance?.token == nil {
            self.loginAlertMessage()
            return
        }
        guard let dataManager = self.dataManager else {return}
        let nextVC = MainDetailViewController()
        // detailPost 로 가기위해서, 현재 가지고 있는 표지 정보와, pk 값을 넘겨주고, 나머지 부분을 DetailViewController 에서 처리 할수 있게 해줌.
        nextVC.postCoverData = dataManager[self.currentIndex].posts[indexPath.row]
        nextVC.postPk = dataManager[self.currentIndex].posts[indexPath.row].pk
        nextVC.otherUserPk = dataManager[self.currentIndex].posts[indexPath.row].author.pk
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// 아래의 부분으로 button Animation 적용 함.
// MARK: Button Rotation Extion.. CABacsic Animation 에서 사용하는 방법으로 적용.
extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double(CGFloat.pi * 2))
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = 900_000_000
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    func stopZRotation(){
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
















