//
//  HUD.swift
//  PKHUD
//
//  Created by Eugene Tartakovsky on 29/01/16.
//  Copyright © 2016 Eugene Tartakovsky, NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit
import PKHUD

/// 为PKHud添加中间层UKSHud
public enum UKSHUDContentType {
    case success
    case error
    case progress
    case image(UIImage?)
    case rotatingImage(UIImage?)

    case labeledSuccess(title: String?, subtitle: String?)
    case labeledError(title: String?, subtitle: String?)
    case labeledProgress(title: String?, subtitle: String?)
    case labeledImage(image: UIImage?, title: String?, subtitle: String?)
    case labeledRotatingImage(image: UIImage?, title: String?, subtitle: String?)

    case label(String?)
    case systemActivity
    case customView(view: UIView)
}

public final class UKSHUD {

    // MARK: Properties
    public static var dimsBackground: Bool {
        get { return HUD.dimsBackground }
        set { HUD.dimsBackground = newValue }
    }

    public static var allowsInteraction: Bool {
        get { return HUD.allowsInteraction  }
        set { HUD.allowsInteraction = newValue }
    }

    public static var leadingMargin: CGFloat {
        get { return HUD.leadingMargin  }
        set { HUD.leadingMargin = newValue }
    }

    public static var trailingMargin: CGFloat {
        get { return HUD.trailingMargin  }
        set { HUD.trailingMargin = newValue }
    }

    public static var isVisible: Bool { return HUD.isVisible }

    // MARK: Public methods, PKHUD based
    public static func show(_ content: UKSHUDContentType, onView view: UIView? = nil) {
        HUD.show(transformType(content), onView: view)
    }

    public static func hide(_ completion: ((Bool) -> Void)? = nil) {
        HUD.hide(completion)
    }

    public static func hide(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        HUD.hide(animated: animated, completion: completion)
    }

    public static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        HUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: Public methods, HUD based
    public static func flash(_ content: UKSHUDContentType, onView view: UIView? = nil) {
        HUD.flash(transformType(content), onView: view)
    }

    public static func flash(_ content: UKSHUDContentType, onView view: UIView? = nil, delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        HUD.flash(transformType(content), onView: view, delay: delay, completion: completion)
    }
    
    // MARK: Keyboard Methods
    public static func registerForKeyboardNotifications() {
        HUD.registerForKeyboardNotifications()
    }
    
    public static func deregisterFromKeyboardNotifications() {
        HUD.deregisterFromKeyboardNotifications()
    }

    // MARK: Private methods
    fileprivate static func transformType(_ content: UKSHUDContentType) -> HUDContentType {
        switch content {
        case .success:
            return .success
        case .error:
            return .error
        case .progress:
            return .progress
        case let .image(image):
            return .image(image)
        case let .rotatingImage(image):
            return .rotatingImage(image)
        case let .labeledSuccess(title, subtitle):
            return .labeledSuccess(title: title, subtitle: subtitle)
        case let .labeledError(title, subtitle):
            return .labeledError(title: title, subtitle: subtitle)
        case let .labeledProgress(title, subtitle):
            return .labeledProgress(title: title, subtitle: subtitle)
        case let .labeledImage(image, title, subtitle):
            return .labeledImage(image: image, title: title, subtitle: subtitle)
        case let .labeledRotatingImage(image, title, subtitle):
            return .labeledRotatingImage(image: image, title: title, subtitle: subtitle)
        case let .label(text):
            return .label(text)
        case .systemActivity:
            return .systemActivity
        case let .customView(view):
            return .customView(view: view)
        }
    }
}
