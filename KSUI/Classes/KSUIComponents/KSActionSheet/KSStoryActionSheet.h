//
//  KSActionSheet.h
//  KSUIBusiness
//
//  Created by zhu hao on 2020/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSStoryActionSheetStyle : NSObject

/// 字体
@property (nonatomic,strong)UIFont *titleStringFont;
@property (nonatomic,strong)UIFont *optionFont;
@property (nonatomic,strong)UIFont *cancelTitleFont;
/// 颜色
@property (nonatomic,strong)UIColor *titleStringColor;
@property (nonatomic,strong)UIColor *optionColor;
@property (nonatomic,strong)UIColor *cancelTitleColor;

@end

@interface KSStoryActionContent : NSObject

@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,strong)NSArray *optionsArr;
@property (nonatomic,strong)NSString *cancelTitle;

@end

@interface KSStoryActionSheet : UIView

- (instancetype)initWithContent:(KSStoryActionContent *_Nullable)content
                          style:(KSStoryActionSheetStyle *_Nullable)style
                  selectedBlock:(void(^)(NSInteger))selectedBlock
                    cancelBlock:(void(^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
