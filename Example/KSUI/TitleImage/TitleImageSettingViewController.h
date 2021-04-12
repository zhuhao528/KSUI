//
//  TitleImageSettingViewController.h
//  KSPageView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPageTitleImageView.h"

@protocol TitleTitleImageSettingViewControllerDelegate <NSObject>

- (void)titleImageSettingVCDidSelectedImageType:(KSPageTitleImageType)imageType;

@end

@interface TitleImageSettingViewController : UITableViewController

@property (nonatomic, weak) id<TitleTitleImageSettingViewControllerDelegate> delegate;

@property (nonatomic, assign) KSPageTitleImageType imageType;

@end
