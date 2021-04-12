//
//  KSPageIndicatorComponentView.m
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageIndicatorComponentView.h"

@implementation KSPageIndicatorComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _componentPosition = KSPageViewComponentPosition_Bottom;
        _scrollEnabled = YES;
        _verticalMargin = 0;
        _scrollAnimationDuration = 0.25;
        _indicatorWidth = KSPageViewAutomaticDimension;
        _indicatorWidthIncrement = 0;
        _indicatorHeight = 3;
        _indicatorCornerRadius = KSPageViewAutomaticDimension;
        _indicatorColor = [UIColor redColor];
        _scrollStyle = KSPageViewIndicatorScrollStyleSimple;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(NO, @"Use initWithFrame");
    }
    return self;
}

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if (self.indicatorWidth == KSPageViewAutomaticDimension) {
        return cellFrame.size.width + self.indicatorWidthIncrement;
    }
    return self.indicatorWidth + self.indicatorWidthIncrement;
}

- (CGFloat)indicatorHeightValue:(CGRect)cellFrame {
    if (self.indicatorHeight == KSPageViewAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.indicatorHeight;
}

- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame {
    if (self.indicatorCornerRadius == KSPageViewAutomaticDimension) {
        return [self indicatorHeightValue:cellFrame]/2;
    }
    return self.indicatorCornerRadius;
}

#pragma mark - KSPageIndicatorProtocol

- (void)ks_refreshState:(KSPageIndicatorParamsModel *)model {

}

- (void)ks_contentScrollViewDidScroll:(KSPageIndicatorParamsModel *)model {

}

- (void)ks_selectedCell:(KSPageIndicatorParamsModel *)model {
    
}

@end
