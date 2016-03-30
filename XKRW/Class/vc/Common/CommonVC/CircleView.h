//
//  CircleView.h
//  XKNewUserQuestionireResult
//
//  Created by 忘、 on 14-7-17.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDGoalBar.h"
@interface CircleView : UIView
@property(nonatomic,strong) UIImageView* exerciseImageView;
@property(nonatomic,strong) KDGoalBar* circleBar;
@property(nonatomic,strong) UIButton* dailyIntakeKcal;
@property(nonatomic,strong) UIButton* dailyDecreaseKcal;
@property(nonatomic,strong) UIButton* dailyExerciseDecreasKcal;
-(void)drawCircleView:(CGFloat)percent andIntakeKcal:(CGFloat)intake  andDecreaseKcal:(CGFloat)decrease andDailyExerciseDecrease:(CGFloat)exerciseDecrease  andRecommandIntake:(CGFloat)RecommandIntake andNormalIntake:(CGFloat)normalIntake;
@end
