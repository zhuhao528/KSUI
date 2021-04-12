//
//  TitleImageSettingViewController.m
//  KSPageView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TitleImageSettingViewController.h"

@interface TitleImageSettingViewController ()

@end

@implementation TitleImageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    NSUInteger selectedIndex = [self converImageTypeToIndex:self.imageType];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KSPageTitleImageType imageType = [self converIndexToImageType:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(titleImageSettingVCDidSelectedImageType:)]) {
        [self.delegate titleImageSettingVCDidSelectedImageType:imageType];
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (KSPageTitleImageType)converIndexToImageType:(NSUInteger)index {
    NSArray <NSNumber *> *imageTypes = @[@(KSPageTitleImageType_TopImage),
                            @(KSPageTitleImageType_LeftImage),
                            @(KSPageTitleImageType_BottomImage),
                            @(KSPageTitleImageType_RightImage),
                                         @(KSPageTitleImageType_OnlyImage),
                                         @(KSPageTitleImageType_OnlyTitle),
                                         @(100)

                                         ];
    return [imageTypes[index] integerValue];
}

- (NSInteger)converImageTypeToIndex:(KSPageTitleImageType)imageType {
    NSArray <NSNumber *> *imageTypes = @[@(KSPageTitleImageType_TopImage),
                                         @(KSPageTitleImageType_LeftImage),
                                         @(KSPageTitleImageType_BottomImage),
                                         @(KSPageTitleImageType_RightImage),
                                         @(KSPageTitleImageType_OnlyImage),
                                         @(KSPageTitleImageType_OnlyTitle),
                                         @(100),];
    return [imageTypes indexOfObject:@(imageType)];
}

@end
