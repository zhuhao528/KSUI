//
//  UKSHudViewControllerTest.swift
//  KSUI_Example
//
//  Created by zhu hao on 2020/11/24.
//  Copyright © 2020 zhuhao. All rights reserved.
//

import UIKit
import KSUI

@objc class UKSHudViewControllerTest: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hello world--")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        let button2 = UIButton(type: .custom)
        button2.frame = CGRect(x: 50, y: 200, width: 100, height: 50)
        button2.setTitle("控制器弹窗", for: .normal)
        button2.backgroundColor = .blue
        button2.setTitleColor(.yellow, for: .normal)
        button2.addTarget(self, action: #selector(KSSwiftViewController.button2Clicked(button:)), for: .touchUpInside)
        view.addSubview(button2)
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hidden),
                                               name:NSNotification.Name(rawValue: UKSHudViewControllerManager.Notifications.UKSHudViewControllerHidden),
                                               object: nil)
    }
    
    @objc public func button2Clicked(button:UIButton)  {
        let vc = UKSHudViewController()
        var style = UKSHudViewControllerManager.Style()
//        style.coverType = .none
        style.animationtype = .right
        UKSHudViewControllerManager.default.presentViewController(vc, animated: true, style: style)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc2 = UKSHudViewController()
            var style = UKSHudViewControllerManager.Style()
            style.animationtype = .size
            UKSHudViewControllerManager.default.presentViewController(vc2, animated: true, style: style)
        }
    }
    
    deinit {
        print("deinit")
    }
    
    @objc public func hidden()  {
        
        print("hidden")
        
    }
    
}

