//
//  KSGhostButton.m
//  Factory
//
//  Created by zhu hao on 2019/11/18.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import "KSGhostButton.h"
#import "KSCore.h"

const CGFloat KSGhostButtonCornerRadiusAdjustsBounds = -1;
const CGFloat KSGhostButtonBorderWidth = 1;

@implementation KSGhostButton

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithGhostType:KSGhostButtonColorBlue frame:frame];
}

- (instancetype)initWithGhostType:(KSGhostButtonColor)ghostType {
    return [self initWithGhostType:ghostType frame:CGRectZero];
}

- (instancetype)initWithGhostType:(KSGhostButtonColor)ghostType frame:(CGRect)frame {
    UIColor *ghostColor = nil;
    switch (ghostType) {
        case KSGhostButtonColorBlue:
            ghostColor = GhostButtonColorBlue;
            break;
        case KSGhostButtonColorRed:
            ghostColor = GhostButtonColorRed;
            break;
        case KSGhostButtonColorGreen:
            ghostColor = GhostButtonColorGreen;
            break;
        case KSGhostButtonColorGray:
            ghostColor = GhostButtonColorGray;
            break;
        case KSGhostButtonColorWhite:
            ghostColor = GhostButtonColorWhite;
            break;
        default:
            break;
    }
    return [self initWithGhostColor:ghostColor frame:frame];
}

- (instancetype)initWithGhostColor:(UIColor *)ghostColor {
    return [self initWithGhostColor:ghostColor frame:CGRectZero];
}

- (instancetype)initWithGhostColor:(UIColor *)ghostColor frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeWithGhostColor:ghostColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeWithGhostColor:GhostButtonColorBlue];
    }
    return self;
}

- (void)initializeWithGhostColor:(UIColor *)ghostColor {
    self.ghostColor = ghostColor;
}

- (void)setGhostColor:(UIColor *)ghostColor {
    _ghostColor = ghostColor;
    [self setTitleColor:_ghostColor forState:UIControlStateNormal];
    self.layer.borderColor = _ghostColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

// 设置圆角 cornerRadius有值时候其为圆角半径 否则默认为高度的一半
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (self.cornerRadius != KSGhostButtonCornerRadiusAdjustsBounds) {
        self.layer.cornerRadius = self.cornerRadius;
    } else {
        self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

@end

@interface KSGhostButton (UIAppearance)

@end

@implementation KSGhostButton (UIAppearance)

//在第一次创建这个类的对象的时候(也就是分配内存空间alloc的时候),会调用该类的+initialize 方法且只调用一次
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    KSGhostButton *appearance = [KSGhostButton appearance];
    appearance.borderWidth = KSGhostButtonBorderWidth;
    appearance.cornerRadius = KSGhostButtonCornerRadiusAdjustsBounds;
}

@end
