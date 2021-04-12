//
//  KSSwiftViewController.swift
//  KSUI_Example
//
//  Created by zhu hao on 2020/9/18.
//  Copyright © 2020 zhuhao. All rights reserved.
//

import UIKit
import KSUI

@objc class KSSwiftViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hello world--")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 50, y: 100, width: 100, height: 50)
        button.setTitle("弹窗", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.yellow, for: .normal)
        button.addTarget(self, action: #selector(KSSwiftViewController.buttonClicked(button:)), for: .touchUpInside)
        view.addSubview(button)
        
        let button2 = UIButton(type: .custom)
        button2.frame = CGRect(x: 50, y: 200, width: 100, height: 50)
        button2.setTitle("控制器弹窗", for: .normal)
        button2.backgroundColor = .blue
        button2.setTitleColor(.yellow, for: .normal)
        button2.addTarget(self, action: #selector(KSSwiftViewController.button2Clicked(button:)), for: .touchUpInside)
        view.addSubview(button2)
        
        let button3 = UIButton(type: .custom)
        button3.frame = CGRect(x: 50, y: 300, width: 100, height: 50)
        button3.setTitle("年龄选择器", for: .normal)
        button3.backgroundColor = .blue
        button3.setTitleColor(.yellow, for: .normal)
        button3.addTarget(self, action: #selector(KSSwiftViewController.button3Clicked(button:)), for: .touchUpInside)
        view.addSubview(button3)
        
        let button4 = UIButton(type: .custom)
        button4.frame = CGRect(x: 200, y: 100, width: 100, height: 50)
        button4.setTitle("ActionSheet", for: .normal)
        button4.backgroundColor = .blue
        button4.setTitleColor(.yellow, for: .normal)
        button4.addTarget(self, action: #selector(KSSwiftViewController.button4Clicked(button:)), for: .touchUpInside)
        view.addSubview(button4)
        
        let button5 = UIButton(type: .custom)
        button5.frame = CGRect(x: 200, y: 200, width: 150, height: 50)
        button5.setTitle("AStoryActionSheet", for: .normal)
        button5.backgroundColor = .blue
        button5.setTitleColor(.yellow, for: .normal)
        button5.addTarget(self, action: #selector(KSSwiftViewController.button5Clicked(button:)), for: .touchUpInside)
        view.addSubview(button5)
        
        let button6 = UIButton(type: .custom)
        button6.frame = CGRect(x: 200, y: 300, width: 150, height: 50)
        button6.setTitle("通用弹窗", for: .normal)
        button6.backgroundColor = .blue
        button6.setTitleColor(.yellow, for: .normal)
        button6.addTarget(self, action: #selector(KSSwiftViewController.button6Clicked(button:)), for: .touchUpInside)
        view.addSubview(button6)
        
        let button7 = UIButton(type: .custom)
        button7.frame = CGRect(x: 350, y: 100, width: 150, height: 50)
        button7.setTitle("通用弹窗", for: .normal)
        button7.backgroundColor = .blue
        button7.setTitleColor(.yellow, for: .normal)
        button7.addTarget(self, action: #selector(KSSwiftViewController.button7Clicked(button:)), for: .touchUpInside)
        view.addSubview(button7)
        
        let button8 = UIButton(type: .custom)
        button8.frame = CGRect(x: 400, y: 200, width: 150, height: 50)
        button8.setTitle("UKSHud", for: .normal)
        button8.backgroundColor = .blue
        button8.setTitleColor(.yellow, for: .normal)
        button8.addTarget(self, action: #selector(KSSwiftViewController.button8Clicked(button:)), for: .touchUpInside)
        view.addSubview(button8)
        
        let button9 = UIButton(type: .custom)
        button9.frame = CGRect(x: 50, y: 400, width: 150, height: 50)
        button9.setTitle("HorizontalListActionSheet", for: .normal)
        button9.backgroundColor = .blue
        button9.setTitleColor(.yellow, for: .normal)
        button9.addTarget(self, action: #selector(KSSwiftViewController.button9Clicked(button:)), for: .touchUpInside)
        view.addSubview(button9)

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hidden),
                                               name:NSNotification.Name(rawValue: UKSHudViewControllerManager.Notifications.UKSHudViewControllerHidden),
                                               object: nil)
        
//        for i in 0...5 {
//            if i == 0{
//                KSToast.makeToast("helo ")
//            }else if i == 1 {
//                KSToast.makeToast("helo llllll22222222")
//            }else if i == 2 {
//                KSToast.makeToast("llllll")
//            }else if i == 3 {
//                KSToast.makeToast("helo lll")
//            }else if i == 4 {
//                KSToast.makeToast("helo mmmmmmmmm")
//            }
//        }
    }
    
    @objc public func buttonClicked(button:UIButton)  {
        print("buttonClicked")
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        contentView.backgroundColor = .red
        let hudView = UKSHudView()
        hudView.contentPositionStyle = .center
        hudView.closeButtonPositionStyle = .bottom
        let ani = UKSHudViewAnimator()
        ani.contentAnimateStyle = .smallSize
        let manager = UKSHudViewManager()
        manager.hudShowWithContentView(contentView: contentView,
                                       hudView: hudView,
                                       animator: ani,
                                       showHudBlock:{ (UKSHudView) in
                                        print("show")
                                       }) { (UKSHudView) in
            print("hidden")
        }
    }
    
    @objc public func button2Clicked(button:UIButton)  {
        //        let vc = UKSHudViewController()
        //        var style = UKSHudViewControllerManager.Style()
        //        style.coverType = .cover
        //        style.animationtype = .right
        //        UKSHudViewControllerManager.default.presentViewController(vc, animated: true, style: style)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //            let vc2 = UKSHudViewController()
        //            var style = UKSHudViewControllerManager.Style()
        //            style.animationtype = .size
        //            UKSHudViewControllerManager.default.presentViewController(vc2, animated: true, style: style)
        //        }
        let vc = UKSHudViewControllerTest()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc public func button3Clicked(button:UIButton)  {
        let vc = UKSDatePickerViewDemoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc public func button4Clicked(button:UIButton)  {
        let sheet = KSActionSheet.init(titleView: UIView(), optionsArr: ["hello","world"], cancelTitle: "取消",
                                       selectedBlock: { (_) in
                                        
                                       }) {
            
        }
        self.view.addSubview(sheet)
    }
    
    @objc public func button5Clicked(button:UIButton)  {
        let content = KSStoryActionContent()
        content.optionsArr = ["垃圾营销","有害信息","辱骂、人生攻击等不善行为","不实信息"]
        content.cancelTitle = "取消"
        content.titleString = "选择您要举报的内容类型"
        _ = KSStoryActionSheet.init(content: content, style: nil, selectedBlock: { (_) in

        }) {

        }
    }
    
    @objc public func button6Clicked(button:UIButton)  {
        UKSGeneralAlert.showAlertView(title: "账户异常", desc: "您的账号已在其他设备登录。如果非本人操作，请联系客服", subDesc: "hello") {
            print("sure pressed")
        }
    }
    
    @objc public func button7Clicked(button:UIButton)  {
        
        UKSGeneralAlert.showVIPAlertView(title: "账户异常", desc: "您的账号已在其他设备登录。如果非本人操作，请联系客服", subDesc: "hello") {
            print("sure pressed")
        }
        
    }
    
    @objc public func button8Clicked(button:UIButton)  {
        
        UKSHUD.dimsBackground = false
        //      UKSHUD.show(.labeledProgress(title:"hello", subtitle: ""))
        let label = UILabel()
        label.frame = CGRect(x:0,y:0,width:50,height:50)
        label.text = "hello world"
        UKSHUD.show(.customView(view: label))
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute:{
            //            UKSHUD.flash(.success, delay: 1.0)
            UKSHUD.hide()
        })
    }
    
    @objc public func button9Clicked(button:UIButton)  {
        
        ///创建方式1
        var actionSheet:KSCommonHorizontalListActionSheet?
        actionSheet = KSCommonHorizontalListActionSheet.init(imageArray: ["icon_share_wechat","icon_share_friends","icon_share_qq"], textArray: ["微信","朋友圈","QQ"], selectedHandler: { (index,imageView) in
            print("index = \(index)")

            actionSheet?.dismiss()
        }, cancelHandler: {
            print("取消")
        })
        
        actionSheet?.showCompletedHandler = {
            actionSheet?.updateImage(withName: "icon_share_qq", index: 0)
            actionSheet?.updateText("更换文字", index: 1)

            let imageView = actionSheet?.getImageView(with: 2)
            imageView?.image = UIImage(named: "icon_share_friends")
        }
                
        /* 创建方式2
        let sheet = KSCommonHorizontalListActionSheet.init(imageArray: ["icon_share_wechat","icon_share_friends","icon_share_qq"], textArray: ["微信","朋友圈","QQ"])
        sheet.selectedHandler = { (index,imageView) in
            print("index = \(index)")
            sheet.dismiss()
        }
        sheet.cancelHandler = {
            print("取消")
        }
          */
    }

    @objc public func hidden()  {
        
        print("hidden")
        
    }
}


