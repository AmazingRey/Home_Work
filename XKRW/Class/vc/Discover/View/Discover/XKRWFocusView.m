//
//  XKRWFocusView.m
//  XKRW
//
//  Created by Shoushou on 16/3/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWFocusView.h"
#import "UIButton+WebCache.h"
@implementation XKRWFocusView
{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIPageControl *_pageCtl;
    NSInteger _page;

}

- (void)awakeFromNib {
    _pageCtl.currentPageIndicatorTintColor = XKMainSchemeColor;
    _page = 0;
}


- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    for (UIView *viewObj in _scrollView.subviews) {
        [viewObj removeFromSuperview];
    }
    [_timer invalidate];
    _timer = nil;
    
    if (dataSource.count == 0) {
        return;
        
    } else if (dataSource.count == 1) {
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(XKAppWidth, self.height);
         _scrollView.contentOffset = CGPointMake(0, 0);
        _pageCtl.hidden = YES;
        XKRWShareAdverEntity *entity = _dataSource.lastObject;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, XKAppWidth, self.height);
        button.tag = 1000;
        [button setBackgroundImageWithURL:[NSURL URLWithString:entity.imgSrc] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"sportsdetails_normal"]];
        [button addTarget:self action:@selector(adTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
    } else {
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake((dataSource.count + 2) * XKAppWidth, self.height);
        _scrollView.contentOffset = CGPointMake(XKAppWidth, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _pageCtl.enabled = NO;
        _pageCtl.hidden = NO;
        _pageCtl.numberOfPages = dataSource.count;
        _pageCtl.currentPage = _page;
        [self setContent];
        
    }
    
}

- (void)setContent {
    
    for (int i = 0; i < _dataSource.count + 2; i ++) {
        
        if (i == 0) {
            XKRWShareAdverEntity *lastEntity = _dataSource.lastObject;
            UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
            lastButton.frame = CGRectMake(0, 0, XKAppWidth, self.height);
            lastButton.tag = i + 1000;
            [lastButton setBackgroundImageWithURL:[NSURL URLWithString:lastEntity.imgSrc] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"sportsdetails_normal"]];
            [lastButton addTarget:self action:@selector(adTapAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:lastButton];
            
        }else if(i == _dataSource.count + 1){
            XKRWShareAdverEntity *firstEntity = _dataSource.firstObject;
            UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
            firstButton.frame = CGRectMake(XKAppWidth *(_dataSource.count + 1), 0, XKAppWidth, self.height);
            firstButton.tag = i + 1000;
            [firstButton setBackgroundImageWithURL:[NSURL URLWithString:firstEntity.imgSrc] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"sportsdetails_normal"]];
            [firstButton addTarget:self action:@selector(adTapAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:firstButton];
            
        }else{
            XKRWShareAdverEntity *entity = _dataSource[i-1];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(XKAppWidth * i, 0, XKAppWidth, self.height);
            button.tag = i + 1000;
            [button setBackgroundImageWithURL:[NSURL URLWithString:entity.imgSrc] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"sportsdetails_normal"]];
            [button addTarget:self action:@selector(adTapAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }
    }
    
    [self addTimer];
}

- (void)adTapAction:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    XKRWShareAdverEntity *entity;
    if (index == 0) {
        entity = _dataSource.lastObject;
        
    }else if(index == _dataSource.count + 1){
        entity = _dataSource.firstObject;
        
    }else{
        entity = _dataSource[index-1];
    }
    
    if (self.adImageClickBlock) {
        self.adImageClickBlock(entity);
    } else return;

}

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_dataSource.count == 1){
        return ;
    }
    if (scrollView.contentOffset.x == (_dataSource.count + 1)*XKAppWidth) {
        [UIView performWithoutAnimation:^{
            scrollView.contentOffset = CGPointMake(XKAppWidth, 0);
            _pageCtl.currentPage = 0;
        }];
    }else if (scrollView.contentOffset.x == 0){
        [UIView performWithoutAnimation:^{
            scrollView.contentOffset = CGPointMake(_dataSource.count * XKAppWidth, 0);
            _pageCtl.currentPage = _dataSource.count - 1;
        }];
    }else{
        _pageCtl.currentPage = scrollView.contentOffset.x / XKAppWidth -1 ;
    }
}


- (void)addTimer {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(pageCirculation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)pageCirculation {
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = _scrollView.contentOffset ;
        _scrollView.contentOffset = CGPointMake(point.x +  XKAppWidth, 0);
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
