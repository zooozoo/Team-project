//
//  AddHighlightTextViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 19..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class AddHighlightTextViewController: UIViewController {
    
    let textView: UITextView = {
        let tv: UITextView = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "내용을 입력 하세요!"
        tv.isEditable = true
        tv.tag = 1
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        return tv
    }()
    
    let textViewOfCounting: UITextView = {
        let tv: UITextView = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "0/80 글자"
        tv.tag = 2
        tv.textColor = .black
        tv.textAlignment = .center
        tv.isEditable = false
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setnavigationController()
        setTextview()
    }
    
    open var postData: PostDataModel!
    open var toAddPostPk: Int?
    
    internal var modifyTextPk: Int?
    internal var isEditingText: Bool = false
    
    @objc func addHighlightpostButtonAction(_ sender: UIButton) {
        guard let text = textView.text, textView.text.count != 0 else {return}
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        // Post 를 생성하고 사용할때, UserProfile 에서 새롭게 Text를 추가할떄
        if self.isEditingText == false {
            var postPk: Int?
            if self.toAddPostPk != nil {
                postPk = self.toAddPostPk
            }else {
                postPk = postData.pk
            }
            Network.Post.textCreat(postPk: postPk!,
                                   contents: text,
                                   type: "h") { (isSuccess, data) in
                                    // 성공적으로 데이터 넘어온 경우
                                    if isSuccess {
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                        self.dismiss(animated: true, completion: nil)
                                        print("Post HighlightText Creat 데이터 변환 성공!...ㅠ.ㅠ")
                                        
                                        // 데이터가 넘어오지 못한 경우..
                                    }else {
                                        print("Post HighlightText Creat 실패...ㅠ.ㅠ")
                                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                    }
            }
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            // Text 를 수정할때.
        }else {
            Network.UpdatePostContents.text(textPk: self.modifyTextPk!,
                                            content: text,
                                            type: "h",
                                            completion: { (isSuccess) in
                                                if isSuccess {
                                                    print("highlight text 수정 완료!")
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                    self.dismiss(animated: true, completion: nil)
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                }else {
                                                    print("highlighttext 수정 실패!!")
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                    self.dismiss(animated: true, completion: nil)
                                                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                }
            })
        }
    }
    
    @objc func backPostButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setnavigationController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                                 target: self,
                                                                 action: #selector(self.addHighlightpostButtonAction) )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.backPostButtonAction(_:)))
        self.setNavigationColorOrTitle(title: "강조글 추가")
    }
    
    func setTextview() {
        textView.delegate = self
        self.view.addSubview(textView)
        self.view.addSubview(textViewOfCounting)
        self.textView.frame = CGRect(x: 8,
                                     y: 110,
                                     width: self.view.frame.size.width - 16,
                                     height: self.view.frame.size.height * 0.4)
        
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navibarHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)!
        print(statusBarHeight, navibarHeight)
        self.textViewOfCounting.frame = CGRect(x: view.center.x - 50,
                                               y: 4 + (statusBarHeight + navibarHeight),
                                               width: 100,
                                               height: 25)
        // 앞 부분을 가리는 현상 수정.
        self.textView.bringSubview(toFront: textViewOfCounting)
    }
}

extension AddHighlightTextViewController: UITextViewDelegate {
    
    // TextView PlaceHolder
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDid Begin Editing")
        if (textView.text == "내용을 입력 하세요!") {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    // TextView Title Color 변경
    func textViewDidChange(_ textView: UITextView) {
        textViewOfCounting.text = "\(textView.text.count)/60 글자"
        guard let textlen = textView.text?.count else {return}
        // Text를 작성할때 커서가 앤터키에 맞추어서 따라감.
        textView.setContentOffset(CGPoint.zero, animated: true)
        if textlen == 60 {
            self.textViewOfCounting.textColor = .red
        }else {
            self.textViewOfCounting.textColor = .black
        }
    }
    
    // MARK: TextView 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count + (text.count - range.length) <= 60 && textView.textContainer.maximumNumberOfLines <= 4 {
            return true
        }
        return false
    }
}

