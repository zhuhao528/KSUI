//
//  KSPageTitleViewCellModel.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageViewCellModel.h"
#import "KSPageIndicatorViewCellModel.h"
#import "KSPageViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPageTitleViewCellModel : KSPageIndicatorViewCellModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger titleNumberOfLines;

@property (nonatomic, strong) UIColor *titleNormalColor;

@property (nonatomic, strong) UIColor *titleCurrentColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIFont *titleSelectedFont;

@property (nonatomic, assign, getter=isTitleLabelMaskEnabled) BOOL titleLabelMaskEnabled;

@property (nonatomic, assign, getter=isTitleLabelZoomEnabled) BOOL titleLabelZoomEnabled;

@property (nonatomic, assign) CGFloat titleLabelNormalZoomScale;

@property (nonatomic, assign) CGFloat titleLabelCurrentZoomScale;

@property (nonatomic, assign) CGFloat titleLabelSelectedZoomScale;

@property (nonatomic, assign) CGFloat titleLabelZoomSelectedVerticalOffset;

@property (nonatomic, assign, getter=isTitleLabelStrokeWidthEnabled) BOOL titleLabelStrokeWidthEnabled;

@property (nonatomic, assign) CGFloat titleLabelNormalStrokeWidth;

@property (nonatomic, assign) CGFloat titleLabelCurrentStrokeWidth;

@property (nonatomic, assign) CGFloat titleLabelSelectedStrokeWidth;

@property (nonatomic, assign) CGFloat titleLabelVerticalOffset;

@property (nonatomic, assign) KSPageViewTitleLabelAnchorPointStyle titleLabelAnchorPointStyle;

@end

NS_ASSUME_NONNULL_END
