//
//  KSPopoverOption.h
//  PopoverObjC
//
//  Created by KSsuner on 2017/10/23.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KSPopoverType) {
    KSPopoverTypeUp = 0,
    KSPopoverTypeDown,
    KSPopoverTypeLeft, // add by zhuhao 20200114
    KSPopoverTypeRight, // add by zhuhao 20200114
    KSPopoverTypeAuto, // add by zhuhao 20200114 只能根据父视图选择上下显示
};

struct KSArrowRadian { // add by zhuhao 20200508 箭头弧度
    CGFloat topRadian;  // 顶部顶点弧度
    CGFloat bottomRadian; // 底部顶点弧度
};
typedef struct KSArrowRadian KSArrowRadian;

@interface KSPopoverOption : NSObject

@property (nonatomic, assign) CGSize arrowSize; // default is (10, 7)
@property (nonatomic, assign) CGFloat offset; // vertical offset from original show point, default is 0.
@property (nonatomic, strong) UIColor *popoverColor;  // contain view color. including arrow.

@property (nonatomic, assign) BOOL autoAjustDirection; //effect just in view not at point; default is YES.
@property (nonatomic, assign) KSPopoverType preferedType; // just effect when autoAjustDirection = YES; default is KSPopoverTypeUp;
@property (nonatomic, assign) KSPopoverType popoverType; // default is KSPopoverTypeUp; not effect when autoAjustDirection = YES;

@property (nonatomic, assign) NSTimeInterval animationIn; // if 0, no animation; default is 0.6.
@property (nonatomic, assign) NSTimeInterval animationOut; // if 0, no animation; default is 0.3.
@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat initialSpringVelocity;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat sideEdge;
@property (nonatomic, strong) UIColor *blackOverlayColor; // default is black/alpha 0.2, can be clear color.
@property (nonatomic, strong) UIBlurEffect *overlayBlur;

@property (nonatomic, assign) BOOL dismissOnBlackOverlayTap; // default is YES.
@property (nonatomic, assign) BOOL showBlackOverlay; // default is YES.

@property (nonatomic, assign) BOOL highlightFromView;
@property (nonatomic, assign) CGFloat highlightCornerRadius;

@property (nonatomic, assign) KSArrowRadian arrowRadian; // 箭头弧度

@end
