
//  PostViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 4..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    // MARK: Creat Instans titleTextView, titleImageView
    internal var titleTV: UITextView = {
        let tv: UITextView = UITextView()
        tv.textAlignment = .center
        tv.text = "나의 101번째 이야기"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.adjustsFontForContentSizeCategory = true
        tv.textColor = UIColor.white
        tv.backgroundColor = .clear
        tv.textContainer.maximumNumberOfLines = 2
        
        //textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail
        tv.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tv.font = UIFont.boldSystemFont(ofSize: 28)
        return tv
    }()
    
    internal var titleImage: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = #imageLiteral(resourceName: "spcae1")
        img.alpha = 0.9
        img.translatesAutoresizingMaskIntoConstraints = true
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    // 이미지를 업로드하기위해서, 이미지 URL 이 필요함.
    internal var imgURL: URL!
    private var changeTitleImageButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("표지변경", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    internal var startDateButton: UIButton = {
        var btn: UIButton = UIButton()
        btn.tag = 1
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("START DATE", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    internal var endDateButton: UIButton = {
        var btn: UIButton = UIButton()
        btn.tag = 2
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("END DATE", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    internal var selectorContinentButton: UIButton = {
        var btn: UIButton = UIButton()
        btn.tag = 2
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Asia", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    var pickerDataSource = ["Aisa", "Europe", "North America", "South America", "Africa", "Oceania"]
    
    // MARK: datePickerView
    private var datePickerView: UIDatePicker =  {
        var dp = UIDatePicker()
        dp.datePickerMode = UIDatePickerMode.date
        dp.translatesAutoresizingMaskIntoConstraints = true
        dp.locale = Locale(identifier: "ko_korea")
        return dp
    }()
    
    // MARK: API CALL 할때 사용되는 continentValue
    internal var continentValue: String!
    
    // MARK: indicator 생성
    private var indicator: UIActivityIndicatorView = {
        let indi: UIActivityIndicatorView = UIActivityIndicatorView()
        indi.activityIndicatorViewStyle = .white
        indi.hidesWhenStopped = true
        indi.translatesAutoresizingMaskIntoConstraints = false
        return indi
    }()
    
    private lazy var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    // 수정중일때와, 수정중이지 않을떄를 알려주는 Bool 값
    internal var isEditingPostCover: Bool = false
    internal var editingPostCoverPk: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layoutIfNeeded()
        titleTV.delegate = self
        // 인스턴스 추가후, layout 적용하기위해서 순서 분리
        allAddSubView()
        setNavigationController()
        
        // 레이아웃 설정
        // MARK: Set Layout
        setLayout()
        // 시작시, 키보드 커서를 타이틀로 이동
        titleTV.becomeFirstResponder()
        
        // 초기 button, continent 셋팅
        startSetting()
        
        // AddTaget들 모아놓음
        setButtonAddTarget()
    }
    
    // MARK: Button 초기 셋팅
    private func startSetting() {
        if isEditingPostCover == false {
            self.startDateButton.setTitle(Time.todayDate, for: .normal)
            self.endDateButton.setTitle(Time.todayDate, for: .normal)
            self.continentValue = "1"
            // 기본 URL 셋팅..!
            self.imgURL = Bundle.main.url(forResource: "Defaultspace", withExtension: "jpg")
            print("imageURL is \(self.imgURL)")
        }else {
            self.continentValue = self.returnContinentValue(continentString: (self.selectorContinentButton.titleLabel?.text)!)
        }
    }
    
    // MARK: SetViewAddSubView
    private func allAddSubView() {
        self.view.addSubview(titleImage)
        self.view.addSubview(titleTV)
        self.view.addSubview(changeTitleImageButton)
        self.view.addSubview(startDateButton)
        self.view.addSubview(endDateButton)
        self.view.addSubview(selectorContinentButton)
        self.view.addSubview(indicator)
    }
    
    // MARK: set Layout func
    private func setLayout() {
        titleImage.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.frame.size.width,
                                  height: self.view.frame.size.height*0.6)
        self.setLayoutMultiplier(target: titleTV,
                                 to: self.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 0.4,
                                 widthMultiplier: 0.95,
                                 heightMultiplier: 0.2)
        self.setLayoutMultiplier(target: startDateButton,
                                 to: self.view,
                                 centerXMultiplier: 0.65,
                                 centerYMultiplier: 0.5,
                                 widthMultiplier: 0.3,
                                 heightMultiplier: 0.05)
        self.setLayoutMultiplier(target: endDateButton,
                                 to: self.view,
                                 centerXMultiplier: 1.35,
                                 centerYMultiplier: 0.5,
                                 widthMultiplier: 0.3,
                                 heightMultiplier: 0.05)
        self.setLayoutMultiplier(target: selectorContinentButton,
                                 to: self.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 0.65,
                                 widthMultiplier: 0.5,
                                 heightMultiplier: 0.05)
        self.setLayoutMultiplier(target: changeTitleImageButton,
                                 to: self.view,
                                 centerXMultiplier: 1.0,
                                 centerYMultiplier: 0.8,
                                 widthMultiplier: 0.2,
                                 heightMultiplier: 0.07)
        self.setLayoutMultiplier(target: self.indicator,
                                 to: self.view,
                                 centerXMultiplier: 1,
                                 centerYMultiplier: 1,
                                 widthMultiplier: 0.1,
                                 heightMultiplier: 0.1)
        self.indicator.bringSubview(toFront: self.titleImage)
    }
    
    // MARK: Set NavigationContorller Property
    private func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        // navigation backgroundColor clear 로 변경
        self.navigationController?.setNavigationBackgroundColor()
        // navigationItem Right, Left Button Selector 연결
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self.savePostTitleButtonAction(_:)) )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                target: self,
                                                                action: #selector(self.exitPostButtonAction(_:)))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setButtonAddTarget() {
        startDateButton.addTarget(self,
                                  action: #selector(self.startButtonAction(_:)),
                                  for: UIControlEvents.touchUpInside)
        endDateButton.addTarget(self,
                                action: #selector(self.startButtonAction(_:)),
                                for: UIControlEvents.touchUpInside)
        changeTitleImageButton.addTarget(self,
                                         action: #selector(self.changeTitleImageButtonAction(_:)),
                                         for: .touchUpInside)
        selectorContinentButton.addTarget(self,
                                          action: #selector(self.selectorContinentButtonAction(_:)),
                                          for: .touchUpInside)
        // DatePicker 값이 변한 순간에 호출.
        datePickerView.addTarget(self,
                                 action: #selector(self.datePickerValueChanged),
                                 for: UIControlEvents.valueChanged)
    }
    
    // MARK: Save Button Action
    @objc private func savePostTitleButtonAction(_ sender: UIBarButtonItem) {
        self.indicator.startAnimating()
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        
        let alertController: UIAlertController = UIAlertController(title: "알럿 타이틀",
                                                                   message: "",
                                                                   preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK",
                                                       style: .default,
                                                       handler: nil)
        alertController.addAction(alertAction)
        
        // title 표지를 입력하지 않은 경우.. 알럿으로 체크!
        if self.titleTV.text.count == 0 {
            alertController.title = "표지를 입력해주세요🤗"
            self.present(alertController,
                         animated: true,
                         completion: nil)
            self.indicator.stopAnimating()
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            return
        }
        
        
        // Date 가 정상적으로 작성되지 않은 경우.. 알럿 처리
        if self.calcDate(self.startDateButton.titleLabel!.text!,
                         endDate: self.endDateButton.titleLabel!.text!) == false {
            alertController.title = "시작 날짜보다, 끝나는 날짜가 이전입니다!🤗"
            self.present(alertController,
                         animated: true,
                         completion: nil)
            self.indicator.stopAnimating()
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            return
            // 정상적으로 Date 가 작성된 경우.
            // MARK: Creat Post API
        }else {
            // 필요한 데이터 title, startDate, endDate, continent, imgURL -> 조건 성립
            if self.isEditingPostCover == false {
                guard let titleText = titleTV.text,
                    let startDate = startDateButton.titleLabel!.text,
                    let endDate = endDateButton.titleLabel!.text,
                    let continentValue = self.continentValue,
                    let imgURL = self.imgURL  else {return}
                
                //  PostCreat API, .post Method
                Network.Post.creatPost(title: titleText,
                                       startDate: startDate,
                                       endDate: endDate,
                                       continent: continentValue,
                                       titleImg: imgURL,
                                       completion: { (isSuccess, data) in
                                        print("Creat Post Cover API \(String(describing: data))")
                                        // 넘어온 데이터가 성공인 경우
                                        if isSuccess {
                                            // Server 에서 온 이미지 값으로 처리 하지않고, APP 상에서 바로 처리함. -> 성능향상(?)
                                            let nextVC = PostTableViewController()
                                            let deliveImage = self.titleImage
                                            let deliveText = titleText
                                            let deliveDate: String = startDate + " ~ " + endDate
                                            let deliveContinent: String = self.returnContinentName(continentString: continentValue)
                                            
                                            // Server 에서 Detail API 에 Cover Data 를 같이 보내주면 좋은데, 그렇지 않아서 해당 데이터를 미리 셋해서 present 함.
                                            nextVC.getTitleImage.image = deliveImage.image
                                            nextVC.getTitleTV.text = deliveText
                                            nextVC.getDateTV.text = deliveDate
                                            nextVC.getContinentTV.text = deliveContinent
                                            nextVC.postData = data
                                            DispatchQueue.main.async {
                                                self.indicator.stopAnimating()
                                                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                                self.navigationController?.pushViewController(nextVC, animated: true)
                                                
                                            }
                                            // 넘어온 데이터가 실패한 경우.
                                        }else {
                                            self.indicator.stopAnimating()
                                            self.navigationController?.navigationBar.isUserInteractionEnabled = true
                                        }
                })
            }else {
            // PostUpdate API 사용, .patch method
                guard let postPk = self.editingPostCoverPk,
                    let titleText = titleTV.text,
                    let startDate = startDateButton.titleLabel!.text,
                    let endDate = endDateButton.titleLabel!.text,
                    let continentValue = self.continentValue else {return}
                Network.UpdatePostCover.updatePostCover(postPk: postPk,
                                                        title: titleText,
                                                        startDate: startDate,
                                                        endDate: endDate,
                                                        continent: continentValue,
                                                        titleImg: self.imgURL,
                                                        completion: { (isSuccess, data) in
                                                            print("Cover 데이터 수정 \(String(describing: data))")
                                                            let alertController: UIAlertController = UIAlertController(title: "변경이 성공했습니다✨", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                                            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                                                self.navigationController?.popToRootViewController(animated: true)
                                                            })
                                                            alertController.addAction(alertAction)
                                                            if isSuccess {
                                                                self.present(alertController, animated: true, completion: nil)
                                                            }else {
                                                                alertController.title = "네트워크 환경이 좋지 않습니다✨"
                                                                self.present(alertController, animated: true, completion: nil)
                                                            }
                })
            }
        }
    }
    
    // MARK: Exit Post Button
    @objc private func exitPostButtonAction(_ sender: UIBarButtonItem) {
        // 수정중일떄와, 수정 중이지 않을때, 사용되는 버튼의 용도가 다름.
        if self.isEditingPostCover == true {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: changetitleImageButtonAction
    @objc private func changeTitleImageButtonAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        // navigationBar 의 기본 속성을 변경
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.tintColor = UIColor.white
        imagePickerController.navigationBar.barTintColor = UIColor.colorConcept
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        imagePickerController.navigationBar.titleTextAttributes = textAttributes
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Set Date Picker
    @objc func datePickerValueChanged(sender: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let returnString = dateFormatter.string(from: sender.date)
        return returnString
    }
    
    // MARK: Selector Continent
    @objc func selectorContinentButtonAction(_ sender: UIButton) {
        let alertView = UIAlertController(title: "여행 하시는곳의 대륙을 선택해주세요😘",
                                          message: "\n\n\n\n\n\n\n\n\n",
                                          preferredStyle: .actionSheet)
        let pickerView = UIPickerView(frame: CGRect(x: 0,
                                                    y: 50,
                                                    width: 260,
                                                    height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        let action1 = UIAlertAction(title: "해당 대륙 선택", style: UIAlertActionStyle.default, handler: nil)
        alertView.addAction(action)
        alertView.addAction(action1)
        pickerView.isHidden = true
        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
            pickerView.isHidden = false
        })
    }
    
    // MARK: Start & End Button Action -> Creat AlertController!
    @objc private func startButtonAction(_ sender: UIButton) {
        // AlertController 생성
        let alertController = UIAlertController(title: "날짜를 선택하세요!😘",
                                                message: "\n\n\n\n\n\n\n\n\n",
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        let alertAction = UIAlertAction(title: "취소",
                                        style: UIAlertActionStyle.cancel,
                                        handler: nil)
        let alertAction1 = UIAlertAction(title: "해당 날짜로 선택",
                                         style: UIAlertActionStyle.default) { (action) in
                                            let setButtonTitleLable = self.datePickerValueChanged(sender: self.datePickerView)
                                            if sender.tag == 1 {
                                                self.startDateButton.setTitle(setButtonTitleLable, for: UIControlState.normal)
                                            }else {
                                                self.endDateButton.setTitle(setButtonTitleLable, for: UIControlState.normal)
                                            }
        }
        // AlertController title 과의 거리를 위해서 origin 값 설정
        datePickerView.frame.origin = CGPoint(x: 0,
                                              y: 25)
        // AlertController.View 의 Height 변경
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertController.view,
                                                            attribute: NSLayoutAttribute.height,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: nil,
                                                            attribute: NSLayoutAttribute.notAnAttribute,
                                                            multiplier: 1, constant: self.view.frame.height * 0.50)
        alertController.addAction(alertAction)
        alertController.addAction(alertAction1)
        alertController.view.addConstraint(height)
        alertController.view.addSubview(datePickerView)
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: TextViewDelegate
extension PostViewController: UITextViewDelegate {
    
    // TextView Title Color 변경
    func textViewDidChange(_ textView: UITextView) {
        self.navigationItem.title = "\(textView.text.count)/30 글자"
        guard let textlen = textView.text?.count else {return}
        if textlen == 30 {
            let navigationtitleColor = [NSAttributedStringKey.foregroundColor:UIColor.red]
            self.navigationController?.navigationBar.titleTextAttributes = navigationtitleColor
        }else {
            let navigationtitleColor = [NSAttributedStringKey.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = navigationtitleColor
        }
        
    }
    
    // MARK: TextView 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("""
            textView.text.count is \(textView.text.count)
            text.count is \(text.count)
            range.length is \(range.length)
            """)
        let layoutManager:NSLayoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            layoutManager.lineFragmentRect(forGlyphAt: index,
                                           effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        
        print(numberOfLines)
        if textView.text.count + (text.count - range.length) <= 30  {
            return true
        }
        return false
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 사진을 선택 후 불리는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imgURL = info[UIImagePickerControllerImageURL] as? URL {
            titleImage.image = img
            // image URL 셋팅
            self.imgURL = imgURL
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //취소했을때 불리는 델리게이트 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// PickerView Extension
extension PostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("호출되나1")
        return pickerDataSource[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectorTitle = pickerDataSource[row]
        self.selectorContinentButton.setTitle(selectorTitle, for: UIControlState.normal)
        self.continentValue = returnContinentValue(continentString: selectorTitle)
    }
}

// MARK: 대륙 이름의 스트링 값을 -> 숫자 스트링을 변환
extension UIViewController {
    func returnContinentValue(continentString value: String) -> String {
        switch value {
        case "Aisa":
            return "1"
        case "Europe":
            return "2"
        case "North America":
            return "3"
        case "South America":
            return "4"
        case "Africa":
            return "5"
        case "Oceania":
            return "6"
        default:
            return "1"
        }
    }
    
    // MARK: 대륙의 value 값을 스트링으로 변환
    func returnContinentName(continentString value: String) -> String {
        switch value {
        case "1":
            return "Aisa"
        case "2":
            return "Europe"
        case "3":
            return "North America"
        case "4":
            return "South America"
        case "5":
            return "Africa"
        case "6":
            return "Oceania"
        default:
            return "1"
        }
    }
    
}

