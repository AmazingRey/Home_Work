//
//  XKRWIntelligentListHeader.m
//  XKRW
//
//  Created by Shoushou on 16/1/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWIntelligentListHeader.h"

@implementation XKRWIntelligentListHeader
{
    IBOutlet UILabel *timeLabel;
    
}

- (void)setStartTime:(NSObject *)startTime endTime:(NSObject *)endTime {
    timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",startTime,endTime];
}

- (void)awakeFromNib {
    NSDate *now = [NSDate date];
    
    NSDate *startDate = [now firstDayInWeek];
    NSDate *endDate = [now lastDayInWeek];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[dateFormatter stringFromDate:startDate],[dateFormatter stringFromDate:endDate]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
