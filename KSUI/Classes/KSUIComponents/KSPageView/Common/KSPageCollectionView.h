//
//  KSPageCollectionView.h
//  KSUI
//
//  Created by zhu hao on 2020/9/7.
//

#import <Foundation/Foundation.h>
#import "KSPageIndicatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class KSPageCollectionView;

@protocol KSPageCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)pageCollectionView:(KSPageCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)pageCollectionView:(KSPageCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface KSPageCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <UIView<KSPageIndicatorProtocol> *> *indicators;
@property (nonatomic, weak) id<KSPageCollectionViewGestureDelegate> gestureDelegate;

@end

NS_ASSUME_NONNULL_END
