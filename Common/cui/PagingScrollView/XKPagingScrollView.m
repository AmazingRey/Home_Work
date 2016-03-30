//
//  XKPagingScrollView.m
//  calorie
//
//  Created by Rick Liao on 12-12-11.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "XKViewRecyclePool.h"
#import "XKPagingScrollView.h"

const NSInteger kXKPagingScrollViewUnspecifiedPageIndex = -1;

static const NSInteger kDefaultPageMarginSize = 0;

@interface XKPagingScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL viewIsBuilt;

@property (nonatomic, readonly, retain) UIScrollView* scrollView;

@property (nonatomic, retain) NSMutableDictionary* scrollPages;
@property (nonatomic, retain) XKViewRecyclePool* reusablePages;

@property (nonatomic) CGSize pageSize;

@property (nonatomic, assign) BOOL usePageViewsDefaultCount;

@property (nonatomic, assign) BOOL ignoreScrollEvent;

@end


@implementation XKPagingScrollView

@synthesize pagingScrollViewStyle = _pagingScrollViewStyle;

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

@synthesize pageMarginSize = _pageMarginSize;

@synthesize pagesCount = _pagesCount;
@synthesize pageViewsCount = _pageViewsCount;
@synthesize usePageViewsDefaultCount = _usePageViewsDefaultCount;

@synthesize centerPageIndex = _centerPageIndex;

@synthesize viewIsBuilt = _viewIsBuilt;

@synthesize scrollView = _scrollView;

@synthesize scrollPages = _scrollPages;
@synthesize reusablePages = _reusablePages;

@synthesize pageSize = _pageSize;

@synthesize ignoreScrollEvent = _ignoreScrollEvent;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    _pagingScrollViewStyle = XKPagingScrollViewStyleRightToLeft;
    
    _dataSource = nil;
    _delegate = nil;
    
    _pageMarginSize = kDefaultPageMarginSize;
    
    _pagesCount = 0;
    _pageViewsCount = 0;
    _usePageViewsDefaultCount = YES;
    
    _centerPageIndex = kXKPagingScrollViewUnspecifiedPageIndex;
    
    _viewIsBuilt = NO;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.pagingEnabled = YES;
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _scrollPages = [NSMutableDictionary dictionaryWithCapacity:3];
    _reusablePages = [XKViewRecyclePool new];
    
    _pageSize = CGSizeZero;
    
    _ignoreScrollEvent = NO;
}


- (void)resetView {
    if (_viewIsBuilt) {
        NSInteger backupIndex = _centerPageIndex;
        
        [self doClearView];
        [self buildView];
        
        [self setCenterPageIndex:backupIndex];
    } // else NOP
}

- (void)buildView {
    _pageSize = [self sizeForPage];
    
    _scrollView.frame = [self frameForScrollView];
    
    _pagesCount = [self calculatePagesCount];
    
    if (_usePageViewsDefaultCount) {
        _pageViewsCount = [self calculatePageViewsDefaultCount];
    } // else NOP
    
    _scrollView.contentSize = [self contentSizeForScrollView];
    
    _viewIsBuilt = YES;
}

- (void)clearView {
    if (_viewIsBuilt) {
        [self doClearView];
    } // else NOP
}

-(void)doClearView {
    [self setCenterPageIndex:kXKPagingScrollViewUnspecifiedPageIndex];
    [self removePageViews:_scrollPages.allKeys];
    
    _pagesCount = 0;
    _pageSize = CGSizeZero;
    
    if (_usePageViewsDefaultCount) {
        _pageViewsCount = 0;
    } // else NOP
    
    [self clearReusablePages];
    
    _scrollView.contentSize = CGSizeZero;
    _scrollView.frame = self.bounds;
    
    _ignoreScrollEvent = NO;
    
    _viewIsBuilt = false;
}

- (void)clearReusablePages {
    [_reusablePages removeAllViews];
}

- (UIView<XKViewReusable> *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    UIView<XKViewReusable> *result = nil;
    
    if (identifier) {
        result = [_reusablePages dequeueReusableViewWithIdentifier:identifier];
    } // else NOP
    
    return result;
}

- (UIView<XKViewReusable> *)centerPage {
    return [self page:_centerPageIndex];
}

- (UIView<XKViewReusable> *)previousPage {
    return [self page:_centerPageIndex - 1];
}

- (UIView<XKViewReusable> *)nextPage {
    return [self page:_centerPageIndex + 1];
}

- (UIView<XKViewReusable> *)page:(NSInteger)index {
    return [_scrollPages objectForKey:[NSNumber numberWithInteger:index]];;
}

- (void)setCenterPageIndex:(NSInteger)centerPageIndex {
    [self pageTo:centerPageIndex animated:NO];
}

- (void)pageUp:(BOOL)animated {
    NSInteger newIndex = [self hasCenter] ? _centerPageIndex - 1 : 0;
    [self pageTo:newIndex animated:animated];
}

- (void)pageDown:(BOOL)animated {
    NSInteger newIndex = [self hasCenter] ? _centerPageIndex + 1 : 0;
    [self pageTo:newIndex animated:animated];
}

- (void)pageToHead:(BOOL)animated {
    [self pageTo:0 animated:animated];
}

- (void)pageToTail:(BOOL)animated {
    NSInteger newIndex = (_pagesCount > 0) ? (_pagesCount - 1) : 0;
    [self pageTo:newIndex animated:animated];
}

- (void)pageTo:(NSInteger)index animated:(BOOL)animated {
    if (!_viewIsBuilt) {
        [self buildView];
    } // else NOP
    
    index = [self legalPageIndex:index];
    
    if (index != _centerPageIndex) {
        NSInteger oldIndex = _centerPageIndex;
        
        if ([_delegate respondsToSelector:@selector(centerPageWillChangeFrom:to:with:)]) {
            [_delegate centerPageWillChangeFrom:oldIndex to:index with:self];
        } // else NOP
        
        [self updatePagesForNewCenterIndex:index];
        
        _ignoreScrollEvent = YES;
        [_scrollView setContentOffset:[self originForContent:index]];
        _ignoreScrollEvent = NO;
        
        if ([_delegate respondsToSelector:@selector(centerPageDidChangeFrom:to:with:)]) {
            [_delegate centerPageDidChangeFrom:oldIndex to:index with:self];
        } // else NOP
    } // else NOP
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updatePagesOnDragging];
}

- (void)updatePagesOnDragging {
    if (!_ignoreScrollEvent && _viewIsBuilt && [self hasCenter]) {
        NSInteger newIndex = _pagesCount - ceil(_scrollView.contentOffset.x / _scrollView.bounds.size.width - 0.5) - 1;
        // 当高速拖拽时，是有可能超出边界的，所以需要下面的界限限制
        newIndex = [self legalPageIndexForScrolling:newIndex];
        
        if (newIndex != _centerPageIndex) {
            NSInteger oldIndex = _centerPageIndex;
            
            if ([_delegate respondsToSelector:@selector(centerPageWillChangeFrom:to:with:)]) {
                [_delegate centerPageWillChangeFrom:oldIndex to:newIndex with:self];
            } // else NOP
            
            [self updatePagesForNewCenterIndex:newIndex];
            
            if ([_delegate respondsToSelector:@selector(centerPageDidChangeFrom:to:with:)]) {
                [_delegate centerPageDidChangeFrom:oldIndex to:newIndex with:self];
            } // else NOP
        } // else NOP
    } // else NOP
}

- (NSInteger)legalPageIndex:(NSInteger)index {
    index = MIN(index, _pagesCount - 1);
    
    if (index < 0) {
        index = kXKPagingScrollViewUnspecifiedPageIndex;
    } // else NOP
    
    return index;
}

- (NSInteger)legalPageIndexForScrolling:(NSInteger)index {
    return MAX(MIN(index, _pagesCount - 1), 0);
}

- (void)updatePagesForNewCenterIndex:(NSInteger)index {
    _centerPageIndex = index;
    
    NSMutableArray *addedIndexes = [NSMutableArray arrayWithCapacity:_pageViewsCount];
    NSMutableArray *removedIndexes = [NSMutableArray arrayWithCapacity:_pageViewsCount];
    
    NSMutableArray *oldIndexes = [NSMutableArray arrayWithArray:[_scrollPages.allKeys sortedArrayUsingSelector:@selector(compare:)]];
    NSInteger oldCount = oldIndexes.count;
    
    NSRange newIndexes = [self pageViewIndexRange:index];
    NSNumber *newIndex = nil;

    NSInteger addedCount = 0;
    
    for (NSInteger i = newIndexes.location; i < newIndexes.location + newIndexes.length; ++i) {
        newIndex = [NSNumber numberWithInteger:i];
        
        if ([oldIndexes containsObject:newIndex]) {
            [oldIndexes removeObject:newIndex];
        } else {
            [addedIndexes addObject:newIndex];
            ++addedCount;
        }
    }
    
    NSInteger removedCount = MAX(oldCount + addedCount - _pageViewsCount, 0);
    if (removedCount >= oldIndexes.count) {
        removedIndexes = oldIndexes;
    } else {
        NSNumber *oldIndexHead = nil;
        NSNumber *oldIndexTail = nil;
        
        NSInteger head = 0;
        NSInteger tail = oldIndexes.count - 1;
        
        for (NSInteger i = 0; i < removedCount; ++i) {
            oldIndexHead = oldIndexes[head];
            oldIndexTail = oldIndexes[tail];
            
            if (ABS(newIndex.integerValue - oldIndexHead.integerValue) >= ABS(newIndex.integerValue - oldIndexTail.integerValue)) {
                [removedIndexes addObject:oldIndexHead];
                ++head;
            } else {
                [removedIndexes addObject:oldIndexTail];
                ++tail;
            }
        }
    }
    
    [self removePageViews:removedIndexes];
    [self addPageViews:addedIndexes];
}

- (void)removePageViews:(NSArray *)indexes {
    for (NSNumber *index in indexes) {
        UIView<XKViewReusable> *page = _scrollPages[index];
        
        [page removeFromSuperview];
        [_scrollPages removeObjectForKey:index];
        [_reusablePages recycleView:page];
    }
}

- (void)addPageViews:(NSArray *)indexes {
    if ([_dataSource respondsToSelector:@selector(page:with:)]) {
        for (NSNumber *index in indexes) {
            UIView<XKViewReusable> *page = [_dataSource page:index.integerValue with:self];
            page.frame = [self frameForPage:index.integerValue];
        
            [_scrollView addSubview:page];
            _scrollPages[index] = page;
        }
    } // else NOP
}

- (void)setPagingScrollViewStyle:(XKPagingScrollViewStyle)pagingScrollViewStyle {
    _pagingScrollViewStyle = pagingScrollViewStyle;
    [self resetView];
}

- (void)setDataSource:(id<XKPagingScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self resetView];
}

- (void)setPageMarginSize:(CGFloat)pageMargin {
    // 目前不支持负间距
    _pageMarginSize = MAX(pageMargin, 0.f);
    [self resetView];
}

- (UIColor *)backgroundColor {
    return [super backgroundColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _scrollView.backgroundColor = backgroundColor;
}

// －－> 注意：从此开始的这几个方法在调用顺序上有先后依赖
- (CGSize)sizeForPage {
    CGSize size = CGSizeZero;
    
    if ([_dataSource respondsToSelector:@selector(pageSizeWith:)]) {
        size = [_dataSource pageSizeWith:self];
    } else {
        UIView<XKViewReusable> *page = [_dataSource page:kXKPagingScrollViewUnspecifiedPageIndex with:self];
        
        if (page) {
            size = page.bounds.size;
            [_reusablePages recycleView:page];
        } // else NOP
    }
    
    size.width = MAX(size.width, 0.f);
    size.height = MAX(size.height, 0.f);
    
    return size;
}

- (CGRect)frameForScrollView {
    CGRect rect = CGRectZero;
    
    rect.origin.x = (self.bounds.size.width - _pageSize.width - _pageMarginSize)/2;
    rect.origin.y = (self.bounds.size.height - _pageSize.height) / 2;
    rect.size.width = _pageSize.width + _pageMarginSize;
    rect.size.height = _pageSize.height;
    
    return rect;
}

- (NSInteger)calculatePagesCount {
    NSInteger count = 0;
    
    if ([_dataSource respondsToSelector:@selector(pagesCountWith:)]) {
        count = [_dataSource pagesCountWith:self];
    } else if (_scrollView.bounds.size.width > 0) {
        // 注意：下式最后除以131072的原因：由于CGFloat的精度有限，当页数过多时会造成所计算出的位置偏移量的显著误差，所以实际支持的最大页数远小于理论值
        count = MIN(CGFLOAT_MAX / ((CGFloat) _scrollView.bounds.size.width), ((CGFloat) NSIntegerMax)) / 131072;
    } // else NOP
    
    return count;
}

- (NSInteger)calculatePageViewsDefaultCount {
    NSInteger count = 0;
    
    CGFloat selfWidth = self.bounds.size.width;
    
    if (selfWidth > 0 && selfWidth < _pageMarginSize) {
        count = 1;
    } else if (selfWidth >= _pageMarginSize) {
        count = self.bounds.size.width / _scrollView.bounds.size.width + 2;
    } // else NOP
    
    return count;
}

- (CGSize)contentSizeForScrollView {
    CGSize size = _scrollView.bounds.size;
    size.width = size.width * _pagesCount;
    
    return size;
}

- (CGRect)frameForPage:(NSInteger)index {
    CGRect rect = CGRectZero;
    
    if (index >= 0) {
        rect.origin.x = (_pagesCount - index - 1) * _pageSize.width + (_pagesCount - index - 0.5) * _pageMarginSize;
        rect.size = _pageSize;
    } // else NOP
    
    return rect;
}

- (CGPoint)originForContent:(NSInteger)index {
    CGPoint point = CGPointZero;
    
    if (index >= 0) {
        point.x = (_pagesCount - index - 1) * (_scrollView.bounds.size.width);
    } // else NOP
        
    return point;
}
// <－－ 注意：到此为止的这几个方法在调用顺序上有先后依赖

- (void)setPageViewsCount:(NSInteger)pageViewsCount {
    _usePageViewsDefaultCount = NO;
    _pageViewsCount = MAX(pageViewsCount, 0);
}

- (BOOL)hasCenter {
    return _centerPageIndex >= 0;
}

- (BOOL)hasPrevious {
    return [self hasCenter] && _centerPageIndex >= 1;
}

- (BOOL)hasNext {
    return [self hasCenter] && _centerPageIndex < _pagesCount - 1;
}

- (BOOL)isValidPageIndex:(NSInteger)index {
    return (index >= 0 && index < _pagesCount);
}

- (NSRange)pageViewIndexRange:(NSInteger)centerIndex {
    NSRange ret;
    
    if (centerIndex >= 0) {
        NSInteger startIndex = centerIndex - _pageViewsCount / 2;
        NSInteger endIndex = centerIndex + _pageViewsCount / 2;
        
        if (_pageViewsCount % 2 == 0) {
            ++startIndex;
        } // else NOP
    
        startIndex = MAX(startIndex, 0);
        endIndex = MIN(endIndex, _pagesCount - 1);

        ret = NSMakeRange(startIndex, endIndex - startIndex + 1);
    } else {
        ret = NSMakeRange(0, 0);
    }
    
    return ret;
}

@end
