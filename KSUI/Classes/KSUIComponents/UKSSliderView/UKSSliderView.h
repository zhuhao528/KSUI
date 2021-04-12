//
//  KSSliderView.h
//  KSUI
//
//  Created by zhu hao on 2020/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UKSSliderViewDelegate <NSObject>

@optional
// 滑块滑动开始
- (void)sliderTouchBegan:(float)value;
// 滑块滑动中
- (void)sliderValueChanged:(float)value;
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value;
// 滑杆点击
- (void)sliderTapped:(float)value;
// 播放到标志位
- (void)playToIndex:(NSInteger)index OfMark:(CGFloat)value;

@end

@interface UKSSliderButton : UIButton

@end

@interface UKSCustomSliderBlockView : UIView

@end

@interface UKSSliderView : UIView

@property (nonatomic, weak) id<UKSSliderViewDelegate> delegate;

/** 滑块 */
@property (nonatomic, strong, readonly) UKSSliderButton *sliderBtn;

/** 自定义滑块 */
@property (nonatomic, strong) UIView *customSliderBlockView;
/** 自定义滑块的高度 */
@property (nonatomic, assign) CGFloat customSliderBlockViewHeight;
/** 自定义滑块的宽度 */
@property (nonatomic, assign) CGFloat customSliderBlockViewWidth;

/** 默认滑杆的颜色 */
@property (nonatomic, strong) UIColor *maximumTrackTintColor;

/** 滑杆进度颜色 */
@property (nonatomic, strong) UIColor *minimumTrackTintColor;

/** 缓存进度颜色 */
@property (nonatomic, strong) UIColor *bufferTrackTintColor;

/** loading进度颜色 */
@property (nonatomic, strong) UIColor *loadingTintColor;

/** 默认滑杆的图片 */
@property (nonatomic, strong) UIImage *maximumTrackImage;

/** 滑杆进度的图片 */
@property (nonatomic, strong) UIImage *minimumTrackImage;

/** 缓存进度的图片 */
@property (nonatomic, strong) UIImage *bufferTrackImage;

/** 标志位 */
@property (nonatomic, strong) NSMutableArray *marksArray;
/** 标志位颜色 */
@property (nonatomic, strong) UIColor *markColor;
/** 标志位宽度*/
@property (nonatomic, assign) float markWidth;

/** 滑杆进度 */
@property (nonatomic, assign) float value;

/** 缓存进度 */
@property (nonatomic, assign) float bufferValue;

/** 是否允许拖拽时超出缓冲区范围，默认YES */
@property (nonatomic, assign) BOOL allowExceedBuffer;

/** 是否允许点击，默认是YES */
@property (nonatomic, assign) BOOL allowTapped;

/** 是否允许点击，默认是YES */
@property (nonatomic, assign) BOOL animate;

/** 控制滑块loading状态 */
@property (nonatomic, assign) BOOL loading;

/** 设置滑杆的高度 */
@property (nonatomic, assign) CGFloat sliderHeight;

/** 设置滑杆的圆角 */
@property (nonatomic, assign) CGFloat sliderRadius;

/** 是否隐藏滑块（默认为NO） */
@property (nonatomic, assign) BOOL isHideSliderBlock;

/// 是否正在拖动
@property (nonatomic, assign) BOOL isdragging;

/// 向前还是向后拖动
@property (nonatomic, assign) BOOL isForward;

@property (nonatomic, assign) CGSize thumbSize;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

// 设置滑块背景色
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

// 设置滑块图片
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

// 设置滑块图片动画数组
- (void)setThumbGifImages:(NSArray *)imagesArray;

@end

NS_ASSUME_NONNULL_END
