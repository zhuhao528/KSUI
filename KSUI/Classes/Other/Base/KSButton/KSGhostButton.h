//
//  KSGhostButton.h
//  Factory
//
//  Created by zhu hao on 2019/11/18.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import "KSButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KSGhostButtonColor) {
    KSGhostButtonColorBlue,
    KSGhostButtonColorRed,
    KSGhostButtonColorGreen,
    KSGhostButtonColorGray,
    KSGhostButtonColorWhite,
};

/// 其值为-1 cornerRadius的默认值 表示圆角半径是高度的一半
extern const CGFloat KSGhostButtonCornerRadiusAdjustsBounds;
extern const CGFloat KSGhostButtonBorderWidth;

/// 透明色的按钮
@interface KSGhostButton : KSButton

@property(nonatomic, strong, nullable) IBInspectable UIColor *ghostColor;    // 默认为 GhostButtonColorBlue
@property(nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;    // 默认为 1pt
@property(nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;   // 默认为KSGhostButtonCornerRadiusAdjustsBounds 也即圆角高度一半

- (instancetype)initWithGhostType:(KSGhostButtonColor)ghostType;
- (instancetype)initWithGhostColor:(nullable UIColor *)ghostColor;

@end

NS_ASSUME_NONNULL_END
