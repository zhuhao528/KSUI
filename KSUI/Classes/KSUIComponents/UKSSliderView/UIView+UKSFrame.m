//
//  KSSliderView.h
//  KSUI
//
//  Created by zhu hao on 2020/9/15.
//

#import "UIView+UKSFrame.h"

@implementation UIView (ksFrame)

- (CGFloat)ks_x {
    return self.frame.origin.x;
}

- (void)setKs_x:(CGFloat)ks_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ks_x;
    self.frame        = newFrame;
}

- (CGFloat)ks_y {
    return self.frame.origin.y;
}

- (void)setKs_y:(CGFloat)ks_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ks_y;
    self.frame        = newFrame;
}

- (CGFloat)ks_width {
    return CGRectGetWidth(self.bounds);
}

- (void)setKs_width:(CGFloat)ks_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = ks_width;
    self.frame          = newFrame;
}

- (CGFloat)ks_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setKs_height:(CGFloat)ks_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = ks_height;
    self.frame           = newFrame;
}

- (CGFloat)ks_top {
    return self.frame.origin.y;
}

- (void)setKs_top:(CGFloat)ks_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ks_top;
    self.frame        = newFrame;
}

- (CGFloat)ks_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setKs_bottom:(CGFloat)ks_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ks_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)ks_left {
    return self.frame.origin.x;
}

- (void)setKs_left:(CGFloat)ks_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ks_left;
    self.frame        = newFrame;
}

- (CGFloat)ks_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setKs_right:(CGFloat)ks_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ks_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)ks_centerX {
    return self.center.x;
}

- (void)setKs_centerX:(CGFloat)ks_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = ks_centerX;
    self.center       = newCenter;
}

- (CGFloat)ks_centerY {
    return self.center.y;
}

- (void)setKs_centerY:(CGFloat)ks_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = ks_centerY;
    self.center       = newCenter;
}

- (CGPoint)ks_origin {
    return self.frame.origin;
}

- (void)setKs_origin:(CGPoint)ks_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = ks_origin;
    self.frame      = newFrame;
}

- (CGSize)ks_size {
    return self.frame.size;
}

- (void)setKs_size:(CGSize)ks_size {
    CGRect newFrame = self.frame;
    newFrame.size   = ks_size;
    self.frame      = newFrame;
}

@end
