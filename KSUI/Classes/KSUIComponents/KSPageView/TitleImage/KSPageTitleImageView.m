//
//  KSPageTitleImageView.m
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageTitleImageView.h"
#import "KSPageViewUtil.h"

@implementation KSPageTitleImageView

- (void)dealloc
{
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _titleImageSpacing = 5;
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
}

- (Class)preferredCellClass {
    return [KSPageTitleImageViewCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        KSPageTitleImageViewCellModel *cellModel = [[KSPageTitleImageViewCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    if (self.imageTypes == nil || self.imageTypes.count == 0) {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titles.count; i++) {
            [types addObject:@(KSPageTitleImageType_LeftImage)];
        }
        self.imageTypes = types;
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(KSPageViewCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    KSPageTitleImageViewCellModel *myCellModel = (KSPageTitleImageViewCellModel *)cellModel;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageType = [self.imageTypes[index] integerValue];
    myCellModel.imageSize = self.imageSize;
    myCellModel.titleImageSpacing = self.titleImageSpacing;
    if (self.imageNames != nil) {
        myCellModel.imageName = self.imageNames[index];
    }else if (self.imageURLs != nil) {
        myCellModel.imageURL = self.imageURLs[index];
    }
    if (self.selectedImageNames != nil) {
        myCellModel.selectedImageName = self.selectedImageNames[index];
    }else if (self.selectedImageURLs != nil) {
        myCellModel.selectedImageURL = self.selectedImageURLs[index];
    }
    myCellModel.imageZoomEnabled = self.imageZoomEnabled;
    myCellModel.imageZoomScale = 1.0;
    if (index == self.selectedIndex) {
        myCellModel.imageZoomScale = self.imageZoomScale;
    }
}

- (void)refreshSelectedCellModel:(KSPageViewCellModel *)selectedCellModel unselectedCellModel:(KSPageViewCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    KSPageTitleImageViewCellModel *myUnselectedCellModel = (KSPageTitleImageViewCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    KSPageTitleImageViewCellModel *myselectedCellModel = (KSPageTitleImageViewCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshLeftCellModel:(KSPageViewCellModel *)leftCellModel rightCellModel:(KSPageViewCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    KSPageTitleImageViewCellModel *leftModel = (KSPageTitleImageViewCellModel *)leftCellModel;
    KSPageTitleImageViewCellModel *rightModel = (KSPageTitleImageViewCellModel *)rightCellModel;

    if (self.isImageZoomEnabled) {
      leftModel.imageZoomScale = [KSPageViewUtil interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
      rightModel.imageZoomScale = [KSPageViewUtil interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == KSPageViewAutomaticDimension) {
        CGFloat titleWidth = [super preferredCellWidthAtIndex:index];
        KSPageTitleImageType type = [self.imageTypes[index] integerValue];
        CGFloat cellWidth = 0;
        switch (type) {
            case KSPageTitleImageType_OnlyTitle:
                cellWidth = titleWidth;
                break;
            case KSPageTitleImageType_OnlyImage:
                cellWidth = self.imageSize.width;
                break;
            case KSPageTitleImageType_LeftImage:
            case KSPageTitleImageType_RightImage:
                cellWidth = titleWidth + self.titleImageSpacing + self.imageSize.width;
                break;
            case KSPageTitleImageType_TopImage:
            case KSPageTitleImageType_BottomImage:
                cellWidth = MAX(titleWidth, self.imageSize.width);
                break;
        }
        return cellWidth;
    }
    return self.cellWidth;
}

@end
