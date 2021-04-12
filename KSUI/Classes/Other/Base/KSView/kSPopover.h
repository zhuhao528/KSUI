//
//  KSPopover.h
//  PopoverObjC
//
//  Created by KSsuner on 2017/10/23.
//

#import <UIKit/UIKit.h>
#import "KSView.h"
#import "kSPopoverOption.h"

typedef void (^KSPopoverBlock)(void);

@interface KSPopover : KSView

@property (nonatomic, copy) KSPopoverBlock willShowHandler;
@property (nonatomic, copy) KSPopoverBlock willDismissHandler;
@property (nonatomic, copy) KSPopoverBlock didShowHandler;
@property (nonatomic, copy) KSPopoverBlock didDismissHandler;

@property (nonatomic, strong) KSPopoverOption *option;

- (instancetype)initWithOption:(KSPopoverOption *)option;

- (void)dismiss;

- (void)show:(UIView *)contentView fromView:(UIView *)fromView;
- (void)show:(UIView *)contentView fromView:(UIView *)fromView inView:(UIView *)inView;
- (void)show:(UIView *)contentView atPoint:(CGPoint)point;
- (void)show:(UIView *)contentView atPoint:(CGPoint)point inView:(UIView *)inView;

- (CGPoint)originArrowPointWithView:(UIView *)contentView fromView:(UIView *)fromView;
- (CGPoint)arrowPointWithView:(UIView *)contentView fromView:(UIView *)fromView inView:(UIView *)inView popoverType:(KSPopoverType)type;

@end
