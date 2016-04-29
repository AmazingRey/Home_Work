//
//  XKRWStatisticAnalysizeVC.m
//  XKRW
//
//  Created by ss on 16/4/29.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWStatisticAnalysizeVC.h"
#import "Masonry.h"
#import "XKRWStatiscHeadView.h"

@interface XKRWStatisticAnalysizeVC ()
@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) XKRWStatiscHeadView *headView;
@end

@implementation XKRWStatisticAnalysizeVC
{
     NSInteger _currentIndex;
     NSInteger _pageTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"统计分析";
    [self addMasonryToLayout];
}

#pragma mark getter Method
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[XKRWUIScrollViewBase alloc]initWithFrame:CGRectMake(0, _segmentControl.bottom + 10, XKAppWidth , XKAppHeight - 50 - 64)];
        _scrollView.backgroundColor = [UIColor colorFromHexString:@"f5f7f9"];
        _scrollView.contentSize = CGSizeMake(XKAppWidth*2, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"周分析",@"计划统计"]];
        _segmentControl.frame = (CGRect){15, 13, XKAppWidth - 30, 30};
        _segmentControl.tintColor = XKMainSchemeColor;
        
        UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [_segmentControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(segmentControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_segmentControl];
    }
    return _segmentControl;
}

-(XKRWStatiscHeadView *)headView{
    if (!_headView) {
        _headView = [[XKRWStatiscHeadView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 123)];
        _headView.backgroundColor = [UIColor yellowColor];
        [self.scrollView addSubview:_headView];
    }
    return _headView;
}

#pragma mark masonry Subviews
-(void)addMasonryToLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.and.right.mas_equalTo(0);
    }];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(13);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(XKAppWidth - 30);
        make.height.mas_equalTo(30);
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.width.mas_equalTo(XKAppWidth);
        make.top.mas_equalTo(self.segmentControl.mas_bottom).offset(13);
    }];
}

#pragma mark segementControl Method

-(void)segmentControlIndexChanged:(UISegmentedControl *)segement{
    _currentIndex = segement.selectedSegmentIndex;
    _pageTime = 0;
    [self.scrollView scrollRectToVisible:CGRectMake(XKAppWidth*_currentIndex, 0, XKAppWidth, _scrollView.height) animated:NO];
    
    if (_currentIndex == 0) {
        
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end