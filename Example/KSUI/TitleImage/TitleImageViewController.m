//
//  ImageViewController.m
//  KSPageView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TitleImageViewController.h"
#import "KSPageTitleImageView.h"
#import "TitleImageSettingViewController.h"
#import "KSPageIndicatorLineView.h"

@interface TitleImageViewController () <KSPageViewDelegate, TitleTitleImageSettingViewControllerDelegate>
@property (nonatomic, strong) KSPageTitleImageView *mypageView;
@property (nonatomic, assign) KSPageTitleImageType currentType;
@end

@implementation TitleImageViewController

- (void)viewDidLoad {
    self.titles = @[@"螃蟹", @"小龙虾", @"苹果", @"胡萝卜", @"葡萄", @"西瓜"];
    
    [super viewDidLoad];

    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(didSettingClicked)];
    self.navigationItem.rightBarButtonItem = settingItem;

    NSArray *imageNames = @[@"crab", @"lobster", @"apple", @"carrot", @"grape", @"watermelon"];
    NSArray *selectedImageNames = @[@"crab_selected", @"lobster_selected", @"apple_selected", @"carrot_selected", @"grape_selected", @"watermelon_selected"];

    self.mypageView.titles = self.titles;
    self.mypageView.imageNames = imageNames;
    self.mypageView.selectedImageNames = selectedImageNames;
    self.mypageView.imageZoomEnabled = YES;
    self.mypageView.imageZoomScale = 1.3;
    self.mypageView.averageCellSpacingEnabled = NO;

    KSPageIndicatorLineView *lineView = [[KSPageIndicatorLineView alloc] init];
    lineView.indicatorWidth = 20;
    lineView.lineStyle = KSPageIndicatorLineStyle_Lengthen;
    self.mypageView.indicators = @[lineView];

    [self configpageViewWithType:KSPageTitleImageType_LeftImage];
}

- (KSPageTitleImageView *)pageView{
    return (KSPageTitleImageView *)self.pageView;
}

- (KSPageView *)preferredpageView {
    return [[KSPageTitleImageView alloc] init];
}

- (CGFloat)preferredpageViewHeight {
    return 60;
}

- (void)didSettingClicked {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TitleImageSettingViewController *imageSettingVC = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([TitleImageSettingViewController class])];
    imageSettingVC.imageType = self.currentType;
    imageSettingVC.delegate = self;
    [self.navigationController pushViewController:imageSettingVC animated:YES];
}

- (void)configpageViewWithType:(KSPageTitleImageType)imageType {
    self.currentType = imageType;
    if ((NSInteger)imageType == 100) {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titles.count; i++) {
            if (i == 2) {
                [types addObject:@(KSPageTitleImageType_OnlyImage)];
            }else if (i == 4) {
                [types addObject:@(KSPageTitleImageType_LeftImage)];
            }else {
                [types addObject:@(KSPageTitleImageType_OnlyTitle)];
            }
        }
        self.mypageView.imageTypes = types;
    }else {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titles.count; i++) {
            [types addObject:@(imageType)];
        }
        self.mypageView.imageTypes = types;
    }
    [self.pageView reloadData];
}

#pragma mark - TitleImageSettingViewControllerDelegate

- (void)titleImageSettingVCDidSelectedImageType:(KSPageTitleImageType)imageType {
    [self configpageViewWithType:imageType];
}

@end
