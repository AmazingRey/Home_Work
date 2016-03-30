//
//  CircleView.m
//  XKNewUserQuestionireResult
//
//  Created by 忘、 on 14-7-17.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)drawCircleView:(CGFloat)percent andIntakeKcal:(CGFloat)intake  andDecreaseKcal:(CGFloat)decrease andDailyExerciseDecrease:(CGFloat)exerciseDecrease  andRecommandIntake:(CGFloat)RecommandIntake andNormalIntake:(CGFloat)normalIntake;
{
    //(0, 44, 177, 177)
    self.circleBar=[[KDGoalBar alloc]initWithFrame:CGRectMake((XKAppWidth-320)/2.0, 44, 177, 177)];
    [ self.circleBar setPercent:percent animated:YES  andRecommandIntake:(CGFloat)RecommandIntake andNormalIntake:(CGFloat)normalIntake];
    [self addSubview:self.circleBar];
    //(0+170, 44+12+25, 177/2+15, 177/2+15)
    self.exerciseImageView=[[UIImageView alloc]initWithFrame:CGRectMake((XKAppWidth-320)/2.0+170, 44+12+25, 177/2+15, 177/2+15)];
    [self addSubview:self.exerciseImageView];
    self.exerciseImageView.image=[UIImage imageNamed:@"slim_report_tagCircle"];
    
    self.dailyIntakeKcal=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dailyIntakeKcal setTitle:[NSString stringWithFormat:@"每日减少摄入%.0fkcal",decrease] forState:UIControlStateNormal];
    self.dailyIntakeKcal.titleLabel.font=[UIFont systemFontOfSize:11];
    //30, 54, 120, 25
    self.dailyIntakeKcal.frame=CGRectMake((XKAppWidth-320)/2.0+30, 54, 120, 25);
    self.dailyIntakeKcal.contentEdgeInsets=UIEdgeInsetsMake(-5,0,0, 0);
    [self.dailyIntakeKcal setBackgroundImage:[UIImage imageNamed:@"slim_condition_red"] forState:UIControlStateNormal];
    [self.dailyIntakeKcal setTintColor:[UIColor whiteColor]];
    self.dailyIntakeKcal.titleLabel.contentMode=UIViewContentModeRedraw;
    [self addSubview:self.dailyIntakeKcal];
    //(30, 54+140, 120, 25)
    self.dailyDecreaseKcal=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dailyDecreaseKcal setTitle:[NSString stringWithFormat:@"每日饮食摄入%.0fkcal",intake ] forState:UIControlStateNormal];
    self.dailyDecreaseKcal.contentEdgeInsets=UIEdgeInsetsMake(0,0,-5,0);
    self.dailyDecreaseKcal.titleLabel.font=[UIFont systemFontOfSize:11];
    self.dailyDecreaseKcal.frame=CGRectMake((XKAppWidth-320)/2.0+30, 54+140, 120, 25);
    [self.dailyDecreaseKcal setBackgroundImage:[UIImage imageNamed:@"slim_condition_green"] forState:UIControlStateNormal];
    [self.dailyDecreaseKcal setTintColor:[UIColor whiteColor]];
    self.dailyDecreaseKcal.titleLabel.contentMode=UIViewContentModeRedraw;
    [self addSubview:self.dailyDecreaseKcal];
    
    self.dailyExerciseDecreasKcal=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dailyExerciseDecreasKcal setTitle:[NSString stringWithFormat:@"每日运动消耗%.0fkcal",exerciseDecrease] forState:UIControlStateNormal];
    self.dailyExerciseDecreasKcal.contentEdgeInsets=UIEdgeInsetsMake(0,0,-5,0);
    self.dailyExerciseDecreasKcal.titleLabel.font=[UIFont systemFontOfSize:11];
    //(30+130+10, 54+140, 120, 25)
    self.dailyExerciseDecreasKcal.frame=CGRectMake((XKAppWidth-320)/2.0+30+130+10, 54+140, 120, 25);
    [self.dailyExerciseDecreasKcal setBackgroundImage:[UIImage imageNamed:@"slim_report_tagRed"] forState:UIControlStateNormal];
    [self.dailyExerciseDecreasKcal setTintColor:[UIColor whiteColor]];
    self.dailyExerciseDecreasKcal.titleLabel.contentMode=UIViewContentModeRedraw;
    [self addSubview:self.dailyExerciseDecreasKcal];
    
    
    
}


@end
