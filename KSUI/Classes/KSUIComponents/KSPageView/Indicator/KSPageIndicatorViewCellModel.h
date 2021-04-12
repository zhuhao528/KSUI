//
//  KSPageIndicatorViewCellModel.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPageIndicatorViewCellModel : KSPageViewCellModel

@property (nonatomic, assign, getter=isSepratorLineShowEnabled) BOOL sepratorLineShowEnabled;

@property (nonatomic, strong) UIColor *separatorLineColor;

@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGRect backgroundViewMaskFrame;   //底部指示器的frame转换到cell的frame

@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;

@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;

@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

@end

NS_ASSUME_NONNULL_END
