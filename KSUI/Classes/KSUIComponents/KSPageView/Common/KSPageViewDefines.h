//
//  KSPageViewViewDefines.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#ifndef KSPageViewDefines_h
#define KSPageViewDefines_h

static const CGFloat KSPageViewAutomaticDimension = -1;

typedef void(^KSPageViewCellSelectedAnimationBlock)(CGFloat percent);

typedef NS_ENUM(NSUInteger, KSPageViewComponentPosition) {
    KSPageViewComponentPosition_Bottom,
    KSPageViewComponentPosition_Top,
};

// cell被选中的类型
typedef NS_ENUM(NSUInteger, KSPageViewCellSelectedType) {
    KSPageViewCellSelectedTypeUnknown,          //未知，不是选中（cellForRow方法里面、两个cell过渡时）
    KSPageViewCellSelectedTypeClick,            //点击选中
    KSPageViewCellSelectedTypeCode,             //调用方法`- (void)selectItemAtIndex:(NSInteger)index`选中
    KSPageViewCellSelectedTypeScroll            //通过滚动到某个cell选中
};

typedef NS_ENUM(NSUInteger, KSPageViewTitleLabelAnchorPointStyle) {
    KSPageViewTitleLabelAnchorPointStyleCenter,
    KSPageViewTitleLabelAnchorPointStyleTop,
    KSPageViewTitleLabelAnchorPointStyleBottom,
};

typedef NS_ENUM(NSUInteger, KSPageViewIndicatorScrollStyle) {
    KSPageViewIndicatorScrollStyleSimple,                   //简单滚动，即从当前位置过渡到目标位置
    KSPageViewIndicatorScrollStyleSameAsUserScroll,         //和用户左右滚动列表时的效果一样
};

#endif /* KSPageViewViewDefines_h */
