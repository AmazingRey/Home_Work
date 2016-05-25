//
//  XKRWPlanService.m
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanService.h"
#import "XKRWUserService.h"
#import "XKRWLocalNotificationService.h"

static XKRWPlanService *planService;
@implementation XKRWPlanService

+ (instancetype)shareService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        planService = [[XKRWPlanService alloc] init];
    });
    return planService;
}

- (XKRWRecordEntity4_0 *)getAllRecordOfDay:(NSDate *)date {
    return [[XKRWRecordService4_0 sharedService] getAllRecordOfDay:date];
}

- (BOOL)saveRecord:(id)recordEntity ofType:(XKRWRecordType)type {
    return [[XKRWRecordService4_0 sharedService] saveRecord:recordEntity ofType:type];
}

- (NSArray *)getRecent_20_RecordWithTableName:(NSString *)tableName {
   
    return [[XKRWRecordService4_0 sharedService] queryRecent_20_RecordTable:tableName];
}


- (void)saveEnergyCircleClickEvent:(ResultType)type {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSDate *date = [NSDate today];
    NSString *key;
    if (type == eFoodType) {
        key = [NSString stringWithFormat:@"%ld_eFoodType",(long)uid];
        
    } else if (type == eSportType) {
        key = [NSString stringWithFormat:@"%ld_eSportType",(long)uid];
        
    } else if (type == eHabitType) {
        key = [NSString stringWithFormat:@"%ld_eHabitType",(long)uid];

    }
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getEnergyCircleClickEvent:(ResultType)type {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *key;
    if (type == eFoodType) {
        key = [NSString stringWithFormat:@"%ld_eFoodType",(long)uid];
        
    } else if (type == eSportType) {
        key = [NSString stringWithFormat:@"%ld_eSportType",(long)uid];
        
    } else if (type == eHabitType) {
        key = [NSString stringWithFormat:@"%ld_eHabitType",(long)uid];
        
    }
    NSDate * date = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (date) {
        NSDate *today = [NSDate today];
        if ([date compare:today] == NSOrderedSame) {
            return YES;
        } else {
            return NO;
        }
        
    } else return NO;
}
- (CGFloat)getHistoryWeightWithDate:(NSDate *)date {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    int dateFormat = [[date stringWithFormat:@"yyyyMMdd"] intValue];
    NSString *sql = [NSString stringWithFormat:@"SELECT date, weight FROM weightrecord WHERE userid = %ld AND date <= %d ORDER BY date DESC LIMIT 1",(long)uid,dateFormat];
    NSArray *result = [self query:sql];
    
    if (!result || !result.count) {
        return [[XKRWUserService sharedService] getUserOrigWeight] / 1000.f;
        
    } else return [result[0][@"weight"] floatValue] / 1000.f;
    
    return 0.f;
}

- (BOOL)isRecordWeightWithDate:(NSDate *)date {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    int dateFormat = [[date stringWithFormat:@"yyyyMMdd"] intValue];
    NSString *sql = [NSString stringWithFormat:@"SELECT date, weight FROM weightrecord WHERE userid = %ld AND date = %d ORDER BY date DESC LIMIT 1",(long)uid,dateFormat];
    NSArray *result = [self query:sql];
    
    if (result!= nil || result.count > 0) {
        return YES;
        
    }
    return NO;
}

// deal with scheme record
- (BOOL)isRecordWithDate:(NSDate *)date{
    XKRWRecordEntity4_0 *recordEntity = [[XKRWPlanService shareService] getAllRecordOfDay:date];
    NSArray * recordScheme = [[XKRWRecordService4_0 sharedService]getSchemeRecordWithDate:date];
    NSInteger   intakeCalorie = 0;
    NSInteger  expendCalorie = 0;
    NSInteger  currentHabit = 0;
    for (XKRWRecordFoodEntity *foodEntity in recordEntity.FoodArray) {
        intakeCalorie += foodEntity.calorie;
    }
    
    for (XKRWRecordSportEntity *sportEntity in recordEntity.SportArray) {
        expendCalorie += sportEntity.calorie;
    }
    
    for (XKRWHabbitEntity *habitEntity in recordEntity.habitArray) {
        currentHabit += habitEntity.situation;
    }
    
    for (XKRWRecordSchemeEntity *schemeEntity in recordScheme) {
        if (schemeEntity.type == 0 || schemeEntity.type == 5) {
            expendCalorie += schemeEntity.calorie;
        }
        
        if (schemeEntity.type == 1 || schemeEntity.type == 2 || schemeEntity.type == 3|| schemeEntity.type == 4|| schemeEntity.type == 6) {
            intakeCalorie += schemeEntity.calorie;
        }
    }
    
    if (intakeCalorie + expendCalorie + currentHabit == 0) {
        return NO;
    }else{
        return YES;
    }
    
}


@end
