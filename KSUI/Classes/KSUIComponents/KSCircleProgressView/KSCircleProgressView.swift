//
//  KSCircleProgressView.swift
//  KSClient
//
//  Created by zhu hao on 2020/2/26.
//  Copyright © 2020 kaishu. All rights reserved.
//

import UIKit

public class KSCircleProgressView: UIView {
    public struct Constant {
        public  static var lineWidth: CGFloat = 5
        public  static var trackColor = UIColor.gray
        public  static var progressColor = UIColor.blue
    }
    
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    let path = UIBezierPath()
    
    public var progress: CGFloat = 0 {
        didSet {
            if progress > 1.0 {
                progress = 1.0
            } else if progress < 0 {
                progress = 0
            } else {
                progressLayer.strokeEnd = CGFloat(progress)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    public override func draw(_: CGRect) {
        // 获取整个进度条圆圈路径 使用此路径 进度有不准确的问题
        //                path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
        //                            radius: bounds.size.width/2 - Constant.lineWidth,
        //                            startAngle:3 * CGFloat.pi/2, endAngle: 7 * CGFloat.pi/2, clockwise: true)
        
        let path = UIBezierPath(ovalIn: bounds)
        self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        // 绘制进度槽
        trackLayer.frame = bounds
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        trackLayer.opacity = 0.5
        layer.addSublayer(trackLayer)
        
        // 绘制进度条
        progressLayer.frame = bounds
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Constant.progressColor.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress)
        layer.addSublayer(progressLayer)
    }
    
}
