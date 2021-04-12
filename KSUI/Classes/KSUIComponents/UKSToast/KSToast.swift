//
//  KSToast.swift
//  KSBook
//
//  Created by kaishu on 2019/12/19.
//  Copyright © 2019 kaishu. All rights reserved.
//

import Foundation
import Toast_Swift

/// 防止多次提示
private var KSToastExtraAction = false
private func KSToastRepeatActionInterval(_ time: TimeInterval? = 1) -> Bool {
    guard var time = time else { return true }
    if time > 5 || time < 0 { time = 1 }
    if KSToastExtraAction { return true }
    KSToastExtraAction = true
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        KSToastExtraAction = false
    }
    return false
}

/// Toast
public struct KSToast {
    /**
     Toast显示位置

     - top: 顶部
     - center: 中间
     - bottom: 底部
     */
    public enum KSToastPosition {
        case top
        case center
        case bottom
    }

    /// 在window上展示toast
    /// - Parameters:
    ///   - message: 显示信息
    ///   - duration: 时长
    ///   - position: 显示位置
    public static func makeToast(_ message: String?, duration: TimeInterval? = nil, position: KSToastPosition = .center) {
        guard let message = message, !message.isEmpty else { return }
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        /// 将弹窗放到队列中去
        ToastManager.shared.isQueueEnabled = true
        
        guard let duration = duration else {
            ///如果没有设置时长，则按照message长度来动态计算时长
            
            ///默认300ms的反应时长， 200ms一个字符长度
            var dynamicDuration: TimeInterval = max(1, min(5, 0.3 + Double(message.count) * 0.2))
            makeToast(message, view: keyWindow, duration: dynamicDuration, position: position)

            return
        }
        makeToast(message, view: keyWindow, duration: duration, position: position)
    }

    /// 在指定view上显示toast
    /// - Parameters:
    ///   - message: 显示信息
    ///   - view: 显示view
    ///   - duration: 时长
    ///   - position: 显示位置
    public static func makeToast(_ message: String?, view: UIView, duration: TimeInterval = 2.5, position: KSToastPosition = .center) {
        guard let message = message, !message.isEmpty else { return }
        if KSToastRepeatActionInterval(1.5) { return }
        var toast_position: ToastPosition = .center
        switch position {
        case .top:
            toast_position = .top
        case .center:
            toast_position = .center
        case .bottom:
            toast_position = .bottom
        }
        view.makeToast(message, duration: duration, position: toast_position)
    }
    
}

@objc public class KSToastOC: NSObject {
    @objc static func makeToast(_ message: String) {
        KSToast.makeToast(message)
    }
}
