//
//  KSPageIndicatorLineView.m
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageIndicatorLineView.h"
#import "KSPageViewAnimator.h"
#import "KSPageIndicatorParamsModel.h"
#import "KSPageViewUtil.h"

@interface KSPageIndicatorLineView ()
@property (nonatomic, strong) KSPageViewAnimator *animator;
@end

@implementation KSPageIndicatorLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineStyle = KSPageIndicatorLineStyle_Normal;
        _lineScrollOffsetX = 10;
        self.indicatorHeight = 3;
    }
    return self;
}

#pragma mark - KSPageIndicatorProtocol

- (void)ks_refreshState:(KSPageIndicatorParamsModel *)model {
    self.backgroundColor = self.indicatorColor;
    self.layer.cornerRadius = [self indicatorCornerRadiusValue:model.selectedCellFrame];

    CGFloat selectedLineWidth = [self indicatorWidthValue:model.selectedCellFrame];
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - selectedLineWidth)/2;
    CGFloat y = self.superview.bounds.size.height - [self indicatorHeightValue:model.selectedCellFrame] - self.verticalMargin;
    if (self.componentPosition == KSPageViewComponentPosition_Top) {
        y = self.verticalMargin;
    }
    self.frame = CGRectMake(x, y, selectedLineWidth, [self indicatorHeightValue:model.selectedCellFrame]);
}

- (void)ks_contentScrollViewDidScroll:(KSPageIndicatorParamsModel *)model {
    if (self.animator.isExecuting) {
        [self.animator invalid];
        self.animator = nil;
    }
    CGRect rightCellFrame = model.rightCellFrame;
    CGRect leftCellFrame = model.leftCellFrame;
    CGFloat percent = model.percent;
    CGFloat targetX = leftCellFrame.origin.x;
    CGFloat targetWidth = [self indicatorWidthValue:leftCellFrame];

    CGFloat leftWidth = targetWidth;
    CGFloat rightWidth = [self indicatorWidthValue:rightCellFrame];
    CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - leftWidth)/2;
    CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - rightWidth)/2;

    if (self.lineStyle == KSPageIndicatorLineStyle_Normal) {
        targetX = [KSPageViewUtil interpolationFrom:leftX to:rightX percent:percent];
        if (self.indicatorWidth == KSPageViewAutomaticDimension) {
            targetWidth = [KSPageViewUtil interpolationFrom:leftWidth to:rightWidth percent:percent];
        }
    }else if (self.lineStyle == KSPageIndicatorLineStyle_Lengthen) {
        CGFloat maxWidth = rightX - leftX + rightWidth;
        //前50%，只增加width；后50%，移动x并减小width
        if (percent <= 0.5) {
            targetX = leftX;
            targetWidth = [KSPageViewUtil interpolationFrom:leftWidth to:maxWidth percent:percent*2];
        }else {
            targetX = [KSPageViewUtil interpolationFrom:leftX to:rightX percent:(percent - 0.5)*2];
            targetWidth = [KSPageViewUtil interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
        }
    }else if (self.lineStyle == KSPageIndicatorLineStyle_LengthenOffset) {
        //前50%，增加width，并少量移动x；后50%，少量移动x并减小width
        CGFloat offsetX = self.lineScrollOffsetX;//x的少量偏移量
        CGFloat maxWidth = rightX - leftX + rightWidth - offsetX*2;
        if (percent <= 0.5) {
            targetX = [KSPageViewUtil interpolationFrom:leftX to:leftX + offsetX percent:percent*2];;
            targetWidth = [KSPageViewUtil interpolationFrom:leftWidth to:maxWidth percent:percent*2];
        }else {
            targetX = [KSPageViewUtil interpolationFrom:(leftX + offsetX) to:rightX percent:(percent - 0.5)*2];
            targetWidth = [KSPageViewUtil interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
        }
    }
    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.isScrollEnabled == YES || (self.isScrollEnabled == NO && percent == 0)) {
        CGRect frame = self.frame;
        frame.origin.x = targetX;
        frame.size.width = targetWidth;
        self.frame = frame;
    }
}

- (void)ks_selectedCell:(KSPageIndicatorParamsModel *)model {
    CGRect targetIndicatorFrame = self.frame;
    CGFloat targetIndicatorWidth = [self indicatorWidthValue:model.selectedCellFrame];
    targetIndicatorFrame.origin.x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - targetIndicatorWidth)/2.0;
    targetIndicatorFrame.size.width = targetIndicatorWidth;
    if (self.isScrollEnabled) {
        if (self.scrollStyle == KSPageViewIndicatorScrollStyleSameAsUserScroll && (model.selectedType == KSPageViewCellSelectedTypeClick | model.selectedType == KSPageViewCellSelectedTypeCode)) {
            if (self.animator.isExecuting) {
                [self.animator invalid];
                self.animator = nil;
            }
            CGFloat leftX = 0;
            CGFloat rightX = 0;
            CGFloat leftWidth = 0;
            CGFloat rightWidth = 0;
            BOOL isNeedReversePercent = NO;
            if (self.frame.origin.x > model.selectedCellFrame.origin.x) {
                leftWidth = [self indicatorWidthValue:model.selectedCellFrame];
                rightWidth = self.frame.size.width;
                leftX = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - leftWidth)/2;;
                rightX = self.frame.origin.x;
                isNeedReversePercent = YES;
            }else {
                leftWidth = self.frame.size.width;
                rightWidth = [self indicatorWidthValue:model.selectedCellFrame];
                leftX = self.frame.origin.x;
                rightX = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - rightWidth)/2;
            }
            __weak typeof(self) weakSelf = self;
            if (self.lineStyle == KSPageIndicatorLineStyle_Normal) {
                [UIView animateWithDuration:self.scrollAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.frame = targetIndicatorFrame;
                } completion: nil];
            }else if (self.lineStyle == KSPageIndicatorLineStyle_Lengthen) {
                CGFloat maxWidth = rightX - leftX + rightWidth;
                //前50%，只增加width；后50%，移动x并减小width
                self.animator = [[KSPageViewAnimator alloc] init];
                self.animator.progressCallback = ^(CGFloat percent) {
                    if (isNeedReversePercent) {
                        percent = 1 - percent;
                    }
                    CGFloat targetX = 0;
                    CGFloat targetWidth = 0;
                    if (percent <= 0.5) {
                        targetX = leftX;
                        targetWidth = [KSPageViewUtil interpolationFrom:leftWidth to:maxWidth percent:percent*2];
                    }else {
                        targetX = [KSPageViewUtil interpolationFrom:leftX to:rightX percent:(percent - 0.5)*2];
                        targetWidth = [KSPageViewUtil interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
                    }
                    CGRect toFrame = weakSelf.frame;
                    toFrame.origin.x = targetX;
                    toFrame.size.width = targetWidth;
                    weakSelf.frame = toFrame;
                };
                [self.animator start];
            }else if (self.lineStyle == KSPageIndicatorLineStyle_LengthenOffset) {
                //前50%，增加width，并少量移动x；后50%，少量移动x并减小width
                CGFloat offsetX = self.lineScrollOffsetX;//x的少量偏移量
                CGFloat maxWidth = rightX - leftX + rightWidth - offsetX*2;
                self.animator = [[KSPageViewAnimator alloc] init];
                self.animator.progressCallback = ^(CGFloat percent) {
                    if (isNeedReversePercent) {
                        percent = 1 - percent;
                    }
                    CGFloat targetX = 0;
                    CGFloat targetWidth = 0;
                    if (percent <= 0.5) {
                        targetX = [KSPageViewUtil interpolationFrom:leftX to:leftX + offsetX percent:percent*2];;
                        targetWidth = [KSPageViewUtil interpolationFrom:leftWidth to:maxWidth percent:percent*2];
                    }else {
                        targetX = [KSPageViewUtil interpolationFrom:(leftX + offsetX) to:rightX percent:(percent - 0.5)*2];
                        targetWidth = [KSPageViewUtil interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
                    }
                    CGRect toFrame = weakSelf.frame;
                    toFrame.origin.x = targetX;
                    toFrame.size.width = targetWidth;
                    weakSelf.frame = toFrame;
                };
                [self.animator start];
            }
        }else if (self.scrollStyle == KSPageViewIndicatorScrollStyleSimple) {
            [UIView animateWithDuration:self.scrollAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = targetIndicatorFrame;
            } completion: nil];
        }
    }else {
        self.frame = targetIndicatorFrame;
    }
}

@end

