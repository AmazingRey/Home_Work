//
//  XKRWShowEnergy_5_3View.m
//  XKRW
//
//  Created by ss on 16/4/8.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWShowEnergy_5_3View.h"

@implementation XKRWShowEnergy_5_3View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWPlan_5_3View");
        
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _firstCircleView = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(20, 15, 100, 100) Style:XKRWEnergyCircleStyleNotOpen];
        _firstCircleView.tag = 1;
        [self addSubview:_firstCircleView];
        
        UILabel *labSuccess = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 20)];
        labSuccess.text = @"达标";
        CGPoint p = CGPointMake(_firstCircleView.center.x, _firstCircleView.center.y+60);
        labSuccess.center = p;
        labSuccess.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labSuccess];
        
        _secondCircleView = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(150, 15, 100, 100) Style:XKRWEnergyCircleStyleNotOpen];
        _secondCircleView.tag = 2;
        [self addSubview:_secondCircleView];
        
        _thridCircleView = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(250, 15, 100, 100) Style:XKRWEnergyCircleStyleNotOpen];
        _thridCircleView.tag = 3;
        [self addSubview:_thridCircleView];
        
        UILabel *labFail = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 20)];
        labFail.text = @"不达标";
        CGPoint t = CGPointMake(_thridCircleView.center.x-50, _firstCircleView.center.y+60);
        labFail.center = t;
        labFail.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labFail];
    }
    return self;
}

@end
