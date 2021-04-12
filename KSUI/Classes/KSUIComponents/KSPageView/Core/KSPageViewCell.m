//
//  KSPageViewCell.m
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageViewCell.h"

@interface KSPageViewCell ()

@property (nonatomic, strong) KSPageViewCellModel *cellModel;
@property (nonatomic, strong) KSPageViewAnimator *animator;
@property (nonatomic, strong) NSMutableArray <KSPageViewCellSelectedAnimationBlock> *animationBlockArray;

@end

@implementation KSPageViewCell

- (void)dealloc
{
    [self.animator stop];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _animationBlockArray = [NSMutableArray array];

//    [RTLManager horizontalFlipViewIfNeeded:self];
//    [RTLManager horizontalFlipViewIfNeeded:self.contentView];
}

- (void)reloadData:(KSPageViewCellModel *)cellModel {
    self.cellModel = cellModel;

    if (cellModel.isSelectedAnimationEnabled) {
        [self.animationBlockArray removeLastObject];
        if ([self checkCanStartSelectedAnimation:cellModel]) {
            _animator = [[KSPageViewAnimator alloc] init];
            self.animator.duration = cellModel.selectedAnimationDuration;
        }else {
            [self.animator stop];
        }
    }
}

- (BOOL)checkCanStartSelectedAnimation:(KSPageViewCellModel *)cellModel {
    if (cellModel.selectedType == KSPageViewCellSelectedTypeCode || cellModel.selectedType == KSPageViewCellSelectedTypeClick) {
        return YES;
    }
    return NO;
}

- (void)addSelectedAnimationBlock:(KSPageViewCellSelectedAnimationBlock)block {
    [self.animationBlockArray addObject:block];
}

- (void)startSelectedAnimationIfNeeded:(KSPageViewCellModel *)cellModel {
    if (cellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:cellModel]) {
        //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
        cellModel.transitionAnimating = YES;
        __weak typeof(self)weakSelf = self;
        self.animator.progressCallback = ^(CGFloat percent) {
            for (KSPageViewCellSelectedAnimationBlock block in weakSelf.animationBlockArray) {
                block(percent);
            }
        };
        self.animator.completeCallback = ^{
            cellModel.transitionAnimating = NO;
            [weakSelf.animationBlockArray removeAllObjects];
        };
        [self.animator start];
    }
}

@end
