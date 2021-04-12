//
//  KSFillButton.h
//  Factory
//
//  Created by zhu hao on 2019/11/15.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import "KSButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KSFillButtonColor) {
    KSFillButtonColorBlue,
    KSFillButtonColorRed,
    KSFillButtonColorGreen,
    KSFillButtonColorGray,
    KSFillButtonColorWhite,·
};

/// 其值为-1 cornerRadius的默认值 表示圆角半径是高度的一半
extern const CGFloat KSFillButtonCornerRadiusAdjustsBounds;

/// 填充色按钮
@interface KSFillButton : KSButton

@property(nonatomic, strong, nullable) IBInspectable UIColor *fillColor; // 默认为 FillButtonColorBlue
@property(nonatomic, strong, nullable) IBInspectable UIColor *titleTextColor; // 默认为 UIColorWhite
@property(nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;// 默认为KSFillButtonCornerRadiusAdjustsBounds 也即圆角高度一半

- (instancetype)initWithFillType:(KSFillButtonColor)fillType;
- (instancetype)initWithFillType:(KSFillButtonColor)fillType frame:(CGRect)frame;
- (instancetype)initWithFillColor:(nullable UIColor *)fillColor titleTextColor:(nullable UIColor *)textColor;
- (instancetype)initWithFillColor:(nullable UIColor *)fillColor titleTextColor:(nullable UIColor *)textColor frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
