//
//  UIImage+KSUI.h
//  Pods
//
//  Created by zhu hao on 2020/1/2.
//

#import <UIKit/UIKit.h>
#import "KSCommonDefines.h"
#import "UIColor+KSUI.h"

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromLeftToRight,                //从做到右
    GradientFromLeftTopToRightBottom,       //从上到下
    GradientFromLeftBottomToRightTop        //从上到下
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KSUI)

/// 给图片绘制圆角
/// @param radius 圆角半径
/// @param size 图片大小
/// @return 返回修改圆角后的图片
- (UIImage *)imageDrawRectWithRoundedCorner:(CGFloat)radius
                                   size:(CGSize)size;

/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percents          渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 *  @return UIImage 返回渐变后的图片
 */
+ (UIImage *)createImageWithSize:(CGSize)imageSize
                  gradientColors:(NSArray *)colorArr
                      percentage:(NSArray *)percents
                    gradientType:(GradientType)gradientType;

@end

NS_ASSUME_NONNULL_END
