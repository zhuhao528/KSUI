//
//  KSPopover.m
//  PopoverObjC
//
//  Created by KSsuner on 2017/10/23.
//

#import "kSPopover.h"

@interface KSPopover ()

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGPoint arrowShowPoint;

@property (nonatomic, strong) UIControl *blackOverLay;

@property (nonatomic, assign) CGRect cacheFrame;

@end

@implementation KSPopover

#define keyWindow [UIApplication sharedApplication].delegate.window

- (instancetype)init {
    if (self = [super init]) {
        self.option = [[KSPopoverOption alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.accessibilityViewIsModal = YES;
    }
    return self;
}

- (instancetype)initWithOption:(KSPopoverOption *)option {
    if (!option) {
        return [self init];
    } else {
        if (self = [super init]) {
            _option = option;
            self.backgroundColor = [UIColor clearColor];
            self.accessibilityViewIsModal = YES;
        }
        return self;
    }
}

#pragma - public

- (void)show:(UIView *)contentView fromView:(UIView *)fromView {
    [self show:contentView fromView:fromView inView:keyWindow];
}

//- (void)show:(UIView *)contentView fromView:(UIView *)fromView inView:(UIView *)inView {
//    if (_option.autoAjustDirection) {
//        CGPoint downPoint = [self arrowPointWithView:contentView fromView:fromView inView:inView popoverType:KSPopoverTypeDown];
//        CGPoint upPoint = [self arrowPointWithView:contentView fromView:fromView inView:inView popoverType:KSPopoverTypeUp];
//        CGPoint leftPoint = [self arrowPointWithView:contentView fromView:fromView inView:inView popoverType:KSPopoverTypeLeft]; // add by zhuhao 20200114
//        CGPoint rightPoint = [self arrowPointWithView:contentView fromView:fromView inView:inView popoverType:KSPopoverTypeRight]; // add by zhuhao 20200114
//
//        BOOL canBeUp = (upPoint.y - _option.arrowSize.height - contentView.bounds.size.height > 0);
//        BOOL canBeDown = downPoint.y + _option.arrowSize.height + contentView.bounds.size.height < inView.bounds.size.height;
//        BOOL canBeLeft = leftPoint.y + _option.arrowSize.height + contentView.bounds.size.height < inView.bounds.size.height; // add by zhuhao 20200114
//        BOOL canBeRight = rightPoint.y + _option.arrowSize.height + contentView.bounds.size.height < inView.bounds.size.height; // add by zhuhao 20200114
//
//        if (canBeUp && !canBeDown) {
//            _option.popoverType = KSPopoverTypeUp;
//        } else if (!canBeUp && canBeDown) {
//            _option.popoverType = KSPopoverTypeDown;
//        } else if (!canBeUp && canBeLeft) { // add by zhuhao 20200114
//            _option.popoverType = KSPopoverTypeLeft;
//        }else if (!canBeUp && canBeRight) { // add by zhuhao 20200114
//            _option.popoverType = KSPopoverTypeRight;
//        }else {
//            _option.popoverType = _option.preferedType;
//        }
//
//    }
//    CGPoint point = [self arrowPointWithView:contentView fromView:fromView inView:inView popoverType:_option.popoverType];
//    if (self.option.highlightFromView) {
//        [self createHighlightLayerFromView:fromView inView:inView];
//    }
//    [self show:contentView atPoint:point inView:inView];
//}
// 上面方法替换为 如下 add by zhuhao 20200115 参考swift版本修改过来
- (void)show:(UIView *)contentView fromView:(UIView *)fromView inView:(UIView *)inView {
    CGPoint point;
    if (_option.popoverType == KSPopoverTypeAuto) {
        CGPoint point = [fromView.superview convertPoint:fromView.frame.origin toView:nil];
        if(point.y + fromView.frame.size.height + _option.arrowSize.height + contentView.frame.size.height > inView.frame.size.height)
            _option.popoverType = KSPopoverTypeUp;
        else
            _option.popoverType = KSPopoverTypeDown;
    }
    switch (_option.popoverType) {
        case KSPopoverTypeUp: {
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x+(fromView.frame.size.width/2), fromView.frame.origin.y) fromView:fromView.superview];
        } break;
        case KSPopoverTypeDown:
        case KSPopoverTypeAuto:{
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x+(fromView.frame.size.width/2), fromView.frame.origin.y + fromView.frame.size.height) fromView:fromView.superview];
        } break;
        case KSPopoverTypeLeft: {
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x - _option.offset, fromView.frame.origin.y + 0.5 * fromView.frame.size.height) fromView:fromView.superview];
        } break;
        case KSPopoverTypeRight: {
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x + fromView.frame.size.width +  _option.offset, fromView.frame.origin.y + 0.5 * fromView.frame.size.height) fromView:fromView.superview];
        } break;
    }
    if (self.option.highlightFromView) {
        [self createHighlightLayerFromView:fromView inView:inView];
    }
    [self show:contentView atPoint:point inView:inView];
}

- (void)show:(UIView *)contentView atPoint:(CGPoint)point {
    [self show:contentView atPoint:point inView:keyWindow];
}

- (void)show:(UIView *)contentView atPoint:(CGPoint)point inView:(UIView *)inView {
    _cacheFrame = contentView.frame;
    if (_option.dismissOnBlackOverlayTap || _option.showBlackOverlay) {
        self.blackOverLay .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.blackOverLay.frame = inView.bounds;
        [inView addSubview:self.blackOverLay];
        
        if (_option.showBlackOverlay) {
            if (_option.overlayBlur) {
                UIVisualEffectView *effectView = [[UIVisualEffectView alloc] init];
                effectView.effect = _option.overlayBlur;
                effectView.frame = self.blackOverLay.bounds;
                effectView.userInteractionEnabled = NO;
                [self.blackOverLay addSubview:effectView];
            } else {
                if (!_option.highlightFromView) {
                    self.blackOverLay.backgroundColor = _option.blackOverlayColor;
                }
                self.blackOverLay.alpha = 0;
            }
            if (_option.dismissOnBlackOverlayTap) {
                [self.blackOverLay addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    self.containerView = inView;
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = _option.cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    self.arrowShowPoint = point;
    [self show];
}

- (void)dismiss {
    if (self.superview) {
        if (self.willDismissHandler) {
            self.willDismissHandler();
        }
        [UIView animateWithDuration:_option.animationOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            self.blackOverLay.alpha = 0;
        } completion:^(BOOL finished) {
            [self.contentView removeFromSuperview];
            [self.blackOverLay removeFromSuperview];
            [self removeFromSuperview];
            self.transform = CGAffineTransformIdentity;
            if (self.didDismissHandler) {
                self.didDismissHandler();
            }
            self->_contentView.frame = self.cacheFrame;
        }];
    }
}

- (CGPoint)originArrowPointWithView:(UIView *)contentView fromView:(UIView *)fromView {
    return [self arrowPointWithView:contentView fromView:fromView inView:keyWindow popoverType:_option.popoverType];
}

// - (void)show:(UIView *)contentView fromView:(UIView *)fromView inView:(UIView *)inView 方法被替换后 此方法不再被调用
- (CGPoint)arrowPointWithView:(UIView *)contentView fromView:(UIView *)fromView inView:(UIView *)inView popoverType:(KSPopoverType)type {
    CGPoint point;
    switch (type) {
        case KSPopoverTypeUp: {
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x + (fromView.frame.size.width / 2), fromView.frame.origin.y) fromView:fromView.superview];
            point = CGPointMake(point.x, point.y - fabs(_option.offset));
        } break;
        case KSPopoverTypeDown:
        case KSPopoverTypeAuto: {
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x + (fromView.frame.size.width / 2), fromView.frame.origin.y + fromView.frame.size.height) fromView:fromView.superview];
            point = CGPointMake(point.x, point.y + fabs(_option.offset));
        } break;
        case KSPopoverTypeLeft: { // add by zhuhao 20200114
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x + (fromView.frame.size.width / 2), fromView.frame.origin.y + fromView.frame.size.height) fromView:fromView.superview];
            point = CGPointMake(point.x, point.y + fabs(_option.offset));
        } break;
        case KSPopoverTypeRight: { // add by zhuhao 20200114
            point = [inView convertPoint:CGPointMake(fromView.frame.origin.x + (fromView.frame.size.width / 2), fromView.frame.origin.y + fromView.frame.size.height) fromView:fromView.superview];
            point = CGPointMake(point.x, point.y + fabs(_option.offset));
        } break;
            
    }
    return point;
}

#pragma - private

- (void)createHighlightLayerFromView:(UIView *)fromView inView:(UIView *)inView {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:inView.bounds];
    CGRect highlightRect = [inView convertRect:fromView.frame fromView:fromView.superview];
    UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:_option.highlightCornerRadius];
    [path appendPath:highlightPath];
    path.usesEvenOddFillRule = YES;
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = _option.blackOverlayColor.CGColor;
    [self.blackOverLay.layer addSublayer:fillLayer];
}

- (void)show {
    [self setNeedsDisplay];
    CGRect frame = self.contentView.frame;
    frame.origin.x = 0;
    switch (_option.popoverType) {
        case KSPopoverTypeUp: {
            frame.origin.y = 0.0;
            self.contentView.frame = frame;
        } break;
        case KSPopoverTypeDown:
        case KSPopoverTypeAuto:{
            frame.origin.y = _option.arrowSize.height;
            self.contentView.frame = frame;
        } break;
        case KSPopoverTypeLeft: { // add by zhuhao 20200114
            frame.origin.x = 0;
            self.contentView.frame = frame;
        } break;
        case KSPopoverTypeRight: { // add by zhuhao 20200114
            frame.origin.x = 0;
            self.contentView.frame = frame;
        } break;
    }
    [self addSubview:self.contentView];
    [self.containerView addSubview:self];
    
    [self create];
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    if (self.willShowHandler) {
        self.willShowHandler();
    }
    [UIView animateWithDuration:_option.animationIn delay:0.0 usingSpringWithDamping:_option.springDamping initialSpringVelocity:_option.initialSpringVelocity options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (self.didShowHandler) {
            self.didShowHandler();
        }
    }];
    [UIView animateWithDuration:_option.animationIn / 3 animations:^{
        self.blackOverLay.alpha = 1;
    }];
}

- (void)create {
    CGRect frame = self.contentView.frame;
    //frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5;
    // 替换为 add by zhuhao 20200114
    switch (_option.popoverType) {
        case KSPopoverTypeUp:
        case KSPopoverTypeDown:
        case KSPopoverTypeAuto:{
            frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5;
        }; break;
        case KSPopoverTypeLeft:
        case KSPopoverTypeRight:{
            frame.origin.y = self.arrowShowPoint.y - frame.size.height * 0.5;
        }; break;
    }
    
    CGFloat sideEdge = 0.0;
    if (frame.size.width < self.containerView.frame.size.width) {
        sideEdge = _option.sideEdge;
    }
    CGFloat outerSideEdge = CGRectGetMaxX(frame) - self.containerView.bounds.size.width;
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge + sideEdge);
    } else {
        if (CGRectGetMinX(frame) < 0) {
            frame.origin.x += fabs(CGRectGetMinX(frame)) + sideEdge;
        }
    }
    self.frame = frame;
    
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    CGPoint anchorPoint;
    switch (_option.popoverType) {
        case KSPopoverTypeUp: {
            frame.origin.y = self.arrowShowPoint.y - frame.size.height - _option.arrowSize.height;
            anchorPoint = CGPointMake(arrowPoint.x / frame.size.width, 1);
        }; break;
        case KSPopoverTypeDown:
        case KSPopoverTypeAuto:{
            frame.origin.y = self.arrowShowPoint.y;
            anchorPoint = CGPointMake(arrowPoint.x / frame.size.width, 0);
        }; break;
        case KSPopoverTypeLeft: { // add by zhuhao 20200114
            frame.origin.x = self.arrowShowPoint.x - frame.size.width - _option.arrowSize.height;
            anchorPoint = CGPointMake(1, 0.5);
        }; break;
        case KSPopoverTypeRight: { // add by zhuhao 20200114
            frame.origin.x = self.arrowShowPoint.x;
            anchorPoint = CGPointMake(0, 0.5);
        }; break;
    }
    
    if (!_option.arrowSize.width || !_option.arrowSize.height) {
        anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    CGPoint lKStAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    CGFloat x = self.layer.position.x + (anchorPoint.x - lKStAnchor.x) * self.layer.bounds.size.width;
    CGFloat y = self.layer.position.y + (anchorPoint.y - lKStAnchor.y) * self.layer.bounds.size.height;
    self.layer.position = CGPointMake(x, y);
    
    frame.size.height += _option.arrowSize.height;
    self.frame = frame;
}

- (BOOL)isCornerLeftArrow {
    return self.arrowShowPoint.x == self.frame.origin.x;
}

- (BOOL)isCornerRightArrow {
    return self.arrowShowPoint.x == self.frame.origin.x + self.bounds.size.width;
}

- (CGFloat)radiansDerees:(CGFloat)degrees {
    return M_PI * degrees / 180;
}


#pragma - override

- (void)drawRect:(CGRect)rect {
#define ArrowAddLineToPoint(x, y)  [arrow addLineToPoint:CGPointMake(x, y)]
#define radians(x) [self radiansDerees:x]
#define selfWidth self.bounds.size.width
#define selfHeight self.bounds.size.height
#define selfArrowWidth _option.arrowSize.width
#define selfArrowHeight _option.arrowSize.height
#define selfCornerRadius _option.cornerRadius
    [super drawRect:rect];
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    UIColor *color = _option.popoverColor;
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    switch (_option.popoverType) {
        case KSPopoverTypeUp: {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, selfHeight)];
            //            ArrowAddLineToPoint(arrowPoint.x - selfArrowWidth * 0.5, [self isCornerLeftArrow] ? selfArrowHeight : selfHeight - selfArrowHeight);
            // 三角形的左边边一条 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 将上行代码改成下两行
            CGPoint point = CGPointMake(arrowPoint.x - selfArrowWidth * 0.5, [self isCornerLeftArrow] ? selfArrowHeight : selfHeight - selfArrowHeight);
            [arrow addCurveToPoint:point controlPoint1:CGPointMake(arrowPoint.x-_option.arrowRadian.topRadian, selfHeight) controlPoint2:CGPointMake(point.x+_option.arrowRadian.bottomRadian, point.y)];
            
            ArrowAddLineToPoint(selfCornerRadius, selfHeight - selfArrowHeight);
            [arrow addArcWithCenter:CGPointMake(selfCornerRadius, selfHeight -  selfArrowHeight - selfCornerRadius) radius:selfCornerRadius startAngle:radians(90) endAngle:radians(180) clockwise:YES];
            
            ArrowAddLineToPoint(0, selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(selfCornerRadius, selfCornerRadius) radius:selfCornerRadius startAngle:radians(180) endAngle:radians(270) clockwise:YES];
            
            ArrowAddLineToPoint(selfWidth - selfCornerRadius, 0);
            [arrow addArcWithCenter:CGPointMake(selfWidth - selfCornerRadius, selfCornerRadius) radius:selfCornerRadius startAngle:radians(270) endAngle:radians(0) clockwise:YES];
            
            ArrowAddLineToPoint(selfWidth, selfHeight - selfArrowHeight - selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(selfWidth - selfCornerRadius, selfHeight - selfArrowHeight - selfCornerRadius) radius:selfCornerRadius startAngle:radians(0) endAngle:radians(90) clockwise:YES];
            
            ArrowAddLineToPoint(arrowPoint.x + selfArrowWidth * 0.5, [self isCornerRightArrow] ? selfArrowHeight : selfHeight - selfArrowHeight);
            
            // 三角形的右边一条 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 新增两行代码
            CGPoint point2 = CGPointMake(arrowPoint.x + selfArrowWidth * 0.5, [self isCornerRightArrow] ? selfArrowHeight : selfHeight - selfArrowHeight);
            [arrow addCurveToPoint:CGPointMake(arrowPoint.x, selfHeight) controlPoint1:CGPointMake(point2.x-_option.arrowRadian.bottomRadian, point2.y) controlPoint2:CGPointMake(arrowPoint.x+_option.arrowRadian.topRadian, selfHeight)];
            
        } break;
            
        case KSPopoverTypeDown:
        case KSPopoverTypeAuto:{
            [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
            //      ArrowAddLineToPoint(arrowPoint.x + selfArrowWidth * 0.5, [self isCornerRightArrow] ? selfArrowHeight + selfHeight : selfArrowHeight);
            // 三角形的右边一条 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 将上行代码改成下两行
            CGPoint point = CGPointMake(arrowPoint.x + selfArrowWidth * 0.5, [self isCornerRightArrow] ? selfArrowHeight + selfHeight : selfArrowHeight);
            [arrow addCurveToPoint:point controlPoint1:CGPointMake(arrowPoint.x+_option.arrowRadian.topRadian, 0) controlPoint2:CGPointMake(point.x-_option.arrowRadian.bottomRadian, point.y)];
            
            ArrowAddLineToPoint(selfWidth - selfCornerRadius, selfArrowHeight);
            [arrow addArcWithCenter:CGPointMake(selfWidth - selfCornerRadius, selfArrowHeight + selfCornerRadius) radius:selfCornerRadius startAngle:radians(270) endAngle:radians(0) clockwise:YES];
            
            ArrowAddLineToPoint(selfWidth, selfHeight - selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(selfWidth - selfCornerRadius, selfHeight - selfCornerRadius) radius:selfCornerRadius startAngle:radians(0) endAngle:radians(90) clockwise:YES];
            
            ArrowAddLineToPoint(0, selfHeight);
            [arrow addArcWithCenter:CGPointMake(selfCornerRadius, selfHeight - selfCornerRadius) radius:selfCornerRadius startAngle:radians(90) endAngle:radians(180) clockwise:YES];
            
            ArrowAddLineToPoint(0, selfArrowHeight + selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(selfCornerRadius, selfArrowHeight + selfCornerRadius) radius:selfCornerRadius startAngle:radians(180) endAngle:radians(270) clockwise:YES];
            
            ArrowAddLineToPoint(arrowPoint.x - selfArrowWidth * 0.5, [self isCornerLeftArrow] ? selfArrowHeight + selfHeight : selfArrowHeight);
            
            // 三角形的左边一条 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 新增两行代码
            CGPoint point2 = CGPointMake(arrowPoint.x - selfArrowWidth * 0.5, [self isCornerLeftArrow] ? selfArrowHeight + selfHeight : selfArrowHeight);
            [arrow addCurveToPoint:CGPointMake(arrowPoint.x, 0) controlPoint1:CGPointMake(point2.x+_option.arrowRadian.bottomRadian, point2.y) controlPoint2:CGPointMake(arrowPoint.x-_option.arrowRadian.topRadian, 0)];
            
        } break;
        case KSPopoverTypeLeft: { // add by zhuhao 20200114
            
            CGPoint topPoint = CGPointMake(selfWidth, selfHeight/2); // add by zhuhao 20200114
            [arrow moveToPoint:topPoint];
            
//            arrow.addLine(
//                to: CGPoint(
//                    x: self.bounds.width - self.arrowSize.height,
//                    y: self.bounds.height * 0.5 + self.arrowSize.width * 0.5
//            ))
            // 三角形的上边一条 起点至上顶点 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 将上行代码改成下两行
            CGPoint point = CGPointMake(self.bounds.size.width - _option.arrowSize.height,self.bounds.size.height * 0.5 + _option.arrowSize.width * 0.5);
            [arrow addCurveToPoint:point controlPoint1:CGPointMake(topPoint.x, topPoint.y + _option.arrowRadian.topRadian) controlPoint2:CGPointMake(point.x, point.y - _option.arrowRadian.bottomRadian)];
            
            ArrowAddLineToPoint(self.bounds.size.width - _option.arrowSize.height, selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(self.bounds.size.width - _option.arrowSize.height - selfCornerRadius, self.bounds.size.height - selfCornerRadius) radius:selfCornerRadius startAngle:radians(0) endAngle:radians(90) clockwise:YES];
            
            ArrowAddLineToPoint(_option.cornerRadius, self.bounds.size.height);
            [arrow addArcWithCenter:CGPointMake(selfCornerRadius, self.bounds.size.height - selfCornerRadius) radius:selfCornerRadius startAngle:radians(90) endAngle:radians(180) clockwise:YES];
            
            ArrowAddLineToPoint(0, selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(selfCornerRadius, selfCornerRadius) radius:selfCornerRadius startAngle:radians(180) endAngle:radians(270) clockwise:YES];
            
            ArrowAddLineToPoint(self.bounds.size.width - _option.arrowSize.height - selfCornerRadius, 0);
            [arrow addArcWithCenter:CGPointMake(self.bounds.size.width - _option.arrowSize.height - selfCornerRadius, selfCornerRadius) radius:selfCornerRadius startAngle:radians(270) endAngle:radians(0) clockwise:YES];
            
            ArrowAddLineToPoint(self.bounds.size.width - _option.arrowSize.height,self.bounds.size.height * 0.5 - _option.arrowSize.width * 0.5);
            
            // 三角形的下边一条 上顶点至起点 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 新增两行代码
            CGPoint point2 = CGPointMake(self.bounds.size.width - _option.arrowSize.height,self.bounds.size.height * 0.5 - _option.arrowSize.width * 0.5);
            [arrow addCurveToPoint:topPoint controlPoint1:CGPointMake(point2.x, point2.y + _option.arrowRadian.bottomRadian) controlPoint2:CGPointMake(topPoint.x, topPoint.y - _option.arrowRadian.topRadian)];
            
        } break;
        case KSPopoverTypeRight: { // add by zhuhao 20200114
            
            CGPoint topPoint = CGPointMake(arrowPoint.x, selfHeight/2); // add by zhuhao 20200114
            [arrow moveToPoint:topPoint];
            
//            arrow.addLine(
//                to: CGPoint(
//                    x: arrowPoint.x + self.arrowSize.height,
//                    y: self.bounds.height * 0.5 + 0.5 * self.arrowSize.width
//            ))
            // 三角形的上边一条 起点至上顶点 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 将上行代码改成下两行
            CGPoint point = CGPointMake(topPoint.x + _option.arrowSize.height,self.bounds.size.height * 0.5 + 0.5 * _option.arrowSize.width);
            [arrow addCurveToPoint:point controlPoint1:CGPointMake(topPoint.x,  topPoint.y + _option.arrowRadian.topRadian) controlPoint2:CGPointMake(point.x, point.y - _option.arrowRadian.bottomRadian)];
            
            ArrowAddLineToPoint(arrowPoint.x + _option.arrowSize.height, self.bounds.size.height - selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(arrowPoint.x + _option.arrowSize.height + selfCornerRadius, self.bounds.size.height - selfCornerRadius) radius:selfCornerRadius startAngle:radians(180) endAngle:radians(90) clockwise:NO];
            
            ArrowAddLineToPoint(self.bounds.size.width + arrowPoint.x - selfCornerRadius, self.bounds.size.height);
            [arrow addArcWithCenter:CGPointMake(self.bounds.size.width + arrowPoint.x - selfCornerRadius, self.bounds.size.height - selfCornerRadius) radius:selfCornerRadius startAngle:radians(90) endAngle:radians(0) clockwise:NO];
            
            ArrowAddLineToPoint(self.bounds.size.width + arrowPoint.x, selfCornerRadius);
            [arrow addArcWithCenter:CGPointMake(self.bounds.size.width + arrowPoint.x - selfCornerRadius, selfCornerRadius) radius:selfCornerRadius startAngle:radians(0) endAngle:radians(-90) clockwise:NO];
            
            ArrowAddLineToPoint(arrowPoint.x + _option.arrowSize.height - selfCornerRadius, 0);
            [arrow addArcWithCenter:CGPointMake(arrowPoint.x + _option.arrowSize.height + selfCornerRadius, selfCornerRadius) radius:selfCornerRadius startAngle:radians(-90) endAngle:radians(-180) clockwise:NO];
            
            ArrowAddLineToPoint(arrowPoint.x + _option.arrowSize.height,  self.bounds.size.height * 0.5 - _option.arrowSize.width * 0.5);
            
            // 三角形的下边一条 下顶点至起点 使用三次贝塞尔曲线而不使用直线 保持箭头的圆润 新增两行代码
            CGPoint point2 = CGPointMake(arrowPoint.x + _option.arrowSize.height, self.bounds.size.height * 0.5 - _option.arrowSize.width * 0.5);
            [arrow addCurveToPoint:topPoint controlPoint1:CGPointMake(point2.x, point2.y+_option.arrowRadian.bottomRadian) controlPoint2:CGPointMake(topPoint.x, topPoint.y - _option.arrowRadian.topRadian)];
            
        } break;
    }
    [color setFill];
    [arrow fill];
}

//- (void)layoutSubviews {
//  [super layoutSubviews];
//  self.contentView.frame = self.bounds;
//}

- (BOOL)accessibilityPerformEscape {
    [self dismiss];
    return YES;
}

- (UIControl *)blackOverLay {
    if (!_blackOverLay) {
        _blackOverLay = [[UIControl alloc] init];
    }
    return _blackOverLay;
}

@end
