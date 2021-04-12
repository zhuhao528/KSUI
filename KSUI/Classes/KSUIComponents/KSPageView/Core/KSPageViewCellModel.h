//
//  KSPageViewCellModel.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import "KSPageViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPageViewCellModel : NSObject

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellSpacing;

@property (nonatomic, assign, getter=isCellWidthZoomEnabled) BOOL cellWidthZoomEnabled;

@property (nonatomic, assign) CGFloat cellWidthNormalZoomScale;

@property (nonatomic, assign) CGFloat cellWidthCurrentZoomScale;

@property (nonatomic, assign) CGFloat cellWidthSelectedZoomScale;

@property (nonatomic, assign, getter=isSelectedAnimationEnabled) BOOL selectedAnimationEnabled;

@property (nonatomic, assign) NSTimeInterval selectedAnimationDuration;

@property (nonatomic, assign) KSPageViewCellSelectedType selectedType;

@property (nonatomic, assign, getter=isTransitionAnimating) BOOL transitionAnimating;

@property (nonatomic, assign) CGFloat cellRadius;


@end

NS_ASSUME_NONNULL_END
