//
//  NSAttributedString+KSText.h
//
//  Created by zhu hao on 2019/12/19.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KSTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (KSText)

@end

/// 富文本工具方法
@interface NSMutableAttributedString (KSText)

/// 设置字体
/// @param font 设置字体
- (void)setFont:(UIFont *)font;

/// 设置字体颜色
/// @param color 设置颜色
- (void)setColor:(UIColor *)color;

/// 设置删除线
- (void)setTextStrikethrough;

///  字体垂直居中
- (void)textVerticalAlignment;

@end

NS_ASSUME_NONNULL_END
