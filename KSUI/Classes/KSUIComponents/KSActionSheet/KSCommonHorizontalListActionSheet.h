//
//  KSCommonHorizontalListActionSheet.h
//  KSUI
//
//  Created by Xue on 2020/12/22.
//

#import <UIKit/UIKit.h>

///选择某个item回调
typedef void(^SelectedHandler)(NSInteger,UIImageView *_Nullable);
///取消回调
typedef void(^CancelHandler)(void);
///显示完成回调
typedef void(^ShowCompletedHandler)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KSCommonHorizontalListActionSheet : UIView

///选中某个item的回调
@property (nonatomic, copy) SelectedHandler selectedHandler;
///取消的回调
@property (nonatomic, copy) CancelHandler cancelHandler;
///显示完成回调
@property (nonatomic, copy) ShowCompletedHandler showCompletedHandler;

/// 初始化方法
/// @param imageArray 图片数组（传入图片名字）
/// @param textArray 图片下方文字数据
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                         textArray:(NSArray <NSString *>*)textArray;

/// 初始化方法
/// @param imageArray 图片数组（传入图片名字）
/// @param textArray 图片下方文字数据
/// @param selectedHandler 选择某个item的回调，回调索引值
/// @param cancelHandler 取消的回调
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                         textArray:(NSArray <NSString *>*)textArray
                   selectedHandler:(SelectedHandler)selectedHandler
                     cancelHandler:(CancelHandler)cancelHandler;

/// 更新某个下标的图片
/// @param imageName 图片名字
/// @param index 下标
- (void)updateImageWithName:(nonnull NSString *)imageName index:(NSInteger)index;

/// 更新某个下标的文字
/// @param text  文本
/// @param index 下标
- (void)updateText:(nonnull NSString *)text index:(NSInteger)index;

/// 获取某个下标的UIImageView对象 （必须是弹窗渲染完成的情况才可以获取到）
/// @param index 下标
/// @return UIImageView对象
- (UIImageView *)getImageViewWithIndex:(NSInteger)index;

/// 获取某个下标的UILabel对象 （必须是弹窗渲染完成的情况才可以获取到）
/// @param index 下标
/// @return UILabel对象
- (UILabel *)getTextLabelWithIndex:(NSInteger)index;

///关闭ActionSheet
- (void)dismiss;

@end

@interface KSCommonHorizontalListContentView : UIView

/// 初始化方法
/// @param imageArray 图片数组（传入图片名字）
/// @param textArray 图片下方文字数据
/// @param selectedHandler 选择某个item的回调，回调索引值
/// @param cancelHandler 取消的回调
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                         textArray:(NSArray <NSString *>*)textArray
                   selectedHandler:(SelectedHandler)selectedHandler
                     cancelHandler:(CancelHandler)cancelHandler;

/// 更新某个下标的图片
/// @param imageName 图片名字
/// @param index 下标
- (void)updateImageWithName:(nonnull NSString *)imageName index:(NSInteger)index;

/// 更新某个下标的文字
/// @param text  文本
/// @param index 下标
- (void)updateText:(nonnull NSString *)text index:(NSInteger)index;

/// 获取某个下标的UIImageView对象
/// @param index 下标
/// @return UIImageView对象
- (UIImageView *)getImageViewWithIndex:(NSInteger)index;

/// 获取某个下标的UILabel对象
/// @param index 下标
/// @return UILabel对象
- (UILabel *)getTextLabelWithIndex:(NSInteger)index;

@end

@interface KSCommonHorizontalListCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

/// 更新视图
/// @param imageName 图片名
/// @param text 文字
- (void)updateWithImageName:(NSString *)imageName text:(NSString *)text;

@end


NS_ASSUME_NONNULL_END
