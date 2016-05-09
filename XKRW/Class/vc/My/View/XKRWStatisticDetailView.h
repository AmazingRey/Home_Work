//
//  XKRWStatisticAnalysisView.h
//  XKRW
//
//  Created by ss on 16/5/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XKRWDailyAnalysizeCell.h"
#import "XKRWStatiscEntity5_3.h"
#import "XKRWStatiscBussiness5_3.h"

@interface XKRWStatisticDetailView : UIView
@property (strong, nonatomic) UILabel *labTitle;
@property (strong, nonatomic) UILabel *labCal;
@property (strong, nonatomic) UILabel *labTarget;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *labEatLeft1;
@property (strong, nonatomic) UILabel *labEatLeft2;
@property (strong, nonatomic) UILabel *labEatRight1;
@property (strong, nonatomic) UILabel *labEatRight2;
@property (strong, nonatomic) UILabel *labSportLeft;
@property (strong, nonatomic) UILabel *labSportRight;

@property (assign, nonatomic) AnalysizeType type;
@property (assign, nonatomic) StatisticType statisticType;

@property (strong, nonatomic) XKRWStatiscBussiness5_3 *bussiness;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) XKRWStatiscEntity5_3 *currentEntity;
//每日正常饮食摄入
@property (assign, nonatomic) CGFloat dailyNormal;
//饮食消耗
@property (assign, nonatomic) CGFloat dailyFoodDecrease;
//运动消耗
@property (assign, nonatomic) CGFloat dailySportDecrease;

- (instancetype)initWithFrame:(CGRect)frame type:(AnalysizeType)type statisType:(StatisticType)statisType withBussiness:(XKRWStatiscBussiness5_3 *)bussiness;

-(void)refreshControls;
@end