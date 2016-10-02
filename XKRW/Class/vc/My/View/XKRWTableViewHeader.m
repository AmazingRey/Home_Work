//
//  XKRWTableViewHeader.m
//  XKRW
//
//  Created by 忘、 on 15/7/4.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#define XKRWContentOffset @"contentOffset"

#import "XKRWTableViewHeader.h"

@implementation XKRWTableViewHeader{
    __weak UIScrollView *_scrollView; //scrollView或者其子类
    __weak UIView *_expandView; //背景可以伸展的View
    
    CGFloat _expandHeight;
    CGFloat _expandWidth;
}

- (void)dealloc{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:XKRWContentOffset];
        _scrollView = nil;
    }
    _expandView = nil;
}

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView {
    XKRWTableViewHeader *expandHeader = [XKRWTableViewHeader new];
    [expandHeader expandWithScrollView:scrollView expandView:expandView];
    return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView {
    _expandHeight = CGRectGetHeight(expandView.frame);
    _expandWidth = CGRectGetWidth(expandView.frame);
    _scrollView = scrollView;
    _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight, 0, 0, 0);
    [_scrollView addSubview:expandView];
    [_scrollView addObserver:self forKeyPath:XKRWContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setContentOffset:CGPointMake(0, -_expandHeight)];

    _expandView = expandView;
    
    //使View可以伸展效果  重要属性
    _expandView.contentMode= UIViewContentModeScaleAspectFill;
    _expandView.clipsToBounds = YES;
    
    [self reSizeView];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![keyPath isEqualToString:XKRWContentOffset]) {
        return;
    }
    [self scrollViewDidScroll:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y > -_expandHeight - 64) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect currentFrame = _expandView.frame;
//
    CGFloat setX = -1 * (offsetY + 44 + 20) / _expandHeight * XKAppWidth;
    
    if (offsetY < _expandHeight * -1) {
        if (setX > XKAppWidth) {
            currentFrame.origin.x = -1 * (setX - XKAppWidth)/2;
            currentFrame.size.width = setX;
        }
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = -1*offsetY;
        _expandView.frame = currentFrame;
    }
}

- (void)reSizeView {
    //重置_expandView位置
    [_expandView setFrame:CGRectMake(0, -1*_expandHeight, CGRectGetWidth(_expandView.frame), _expandHeight)];
    
}

@end


