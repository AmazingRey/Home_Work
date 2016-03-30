//
//  XKPagingScrollView.h
//  calorie
//
//  Created by Rick Liao on 12-12-11.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - declaration of types
@protocol XKViewReusable;
@class XKPagingScrollView;

extern const NSInteger kXKPagingScrollViewUnspecifiedPageIndex;

// 目前仅支持从右到左类型，其余类型留待后续开发。
typedef enum {
//    XKPagingScrollViewStyleLeftToRight = 0,
    XKPagingScrollViewStyleRightToLeft,
//    XKPagingScrollViewStyleTopToBottom,
//    XKPagingScrollViewStyleBottomToTop,
} XKPagingScrollViewStyle;

#pragma mark - declaration of XKPagingScrollViewDataSource
@protocol XKPagingScrollViewDataSource <NSObject>

@required
// 当下面的pageSizeWith:方法未被实现时，XKPagingScrollView会专门调用一次本方法以通过返回的page的View获得其size，这种调用发生时传入的index参数为kXKPSVUnspecifiedPageIndex。
- (UIView<XKViewReusable> *)page:(NSInteger)index
                            with:(XKPagingScrollView *)pagingScrollView;

@optional
// 如果不实现该方法，XKPagingScrollView会根据page的size计算出所能支持的尽可能大的page数。
- (NSInteger)pagesCountWith:(XKPagingScrollView *)pagingScrollView;

// 如果不实现该方法，XKPagingScrollView会专门调用一次上面的page:with:方法，然后从返回的page的View中得到其size。（之后page的View会被放入回收池）
- (CGSize)pageSizeWith:(XKPagingScrollView *)pagingScrollView;

@end


#pragma mark - declaration of XKPagingScrollViewDelegate
@protocol XKPagingScrollViewDelegate <NSObject>

@optional
- (void)centerPageWillChangeFrom:(NSInteger)oldIndex
                              to:(NSInteger)newIndex
                            with:(XKPagingScrollView *)pagingScrollView;

- (void)centerPageDidChangeFrom:(NSInteger)oldIndex
                             to:(NSInteger)newIndex
                           with:(XKPagingScrollView *)pagingScrollView;

@end


#pragma mark - declaration of XKPagingScrollView
// 该View初始化后必须设置center页才开始显示页面，设置方式包括对centerPage属性赋值或调用pageTo...系列方法之一。
@interface XKPagingScrollView : UIView

@property (nonatomic, assign) XKPagingScrollViewStyle pagingScrollViewStyle UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) id<XKPagingScrollViewDataSource> dataSource;
@property (nonatomic, assign) id<XKPagingScrollViewDelegate> delegate;

@property (nonatomic, assign) CGFloat pageMarginSize UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign, readonly) NSInteger pagesCount;
// 最多使用的page view的个数，缺省为3，最小为3，最大不能超过pagesCount
@property (nonatomic, assign) NSInteger pageViewsCount UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSInteger centerPageIndex;

@property(nonatomic,copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

- (UIView<XKViewReusable> *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

- (UIView<XKViewReusable> *)centerPage;
- (UIView<XKViewReusable> *)previousPage;
- (UIView<XKViewReusable> *)nextPage;
- (UIView<XKViewReusable> *)page:(NSInteger)index;

- (void)pageTo:(NSInteger)index animated:(BOOL)animated;
- (void)pageUp:(BOOL)animated;
- (void)pageDown:(BOOL)animated;
- (void)pageToHead:(BOOL)animated;
- (void)pageToTail:(BOOL)animated;

- (BOOL)hasCenter;
- (BOOL)hasPrevious;
- (BOOL)hasNext;

- (BOOL)isValidPageIndex:(NSInteger)index;

// 调用该方法清除画面后需要重新设置center页才能正常显示页面
- (void)clearView;

@end
