//
//  KSPageIndicatorViewCell.m
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageIndicatorViewCell.h"
#import "KSPageIndicatorViewCellModel.h"

@interface KSPageIndicatorViewCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation KSPageIndicatorViewCell

- (void)initializeViews
{
    [super initializeViews];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    KSPageIndicatorViewCellModel *model = (KSPageIndicatorViewCellModel *)self.cellModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;

    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.cellModel.cellSpacing/2, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)reloadData:(KSPageViewCellModel *)cellModel {
    [super reloadData:cellModel];

    KSPageIndicatorViewCellModel *model = (KSPageIndicatorViewCellModel *)cellModel;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.isSepratorLineShowEnabled;

    if (model.isCellBackgroundColorGradientEnabled) {
        if (model.isSelected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        }else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
    
    if (cellModel.cellRadius != 0) {
        self.contentView.layer.cornerRadius = model.cellRadius;
    }else{
        NSLog(@"hello cellRadius");
    }

}

@end
