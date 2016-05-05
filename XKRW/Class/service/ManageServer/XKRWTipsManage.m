//
//  XKRWTipsManage.m
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWTipsManage.h"
#import "XKRWUserService.h"
#import "XKRWPlanService.h"
#import "XKRWAlgolHelper.h"
#import "XKRWPlanTipsEntity.h"
#import "NSDate+XKRWCalendar.h"
static XKRWTipsManage *shareInstance;

@implementation XKRWTipsManage

+(instancetype)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWTipsManage alloc]init];
    });
    return shareInstance;
}


- (NSMutableArray *)TipsInfoWithUseSituationwithRecordDate:(NSDate *)date {
    
    NSMutableArray *tipsEntityArray = [NSMutableArray array];
    NSDate *todayDate = [NSDate today];
    if ([date compare:todayDate] != NSOrderedSame) {
        XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
        entity.showType = 0;
        entity.tipsText = [NSString stringWithFormat:@"当前查看的是%ld年%ld月%ld日的记录",(long)date.year,(long)date.month,(long)date.day ];
        [tipsEntityArray addObject:entity];
    }else{
    //新用户 未开启
        if ([[XKRWUserService sharedService ]getInsisted] == 1 && ![[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType] && ![[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType]&& ![[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType]){
            [tipsEntityArray removeAllObjects];
            NSArray *tipsTextArray = @[[NSString stringWithFormat:@"你已经开始了%@天减到%.1fkg的瘦身计划，快去“开启”今天的计划吧！",[XKRWAlgolHelper expectDayOfAchieveTarget],[[XKRWUserService sharedService]getUserDestiWeight] /1000.f ],@"左上角是你的瘦身日历，可以查看记录过的饮食和运动。",@"右上角是你的体重中心，点击可以更新体重、围度，可以查看体重曲线。PS.长按可以快捷记录体重哦！",@"打开瘦瘦的通知设置就可以收到你的每日计划。"];
            
            NSArray *tipsTypeArray = @[@0,@0,@0,@3];
            
            for (int i = 0; i < [tipsTypeArray count]; i++) {
               XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
                entity.showType = [[tipsTypeArray objectAtIndex:i] integerValue];
                entity.tipsText = [tipsTextArray objectAtIndex:i];
                [tipsEntityArray addObject:entity];
            }
        }
        
        //老用户新计划 未开启
        
        if ([[XKRWUserService sharedService ]getInsisted] != 1 &&[XKRWAlgolHelper newSchemeStartDayToAchieveTarget] ==1 && ![[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType] && ![[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType]&& ![[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType]){
           
            
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 0;
            entity.tipsText = [NSString stringWithFormat:@"你已经开始了%@天减到%.1fkg的瘦身计划，快去“开启”今天的计划吧！",[XKRWAlgolHelper expectDayOfAchieveTarget],[[XKRWUserService sharedService]getUserDestiWeight] /1000.f ];
            [tipsEntityArray addObject:entity];

        }
        
        if([XKRWAlgolHelper newSchemeStartDayToAchieveTarget] != 1 && [[XKRWUserService sharedService ]getInsisted] != 1) {
            
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 0;
            entity.tipsText = [NSString stringWithFormat:@"今天是瘦身计划第%ld天，距离计划结束剩%ld天，，距离目标体重还需减重%.1fkg",(long)[XKRWAlgolHelper newSchemeStartDayToAchieveTarget],(long)[XKRWAlgolHelper remainDayToAchieveTarget],([[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]*1000 - [[XKRWUserService sharedService]getUserDestiWeight])/1000.f ];
            [tipsEntityArray addObject:entity];
            
        }
        
       // 已开启
        if ( [[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType] || [[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType] || [[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType]) {
        
            if ([[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType]) {
                XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
                entity.showType = 0;
                entity.tipsText = [NSString stringWithFormat:@"今日建议摄入热量%@，记录饮食或执行推荐食谱可以帮助你合理的控制摄入热量",[XKRWAlgolHelper getDailyIntakeSize]];
                [tipsEntityArray addObject:entity];
            }
            
            if ([[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType]) {
                XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
                entity.showType = 0;
                entity.tipsText = [NSString stringWithFormat:@"今日建议运动消耗%.1fcal，记录运动或执行运动方案可以帮助你完成运动目标。",[XKRWAlgolHelper dailyConsumeSportEnergy]];
                [tipsEntityArray addObject:entity];
            }
            
            if ([[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType]) {
                XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
                entity.showType = 0;
                entity.tipsText = [NSString stringWithFormat:@"每一天都要提醒自己改掉导致发胖的不良习惯。"];
                [tipsEntityArray addObject:entity];
            }
            
        }

        if ([XKRWAlgolHelper newSchemeStartDayToAchieveTarget] % 7 == 0) {
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 2;
            entity.tipsText = [NSString stringWithFormat:@"瘦身计划已执行%ld周，快看看瘦瘦帮你做的专业分析吧",(long)([XKRWAlgolHelper newSchemeStartDayToAchieveTarget] / 7)];
            [tipsEntityArray addObject:entity];
          
        }
        
        if([XKRWAlgolHelper remainDayToAchieveTarget] == -1){
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 1;
            entity.tipsText =@"已到达计划预期的天数，计划已结束";
            [tipsEntityArray addObject:entity];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"needResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]]) {
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 1;
            entity.tipsText =[NSString stringWithFormat:@"太棒了！减重到%.1fkg的计划已完成，瘦身成功！",(float)([[XKRWUserService sharedService]getUserDestiWeight]/1000.f) ];
            [tipsEntityArray addObject:entity];
        }
    
    }
    return tipsEntityArray;
}

@end
