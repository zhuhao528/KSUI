//
//  KSActionSheet.m
//  KSUIBusiness
//
//  Created by zhu hao on 2020/9/11.
//

#import "KSStoryActionSheet.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 15
@implementation KSStoryActionSheetStyle

- (id)init{
    if (self = [super init]) {
        self.titleStringFont = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        self.titleStringColor =  [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        self.optionFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        self.optionColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
        self.cancelTitleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        self.cancelTitleColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
    }
    return self;
}

@end

@implementation KSStoryActionContent

@end

@interface KSStoryActionSheet ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *optionsArr;
@property (nonatomic,   copy) NSString *cancelTitle;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic,   copy) void(^selectedBlock)(NSInteger);
@property (nonatomic,   copy) void(^cancelBlock)(void);
/// 样式
@property (nonatomic, strong)KSStoryActionSheetStyle *style;
@end

@implementation KSStoryActionSheet

- (instancetype)initWithContent:(KSStoryActionContent *_Nullable)content
                          style:(KSStoryActionSheetStyle *_Nullable)style
                  selectedBlock:(void(^)(NSInteger))selectedBlock
                    cancelBlock:(void(^)(void))cancelBlock{
    if (self = [super init]) {
        self.style = [[KSStoryActionSheetStyle alloc] init];
        if (style != nil) {
            if (style.titleStringFont != nil) {
                self.style.titleStringFont = style.titleStringFont;
            }
            if (style.titleStringColor != nil) {
                self.style.titleStringColor = style.titleStringColor;
            }
            if (style.optionFont != nil) {
                self.style.optionFont = style.optionFont;
            }
            if (style.optionColor != nil) {
                self.style.optionColor = style.optionColor;
            }
            if (style.cancelTitleFont != nil) {
                self.style.cancelTitleFont = style.cancelTitleFont;
            }
            if (style.cancelTitleColor != nil) {
                self.style.cancelTitleColor = style.cancelTitleColor;
            }
        }
        if (content.titleString != nil && ![content.titleString isEqualToString:@""]) {
            UILabel *label = [[UILabel alloc] init];
            label.text = content.titleString;
            label.frame = CGRectMake(0, 0, [UIScreen  mainScreen].bounds.size.width-30, 50);
            label.textColor = self.style.titleStringColor;
            label.font = self.style.titleStringFont;
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            _headView = label;
        }else{
            _headView = nil;
        }
        _optionsArr = content.optionsArr;
        _cancelTitle = content.cancelTitle;
        _selectedBlock = selectedBlock;
        _cancelBlock = cancelBlock;
        [self craetUI];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)craetUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
}

- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 20;
        _tableView.clipsToBounds = YES;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.headView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Navi_Cell"];
    }
    return _tableView;
}
#pragma mark TableViewDel
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0)?_optionsArr.count:1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Navi_Cell"];
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    cell.textLabel.textColor = self.style.optionColor;
    if (indexPath.section == 0) {
        cell.textLabel.text = _optionsArr[indexPath.row];
        /// 分割线
        if (indexPath.row != _optionsArr.count -1) {
            UIView *line = [[UIView alloc] init];
            line.frame = CGRectMake(0, cell.contentView.frame.size.height-1, _tableView.frame.size.width, 0.5);
            line.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
            [cell.contentView addSubview:line];
        }
    } else {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                                  CGRectMake(0, 0, Screen_Width - (SPACE * 2), 70) byRoundingCorners:
                                  UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:
                                  CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
        /// 显示取消标签
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 10, _tableView.frame.size.width-30, 50);
        label.textColor = self.style.cancelTitleColor;
        label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        label.layer.cornerRadius = label.frame.size.height/2;
        label.layer.masksToBounds = YES;
        label.text = _cancelTitle;
        label.font = self.style.cancelTitleFont;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = self.style.optionFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectedBlock) {
            self.selectedBlock(indexPath.row);
        }
    } else {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 55;
    }else{
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, SPACE)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
    _tableView.frame = CGRectMake(SPACE, Screen_height, Screen_Width - (SPACE * 2), 55 * _optionsArr.count + 70 * 1 + _headView.bounds.size.height + (SPACE * 2));
    
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = self->_tableView.frame;
        rect.origin.y -= self->_tableView.bounds.size.height;
        self->_tableView.frame = rect;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = self->_tableView.frame;
        rect.origin.y += self->_tableView.bounds.size.height;
        self->_tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
