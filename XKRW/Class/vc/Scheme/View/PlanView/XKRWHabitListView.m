//
//  XKRWHabitListView.m
//  XKRW
//
//  Created by Shoushou on 16/4/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWHabitListView.h"

@implementation XKRWHabitListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)setEntity:(XKRWRecordEntity4_0 *)entity {
    
    _entity = entity;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    if (entity.habitArray.count == 0) {
        return;
        
    } else {
        CGFloat buttonWidth = XKAppWidth / 4.0;
        CGFloat xPoint = 0.0;
        CGFloat yPoint = 0.0;
        
        NSInteger tag = 1;
        NSInteger numberOfHabits = entity.habitArray.count;
        
        for (XKRWHabbitEntity *tempEntity in entity.habitArray) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(xPoint, yPoint, buttonWidth, 63);
            button.tag = tag++;
            xPoint += buttonWidth;
            if (xPoint == XKAppWidth) {
                yPoint += 63;
                xPoint = 0;
            }
            
            [button setImage:[UIImage imageNamed:([tempEntity getButtonImages][0])] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:([tempEntity getButtonImages][1])] forState:UIControlStateSelected];
            if (tempEntity.situation == 1) {
                button.selected = YES;
            }
            [button addTarget:self action:@selector(clickHabitButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        // reset self.size
        if (numberOfHabits % 4 == 0 && numberOfHabits != 0) {
            self.size = CGSizeMake(XKAppWidth, yPoint);
        } else {
            self.size = CGSizeMake(XKAppWidth, yPoint + 63);
        }
    }
}

- (void)clickHabitButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 1;
    XKRWHabbitEntity *entity = _entity.habitArray[index];
    if (sender.selected) {
        entity.situation = 1;
    } else {
        entity.situation = 0;
    }
    
}
@end
