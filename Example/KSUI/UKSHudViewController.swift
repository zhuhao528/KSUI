//
//  UKSHudViewController.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/21.
//

import UIKit
import KSUI

open class UKSHudViewController: UIViewController, UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        let content = UIView()
        content.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 100))
        content.center = view.center
        content.backgroundColor = UIColor(red: CGFloat(arc4random()%256) / 255.0, green: CGFloat(arc4random()%256) / 255.0, blue: CGFloat(arc4random()%256) / 255.0, alpha: 1)
        self.view.addSubview(content)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UKSHudViewControllerManager.action))
        tap.delegate = self
        content.isUserInteractionEnabled = true
        content.addGestureRecognizer(tap)
    }
    
    @objc public func action() {
        print("hello word")
    }

}

/* 蒙层点击回调事件 不用可以不写
 extension UKSHudViewController : UKSHudViewControllerDismissDelegate {
 public func hudViewControllerDismissAction() {
 print("hello world")
 }
 }
 */
