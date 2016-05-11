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
#import "XKRWCommHelper.h"

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
            
            //设置用户进入主页的第一天日期
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate today]  forKey:[NSString stringWithFormat:@"User5_3_%ld",[[XKRWUserService sharedService] getUserId]]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [tipsEntityArray removeAllObjects];
            NSArray *tipsTextArray = @[[NSString stringWithFormat:@"你已经开始了%@天减到%.1fkg的瘦身计划，快去“开启”今天的计划吧！",[XKRWAlgolHelper expectDayOfAchieveTarget],[[XKRWUserService sharedService]getUserDestiWeight] /1000.f ],@"右上角是你的体重中心，点击可以更新体重、围度，可以查看体重曲线。PS.长按可以快捷记录体重哦！",@"遇到使用问题或者需要帮助，可长按左下角的“计划”按钮哦！"];
            
            NSArray *tipsTypeArray = @[@0,@0,@0];
            
            for (int i = 0; i < [tipsTypeArray count]; i++) {
               XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
                entity.showType = [[tipsTypeArray objectAtIndex:i] integerValue];
                entity.tipsText = [tipsTextArray objectAtIndex:i];
                [tipsEntityArray addObject:entity];
            }
        }
        
        //老用户升级后第一次进入主页
        if ([XKRWCommHelper isFirstOpenThisAppWithUserId:[[XKRWUserService sharedService] getUserId]] && [[XKRWUserService sharedService ]getInsisted] != 1) {
            
            //设置用户进入主页的第一天日期
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate today]  forKey:[NSString stringWithFormat:@"User5_3_%ld",[[XKRWUserService sharedService] getUserId]]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
             NSArray *tipsTextArray = @[@"右上角是你的体重中心，点击可以更新体重、围度，可以查看体重曲线。PS.长按可以快捷记录体重哦！",@"遇到使用问题或者需要帮助，可长按左下角的“计划”按钮哦！"];
            NSArray *tipsTypeArray = @[@0,@0];
            
            for (int i = 0; i < [tipsTypeArray count]; i++) {
                XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
                entity.showType = [[tipsTypeArray objectAtIndex:i] integerValue];
                entity.tipsText = [tipsTextArray objectAtIndex:i];
                [tipsEntityArray addObject:entity];
            }
        }
        
        // 用户点击“开启”以后（只在第一天进入v5.3时有效)
        if ( [[XKRWPlanService shareService] getEnergyCircleClickEvent:eFoodType] || [[XKRWPlanService shareService] getEnergyCircleClickEvent:eSportType] || ([[XKRWPlanService shareService] getEnergyCircleClickEvent:eHabitType] && ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"User5_3_%ld",[[XKRWUserService sharedService] getUserId]]] compare:[NSDate date]] == NSOrderedSame))) {
            
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

        
        
        //老用户新计划 未开启  用户重新开始新计划时显示：
        if ([[XKRWUserService sharedService ]getInsisted] != 1 &&[XKRWAlgolHelper newSchemeStartDayToAchieveTarget] ==1 ){
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 0;
            entity.tipsText = [NSString stringWithFormat:@"你已经开始了%@天减到%.1fkg的瘦身计划。",[XKRWAlgolHelper expectDayOfAchieveTarget],[[XKRWUserService sharedService]getUserDestiWeight] /1000.f ];
            [tipsEntityArray addObject:entity];

        }
        //方案天数到达：
        if([XKRWAlgolHelper remainDayToAchieveTarget] == -1){
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 1;
            entity.tipsText =@"已到达计划预期的天数，计划已结束";
            [tipsEntityArray addObject:entity];
        }
        
        //方案进行第X个七天：
        if ([XKRWAlgolHelper newSchemeStartDayToAchieveTarget] % 7 == 0) {
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 2;
            entity.tipsText = [NSString stringWithFormat:@"瘦身计划已进行%ld周，来看看瘦瘦的分析吧！",(long)([XKRWAlgolHelper newSchemeStartDayToAchieveTarget] / 7)];
            [tipsEntityArray addObject:entity];
        }

       //每天（非计划第1天和最后一天时显示）
        if([XKRWAlgolHelper newSchemeStartDayToAchieveTarget] != 1 && [[XKRWUserService sharedService ]getInsisted] != 1 && ![ XKRWAlgolHelper isSchemeLastDay ]) {
            
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 0;
            entity.tipsText = [NSString stringWithFormat:@"今天是瘦身计划第%ld天，距离计划结束剩%ld天，，距离目标体重还需减重%.1fkg",(long)[XKRWAlgolHelper newSchemeStartDayToAchieveTarget],(long)[XKRWAlgolHelper remainDayToAchieveTarget],([[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]]*1000 - [[XKRWUserService sharedService]getUserDestiWeight])/1000.f ];
            [tipsEntityArray addObject:entity];
            
            
            //随机Tips 数据处理
            NSArray *tipsTextArray = @[@"按照推荐食谱吃可以直接达成饮食目标哦！",@"瘦身计划执行到一周时，瘦瘦会为你进行一周分析哦！",@"你的瘦身计划会根据体重变化调整，快去记录你的最新体重吧！",@"左上角是你的瘦身日历，可以查看记录过的饮食和运动。"];
            NSArray *tipsTypeArray = @[@5,@0,@0,@0,@0];
            NSInteger i =  arc4random() % 5 ;
            XKRWPlanTipsEntity *randomEntity = [[XKRWPlanTipsEntity alloc] init];
            randomEntity.showType = [[tipsTypeArray objectAtIndex:i] integerValue];
            randomEntity.tipsText = [tipsTextArray objectAtIndex:i];
            [tipsEntityArray addObject:randomEntity];
        }

        
  
        
        if (([[NSDate today]timeIntervalSince1970] - [[NSDate dateFromString:[[XKRWUserService sharedService]getREGDate]] timeIntervalSince1970]) < 5*24*60*60) {
            XKRWPlanTipsEntity *entity =  [[ XKRWPlanTipsEntity alloc] init];
            entity.showType = 0;
            entity.tipsText =@"刚开始的五天为适应阶段，不要求必须运动，如一直有运动，请保持原有的运动习惯即可。从第6天开始，恢复运动计划。";
            [tipsEntityArray addObject:entity];
        }
    
    }
    return tipsEntityArray;
}

@end
