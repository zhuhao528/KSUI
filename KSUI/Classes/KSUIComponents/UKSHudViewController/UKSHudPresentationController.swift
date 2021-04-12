//
//  UKSHudPresentationController.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/21.
//

import UIKit

open class UKSHudPresentationController: UIPresentationController {
    public var presentedFrame : CGRect = .zero
    
    /// 蒙层类型
    public enum CoverType {
        case cover
        case blur
        case none
    }

    public var coverType :CoverType = .none
    
    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return coverView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 1.设置弹出View的尺寸
//      presentedView?.frame = presentedFrame
        
        // 2.添加蒙版
        configCoverView()
    }
    
//    open override var shouldRemovePresentersView: Bool{
//        return true
//    }
  
}

extension UKSHudPresentationController {
    
    private func configCoverView() {
        
        
        switch self.coverType {
        case .blur:
            containerView?.insertSubview(blurView, at: 0)
            blurView.frame = containerView?.bounds ?? .zero
        
        case .cover:
            
            containerView?.insertSubview(coverView, at: 0)
            coverView.frame = containerView?.bounds ?? .zero
            
        case .none:
            
            blurView.removeFromSuperview()
            coverView.removeFromSuperview()
            
        }
        
        //        // 3.添加手势
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.coverViewAction))
        //        //coverView.addGestureRecognizer(tap)
        //        blurView.addGestureRecognizer(tap)
    }
    
    @objc private func coverViewAction() {
        guard let view = containerView?.subviews.last, view.isUserInteractionEnabled else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
