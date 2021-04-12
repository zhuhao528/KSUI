//
//  KSPageViewCell.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import <UIKit/UIKit.h>
#import "KSPageViewCellModel.h"
#import "KSPageViewAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPageViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) KSPageViewCellModel *cellModel;
@property (nonatomic, strong, readonly) KSPageViewAnimator *animator;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(KSPageViewCellModel *)cellModel NS_REQUIRES_SUPER;

- (BOOL)checkCanStartSelectedAnimation:(KSPageViewCellModel *)cellModel;

- (void)addSelectedAnimationBlock:(KSPageViewCellSelectedAnimationBlock)block;

- (void)startSelectedAnimationIfNeeded:(KSPageViewCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
