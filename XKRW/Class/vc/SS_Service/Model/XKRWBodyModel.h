//
//  XKRWBodyModel.h
//  XKRW
//
//  Created by 忘、 on 15-2-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWSchemeStepsModel.h"
#import "XKRWStatusModel.h"
@interface XKRWBodyModel : NSObject

@property (nonatomic,strong) NSString *BMI; //BMI值
@property (nonatomic,strong) NSString *BMIStatus; //BMI状态
@property (nonatomic,assign) NSInteger BMR;  //基础代谢
@property (nonatomic,assign) CGFloat bestWeight;  //最佳体重
@property (nonatomic,strong) NSString *bodyFatPercentage; //体脂率
@property (nonatomic,strong) NSString *fatStandard;  //体脂状态
@property (nonatomic,strong) NSString *fatPctStatus;
@property (nonatomic,assign) NSInteger lowestCalCtrl;

@property (nonatomic,strong) NSString * total;

@property (nonatomic,strong) XKRWStatusModel *model;
@property (nonatomic,strong) NSString * BMIsd;
@property (nonatomic,strong) NSString * title;

@property (nonatomic,strong) NSString *calf;  //小腿围
@property (nonatomic,strong) NSString *chest;// 胸围
@property (nonatomic,strong) NSString *hipline;// 臀围
@property (nonatomic,strong) NSString *scale;//分数
@property (nonatomic,strong) NSString *thigh;// 大腿围
@property (nonatomic,strong) NSString *waist;//腰围
@property (nonatomic,assign) NSInteger fatSTFlag;
@property (nonatomic,strong) NSString *BMISdisc;
@property (nonatomic,strong) NSString *fatPctdisc1;
@property (nonatomic,strong) NSString *fatPctdisc2;

@property (nonatomic,assign) NSInteger BMISflag;
@property (nonatomic,assign) NSInteger fatPctFlag;

@property (nonatomic,strong) NSString *weight;  //体重
@property (nonatomic,strong) NSString *age;    //年龄
@property (nonatomic,strong) NSString *height;  //身高
@property (nonatomic,strong) NSString *gender;
@end
