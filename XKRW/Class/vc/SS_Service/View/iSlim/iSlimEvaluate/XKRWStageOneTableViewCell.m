//
//  XKRWStageOneTableViewCell.m
//  XKRW
//
//  Created by y on 15-1-21.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWStageOneTableViewCell.h"
#import "XKRWCircleView.h"

@implementation XKRWStageOneTableViewCell
@synthesize circleView;



- (void)awakeFromNib {
    // Initialization code
    

    circleView =  [[XKRWCircleView alloc ]initWithFrame:CGRectMake(0, 0, 95, 95)];
    circleView.circleColor = RGB(242, 82, 90, 1);
    [self.sportImageView addSubview:circleView];
    
    [circleView setNeedsDisplay];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCirclePro:(CGFloat)rain
{
    circleView.radian = rain;
    [circleView setNeedsDisplay];
}



@end
