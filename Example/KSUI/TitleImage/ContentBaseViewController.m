//
//  BaseViewController.m
//  KSPageView
//
//  Created by jiaxin on 2018/8/9.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ContentBaseViewController.h"
#import "ListViewController.h"
#import "KSPageIndicatorView.h"

@interface ContentBaseViewController () <KSPageViewDelegate>
@end

@implementation ContentBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.listContainerView];

    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];


    if (self.isNeedIndicatorPositionChangeItem) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"指示器位置切换" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, 80, self.view.bounds.size.width, [self preferredCategoryViewHeight]);
    self.listContainerView.frame = CGRectMake(0, [self preferredCategoryViewHeight]+80, self.view.bounds.size.width, self.view.bounds.size.height-80-50);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (KSPageView *)preferredCategoryView {
    return [[KSPageView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

- (KSPageView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [self preferredCategoryView];
    }
    return _categoryView;
}

- (KSPageListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[KSPageListContainerView alloc] initWithType:KSPageListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (void)rightItemClicked {
    KSPageIndicatorView *componentView = (KSPageIndicatorView *)self.categoryView;
    for (KSPageIndicatorComponentView *view in componentView.indicators) {
        if (view.componentPosition == KSPageViewComponentPosition_Top) {
            view.componentPosition = KSPageViewComponentPosition_Bottom;
        }else {
            view.componentPosition = KSPageViewComponentPosition_Top;
        }
    }
    [componentView reloadDataWithoutListContainer];
}

#pragma mark - KSPageViewDelegate

- (void)categoryView:(KSPageView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(KSPageView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - KSPageListContainerViewDelegate

- (id<KSPageListContentViewDelegate>)listContainerView:(KSPageListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    ListViewController *list = [[ListViewController alloc] init];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(KSPageListContainerView *)listContainerView {
    return self.titles.count;
}

@end
