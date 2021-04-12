//
//  UKSHudViewControllerManager.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/22.
//

import UIKit
import KSRouterHelpToolModule

@objc public protocol UKSHudViewControllerDismissDelegate {
    @objc func hudViewControllerDismissAction();
}

open class UKSHudViewControllerManager: NSObject {
    
    public struct Notifications {
        public static let UKSHudViewControllerShow = "UKSGeneralAlert.Notifications.UKSHudViewControllerShow"
        public static let UKSHudViewControllerHidden = "UKSGeneralAlert.Notifications.UKSHudViewControllerHidden"
    }
    
    /// 配置
    public struct Style {
        public var needHide = true
        public var animationtype: UKSHudViewControllerAnimator.AnimationType = .right
        public var coverType: UKSHudPresentationController.CoverType = .cover
        
        public init() {
            
        }
    }
    
    var mapTable = NSMapTable<AnyObject, AnyObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)
    
    public static let `default` = UKSHudViewControllerManager()
    
    public func presentViewController(_ viewControllerToPresent: UIViewController,
                                      animated flag: Bool,
                                      style: Style = Style(),
                                      completion: ((_ presented: Bool) -> ())? = nil)  {
        let animator = UKSHudViewControllerAnimator { (presented) in
            completion?(presented)
            if presented {
                NotificationCenter.default.post(name: NSNotification.Name(Notifications.UKSHudViewControllerShow),
                                                object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(Notifications.UKSHudViewControllerHidden),
                                                object: nil)
            }
        }
        mapTable.setObject(animator, forKey: viewControllerToPresent)
        animator.animationType = style.animationtype
        animator.presentedFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        animator.coverType = style.coverType
        //        viewControllerToPresent.modalPresentationStyle = .custom
        //        viewControllerToPresent.transitioningDelegate = animator
        
        let nav = UINavigationController(rootViewController: viewControllerToPresent)
        nav.setNavigationBarHidden(true, animated: false)
        nav.view.backgroundColor = .clear
        nav.modalPresentationStyle = .custom
        nav.transitioningDelegate = animator
        UKSHudViewControllerManager.default.topViewController()?.present(nav, animated: flag, completion: nil)
        
        viewControllerToPresent.view.tag = style.needHide ? 1 : 0
        viewControllerToPresent.view.backgroundColor = .clear
        let button = UIButton()
        button.frame = viewControllerToPresent.view.bounds;
        button.backgroundColor = .clear
        viewControllerToPresent.view.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(UKSHudViewControllerManager.action), for: .touchUpInside)
        viewControllerToPresent.view.insertSubview(button, at: 0)
    }
    
    public func dissmissViewController(animated flag: Bool, completion: (() -> Void)? = nil) {
        UKSHudViewControllerManager.default.topViewController()?.dismiss(animated: flag, completion: {
            completion?()
        })
    }
    
    @objc public func action() {
        if UKSHudViewControllerManager.default.topViewController()?.view.tag == 1 {
            dissmissViewController(animated: true)
        }
        guard let cls = object_getClass(UKSHudViewControllerManager.default.topViewController()).self as AnyObject as? UKSHudViewControllerDismissDelegate, let vc = UKSHudViewControllerManager.default.topViewController() else { return }
        if vc.responds(to: #selector(cls.hudViewControllerDismissAction)) {
            guard let delegate = vc as? UKSHudViewControllerDismissDelegate else { return }
            delegate.hudViewControllerDismissAction()
        }
    }
    
}

extension UKSHudViewControllerManager {
    
    func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        //        if let nav = viewController as? UINavigationController {
        //            return topViewController(nav.visibleViewController)
        //        }
        //        if let tab = viewController as? UITabBarController {
        //            if let selected = tab.selectedViewController {
        //                return topViewController(selected)
        //            }
        //        }
        //        if let presented = viewController?.presentedViewController {
        //            return topViewController(presented)
        //        }
        //        return viewController
        return KSRouterTool.fetchCurrentViewController()
    }
    
    func topNavigation(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {
        
        if let nav = viewController as? UINavigationController {
            return nav
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.navigationController
            }
        }
        return viewController?.navigationController
    }
}



