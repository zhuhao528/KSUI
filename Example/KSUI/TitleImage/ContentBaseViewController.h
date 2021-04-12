//
//  BaseViewController.h
//  KSPageView
//
//  Created by jiaxin on 2018/8/9.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPageView.h"
#import "KSPageListContainerView.h"

#define WindowsSize [UIScreen mainScreen].bounds.size

@interface ContentBaseViewController : UIViewController<KSPageListContainerViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) KSPageView *categoryView;

@property (nonatomic, strong) KSPageListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

- (KSPageView *)preferredCategoryView;

- (CGFloat)preferredCategoryViewHeight;

@end
