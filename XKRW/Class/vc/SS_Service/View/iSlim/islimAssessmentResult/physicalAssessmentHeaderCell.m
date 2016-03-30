//
//  physicalAssessmentHeaderCell.m
//  XKRW
//
//  Created by 忘、 on 15-2-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "physicalAssessmentHeaderCell.h"
#import "JYRadarChart.h"
@implementation physicalAssessmentHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

/**
 *  显示雷达图
 */
- (void)showRadar:(NSArray *)scoreArray
{
    JYRadarChart * radar = [[JYRadarChart alloc] initWithFrame:CGRectMake((XKAppWidth-130)/2, 50, 130, 130)];
  
 

    radar.dataSeries = @[scoreArray];
    radar.steps = 1;
    radar.showStepText = NO;
 
    radar.r = 41;
    radar.fillArea = YES;
    radar.colorOpacity = 0.7;
    radar.backgroundFillColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0];
//    radar.attributes = @[@"Attack", @"Defense", @"Speed", @"HP", @"MP", @"IQ"];
    radar.showLegend = YES;
    [radar setTitles:@[@"archer", @"footman"]];
    [radar setColors:@[RGB(189, 236, 225, 0.7), [UIColor purpleColor]]];
    [self addSubview:radar];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth-130)/2, 50, 130, 130)];
    
    imageView.image = [UIImage imageNamed:@"radar_"];
    
    [self addSubview:imageView];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
