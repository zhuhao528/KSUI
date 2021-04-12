//
//  UKSHudView.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/16.
//

import UIKit

public protocol UKSHudViewDelegate {
    /// 点击关闭按钮
    func UKSHudViewCloseButonClick(hudView:UKSHudView)
    /// 点击空白区域
    func UKSHudViewBlankClick(hudView:UKSHudView)
}

/// 蒙版
open class UKSHudView: UIView {
    
    /// 内容视图位置
    public enum ContentPositionStyle : Int {
        ///  HUD中间，默认
        case center
        ///  HUD顶部
        case top
        ///  屏幕底部
        case bottom
    }
    
    /// 关闭按钮位置
    public enum CloseButtonPositionStyle : Int {
        ///  在弹窗视图的右上角
        case inTop
        ///  在弹窗视图外部右上角
        case outTop
        ///  在弹窗视图的底部
        case bottom
    }
    
    /// 点击空白区域是否消失
    public var isNeedHidden = false
    /// 是否添加到window
    public var isAddToWindow = true
    /// 弹窗类名
    public var contentClass:String?
    
    // MARK: - Property
    /** 内容视图真实位置 */
    public var contentPositionStyle: ContentPositionStyle?
    /** 关闭按钮真实位置 */
    public var closeButtonPositionStyle: CloseButtonPositionStyle?
    /** 蒙层透明度 */
    public var alphaContentEnd:Double?
    /** 回调代理 */
    public var delegate : UKSHudViewDelegate?
    
    // MARK: - UI
    /// 内容区视图
    public var contentView: UIView? {
        didSet {
            guard let contentView = contentView else { return }
            self.addSubview(contentView)
            contentView.addSubview(closeButton)
            layoutSubviews()
        }
    }
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.backgroundColor = .blue
        closeButton.addTarget(self, action: #selector(UKSHudView.closeButtonClicked), for: .touchUpInside)
        closeButton.adjustsImageWhenHighlighted = false
        return closeButton
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    // MARK: - Overide
    override init(frame: CGRect) {
        super.init(frame: frame)
        configDefaultInit()
        configSubviews()
        configLayoutSubviews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configDefaultInit()
        configSubviews()
        configLayoutSubviews()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let contentView = contentView else { return }
        switch self.contentPositionStyle{
        case .center:
            var rect = contentView.frame
            rect.origin.x = (UIScreen.main.bounds.width-rect.size.width)/2
            rect.origin.y = (UIScreen.main.bounds.height-rect.size.height)/2
            contentView.frame = rect
        case .top:
            var rect = contentView.frame
            rect.origin.x = (UIScreen.main.bounds.width-rect.size.width)/2
            rect.origin.y = 0
            contentView.frame = rect
        case .bottom:
            var rect = contentView.frame
            rect.origin.x = (UIScreen.main.bounds.width-rect.size.width)/2
            rect.origin.y = UIScreen.main.bounds.height-rect.size.height
            contentView.frame = rect
        case .none:
            var rect = contentView.frame
            rect.origin.x = (UIScreen.main.bounds.width-rect.size.width)/2
            rect.origin.y = (UIScreen.main.bounds.height-rect.size.height)/2
            contentView.frame = rect
        }
        self.closeButton.isHidden = false
        switch self.closeButtonPositionStyle{
        case .inTop:
            self.closeButton.frame = CGRect(x: contentView.frame.size.width-10,
                                            y: -5,
                                            width: 10,
                                            height: 10)
        case .outTop:
            self.closeButton.frame = CGRect(x: contentView.frame.size.width+10,
                                            y: -20,
                                            width: 10,
                                            height: 10)
            
        case .bottom:
            self.closeButton.frame = CGRect(x: (contentView.frame.size.width+10)/2,
                                            y: contentView.frame.size.height + 20,
                                            width: 10,
                                            height: 10)
            
        case .none:
            self.closeButton.isHidden = true
        }
    }
    
}

// MARK: - Layout
extension UKSHudView {
    
    func configDefaultInit() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    func configSubviews() {
        self.addGestureRecognizer(self.tapGesture)
    }
    
    func configLayoutSubviews() {
        
    }
}

// MARK: - Aciton
extension UKSHudView {
    
    @objc func closeButtonClicked(){
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.UKSHudViewCloseButonClick(hudView: self)
    }
    
    @objc func tap(){
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.UKSHudViewBlankClick(hudView: self)
    }
    
}

extension UKSHudView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 阴影部分才响应 视图属于self 不响应
        guard let contentView = self.contentView else { return false}
        return !(touch.view?.isDescendant(of: contentView) ?? false)
    }
    
}
