//
//  KSPageTitleImageViewCellModel.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import "KSPageViewCellModel.h"
#import "KSPageTitleViewCellModel.h"


typedef NS_ENUM(NSUInteger, KSPageTitleImageType) {
    KSPageTitleImageType_TopImage = 0,
    KSPageTitleImageType_LeftImage,
    KSPageTitleImageType_BottomImage,
    KSPageTitleImageType_RightImage,
    KSPageTitleImageType_OnlyImage,
    KSPageTitleImageType_OnlyTitle,
};


NS_ASSUME_NONNULL_BEGIN

@interface KSPageTitleImageViewCellModel : KSPageTitleViewCellModel

@property (nonatomic, assign) KSPageTitleImageType imageType;

@property (nonatomic, copy) void(^loadImageCallback)(UIImageView *imageView, NSURL *imageURL);

@property (nonatomic, copy) NSString *imageName;    //加载bundle内的图片

@property (nonatomic, strong) NSURL *imageURL;      //图片URL

@property (nonatomic, copy) NSString *selectedImageName;

@property (nonatomic, strong) NSURL *selectedImageURL;

@property (nonatomic, assign) CGSize imageSize;     //默认CGSizeMake(20, 20)

@property (nonatomic, assign) CGFloat titleImageSpacing;    //titleLabel和ImageView的间距，默认5

@property (nonatomic, assign, getter=isImageZoomEnabled) BOOL imageZoomEnabled;

@property (nonatomic, assign) CGFloat imageZoomScale;

@end

NS_ASSUME_NONNULL_END
