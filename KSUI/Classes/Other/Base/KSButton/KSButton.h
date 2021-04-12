//
//  KSButton.h
//  Factory
//
//  Created by zhu hao on 2019/11/15.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSButton.h"

NS_ASSUME_NONNULL_BEGIN

/// 控制图片在UIButton里的位置，默认为KSButtonImagePositionLeft
typedef NS_ENUM(NSUInteger, KSButtonImagePosition) {
    KSButtonImagePositionTop,             // imageView在titleLabel上面
    KSButtonImagePositionLeft,            // imageView在titleLabel左边
    KSButtonImagePositionBottom,          // imageView在titleLabel下面
    KSButtonImagePositionRight,           // imageView在titleLabel右边
};


///  图片和文字默认间距为0
extern const CGFloat KSButtonCornerSpacing;

@interface KSButton : UIButton

/// 图文位置关系
@property(nonatomic, assign) KSButtonImagePosition imagePosition;

/// 图文间距
@property(nonatomic, assign) CGFloat spacingBetweenImageAndTitle;

/// 设置图片和文字的位置关系以及间距
/// @param postion 位置关系
/// @param spacing 根据
- (void)setImagePosition:(KSButtonImagePosition)postion spacing:(CGFloat)spacing;

/// 设置图片和位置关系以及根据边框来调整间距
/// @param postion 位置关系
/// @param margin 根据边框调整图文间距
- (void)setImagePosition:(KSButtonImagePosition)postion WithMargin:(CGFloat )margin;

@end

NS_ASSUME_NONNULL_END
