//
//  KSButton.m
//  Factory
//
//  Created by zhu hao on 2019/11/15.
//  Copyright © 2019 凯声文化. All rights reserved.
//

#import "KSButton.h"
#import "KSCore.h"

@interface KSButton ()

@end

const CGFloat KSButtonCornerSpacing = 0;

@implementation KSButton

- (instancetype)init {
    if (self = [super init]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.imagePosition = KSButtonImagePositionLeft;
    self.spacingBetweenImageAndTitle = KSButtonCornerSpacing;
}

#pragma mark -- 按钮上图文混排

- (void)setImagePosition:(KSButtonImagePosition)imagePosition{
    _imagePosition = imagePosition;
    [self setImagePosition:imagePosition spacing:self.spacingBetweenImageAndTitle];
}

- (void)setSpacingBetweenImageAndTitle:(CGFloat)spacingBetweenImageAndTitle{
    _spacingBetweenImageAndTitle = spacingBetweenImageAndTitle;
    [self setImagePosition:self.imagePosition spacing:spacingBetweenImageAndTitle];
}

- (void)setImagePosition:(KSButtonImagePosition)postion spacing:(CGFloat)spacing {
    self.titleEdgeInsets = self.imageEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat imgW = self.imageView.image.size.width;
    CGFloat imgH = self.imageView.image.size.height;
    
    CGSize showLabSize = self.titleLabel.bounds.size;
    CGFloat showLabW = showLabSize.width;
    CGFloat showLabH = showLabSize.height;
    
    CGSize trueSize = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat trueLabW = trueSize.width;
    
    CGFloat imageOffsetX = showLabW/2 ;
    CGFloat imageOffsetY = showLabH/2 + spacing/2;
    CGFloat labelOffsetX1 = imgW/2 - showLabW/2 + trueLabW/2;
    CGFloat labelOffsetX2 = fabs(imgW/2 + showLabW/2 - trueLabW/2);
    CGFloat labelOffsetY = imgH/2 + spacing/2;
    
    switch (postion) {
        case KSButtonImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case KSButtonImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, showLabW + spacing/2, 0, -(showLabW + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imgW + spacing/2), 0, imgW + spacing/2);
            break;
            
        case KSButtonImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX1, -labelOffsetY, labelOffsetX2);
            break;
            
        case KSButtonImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX1, labelOffsetY, labelOffsetX2);
            break;
            
        default:
            break;
    }
}

/**根据图文距边框的距离调整图文间距*/
- (void)setImagePosition:(KSButtonImagePosition)postion WithMargin:(CGFloat )margin{
    if (postion == KSButtonImagePositionLeft || postion == KSButtonImagePositionRight) {
        CGFloat imageWith = self.imageView.image.size.width;
        CGFloat labelWidth = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGFloat spacing = self.bounds.size.width - imageWith - labelWidth - 2*margin;
        [self setImagePosition:postion spacing:spacing];
    }else {
        CGFloat imageHeight = self.imageView.image.size.height;
        CGFloat labelHeight = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
        CGFloat spacing = self.bounds.size.height - imageHeight - labelHeight - 2*margin;
        [self setImagePosition:postion spacing:spacing];
    }
}

@end

@implementation KSButton (UIAppearance)

//在第一次创建这个类的对象的时候(也就是分配内存空间alloc的时候),会调用该类的+initialize 方法且只调用一次
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    KSButton *appearance = [KSButton appearance];
    appearance.imagePosition = KSButtonImagePositionLeft;
    appearance.spacingBetweenImageAndTitle = KSButtonCornerSpacing;
}

@end

