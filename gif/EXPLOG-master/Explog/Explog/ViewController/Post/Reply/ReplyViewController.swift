//
//  ReplyViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 27..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    // MARK: StoryBoard Instance
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var inputviewBottomMargin: NSLayoutConstraint!
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var inputContainerView: UIView!
    @IBOutlet private weak var inputDoneBtn: UIButton!
    
    // MARK: Modifiy 일떄와, 해당 PostPk 값
    open var postPK: Int!
    open var isModify: Bool = false
    open var modifyIndex: Int?
    
    // MARK: inputTextView의 Constraint!
    @IBOutlet private weak var inputTextViewHeight: NSLayoutConstraint!
    var replyData: [PostReplyModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // API CALL
        // 비동기 처리로 인해서, 나중에 DataReLoad 해주어야함.
        Network.Post.reply(postPk: self.postPK) { (isSuccess, data) in
            guard let replyData = data else {return}
            self.replyData = replyData
            
            // ProfileImage를 ,imageCache 에 저장
            for item in replyData {
                let profileImageURL: URL = URL(string: (item.author?.imgProfile)!)!
                let imageData: Data = try! Data(contentsOf: profileImageURL)
                let image: UIImage = UIImage(data: imageData, scale: 1.0)!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 버튼 색상
        inputDoneBtn.backgroundColor = .colorConcept
        inputDoneBtn.layer.cornerRadius = 10
        
        inputTextView.delegate = self
        
        // SetTableView
        setTableView()
        
        // 키보드 Notification
        setKeyboard()
        
        // set Navigation
        setNavigation()
        print("postPK is \(postPK)")
        
    }
    
    // MARK: Set TableView
    private func setTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        //Nib 파일로 Cell 을 만들경우, 이렇게 등록을 해주어야함.
        tableView.register(UINib(nibName: "ReplyCell", bundle: nil),
                           forCellReuseIdentifier: "ReplyCell")
    }
    
    // MARK: Set KeyBoard Observer
    private func setKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(noti:)) ,
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(noti:)) ,
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    private func setNavigation() {
        self.navigationController?.isNavigationBarHidden = false 
        self.navigationItem.title = "COMMENTS"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.exitNaviButtonAction(_:)))
        // title 색상 white 로 변경.
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorConcept
    }
    
    @objc func exitNaviButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // 키보드가 올라오고 사라질때, 자연스러운 에니메이션 처리해줌.
    // MARK: keyboardWillShow!
    @objc private func keyboardWillShow(noti: NSNotification) {
        // userInfo 값을 가져옴
        guard let notiInfo = noti.userInfo as NSDictionary? else {return}
        //let notiInfo = noti.userInfo //as! NSDictionary
        // keyboardfrema 값을 가져온후, CGRect값으로 변경함
        
        let keyboardFrema = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrema.size.height
        self.inputviewBottomMargin.constant = -height
        let keyboardDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyboardDuration) {
            // animation, frema 을 실시간으로 적용할때 무조건 필요함
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: keyboardWillHide!
    @objc private func keyboardWillHide(noti: NSNotification){
        guard let notiInfo = noti.userInfo as NSDictionary? else {return}
        let keyboardDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
            self.inputviewBottomMargin.constant = 0
        }
    }
    
    // MARK: Done Button
    @IBAction func InputDone(_ sender: UIButton) {
        if inputTextView.text.isEmpty {
            self.convenienceAlert(alertTitle: "텍스트를 입력해주세요✨")
            return
        }else {
            // done 을 눌렀을때, text와 함께 현재 나의 data 추가.
            Network.Post.creatReply(postPk: self.postPK, comments: inputTextView.text, completion: { (isSuccess, data) in
                if isSuccess {
                    print("Creat Reply API 요청이 성공 했습니다.")
                    self.replyData?.append(data!)
                    self.inputTextView.text = ""
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let lastIndexPath = IndexPath(row: (self.replyData?.count)!-1, section: 0)
                        
                        //layout 이 잘 안가는경우에, 아래의 녀석을 호출하고 이동시켜보자.
                        self.view.layoutIfNeeded()
                        //원하는 tableView의 low로 이동하는
                        self.tableView.scrollToRow(at: lastIndexPath,
                                                   at: UITableViewScrollPosition.bottom,
                                                   animated: false)
                    }
                }else {
                    print("Creat Reply API 요청이 실패 했습니다.")
                }
            })
        }
        //같은 함수 한번더 호출해서 해결
        // enter key 를 누르면, Text 박스가 일정 크기까지 증가됨!
        textViewDidChange(inputTextView)
    }
}

// MARK: Extension TableView DataSource
extension ReplyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let replyData = self.replyData else {return UITableViewCell()}
        let replyCell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
        
        // Cell Data 뿌려주기
        if replyData[indexPath.row].author != nil {
            replyCell.profileImageView.af_setImage(withURL: URL(string: (replyData[indexPath.row].author?.imgProfile)!)!,
                                                   placeholderImage: UIImage(),
                                                   filter: nil,
                                                   progress: nil,
                                                   progressQueue: DispatchQueue.main,
                                                   imageTransition: .crossDissolve(0.5),
                                                   runImageTransitionIfCached: false)
        }
        replyCell.nickNameLabel.text = replyData[indexPath.row].author?.username
        replyCell.comments.text = replyData[indexPath.row].content
        replyCell.comments.tag = indexPath.row
        replyCell.timeLabel.text = replyData[indexPath.row].createdAt
        
        
        
        // 셀 선택되었을때, 나타나는 녀석..
        replyCell.selectionStyle = UITableViewCellSelectionStyle.none
        return replyCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let replyData = self.replyData else {return}
        
        // 클릭했을때, 현재의 댓글을 수정할수 있는 알럿 소환
        if replyData[indexPath.row].author?.pk == AppDelegate.instance?.userPK {
            let alertController: UIAlertController = UIAlertController(title: "COMMENDTS", message: "", preferredStyle: .actionSheet)
            let cancelAlertAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let modifyAlertAction: UIAlertAction = UIAlertAction(title: "Modify", style: .default, handler: nil)
            let deleteAlertAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { alert in
                Network.Delete.reply(replyPk: replyData[indexPath.row].pk, completion: { (isSuccess, data) in
                    print("댓글 data \(String(describing: data))")
                    
                    // 삭제 요청이 성공한 경우,
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.replyData?.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            tableView.reloadData()
                            self.convenienceAlert(alertTitle: "댓글이 삭제 되었습니다✨")
                        }
                        // 삭제 요청이 실패한 경우
                    }else {
                    }
                })
            }
            alertController.addAction(cancelAlertAction)
            alertController.addAction(deleteAlertAction)
            alertController.addAction(modifyAlertAction)
            self.present(alertController, animated: true, completion: nil)
        }else {
            self.view.endEditing(true)
        }
    }
}

// MARK: TextView 크기를 일정 크기이상 증가 시키지 않게 해주기 위한 처리.
extension ReplyViewController: UITextViewDelegate {
    
    // textView에 글자를 작성할때마다 호출되는 녀석
    func textViewDidChange(_ textView: UITextView) {
        print("같은 함수 한번더 호출")
        if textView.contentSize.height <= 83 {
            inputTextViewHeight.constant = textView.contentSize.height
            textView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    // TextView placeHolder
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDid Begin Editing")
        if (textView.text == "Add Comment🐳") {
            textView.text = ""
            textView.textColor = .black
        }
        //Optional
        textView.becomeFirstResponder()
    }
}


