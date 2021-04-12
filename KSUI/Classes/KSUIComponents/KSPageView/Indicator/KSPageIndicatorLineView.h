//
//  KSPageIndicatorLineView.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageIndicatorComponentView.h"

typedef NS_ENUM(NSUInteger, KSPageIndicatorLineStyle) {
    KSPageIndicatorLineStyle_Normal             = 0,
    KSPageIndicatorLineStyle_Lengthen           = 1,
    KSPageIndicatorLineStyle_LengthenOffset     = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface KSPageIndicatorLineView : KSPageIndicatorComponentView

@property (nonatomic, assign) KSPageIndicatorLineStyle lineStyle;

/**
 line滚动时x的偏移量，默认为10；
 lineStyle为KSPageIndicatorLineStyle_LengthenOffset有用；
 */
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@end

NS_ASSUME_NONNULL_END
