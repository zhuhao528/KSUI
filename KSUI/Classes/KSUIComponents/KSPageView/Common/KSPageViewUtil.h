//
//  KSPageViewUtil.h
//  KSUI
//
//  Created by zhu hao on 2020/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSPageViewUtil : NSObject

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent;

@end


@interface UIColor (JXAdd)

@property (nonatomic, assign, readonly) CGFloat jx_red;
@property (nonatomic, assign, readonly) CGFloat jx_green;
@property (nonatomic, assign, readonly) CGFloat jx_blue;
@property (nonatomic, assign, readonly) CGFloat jx_alpha;

@end
NS_ASSUME_NONNULL_END
