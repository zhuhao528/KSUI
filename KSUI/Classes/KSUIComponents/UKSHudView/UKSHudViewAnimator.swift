//
//  UKSHudViewAnimator.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/16.
//

import UIKit

/// 继承UKSHudViewAnimator复写协议实现扩展动画
public protocol ExtensionUKSHudViewAnimatorProtocol {
    /// 显示动画
    func UKSHudViewAnimateSytleShowAnimator(hudView:UKSHudView,contentView:UIView)
    /// 消失动画
    func UKSHudViewAnimateSytleDisappearAnimator(hudView:UKSHudView,contentView:UIView)
}

/// 动画结束回调
public protocol UKSHudViewAnimatorDelegate {
    /// 显示动画结束回调
    func UKSHudViewAnimateIsShow(hudView:UKSHudView,contentView:UIView)
    /// 隐藏动画结束回调
    func UKSHudViewAnimateSytleIsDisappear(hudView:UKSHudView,contentView:UIView)
}

open class UKSHudViewAnimator: UIView {
    
    public enum UKSHudViewContentAnimateStyle {
        case immedia
        case top
        case bottom
        case smallSize
    }
    
    /// 显示动画时间
    open var timeShowDuring:Double = 0.3;
    /// 消失动画时间
    open var timeHiddenDuring:Double = 0.3;
    /// 动画类型
    public var contentAnimateStyle:UKSHudViewContentAnimateStyle = .bottom
    /// 回调代理
    public var delegate:UKSHudViewAnimatorDelegate?
    
    var hudView:UKSHudView?
    
    var contentView:UIView?
}

extension UKSHudViewAnimator : ExtensionUKSHudViewAnimatorProtocol {
    
    /// 显示动画
    public func UKSHudViewAnimateSytleShowAnimator(hudView:UKSHudView,contentView:UIView) {
        self.hudView = hudView
        self.contentView = contentView
        /// 背景动画
        hudView.alpha = 0.0
        UIView.animate(withDuration: self.timeShowDuring, animations: {
            hudView.alpha = 1.0
        }, completion: nil)
        /// 结束回调
        let delegateBlock = { (finish:Bool) -> Void in
            guard (self.delegate != nil) else {
                return
            }
            self.delegate!.UKSHudViewAnimateIsShow(hudView: self.hudView!, contentView: self.contentView!)
        }
        /// 内容动画
        switch self.contentAnimateStyle{
        case .bottom:
            let toRect = contentView.frame
            var fromRect = contentView.frame
            fromRect.origin.y = hudView.bounds.size.height
            contentView.frame = fromRect
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.frame = toRect
            }, completion: delegateBlock)
        case .top:
            let toRect = contentView.frame
            var fromRect = contentView.frame
            fromRect.origin.y = -contentView.bounds.size.height
            contentView.frame = fromRect
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.frame = toRect
            }, completion: delegateBlock)
        case .smallSize:
            contentView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: delegateBlock)
        case .immedia:
            contentView.alpha = 0.75
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.alpha = 1.0
            }, completion: delegateBlock)
        }
    }
    
    /// 隐藏动画
    public func UKSHudViewAnimateSytleDisappearAnimator(hudView:UKSHudView,contentView:UIView){
        self.hudView = hudView
        self.contentView = contentView
        /// 背景动画
        UIView.animate(withDuration: self.timeShowDuring, animations: {
            hudView.alpha = 0.0
        }, completion: nil)
        /// 结束回调
        let delegateBlock = { (finish:Bool) -> Void in
            guard (self.delegate != nil) else {
                return
            }
            self.delegate!.UKSHudViewAnimateSytleIsDisappear (hudView: self.hudView!, contentView: self.contentView!)
        }
        /// 内容动画
        switch self.contentAnimateStyle{
        case .bottom:
            var toRect = contentView.frame
            toRect.origin.y = hudView.bounds.size.height
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.frame = toRect
            }, completion: delegateBlock)
        case .top:
            var toRect = contentView.frame
            toRect.origin.y = -contentView.bounds.size.height
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.frame = toRect
            }, completion: delegateBlock)
        case .smallSize:
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: delegateBlock)
        case .immedia:
            UIView.animate(withDuration: self.timeShowDuring, animations: {
                contentView.alpha = 0.0
            }, completion: delegateBlock)
        }
    }
}


