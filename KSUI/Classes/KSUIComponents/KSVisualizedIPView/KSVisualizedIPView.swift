//
//  ARCustomSKView.swift
//  ARDemo
//
//  Created by Levi Han on 2020/9/4.
//

import UIKit
import SpriteKit
//import KSAudioPlayerModule
/// IP形象视图
///
/// 继承自SKView，加载骨骼动画贴图，based on spine
/// 当做一个View，可以添加到任意位置
@objcMembers
open class KSVisualizedIPView: SKView {
    
    /// IP形象枚举
    public enum Name: String {
        case tutu = "tutu"
    }
    
    /// IP动画枚举
    public enum Animation: String {
        case walk = "walk"
        case sleep = "sleep"
    }
    /// IP音效枚举
    public enum Audio: String {
        case walk = "王者荣耀Lets Play Again"
        case sleep = "airplane-prop-ext"
    }
    
    /// 返回当前ip形象名称
    private (set) var ipName: Name = .tutu
    /// 当前IP形象的动画名称
    private (set) var animationName : Animation = .walk
    /// 当前IP形象的音效名称
    private (set) var audioName : Audio = .walk
    /// 唯一id
    private (set) var identifier: String = ""

    private var ipNode : Skeleton?
    
    /// 播放器
//    private lazy var audioPlayViewController: KSAudioPlayViewController = {
//        let player = KSAudioPlayViewController(playerManager: KSIJKAudioManager())
//        return player
//    }()
//    /// 播放器<只读>
//    public var audioPlayer: KSAudioPlayProtocol {
//        return audioPlayViewController.currentPlayerManager
//    }
    
    typealias Closure = () -> Void
    var didTapCallback : Closure?
    var didPanCallback : Closure?

    /// 设置是否禁用内部音频播放器-SKAudioNode。
    ///
    /// - 如果不需要使用内部音频播放，例如可能点击ip形象后使用App的音频播放器
    /// - if true，ip形象不会播放所有音频
    var disableInternalAudio = false {
        didSet {
            if disableInternalAudio {
                removeAudio()
            }
        }
    }

    //MARK: - LifeCycle
    convenience public init(ip: Name, frame: CGRect) {
        self.init(frame:frame)
        self.ipName = ip
    }
    
    convenience public init(ip: String, identifier: String = "", frame: CGRect) {
        self.init(frame:frame)
        self.ipName = Name(rawValue: ip) ?? .tutu
        self.identifier = identifier
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        //使用自定义场景
        let scene = MySKScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .white
        self.presentScene(scene)
        
        //添加手势
        addGesture()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init coder")
    }
    
    open override func layoutSubviews() {
        setup()
    }
    
    //MARK: - Public
    /// 执行动画
    /// - Parameter name: 动画名称Animation枚举
    /// - 播放一次
    public func startAnimation(_ name: Animation) {
        startAnimation(name: name.rawValue, repeated: false) {}
    }
    /// 执行动画
    /// - Parameter name: 动画名称-Animation枚举
    /// - Parameter repeated: 是否循环播放
    /// - Parameter completion: 单次播放结束回调
    public func startAnimation(_ name: Animation, repeated: Bool = false, completion: @escaping () -> Void ) {
        startAnimation(name: name.rawValue, repeated: repeated, completion: completion)
    }
    
    /// 执行动画
    /// - Parameter name: 动画名称字符串
    /// - 播放一次
    public func startAnimation(name: String) {
        startAnimation(name: name, repeated: false) {}
    }
    
    /// 执行动画
    /// - Parameter name: 动画名称字符串
    /// - Parameter repeated: 是否循环播放
    /// - Parameter completion: 单次播放结束回调
    public func startAnimation(name: String, repeated: Bool = false, completion: @escaping () -> Void ) {
        //先清除所有动作？
        ipNode?.removeAllActions()
        //根据不同状态，执行对应动效
        if let anim = ipNode?.animation(named: name) {
            animationName = Animation(rawValue: name) ?? .walk
            if repeated {
                //循环执行动画
                ipNode?.run(SKAction.repeatForever(anim))
            }else {
                //执行一次动画
                ipNode?.run(anim) {
                    print("walkAnimation complete")
                    completion()
                }
            }
        }else {
            print("Can't find animation with \(name)")
        }
    }
    
    /// 播放音效
    /// - Parameter name: 音效名称-枚举
    ///
    /// 会切换音效
    public func playAudio(_ name: Audio) {
        removeAudio()
        if !disableInternalAudio {
            audioName = name
            addAudio(name: name.rawValue)
        }
    }
    /// 播放音效
    /// - Parameter name: 音效名称-字符串
    ///
    /// 会切换音效
    public func playAudio(name: String) {
        removeAudio()
        if !disableInternalAudio {
            audioName = Audio(rawValue: name) ?? .walk
            addAudio(name: name)
        }
    }

    /// 通过文字转换成音频播放
    /// 内部调用讯飞SDK：文字->语音-->变声 输出音频，再使用App内音频播放器播放
    /// SDK内变声是通过接口，所以是异步的可能会有延迟
    /// - Parameter text: 文字
    public func playAudio(text:String) {
        //
    }
}

extension KSVisualizedIPView {
    // MARK: - Private
    private func setup() {
        let width = self.bounds.size.width
        let height = self.bounds.size.height

        self.scene?.size = CGSize(width: width, height: height)

        //添加ip形象模型
        if let node = ipNode {
            adjustScale(for: node)
        }
        else if let node = addSKNodeUsingSpine(x: 0, y: 0) {
            adjustScale(for: node)
            ipNode = node
            self.scene?.addChild(node)
        }
    }
    
    private func adjustScale(for node:Skeleton) {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        // 设置缩放比例
        // 计算当前模型需要缩放的比例
        // node.skeleton skeleton 是在spine中自己增加的属性，方便拿到size
        if let skeleton = node.skeleton {
            let size = skeleton.size
            let xScale = width/(size.width + 10)
            let yScale = height/(size.height + 20)
            let scale = min(xScale,yScale)
    
            node.xScale = scale
            node.yScale = scale
        }
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(pan)
    }
    
    @objc
    private func didTap() {
        self.didTapCallback?()
    }
    
    @objc
    private func didPan() {
        self.didPanCallback?()
    }
    
    private func addSKNodeUsingSpine(x: CGFloat, y: CGFloat) -> Skeleton? {
        if ipName == .tutu {
            guard let character = Skeleton(fromJSON: "goblins-ess", atlas: "Goblins", skin: "goblin") else {
                return nil
            }
            character.name = "goblins"
            character.position = CGPoint(x: x, y: y)
            
            return character
        }else {
            
        }
        return nil
    }
    
    
    private func removeAudio() {
        guard let scene = self.scene else { return }
        for node in scene.children {
           if node is SKAudioNode {
               node.removeFromParent()
           }
        }
    }
    
    private func addAudio(name: String) {
        guard let scene = self.scene else { return }
        let audio = SKAudioNode(fileNamed: name)
        scene.addChild(audio)
    }
}
