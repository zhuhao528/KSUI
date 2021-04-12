//
//  KSSliderView.m
//  KSUI
//
//  Created by zhu hao on 2020/9/15.
//

#import "UKSSliderView.h"
#import "UIView+UKSFrame.h"

/** 滑块的大小 */
static const CGFloat kSliderBtnWH = 50.0;
/** 进度的高度 */
static const CGFloat kProgressH = 1.0;
/** 拖动slider动画的时间*/
static const CGFloat kAnimate = 0.3;

/** 标志位结构体 */
struct KSScope {
    CGFloat min;
    CGFloat max;
};
typedef struct KSScope KSScope;

@implementation UKSCustomSliderBlockView

// 重写此方法将按钮的点击范围扩大
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    // 扩大点击区域
    bounds = CGRectInset(bounds, -50, -50);
    // 若点击的点在新的bounds里面。就返回yes
    return CGRectContainsPoint(bounds, point);
}

@end

@implementation UKSSliderButton

// 重写此方法将按钮的点击范围扩大
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    // 扩大点击区域
    bounds = CGRectInset(bounds, -50, -50);
    // 若点击的点在新的bounds里面。就返回yes
    return CGRectContainsPoint(bounds, point);
}

@end

@interface UKSSliderView ()

/** 进度背景 */
@property (nonatomic, strong) UIImageView *bgProgressView;
/** 缓存进度 */
@property (nonatomic, strong) UIImageView *bufferProgressView;
/** 滑动进度 */
@property (nonatomic, strong) UIImageView *sliderProgressView;
/** 滑块 */
@property (nonatomic, strong) UKSSliderButton *sliderBtn;

@property (nonatomic, strong) UIView *loadingBarView;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/// 标志位
@property (nonatomic, strong) NSMutableArray *markImageView;
@property (nonatomic, assign) KSScope currentScope;

@end

@implementation UKSSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.allowTapped = YES;
        self.animate = YES;
        self.allowExceedBuffer = YES;
        [self addSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.allowTapped = YES;
    self.animate = YES;
    [self addSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (isnan(self.value) || isnan(self.bufferValue)) return;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_w = min_view_w;
    min_y = 0;
    min_h = self.sliderHeight;
    self.bgProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
        
    min_x = 0;
    min_y = 0;
    min_w = self.thumbSize.width;
    min_h = self.thumbSize.height;
    self.sliderBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.sliderBtn.ks_centerX = self.bgProgressView.ks_width * self.value;
    
    /// 自定义滑块
    if (self.customSliderBlockView != nil) {
        self.customSliderBlockView.frame = CGRectMake(min_x, min_y, _customSliderBlockViewWidth, _customSliderBlockViewHeight);
        self.customSliderBlockView.ks_left = (self.bgProgressView.ks_width-self.customSliderBlockView.ks_width) * self.value;
    }
    /// 自定义滑块

    min_x = 0;
    min_y = 0;
    if (self.sliderBtn.hidden) {
        min_w = self.bgProgressView.ks_width * self.value;
    } else {
        min_w = self.sliderBtn.ks_centerX;
    }
    /// 自定义滑块
    if (self.customSliderBlockView != nil && self.customSliderBlockView.hidden) {
        min_w = self.bgProgressView.ks_width * self.value;
    } else if (self.customSliderBlockView != nil && !self.customSliderBlockView.hidden) {
        min_w = self.customSliderBlockView.ks_left;
    }
    /// 自定义滑块

    min_h = self.sliderHeight;
    self.sliderProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.bgProgressView.ks_width * self.bufferValue;
    min_h = self.sliderHeight;
    self.bufferProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 0.1;
    min_h = self.sliderHeight;
    min_x = (min_view_w - min_w)/2;
    min_y = (min_view_h - min_h)/2;
    self.loadingBarView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgProgressView.ks_centerY     = min_view_h * 0.5;
    self.bufferProgressView.ks_centerY = min_view_h * 0.5;
    self.sliderProgressView.ks_centerY = min_view_h * 0.5;
    self.sliderBtn.ks_centerY          = min_view_h * 0.5;
    
    /// 自定义滑块
    if (self.customSliderBlockView != nil) {
        self.customSliderBlockView.ks_centerY = min_view_h * 0.5;
    }
    /// 自定义滑块

    
    /// 设置marks
    for (int i = 0; i < self.markImageView.count; i++) {
        UIImageView *markImageView = [self.markImageView objectAtIndex:i];
        markImageView.backgroundColor = self.markColor;
        NSString *string = [self.marksArray objectAtIndex:i];
        [markImageView setFrame:CGRectMake(self.bgProgressView.ks_width*[string floatValue], self.bgProgressView.frame.origin.y, self.markWidth, self.bgProgressView.frame.size.height)];
    }
}

/**
 添加子视图
 */
- (void)addSubViews {
    self.thumbSize = CGSizeMake(kSliderBtnWH, kSliderBtnWH);
    self.sliderHeight = kProgressH;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    [self addSubview:self.loadingBarView];
    
    // 添加点击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGesture];
    
    // 添加滑动手势
    UIPanGestureRecognizer *sliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
    [self addGestureRecognizer:sliderGesture];
}

/// 子视图穿透效果
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }

    return view;
}

#pragma mark - Setter

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    self.bgProgressView.backgroundColor = maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    self.sliderProgressView.backgroundColor = minimumTrackTintColor;
}

- (void)setBufferTrackTintColor:(UIColor *)bufferTrackTintColor {
    _bufferTrackTintColor = bufferTrackTintColor;
    self.bufferProgressView.backgroundColor = bufferTrackTintColor;
}

- (void)setLoadingTintColor:(UIColor *)loadingTintColor {
    _loadingTintColor = loadingTintColor;
    self.loadingBarView.backgroundColor = loadingTintColor;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    _maximumTrackImage = maximumTrackImage;
    self.bgProgressView.image = maximumTrackImage;
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage {
    _minimumTrackImage = minimumTrackImage;
    self.sliderProgressView.image = minimumTrackImage;
    self.minimumTrackTintColor = [UIColor clearColor];
}

- (void)setBufferTrackImage:(UIImage *)bufferTrackImage {
    _bufferTrackImage = bufferTrackImage;
    self.bufferProgressView.image = bufferTrackImage;
    self.bufferTrackTintColor = [UIColor clearColor];
}

/// 标志位
- (void)setMarksArray:(NSMutableArray *)marksArray{
    if (_marksArray == nil) {
        _marksArray = [[NSMutableArray alloc] initWithArray:marksArray];
    }else{
        [_marksArray removeAllObjects];
        [_marksArray addObjectsFromArray:marksArray];
    }
    if (_markImageView == nil) {
        _markImageView = [[NSMutableArray alloc] init];
    }else{
        [_markImageView removeAllObjects];
        for (int i = 0; i < self.markImageView.count; i++) {
            UIImageView *markImageView = [self.markImageView objectAtIndex:i];
            [markImageView removeFromSuperview];
        }
    }
    for (int i = 0; i < self.marksArray.count; i++) {
        UIImageView *markImageView = [UIImageView new];
        markImageView.contentMode = UIViewContentModeScaleAspectFill;
        markImageView.clipsToBounds = YES;
        [_markImageView addObject:markImageView];
        [self insertSubview:markImageView aboveSubview:self.sliderProgressView];
    }
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setBackgroundImage:image forState:state];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setImage:image forState:state];
}

- (void)setThumbGifImages:(NSArray *)imagesArray {
    if (imagesArray.count == 0) return;
    self.sliderBtn.imageView.animationImages = imagesArray;
    self.sliderBtn.imageView.animationDuration = 0.8;
}

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    if (loading) {
        if (self.sliderBtn.imageView.isAnimating) return;
        [self.sliderBtn.imageView startAnimating];
    } else {
        if (self.sliderBtn.imageView.isAnimating) {
            [self.sliderBtn.imageView stopAnimating];
        }
    }
}

- (void)setValue:(float)value {
    if (isnan(value)) return;
    value = MIN(1.0, value);
    _value = value;
    if (self.sliderBtn.hidden) {
        self.sliderProgressView.ks_width = self.bgProgressView.ks_width * value;
    } else {
        self.sliderBtn.ks_centerX = self.bgProgressView.ks_width * value;
        self.sliderProgressView.ks_width = self.sliderBtn.ks_centerX;
    }
    /// 自定义滑块
    if (self.customSliderBlockView != nil && self.customSliderBlockView.hidden) {
        self.sliderProgressView.ks_width = self.bgProgressView.ks_width * value;
    } else if (self.customSliderBlockView != nil && !self.customSliderBlockView.hidden){
        self.customSliderBlockView.ks_left = (self.bgProgressView.ks_width-self.customSliderBlockView.ks_width)* value;
        self.sliderProgressView.ks_width = self.customSliderBlockView.ks_centerX;
    }
    /// 自定义滑块

    /// 处理标志位回调
    NSNumber *valueNum = [NSNumber numberWithFloat:value];
    NSNumber *currentMinNum = [NSNumber numberWithFloat:_currentScope.min];
    NSNumber *currentMaxNum = [NSNumber numberWithFloat:_currentScope.max];
    if ([currentMinNum compare:valueNum] == NSOrderedDescending
        ||  [currentMaxNum compare:valueNum] == NSOrderedAscending) {
        _currentScope.min = 0;
        _currentScope.max = 0;
    }
    for (int i = 0; i < self.marksArray.count; i++) {
        NSString *string = [self.marksArray objectAtIndex:i];
        NSNumber *markMinNum = [NSNumber numberWithFloat:[string floatValue] - 0.005];
        NSNumber *markMaxNum = [NSNumber numberWithFloat:[string floatValue] + 0.005];
        if ([markMinNum compare:valueNum] == NSOrderedAscending
            && [markMaxNum compare:valueNum] == NSOrderedDescending
            && _currentScope.min != string.floatValue - 0.005
            && _currentScope.max != string.floatValue + 0.005) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(playToIndex:OfMark:)]){
                [self.delegate playToIndex:i OfMark:value];
            }
            _currentScope.min = string.floatValue - 0.005;
            _currentScope.max = string.floatValue + 0.005;
            break;
        }
    }
}


- (void)setBufferValue:(float)bufferValue {
    if (isnan(bufferValue)) return;
    bufferValue = MIN(1.0, bufferValue);
    _bufferValue = bufferValue;
    self.bufferProgressView.ks_width = self.bgProgressView.ks_width * bufferValue;
}

- (void)setAllowTapped:(BOOL)allowTapped {
    _allowTapped = allowTapped;
    if (!allowTapped) {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    if (isnan(sliderHeight)) return;
    _sliderHeight = sliderHeight;
    self.bgProgressView.ks_height     = sliderHeight;
    self.bufferProgressView.ks_height = sliderHeight;
    self.sliderProgressView.ks_height = sliderHeight;
}

- (void)setSliderRadius:(CGFloat)sliderRadius {
    if (isnan(sliderRadius)) return;
    _sliderRadius = sliderRadius;
    self.bgProgressView.layer.cornerRadius      = sliderRadius;
    self.bufferProgressView.layer.cornerRadius  = sliderRadius;
    self.sliderProgressView.layer.cornerRadius  = sliderRadius;
    self.bgProgressView.layer.masksToBounds     = YES;
    self.bufferProgressView.layer.masksToBounds = YES;
    self.sliderProgressView.layer.masksToBounds = YES;
}

- (void)setIsHideSliderBlock:(BOOL)isHideSliderBlock {
    _isHideSliderBlock = isHideSliderBlock;
    // 隐藏滑块，滑杆不可点击
    if (isHideSliderBlock) {
        self.sliderBtn.hidden = YES;
        /// 自定义滑块
        self.customSliderBlockView.hidden = YES;
        /// 自定义滑块
        self.bgProgressView.ks_left     = 0;
        self.bufferProgressView.ks_left = 0;
        self.sliderProgressView.ks_left = 0;
        self.allowTapped = NO;
    }
}

- (void)setCustomSliderBlockView:(UIView *)customSliderBlockView{
    _customSliderBlockView = customSliderBlockView;
    [self addSubview:self.customSliderBlockView];
    self.sliderBtn.hidden = YES;
}

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating {
    if (self.isLoading) return;
    self.isLoading = YES;
    self.bufferProgressView.hidden = YES;
    self.sliderProgressView.hidden = YES;
    self.sliderBtn.hidden = YES;
    /// 自定义滑块
    self.customSliderBlockView.hidden = YES;
    /// 自定义滑块
    self.loadingBarView.hidden = NO;
    
    [self.loadingBarView.layer removeAllAnimations];
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = 0.4;
    animationGroup.beginTime = CACurrentMediaTime() + 0.4;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale.x";
    scaleAnimation.fromValue = @(1000.0f);
    scaleAnimation.toValue = @(self.ks_width * 10);
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.fromValue = @(1.0f);
    alphaAnimation.toValue = @(0.0f);
    
    [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
    [self.loadingBarView.layer addAnimation:animationGroup forKey:@"loading"];
}

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating {
    self.isLoading = NO;
    self.bufferProgressView.hidden = NO;
    self.sliderProgressView.hidden = NO;
    self.sliderBtn.hidden = self.isHideSliderBlock;
    /// 自定义滑块
    self.customSliderBlockView.hidden = self.isHideSliderBlock;
    /// 自定义滑块
    self.loadingBarView.hidden = YES;
    [self.loadingBarView.layer removeAllAnimations];
}

#pragma mark - User Action

- (void)sliderGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (_customSliderBlockView != nil) {
                [self sliderBtnTouchBegin:self.customSliderBlockView];
            }else{
                [self sliderBtnTouchBegin:self.sliderBtn];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (_customSliderBlockView != nil) {
                [self sliderBtnDragMoving:self.customSliderBlockView point:[gesture locationInView:self.bgProgressView]];
            }else{
                [self sliderBtnDragMoving:self.sliderBtn point:[gesture locationInView:self.bgProgressView]];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (_customSliderBlockView != nil) {
                [self sliderBtnTouchEnded:self.customSliderBlockView];
            }else{
                [self sliderBtnTouchEnded:self.sliderBtn];
            }
        }
            break;
        default:
            break;
    }
}

- (void)sliderBtnTouchBegin:(UIView *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self.value];
    }
    if (self.animate) {
        [UIView animateWithDuration:kAnimate animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
}

- (void)sliderBtnTouchEnded:(UIView *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self.value];
    }
    if (self.animate) {
        [UIView animateWithDuration:kAnimate animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)sliderBtnDragMoving:(UIView *)btn point:(CGPoint)touchPoint {
    // 点击的位置
    CGPoint point = touchPoint;
    // 获取进度值 由于btn是从 0-(self.width - btn.width)
    CGFloat value = (point.x - btn.ks_width * 0.5) / self.bgProgressView.ks_width;
    if (self.customSliderBlockView != nil) {
        value = point.x / self.bgProgressView.ks_width;
    }
    // value的值需在0-1之间
    value = value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
    if (self.value == value) return;
    self.isForward = self.value < value;
    
    /// 自定义属性是否可滑动道缓存区以外
    if (!self.allowExceedBuffer && self.value > self.bufferValue) return;
    ///

    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.bgProgressView];
    // 获取进度
    CGFloat value = (point.x - self.sliderBtn.ks_width * 0.5) * 1.0 / self.bgProgressView.ks_width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}

#pragma mark - getter

- (UIView *)bgProgressView {
    if (!_bgProgressView) {
        _bgProgressView = [UIImageView new];
        _bgProgressView.backgroundColor = [UIColor grayColor];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}

- (UIView *)bufferProgressView {
    if (!_bufferProgressView) {
        _bufferProgressView = [UIImageView new];
        _bufferProgressView.backgroundColor = [UIColor whiteColor];
        _bufferProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bufferProgressView.clipsToBounds = YES;
    }
    return _bufferProgressView;
}

- (UIView *)sliderProgressView {
    if (!_sliderProgressView) {
        _sliderProgressView = [UIImageView new];
        _sliderProgressView.backgroundColor = [UIColor redColor];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}

- (UKSSliderButton *)sliderBtn {
    if (!_sliderBtn) {
        _sliderBtn = [UKSSliderButton buttonWithType:UIButtonTypeCustom];
        [_sliderBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _sliderBtn;
}

- (UIView *)loadingBarView {
    if (!_loadingBarView) {
        _loadingBarView = [[UIView alloc] init];
        _loadingBarView.backgroundColor = [UIColor whiteColor];
        _loadingBarView.hidden = YES;
    }
    return _loadingBarView;
}

@end



