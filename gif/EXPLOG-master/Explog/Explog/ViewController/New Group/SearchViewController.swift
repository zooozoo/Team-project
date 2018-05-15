//
//  SearchTableViewController.swift
//  Explog
//
//  Created by 주민준 on 2017. 12. 12..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController {
    
    // MARK: tableView, SearchViewController
    @IBOutlet var tableView: UITableView!
    private lazy var searchViewController = UISearchController(searchResultsController: nil)
    private lazy var defaultData: [String]? = []
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private var targetData: MainDataModel?
    private var myPk: Int!
    private var targetWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.searchController?.delegate = self
        self.indicator.hidesWhenStopped = true
        
        // 자신의 pk 값 저장
        self.myPk = AppDelegate.instance?.userPK
        
        // Set TableView
        setTableView()
        
        // Set SearchControl
        setSearchControl()
    }
    
    // MARK: Navigation Color 초기화 및 셋팅.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set NavigationControl
        setNavigationTransition()
    }
    
    // MARK: SetNavigation
    private func setNavigationTransition() {
        self.searchViewController.searchBar.alpha = 1
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false        
        self.navigationController?.navigationBar.setBackgroundImage(nil,for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.setNavigationColorOrTitle(title: "Search Trips!🐳")
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: Set TableView
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: "CustomTableViewCell",bundle: nil),
                           forCellReuseIdentifier: "cell")
    }
    
    // MARK: Set SearchViewController
    private func setSearchControl() {
        self.tableView.tableHeaderView = searchViewController.searchBar
        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchViewController.searchBar.sizeToFit()
        searchViewController.hidesNavigationBarDuringPresentation = true
        // 검색중 기본 내용들이 흐리게 표시되게 해주는 녀석.
        searchViewController.dimsBackgroundDuringPresentation = false
        searchViewController.searchBar.searchBarStyle = UISearchBarStyle.default
        
        // Place Holder 설정
        let mutableString = NSMutableAttributedString(string: " 여행을 검색하세요! ")
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor,
                                   value: UIColor.colorConcept,
                                   range: NSRange(location: 0,
                                                  length: 4))
        searchViewController.accessibilityAttributedHint = mutableString
        // SearchBar PlaceHolder
        let searchTextField: UITextField? = searchViewController.searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.attributedPlaceholder = mutableString
        
        // cancel button Color 변경
        searchViewController.searchBar.tintColor = UIColor.colorConcept
        searchViewController.searchBar.barTintColor = .white
    }
    
    // MARK: Search 이후에 tableView를 scroll 하면, pagenation 된 데이터들을 가져옴.
    func bottomScrollingReloadTableView(){
        print("search 마지막 IndexPath")
        if self.targetData?.next != nil{
            guard let token = AppDelegate.instance?.token else {return}
            Network.SearchService.search(targetTitleWord: self.targetWord!,
                                         nextPageURL:self.targetData?.next,
                                         token: token) { (isSuccess, data) in
                                            self.indicator.startAnimating()
                                            let asyncItem: DispatchWorkItem = DispatchWorkItem(block: { [unowned self] in
                                                // 데이터 변환이 성공 했을 경우.
                                                if isSuccess {
                                                    self.targetData?.next = data?.next
                                                    for item in (data?.posts)! {
                                                        self.targetData?.posts.append(item)
                                                        print("Search data 변환 완료")
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.indicator.stopAnimating()
                                                        self.tableView.reloadData()
                                                    }
                                                    // Search Data 변환이 실패 했을 경우..
                                                }else {
                                                    self.indicator.stopAnimating()
                                                    print("target Data 가 더이상 존재하지 않습니다!")
                                                }
                                            })
                                            DispatchQueue.global().async(execute: asyncItem)
            }
        }
    }
}

// MARK: SearchViewController, TableView Delegate, DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.targetData?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        guard let targetData = self.targetData, self.targetData?.posts.count != 0 else {return UITableViewCell()}
        cell.title.text = targetData.posts[indexPath.row].title
        cell.dateTitle.text = targetData.posts[indexPath.row].startDate + " ~ " + targetData.posts[indexPath.row].endDate
        cell.nickNameTitle.text = targetData.posts[indexPath.row].author.username
        cell.numberOfLikeLabel.text = String(targetData.posts[indexPath.row].numLiked)
        if targetData.posts[indexPath.row].liked.contains(self.myPk) {
            cell.likeImageView.image = #imageLiteral(resourceName: "like")
        }else {
            cell.likeImageView.image = #imageLiteral(resourceName: "unlike")
        }
        cell.backGroundImageView.af_setImage(withURL: URL(string: targetData.posts[indexPath.row].img)!,
                                             placeholderImage: UIImage(),
                                             filter: nil,
                                             progress: nil,
                                             progressQueue: DispatchQueue.main,
                                             imageTransition: .crossDissolve(0.5),
                                             runImageTransitionIfCached: false)
        // Search 결과가 6개 이상일때, 더 있는 결과를 호출함.
        let lastIndexPath = IndexPath(row: (self.targetData?.posts.count)! - 1,
                                      section: 0)
        if indexPath == lastIndexPath {
            bottomScrollingReloadTableView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchViewController.isActive == true {
            return 150
        }else {
            return 150
        }
    }
    
    func tableView(_ tableViewiwww: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchViewController.isActive == true {
            return 150
        }else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC: MainDetailViewController = MainDetailViewController()
        nextVC.postCoverData = self.targetData?.posts[indexPath.row]
        nextVC.postPk = self.targetData?.posts[indexPath.row].pk
        nextVC.otherUserPk = self.targetData?.posts[indexPath.row].author.pk
        // 자연스러운 화면 처리 위해서, 화면이 넘어갈때, 해당 부분 호출해줌.. talbeViewHeader 에, searchBar 를 사용하니까 뭔가 부적절..
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.searchViewController.searchBar.text = nil
        self.searchViewController.isActive = false
        self.searchViewController.searchBar.alpha = 0
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}

// MARK: Search Controller ResultUpdating
extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        let searchBar = searchController.searchBar
        // 해당 Token 은 Main Thread 에서만 사용할수 있다고 해서, 파라미터로 빼놓고 사용함.
        guard let token = AppDelegate.instance?.token else {return}
        guard let text = searchBar.text, !text.isEmpty else {return}
        print("호출 시점 확인 \(text)")
        self.targetWord = text
        self.indicator.startAnimating()
        Network.SearchService.search(targetTitleWord: text, token: token) { (isSuccess, data) in
            // Search API 요청이 성공한 경우
            if isSuccess {
                print("Serarch Data 있음.")
                self.targetData?.posts.removeAll()
                self.targetData = data
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
                // Search API 요청이 실패한 경우
            }else {
                print("Serarch Data 없음.. 실패 ㅠ_ㅠ")
                self.indicator.stopAnimating()
            }
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {}
