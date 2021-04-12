//
//  UKSHudViewControllerAnimator.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/21.
//

import UIKit

/// 弹出动画
public class UKSHudViewControllerAnimator: NSObject {
    
    /// 动画类型
    public enum AnimationType {
        case size
        case right
        case none
    }
    
    public var animationType = AnimationType.right
    
    public var presentedFrame: CGRect = .zero
    
    public var coverType = UKSHudPresentationController.CoverType.blur
    
    private var callBack: ((_ presented: Bool) -> ())?
    private var isPresented: Bool = false
    
    // 注意: 如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    public init(_ callBack: @escaping (_ presented: Bool) -> ()) {
        self.callBack = callBack
    }
    
}

extension UKSHudViewControllerAnimator: UIViewControllerTransitioningDelegate {
    
    // 改变弹出View的尺寸
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = UKSHudPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        presentation.coverType = coverType
        return presentation
    }
    
    // 自定义弹出的动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack?(isPresented)
        return self
    }
    
    // 自定义消失的动画
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension UKSHudViewControllerAnimator: UIViewControllerAnimatedTransitioning {
    
    // 动画执行的时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if animationType == .none {
            return 0.01
        }
        return 0.5
    }
    
    // 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    /// 自定义弹出动画
    private func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        // 1. 获取弹出的View
        guard let presentedView = transitionContext.view(forKey: .to) else { return }
        
        // 2. 将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        // 3. 执行动画
        if self.animationType == .right{
            transitionContext.containerView.alpha = 0
            
            let toRect = presentedView.frame
            var fromRect = presentedView.frame
            fromRect.origin.x += presentedView.frame.size.width
            presentedView.frame = fromRect
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                presentedView.frame = toRect
                transitionContext.containerView.alpha = 1
            }) { (finished) in
                // 必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
                
            }
        }else{
            transitionContext.containerView.alpha = 0
            presentedView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            //presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                presentedView.transform = .identity
                transitionContext.containerView.alpha = 1
            }) { (finished) in
                // 必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
                
            }
        }
    }
    
    /// 自定义消失动画
    private func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        // 1. 获取消失的View
        guard let dismissView = transitionContext.view(forKey: .from) else { return }
        
        if self.animationType == .right {
            // 2. 执行动画
            var toRect = dismissView.frame
            toRect.origin.x += dismissView.frame.size.width
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                dismissView.frame = toRect
                transitionContext.containerView.alpha = 0
            }) { (finished) in
                dismissView.removeFromSuperview()
                // 必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
                
                if finished{
                    self.callBack?(self.isPresented)
                }
                
            }
        }else{
            // 2. 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                dismissView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                transitionContext.containerView.alpha = 0
            }) { (finished) in
                dismissView.removeFromSuperview()
                // 必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
                
                if finished{
                    self.callBack?(self.isPresented)
                }

            }
        }
    }
    
}
