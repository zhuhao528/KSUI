//
//  KSPageIndicatorView.m
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageIndicatorView.h"
#import "KSPageViewUtil.h"

@interface KSPageIndicatorView()

@end

@implementation KSPageIndicatorView

- (void)initializeData {
    [super initializeData];

    _separatorLineShowEnabled = NO;
    _separatorLineColor = [UIColor lightGrayColor];
    _separatorLineSize = CGSizeMake(1/[UIScreen mainScreen].scale, 20);
    _cellBackgroundColorGradientEnabled = NO;
    _cellBackgroundUnselectedColor = [UIColor whiteColor];
    _cellBackgroundSelectedColor = [UIColor lightGrayColor];
}

- (void)initializeViews {
    [super initializeViews];
}

- (void)setIndicators:(NSArray<UIView<KSPageIndicatorProtocol> *> *)indicators {
    _indicators = indicators;

    self.collectionView.indicators = indicators;
}

- (void)refreshState {
    [super refreshState];

    CGRect selectedCellFrame = CGRectZero;
    KSPageIndicatorViewCellModel *selectedCellModel = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        KSPageIndicatorViewCellModel *cellModel = (KSPageIndicatorViewCellModel *)self.dataSource[i];
        cellModel.sepratorLineShowEnabled = self.isSeparatorLineShowEnabled;
        cellModel.separatorLineColor = self.separatorLineColor;
        cellModel.separatorLineSize = self.separatorLineSize;
        cellModel.backgroundViewMaskFrame = CGRectZero;
        cellModel.cellBackgroundColorGradientEnabled = self.isCellBackgroundColorGradientEnabled;
        cellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        cellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        cellModel.cellRadius = self.cellRadius;
        if (i == self.dataSource.count - 1) {
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedCellModel = cellModel;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }

    for (UIView<KSPageIndicatorProtocol> *indicator in self.indicators) {
        if (self.dataSource.count <= 0) {
            indicator.hidden = YES;
        }else {
            indicator.hidden = NO;
            KSPageIndicatorParamsModel *indicatorParamsModel = [[KSPageIndicatorParamsModel alloc] init];
            indicatorParamsModel.selectedIndex = self.selectedIndex;
            indicatorParamsModel.selectedCellFrame = selectedCellFrame;
            [indicator ks_refreshState:indicatorParamsModel];

            if ([indicator isKindOfClass:[KSPageIndicatorBackgroundView class]]) {
                CGRect maskFrame = indicator.frame;
                maskFrame.origin.x = maskFrame.origin.x - selectedCellFrame.origin.x;
                selectedCellModel.backgroundViewMaskFrame = maskFrame;
            }
        }
    }
}

- (void)refreshSelectedCellModel:(KSPageViewCellModel *)selectedCellModel unselectedCellModel:(KSPageViewCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    KSPageIndicatorViewCellModel *myUnselectedCellModel = (KSPageIndicatorViewCellModel *)unselectedCellModel;
    myUnselectedCellModel.backgroundViewMaskFrame = CGRectZero;
    myUnselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myUnselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;

    KSPageIndicatorViewCellModel *myselectedCellModel = (KSPageIndicatorViewCellModel *)selectedCellModel;
    myselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    [super contentOffsetOfContentScrollViewDidChanged:contentOffset];
    
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    if (baseIndex + 1 >= self.dataSource.count) {
        //右边越界了，不需要处理
        return;
    }
    CGFloat remainderRatio = ratio - baseIndex;

    CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
    CGRect rightCellFrame = [self getTargetCellFrame:baseIndex + 1];

    KSPageIndicatorParamsModel *indicatorParamsModel = [[KSPageIndicatorParamsModel alloc] init];
    indicatorParamsModel.selectedIndex = self.selectedIndex;
    indicatorParamsModel.leftIndex = baseIndex;
    indicatorParamsModel.leftCellFrame = leftCellFrame;
    indicatorParamsModel.rightIndex = baseIndex + 1;
    indicatorParamsModel.rightCellFrame = rightCellFrame;
    indicatorParamsModel.percent = remainderRatio;
    if (remainderRatio == 0) {
        for (UIView<KSPageIndicatorProtocol> *indicator in self.indicators) {
            [indicator ks_contentScrollViewDidScroll:indicatorParamsModel];
        }
    }else {
        KSPageIndicatorViewCellModel *leftCellModel = (KSPageIndicatorViewCellModel *)self.dataSource[baseIndex];
        leftCellModel.selectedType = KSPageViewCellSelectedTypeUnknown;
        KSPageIndicatorViewCellModel *rightCellModel = (KSPageIndicatorViewCellModel *)self.dataSource[baseIndex + 1];
        rightCellModel.selectedType = KSPageViewCellSelectedTypeUnknown;
        [self refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:remainderRatio];

        for (UIView<KSPageIndicatorProtocol> *indicator in self.indicators) {
            [indicator ks_contentScrollViewDidScroll:indicatorParamsModel];
            if ([indicator isKindOfClass:[KSPageIndicatorBackgroundView class]]) {
                CGRect leftMaskFrame = indicator.frame;
                leftMaskFrame.origin.x = leftMaskFrame.origin.x - leftCellFrame.origin.x;
                leftCellModel.backgroundViewMaskFrame = leftMaskFrame;

                CGRect rightMaskFrame = indicator.frame;
                rightMaskFrame.origin.x = rightMaskFrame.origin.x - rightCellFrame.origin.x;
                rightCellModel.backgroundViewMaskFrame = rightMaskFrame;
            }
        }

        KSPageViewCell *leftCell = (KSPageViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        [leftCell reloadData:leftCellModel];
        KSPageViewCell *rightCell = (KSPageViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
        [rightCell reloadData:rightCellModel];
    }
}

- (BOOL)selectCellAtIndex:(NSInteger)index selectedType:(KSPageViewCellSelectedType)selectedType {
    NSInteger lastSelectedIndex = self.selectedIndex;
    BOOL result = [super selectCellAtIndex:index selectedType:selectedType];
    if (!result) {
        return NO;
    }

    CGRect clickedCellFrame = [self getTargetSelectedCellFrame:index selectedType:selectedType];
    
    KSPageIndicatorViewCellModel *selectedCellModel = (KSPageIndicatorViewCellModel *)self.dataSource[index];
    selectedCellModel.selectedType = selectedType;
    for (UIView<KSPageIndicatorProtocol> *indicator in self.indicators) {
        KSPageIndicatorParamsModel *indicatorParamsModel = [[KSPageIndicatorParamsModel alloc] init];
        indicatorParamsModel.lastSelectedIndex = lastSelectedIndex;
        indicatorParamsModel.selectedIndex = index;
        indicatorParamsModel.selectedCellFrame = clickedCellFrame;
        indicatorParamsModel.selectedType = selectedType;
        [indicator ks_selectedCell:indicatorParamsModel];
        if ([indicator isKindOfClass:[KSPageIndicatorBackgroundView class]]) {
            CGRect maskFrame = indicator.frame;
            maskFrame.origin.x = maskFrame.origin.x - clickedCellFrame.origin.x;
            selectedCellModel.backgroundViewMaskFrame = maskFrame;
        }
    }

    KSPageIndicatorViewCell *selectedCell = (KSPageIndicatorViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [selectedCell reloadData:selectedCellModel];

    return YES;
}

@end

@implementation KSPageIndicatorView (UISubclassingIndicatorHooks)

- (void)refreshLeftCellModel:(KSPageViewCellModel *)leftCellModel rightCellModel:(KSPageViewCellModel *)rightCellModel ratio:(CGFloat)ratio {
    if (self.isCellBackgroundColorGradientEnabled) {
        //处理cell背景色渐变
        KSPageIndicatorViewCellModel *leftModel = (KSPageIndicatorViewCellModel *)leftCellModel;
        KSPageIndicatorViewCellModel *rightModel = (KSPageIndicatorViewCellModel *)rightCellModel;
        if (leftModel.isSelected) {
            leftModel.cellBackgroundSelectedColor = [KSPageViewUtil interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            
            leftModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            leftModel.cellBackgroundUnselectedColor = [KSPageViewUtil interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];

            leftModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
        if (rightModel.isSelected) {
            rightModel.cellBackgroundSelectedColor = [KSPageViewUtil interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];

            rightModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            rightModel.cellBackgroundUnselectedColor = [KSPageViewUtil interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            
            rightModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
    }

}

@end

