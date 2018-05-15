//
//  ExtensionViewController.swift
//  Explog
//
//  Created by MIN JUN JU on 2017. 12. 30..
//  Copyright © 2017년 becomingmacker. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


// MARK: 오토 레이아웃을 코드로 작성하는 가장 기본적인 extention
extension UIViewController {
    func setLayoutMultiplier(target: AnyObject,
                             to: AnyObject,
                             centerXMultiplier: CGFloat,
                             centerYMultiplier: CGFloat,
                             widthMultiplier: CGFloat,
                             heightMultiplier: CGFloat) {
        let targetCenterX = NSLayoutConstraint(item: target,
                                               attribute: NSLayoutAttribute.centerX,
                                               relatedBy: NSLayoutRelation.equal,
                                               toItem: to,
                                               attribute: NSLayoutAttribute.centerX,
                                               multiplier: centerXMultiplier,
                                               constant: 0)
        let targetCenterY = NSLayoutConstraint(item: target,
                                               attribute: NSLayoutAttribute.centerY,
                                               relatedBy: NSLayoutRelation.equal,
                                               toItem: to,
                                               attribute: NSLayoutAttribute.centerY,
                                               multiplier: centerYMultiplier,
                                               constant: 0)
        let targetWidth = NSLayoutConstraint(item: target,
                                             attribute: NSLayoutAttribute.width,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: to,
                                             attribute: NSLayoutAttribute.width,
                                             multiplier: widthMultiplier,
                                             constant: 0)
        let targetHeight = NSLayoutConstraint(item: target,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: to,
                                              attribute: NSLayoutAttribute.height,
                                              multiplier: heightMultiplier,
                                              constant: 0)
        
        to.addConstraint(targetCenterX)
        to.addConstraint(targetCenterY)
        to.addConstraint(targetWidth)
        to.addConstraint(targetHeight)
    }
    
    func setNavigationColorOrTitle(title value: String) {
        self.navigationItem.title = value
        
        
        // navigation title text color 변경
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.colorConcept
        self.navigationController?.navigationBar.tintColor = .white
    }
}

// 원리는 스트링으로된 날짜를 숫자로 쪼개서 합친후, 그 값을 비교후 Bool 값 체크함.
// MARK: 스트링으로 된 날짜 값을 받아서, Bool 값을 반환
extension UIViewController {
    func calcDate(_ startDate: String, endDate: String) -> Bool{
        var stringDateforStart: String = ""
        var stringDateforEnd: String = ""
        
        for character in startDate {
            if character != "-" {
                stringDateforStart += String(character)
            }
        }
        
        for character in endDate {
            if character != "-" {
                stringDateforEnd += String(character)
            }
        }
        
        let startValue = Int(stringDateforStart)!
        let endValue = Int(stringDateforEnd)!
        if startValue <= endValue {
            print("Date farameter 가 정상입니다.")
            return true
        }else {
            print("endDate 가 startDate 보다 큰값입니다.")
            return false
        }
    }
}

// MARK: AlertController 를 간단하게 사용하기 위해서 빼놓음
extension UIViewController {
    func convenienceAlert(alertTitle: String) {
        let alertController: UIAlertController = UIAlertController(title: alertTitle,
                                                                   message: "", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginAlertMessage() {
        let alertController: UIAlertController = UIAlertController(title: "로그인이 필요합니다",
                                                                   message: "",
                                                                   preferredStyle: UIAlertControllerStyle.alert)
        
        let LoginAlertAction: UIAlertAction = UIAlertAction(title: "OK",
                                                            style: UIAlertActionStyle.default){ (alert) in
                                                                let LoginVC = UIStoryboard(name: "Master", bundle: nil).instantiateViewController(withIdentifier: "SelectLoginViewController") as! SelectLoginViewController
                                                                self.present(LoginVC, animated: true, completion: nil)
        }
        let cancelAlertAction: UIAlertAction = UIAlertAction(title: "CANCEL💦",
                                                             style: UIAlertActionStyle.default,
                                                             handler: nil)
        alertController.addAction(LoginAlertAction)
        alertController.addAction(cancelAlertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// ImageURL 을 받아서 -> UIImage 로 변환해서 돌려줌
extension UIViewController {
    func fromImageUrlToUIImage(imageURLString imageURL: String) -> UIImage {
        let imageURL: URL = URL(string: imageURL)!
        let imageData: Data = try! Data(contentsOf: imageURL)
        let image: UIImage = UIImage(data: imageData, scale: 1.0)!
        return image
    }
}

// UINavigationController 의 background color 을 clear 로 만들어줌.
extension UINavigationController {
    func setNavigationBackgroundColor() {
        self.navigationBar.setBackgroundImage(UIImage(),for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    // BackGround 의 color 이 clear 된것을 원래되로 reset 해줍니다.
    func resetNavigationBackGroundColor() {
        self.navigationController?.navigationBar.setBackgroundImage(nil,for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

// 포스트 생성시, 현재의 시간을 날려줄때 날려줌.
class Time {
    static var todayDate: String {
        get{
            let date: Date = Date()
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let returnDate = formatter.string(from: date)
            return returnDate
        }
    }
}

// Extension random Color 값 넣는 넣기
extension UIColor {
    open class var colorConcept: UIColor {
        get {
            let color = UIColor(red:0.26,
                                green:0.63,
                                blue:0.97,
                                alpha:1.00)
            return color
        }
    }
}





