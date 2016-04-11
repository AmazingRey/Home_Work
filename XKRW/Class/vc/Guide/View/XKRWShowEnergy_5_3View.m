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
        _firstCircleView.backgroundColor = [UIColor greenColor];
        _secondCircleView.backgroundColor = [UIColor redColor];
        _thridCircleView.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

@end
