//
//  KSFillButton.m
//  Factory
//
//  Created by zhu hao on 2019/11/15.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import "KSFillButton.h"
#import "KSCore.h"

const CGFloat KSFillButtonCornerRadiusAdjustsBounds = -1;

@implementation KSFillButton

- (instancetype)init {
    return [self initWithFillType:KSFillButtonColorBlue];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFillType:KSFillButtonColorBlue frame:frame];
}

- (instancetype)initWithFillType:(KSFillButtonColor)fillType {
    return [self initWithFillType:fillType frame:CGRectZero];
}

- (instancetype)initWithFillType:(KSFillButtonColor)fillType frame:(CGRect)frame {
    UIColor *fillColor = nil;
    UIColor *textColor = UIColorWhite;
    switch (fillType) {
        case KSFillButtonColorBlue:
            fillColor = FillButtonColorBlue;
            break;
        case KSFillButtonColorRed:
            fillColor = FillButtonColorRed;
            break;
        case KSFillButtonColorGreen:
            fillColor = FillButtonColorGreen;
            break;
        case KSFillButtonColorGray:
            fillColor = FillButtonColorGray;
            break;
        case KSFillButtonColorWhite:
            fillColor = FillButtonColorWhite;
            textColor = UIColorBlue;
        default:
            break;
    }
    return [self initWithFillColor:fillColor titleTextColor:textColor frame:frame];
}

- (instancetype)initWithFillColor:(UIColor *)fillColor titleTextColor:(UIColor *)textColor {
    return [self initWithFillColor:fillColor titleTextColor:textColor frame:CGRectZero];
}

- (instancetype)initWithFillColor:(UIColor *)fillColor titleTextColor:(UIColor *)textColor frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.fillColor = fillColor;
        self.titleTextColor = textColor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.fillColor = FillButtonColorBlue;
        self.titleTextColor = UIColorWhite;
    }
    return self;
}


- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.backgroundColor = fillColor;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    [self setTitleColor:titleTextColor forState:UIControlStateNormal];
}

// 设置圆角 cornerRadius有值时候其为圆角半径 否则默认为高度的一半
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (self.cornerRadius != KSFillButtonCornerRadiusAdjustsBounds) {
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

@interface KSFillButton (UIAppearance)

@end

@implementation KSFillButton (UIAppearance)

//在第一次创建这个类的对象的时候(也就是分配内存空间alloc的时候),会调用该类的+initialize 方法且只调用一次
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    KSFillButton *appearance = [KSFillButton appearance];
    appearance.cornerRadius = KSFillButtonCornerRadiusAdjustsBounds;
}

@end
