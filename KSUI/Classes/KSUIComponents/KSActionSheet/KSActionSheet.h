//
//  KSActionSheet.h
//  KSUIBusiness
//
//  Created by zhu hao on 2020/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSActionSheet : UIView

- (instancetype)initWithTitleView:(UIView*)titleView
                       optionsArr:(NSArray*)optionsArr
                      cancelTitle:(NSString*)cancelTitle
                    selectedBlock:(void(^)(NSInteger))selectedBlock
                      cancelBlock:(void(^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
