//
//  UKSHudViewManager.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/16.
//

import UIKit
import KSRouterHelpToolModule

open class UKSHudViewManager: UIView {
    
    public struct Notifications {
        public static let UKSGeneralAlertShow = "UKSGeneralAlert.Notifications.UKSGeneralAlertShow"
        public static let UKSGeneralAlertHidden = "UKSGeneralAlert.Notifications.UKSGeneralAlertHidden"
    }
    
    /// 属性
    var contentView:UIView?
    var hudView:UKSHudView?
    var UNKHudViewAni:UKSHudViewAnimator?
    var showBlock:(UKSHudView)->Void = {_ in }
    var hidenBolock:(UKSHudView)->Void = {_ in }
    
    public func serializer() -> UKSHudViewManager{
        return self
    }
    
    /// 弹出视图
    public func hudShowWithContentView(contentView:UIView?,
                                hudView:UKSHudView? = UKSHudView(),
                                animator:UKSHudViewAnimator? = UKSHudViewAnimator(),
                                showHudBlock:@escaping (UKSHudView)->Void,
                                hideHudBlock:@escaping (UKSHudView)->Void){
        guard let contentView = contentView else { return  }
        guard let hudView = hudView else { return  }
        guard let animator = animator else { return  }
        /// 如果多次弹出，做返回容错处理
        let tempHudView:UKSHudView?
        if hudView.isAddToWindow {
            tempHudView =  UIApplication.shared.keyWindow?.viewWithTag(10000) as? UKSHudView
        }else{
            tempHudView =  KSRouterTool.fetchCurrentViewController().view.viewWithTag(10000) as? UKSHudView
        }
        if NSStringFromClass(type(of: contentView)) == NSStringFromClass(type(of: tempHudView?.contentView ?? UIView())) {
            return
        }
        self.contentView = contentView
        self.hudView = hudView
        self.hudView?.delegate = self
        self.hudView?.contentView = contentView
        self.hudView?.tag = 10000
        self.UNKHudViewAni = animator
        self.UNKHudViewAni?.delegate = self
        self.showBlock = showHudBlock
        self.hidenBolock = hideHudBlock
        if hudView.isAddToWindow {
            UIApplication.shared.keyWindow?.addSubview(hudView) /// 取消加载到UIWindow上
        }else{
            KSRouterTool.fetchCurrentViewController().view.addSubview(hudView)
        }
        self.UNKHudViewAni?.UKSHudViewAnimateSytleShowAnimator(hudView: hudView, contentView: contentView)
    }
    
    /// 隐藏视图
    public func hiddenHudView(){
        /// 发送通知
        self.UNKHudViewAni?.UKSHudViewAnimateSytleDisappearAnimator(hudView: self.hudView!, contentView: self.contentView!)
        self.hudView?.removeFromSuperview()
    }
}

extension UKSHudViewManager : UKSHudViewAnimatorDelegate{
    /// 显示动画
    public func UKSHudViewAnimateIsShow(hudView:UKSHudView,contentView:UIView){
        self.showBlock(self.hudView!)
        /// 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(Notifications.UKSGeneralAlertShow),
                                        object: self.contentView)
    }
    /// 消失动画
    public func UKSHudViewAnimateSytleIsDisappear(hudView:UKSHudView,contentView:UIView){
        self.hidenBolock(self.hudView!)
        /// 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(Notifications.UKSGeneralAlertHidden),
                                        object: self.contentView)
    }
}

extension UKSHudViewManager : UKSHudViewDelegate{
    /// 点击关闭按钮
    public func UKSHudViewCloseButonClick(hudView:UKSHudView){
        self.hiddenHudView()
    }
    
    /// 点击空白区域
    public func UKSHudViewBlankClick(hudView:UKSHudView){
        if hudView.isNeedHidden {
            self.hiddenHudView()
        }
    }

}






