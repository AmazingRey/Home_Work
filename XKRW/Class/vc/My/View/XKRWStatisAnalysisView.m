//
//  XKRWStatisAnalysisView.m
//  XKRW
//
//  Created by ss on 16/5/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#define HeadViewHeight 123*XKAppWidth/375
#define StatisticAnalysisViewHeight 194
#import "XKRWStatisAnalysisView.h"
#import "Masonry.h"
#import "XKRWStatiscBussiness5_3.h"

@implementation XKRWStatisAnalysisView
- (instancetype)initWithFrame:(CGRect)frame withBussiness:(XKRWStatiscBussiness5_3 *)bussiness
{
    self = [super initWithFrame:frame];
    if (self) {
        _bussiness = bussiness;
        [self addMasonryLayOut];
    }
    return self;
}

-(void)refreshViews{
//    [self.headView refreshControls];
//    [self.eatDecreaseView refreshControls];
//    [self.sportDecreaseView refreshControls];
//    [self addMasonryLayOut];
//    [self.headView setNeedsDisplay];
//    [self.eatDecreaseView setNeedsDisplay];
//    [self.sportDecreaseView setNeedsDisplay];
}

-(XKRWStatiscHeadView *)headView{
    if (!_headView) {
        CGRect frame = CGRectMake(0, 0, XKAppWidth, HeadViewHeight);
        _headView = [[XKRWStatiscHeadView alloc] initWithFrame:frame type:2 withBussiness:_bussiness];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.currentIndex = 0;
        _headView.statiscEntity = _bussiness.statiscEntity;
        _headView.currentEntity = _bussiness.statiscEntity;
        [self addSubview:_headView];
    }
    return _headView;
}

-(XKRWStatisticDetailView *)eatDecreaseView{
    if (!_eatDecreaseView) {
        _eatDecreaseView = [[XKRWStatisticDetailView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, StatisticAnalysisViewHeight) type:analysizeEat statisType:2 withBussiness:_bussiness];
        _eatDecreaseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_eatDecreaseView];
    }
    return _eatDecreaseView;
}

-(XKRWStatisticDetailView *)sportDecreaseView{
    if (!_sportDecreaseView) {
        _sportDecreaseView = [[XKRWStatisticDetailView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, StatisticAnalysisViewHeight) type:analysizeSport statisType:2 withBussiness:_bussiness];
        _sportDecreaseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_sportDecreaseView];
    }
    return _sportDecreaseView;
}

-(void)addMasonryLayOut{
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(HeadViewHeight);
        make.right.equalTo(@0);
    }];
    [self.eatDecreaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(StatisticAnalysisViewHeight);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    [self.sportDecreaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(StatisticAnalysisViewHeight);
        make.top.mas_equalTo(_eatDecreaseView.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

@end
