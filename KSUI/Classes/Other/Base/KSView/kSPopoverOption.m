//
//  KSPopoverOption.m
//  PopoverObjC
//
//  Created by KSsuner on 2017/10/23.
//

#import "kSPopoverOption.h"

@implementation KSPopoverOption

- (instancetype)init {
  if (self = [super init]) {
    _arrowSize = CGSizeMake(26, 8);
    _offset = 0.0;
    _animationIn = 0.6;
    _animationOut = 0.3;
    _cornerRadius = 2.0;
    _sideEdge = 5.0;
    _autoAjustDirection = YES;
    _popoverType = KSPopoverTypeUp;
    _preferedType = KSPopoverTypeUp;
    _blackOverlayColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    _popoverColor = [UIColor lightGrayColor];
    _dismissOnBlackOverlayTap = YES;
    _showBlackOverlay = YES;
    _springDamping = 0.7;
    _initialSpringVelocity = 3.0;
    _highlightFromView = NO;
    _highlightCornerRadius = 0.0;
    _arrowRadian.topRadian = 3;
    _arrowRadian.bottomRadian = 6;
  }
  return self;
}

@end
