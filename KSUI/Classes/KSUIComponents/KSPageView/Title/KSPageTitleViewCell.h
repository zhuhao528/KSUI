//
//  KSPageTitleViewCell.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageViewCell.h"
#import "KSPageViewDefines.h"
#import "KSPageIndicatorViewCell.h"
#import "KSPageTitleViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPageTitleViewCell : KSPageIndicatorViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterX;

- (KSPageViewCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(KSPageTitleViewCellModel *)cellModel baseScale:(CGFloat)baseScale;

- (KSPageViewCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(KSPageTitleViewCellModel *)cellModel attributedString:(NSMutableAttributedString *)attributedString;

- (KSPageViewCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(KSPageTitleViewCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
