//
//  KSPageViewUtil.m
//  KSUI
//
//  Created by zhu hao on 2020/9/8.
//

#import "KSPageViewUtil.h"

@implementation KSPageViewUtil

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.jx_red to:toColor.jx_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.jx_green to:toColor.jx_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.jx_blue to:toColor.jx_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.jx_alpha to:toColor.jx_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation UIColor (JXAdd)

- (CGFloat)jx_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)jx_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)jx_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)jx_alpha {
    return CGColorGetAlpha(self.CGColor);
}
@end


