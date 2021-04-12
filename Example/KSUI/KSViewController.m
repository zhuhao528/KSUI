//
//  KSViewController.m
//  KSUI
//
//  Created by zhuhao on 12/05/2019.
//  Copyright (c) 2019 zhuhao. All rights reserved.
//

#import "KSViewController.h"
#import "KSUI.h"
#import "TitleImageViewController.h"

@interface KSViewController ()

@property (strong, nonatomic) KSButton *button;
@property (strong, nonatomic) KSButton *rightButton;
@property (nonatomic, strong) KSPopover *btnPopover;
@property (nonatomic, strong) KSPopover *rightBtnPopover;

@end

@implementation KSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 气泡提示
    // Do any additional setup after loading the view, typically from a nib.
    self.button = [KSButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setFrame:CGRectMake(10,100,100,50)];
    [self.button setBackgroundColor:[UIColor grayColor]];
    [self.button setImagePosition:KSButtonImagePositionLeft];  // 测试图文位置
    //   [self.button setSpacingBetweenImageAndTitle:10]; // 测试图文位置
    [self.button setTitle:@"Test" forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"icon_homework"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.rightButton = [KSButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rightButton setFrame:CGRectMake(250,400,100,50)];
    [self.rightButton setBackgroundColor:[UIColor grayColor]];
    [self.rightButton setImagePosition:KSButtonImagePositionLeft];  // 测试图文位置
    //   [self.button setSpacingBetweenImageAndTitle:10]; // 测试图文位置
    [self.rightButton setTitle:@"Test" forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"icon_homework"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
    
    // 图片绘制圆角
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"cover"];
    [imageView setFrame:CGRectMake(10,170,image.size.width,image.size.height)];
    UIImage *image1 = [image imageDrawRectWithRoundedCorner:50
                                                       size:imageView.bounds.size];
    [imageView setImage:image1];
    [self.view addSubview:imageView];
    
    
    UIButton *button = [KSButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10,500,100,50)];
    [button setBackgroundColor:[UIColor grayColor]];
    [button setTitle:@"KSPageView" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(KSPageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (KSPopover *)buttonPopover {
    if (!_btnPopover) {
        KSPopoverOption *option = [[KSPopoverOption alloc] init];
        option.autoAjustDirection = YES;
        option.preferedType = KSPopoverTypeDown;
//      option.popoverType = KSPopoverTypeUp;
//      option.popoverType = KSPopoverTypeDown;
        option.popoverType = KSPopoverTypeRight;
        option.arrowSize = CGSizeMake(26, 8);
        option.blackOverlayColor = [UIColor clearColor];
        option.popoverColor = [UIColor lightGrayColor];
        option.dismissOnBlackOverlayTap = YES;
        option.animationIn = 0.5;
        option.cornerRadius = 7;
        //...
        
        _btnPopover = [[KSPopover alloc] initWithOption:option];
    }
    return _btnPopover;
}

- (KSPopover *)rightButtonPopover {
    if (!_rightBtnPopover) {
        KSPopoverOption *option = [[KSPopoverOption alloc] init];
        option.autoAjustDirection = YES;
        option.preferedType = KSPopoverTypeLeft;
        option.popoverType = KSPopoverTypeLeft;
        option.arrowSize = CGSizeMake(26, 8);
        option.blackOverlayColor = [UIColor clearColor];
        option.popoverColor = [UIColor lightGrayColor];
        option.dismissOnBlackOverlayTap = YES;
        option.animationIn = 0.5;
        option.cornerRadius = 10;
        //...
        
        _rightBtnPopover = [[KSPopover alloc] initWithOption:option];
    }
    return _rightBtnPopover;
}

- (void)buttonClicked:(id)sender {
    if (sender == self.button) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 150, 40)];
        [self.buttonPopover show:view fromView:self.button];  // in delegate window
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 150, 40)];
        [self.rightButtonPopover show:view fromView:self.rightButton];  // in delegate window
    }
}

- (void)KSPageClick:(id)sender{
    TitleImageViewController *imageVC = [[TitleImageViewController alloc] init];
    [self.navigationController pushViewController:imageVC animated:YES];
}

@end
