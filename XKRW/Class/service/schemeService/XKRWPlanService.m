//
//  XKRWPlanService.m
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanService.h"
#import "XKRWUserService.h"

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
    NSDate *date = [NSDate date];
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
        if ([today year] == [date year] && [today month] == [date month] && [today day] == [date day]) {
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
@end
