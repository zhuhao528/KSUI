//
//  KSPageViewAnimator.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSPageViewAnimator : NSObject

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) void(^progressCallback)(CGFloat percent);
@property (nonatomic, copy) void(^completeCallback)(void);
@property (readonly, getter=isExecuting) BOOL executing;

- (void)start;
- (void)stop;
- (void)invalid;

@end

NS_ASSUME_NONNULL_END
