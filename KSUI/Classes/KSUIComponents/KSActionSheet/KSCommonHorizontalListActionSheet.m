//
//  KSCommonHorizontalListActionSheet.m
//  KSUI
//
//  Created by Xue on 2020/12/22.
//

#import "KSCommonHorizontalListActionSheet.h"
#import "Masonry.h"

static NSString *const kKSCommonHorizontalListCellReuseIdentifier = @"kKSCommonHorizontalListCellReuseIdentifier";
static CGFloat const kCollectionHeight = 85.f;

@interface KSCommonHorizontalListActionSheet ()

///图片名字数组
@property (nonatomic, strong) NSArray *imageArray;
///图片下方文字数组
@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, strong)KSCommonHorizontalListContentView *contentView;

@end

@implementation KSCommonHorizontalListActionSheet

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

/// 初始化方法
/// @param imageArray 图片数组（传入图片名字）
/// @param textArray 图片下方文字数据
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                         textArray:(NSArray <NSString *>*)textArray {
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6f];
        _imageArray = imageArray;
        _textArray = textArray;
        [self configSubViews];
    }
    return self;
}

/// 初始化方法
/// @param imageArray 图片数组（传入图片名字）
/// @param textArray 图片下方文字数据
/// @param selectedHandler 选择某个item的回调，回调索引值
/// @param cancelHandler 取消的回调
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                         textArray:(NSArray <NSString *>*)textArray
                   selectedHandler:(SelectedHandler)selectedHandler
                     cancelHandler:(CancelHandler)cancelHandler {
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6f];
        _imageArray = imageArray;
        _textArray = textArray;
        _selectedHandler = selectedHandler;
        _cancelHandler = cancelHandler;
        [self configSubViews];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self dismiss];
    }
}

#pragma mark - Public

/// 更新某个下标的图片
/// @param imageName 图片名字
/// @param index 下标
- (void)updateImageWithName:(nonnull NSString *)imageName index:(NSInteger)index {
    [self.contentView updateImageWithName:imageName index:index];
}

/// 更新某个下标的文字
/// @param text  文本
/// @param index 下标
- (void)updateText:(nonnull NSString *)text index:(NSInteger)index {
    [self.contentView updateText:text index:index];
}

/// 获取某个下标的UIImageView对象
/// @param index 下标
/// @return UIImageView对象
- (UIImageView *)getImageViewWithIndex:(NSInteger)index {
    return [self.contentView getImageViewWithIndex:index];
}

/// 获取某个下标的UILabel对象
/// @param index 下标
/// @return UILabel对象
- (UILabel *)getTextLabelWithIndex:(NSInteger)index {
    return [self.contentView getTextLabelWithIndex:index];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25f animations:^{
        CGRect rect = self.contentView.frame;
        rect.origin.y += (self.contentView.bounds.size.height + 10);
        self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private

- (void)configSubViews {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.contentView];
    [self show];
}

- (void)show {    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect rect = self.contentView.frame;
        rect.origin.y -= (self.contentView.bounds.size.height + 10);
        self.contentView.frame = rect;

    } completion:^(BOOL finished) {
        if (finished) {
            !self.showCompletedHandler ?: self.showCompletedHandler();
        }
    }];
}

- (void)tapAcion:(UITapGestureRecognizer *)tap {
    [self dismiss];
}

#pragma mark - Getter

- (KSCommonHorizontalListContentView *)contentView {
    if (!_contentView) {
        __weak __typeof(self)weakSelf = self;
        _contentView = [[KSCommonHorizontalListContentView alloc] initWithImageArray:_imageArray textArray:_textArray selectedHandler:^(NSInteger index, UIImageView *imageView) {
            //[weakSelf dismiss];
            !weakSelf.selectedHandler ?: weakSelf.selectedHandler(index,imageView);
        } cancelHandler:^{
            [weakSelf dismiss];
            !weakSelf.cancelHandler ?: weakSelf.cancelHandler();
        }];
        _contentView.frame = CGRectMake(15, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width - 30, 197);
    }
    return _contentView;
}

@end

///底部内容视图
@interface KSCommonHorizontalListContentView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UICollectionView *collectionView;
///图片名字数组
@property (nonatomic, strong) NSMutableArray *imageArray;
///图片下方文字数组
@property (nonatomic, strong) NSMutableArray *textArray;
///选中某个item的回调
@property (nonatomic, copy) SelectedHandler selectedHandler;
///取消的回调
@property (nonatomic, copy) CancelHandler cancelHandler;

@end

@implementation KSCommonHorizontalListContentView

- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                         textArray:(NSArray <NSString *>*)textArray
                   selectedHandler:(SelectedHandler)selectedHandler
                     cancelHandler:(CancelHandler)cancelHandler {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageArray = imageArray.mutableCopy;
        _textArray = textArray.mutableCopy;
        _selectedHandler = selectedHandler;
        _cancelHandler = cancelHandler;
        [self configSubViews];
    }
    return self;
}

/// 更新某个下标的图片
/// @param imageName 图片名字
/// @param index 下标
- (void)updateImageWithName:(nonnull NSString *)imageName index:(NSInteger)index {
    if (!imageName || imageName.length <= 0) {
        return;
    }
    if (index >= self.imageArray.count || index < 0) {
        return;
    }
    [self.imageArray replaceObjectAtIndex:index withObject:imageName];
    UIImageView *imageView = [self getImageViewWithIndex:index];
    if (imageView) {
        imageView.image = [UIImage imageNamed:imageName];
    } else {
        [self.collectionView reloadData];
    }
}

/// 更新某个下标的文字
/// @param text  文本
/// @param index 下标
- (void)updateText:(nonnull NSString *)text index:(NSInteger)index {
    if (!text || text.length <= 0) {
        return;
    }
    if (index >= self.textArray.count || index < 0) {
        return;
    }
    [self.textArray replaceObjectAtIndex:index withObject:text];
    UILabel *textLabel = [self getTextLabelWithIndex:index];
    if (textLabel) {
        textLabel.text = text;
    } else {
        [self.collectionView reloadData];
    }
}

/// 获取某个下标的UIImageView对象
/// @param index 下标
/// @return UIImageView对象
- (UIImageView *)getImageViewWithIndex:(NSInteger)index {
    if (index >= self.imageArray.count) {
        return nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    KSCommonHorizontalListCell *cell = (KSCommonHorizontalListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView;
}

/// 获取某个下标的UILabel对象
/// @param index 下标
/// @return UILabel对象
- (UILabel *)getTextLabelWithIndex:(NSInteger)index {
    if (index >= self.textArray.count) {
        return nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    KSCommonHorizontalListCell *cell = (KSCommonHorizontalListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textLabel;
}

- (void)configSubViews {
    self.layer.cornerRadius = 20.f;
    self.layer.masksToBounds = YES;
    [self addSubview:self.cancelButton];
    [self addSubview:self.collectionView];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    
    if (self.imageArray.count >= 5) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(30);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(kCollectionHeight);
        }];
    } else if (self.imageArray.count > 0) {
        CGFloat width = 50*_imageArray.count + 35*(_imageArray.count-1);
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(kCollectionHeight);
            make.centerX.mas_equalTo(0);
        }];
    }
}

- (void)cancelButtonAction:(UIButton *)button {
    !self.cancelHandler ?: self.cancelHandler();
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSCommonHorizontalListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kKSCommonHorizontalListCellReuseIdentifier forIndexPath:indexPath];
    [cell updateWithImageName:[self.imageArray objectAtIndex:indexPath.item] text:[self.textArray objectAtIndex:indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KSCommonHorizontalListCell *cell = (KSCommonHorizontalListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    !self.selectedHandler ?: self.selectedHandler(indexPath.item,cell.imageView);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, kCollectionHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.imageArray.count >=5 ? 25 : 35;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.cornerRadius = 25.f;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
        [_cancelButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[KSCommonHorizontalListCell class] forCellWithReuseIdentifier:kKSCommonHorizontalListCellReuseIdentifier];
    }
    return _collectionView;
}

@end

///列表cell
@interface KSCommonHorizontalListCell ()

@end

@implementation KSCommonHorizontalListCell

- (instancetype)init {
    self = [super init];
    if (self) {
       [self configSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
       [self configSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(13);
        make.centerX.equalTo(self.imageView);
    }];
}

- (void)updateWithImageName:(NSString *)imageName text:(NSString *)text {
    if ([imageName isKindOfClass:[NSString class]] && imageName.length > 0) {
        self.imageView.image = [UIImage imageNamed:imageName];
        [self.imageView.image setAccessibilityIdentifier:imageName];
    }
    
    if ([text isKindOfClass:[NSString class]] && text.length > 0) {
        self.textLabel.text = text;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightRegular];
        _textLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
