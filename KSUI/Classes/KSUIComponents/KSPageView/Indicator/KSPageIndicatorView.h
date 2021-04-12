//
//  KSPageIndicatorView.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import "KSPageView.h"
#import "KSPageIndicatorViewCell.h"
#import "KSPageIndicatorViewCellModel.h"
#import "KSPageIndicatorParamsModel.h"
#import "KSPageIndicatorProtocol.h"
#import "KSPageIndicatorBackgroundView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPageIndicatorView : KSPageView

@property (nonatomic, strong) NSArray <UIView<KSPageIndicatorProtocol> *> *indicators;

//----------------------ellBackgroundColor-----------------------//
//cell的背景色是否渐变。默认：NO
@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;
//cell普通状态的背景色。默认：[UIColor clearColor]
@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;
//cell选中状态的背景色。默认：[UIColor grayColor]
@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

//----------------------separatorLine-----------------------//
//是否显示分割线。默认为NO
@property (nonatomic, assign, getter=isSeparatorLineShowEnabled) BOOL separatorLineShowEnabled;
//分割线颜色。默认为[UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *separatorLineColor;
//分割线的size。默认为CGSizeMake(1/[UIScreen mainScreen].scale, 20)
@property (nonatomic, assign) CGSize separatorLineSize;

@end

@interface KSPageIndicatorView (UISubclassingIndicatorHooks)

/**
 当contentScrollView滚动时候，处理跟随手势的过渡效果。
 根据cellModel的左右位置、是否选中、ratio进行过滤数据计算。

 @param leftCellModel 左边的cellModel
 @param rightCellModel 右边的cellModel
 @param ratio 从左往右方向计算的百分比
 */
- (void)refreshLeftCellModel:(KSPageViewCellModel *)leftCellModel rightCellModel:(KSPageViewCellModel *)rightCellModel ratio:(CGFloat)ratio NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
