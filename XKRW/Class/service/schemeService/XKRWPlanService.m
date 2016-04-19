//
//  XKRWPlanService.m
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanService.h"

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
    NSArray *dataArray = [[XKRWRecordService4_0 sharedService] queryRecent_20_RecordTable:tableName];
    if ([tableName isEqualToString:@"food_record"]) {
        /*
         @property (nonatomic, assign) NSInteger foodId;
         //食物名称
         @property (nonatomic, strong) NSString *foodName;
         //食物logo
         @property (nonatomic, strong) NSString *foodLogo;
         //食物营养
         @property (nonatomic, strong) NSArray  *foodNutri;
         //食物能量 一般是每百克
         @property (nonatomic, assign) NSInteger foodEnergy;
         //是否适合减肥吃
         @property (nonatomic, assign) NSInteger  fitSlim;
         //食物度量单位
         //@property (nonatomic, strong) NSArray  *foodUnit;
         #pragma mark - 5.0 new
         @property (nonatomic ,strong) NSDictionary *foodUnit;
         */
        for (NSDictionary *temp in dataArray) {
            XKRWFoodEntity *foodEntity = [XKRWFoodEntity new];
            foodEntity.foodId = [temp[@"food_id"] integerValue];
        }
    } else if ([tableName isEqualToString:@"sport_record"]) {
        
    }
    
    return [NSArray new];
}
- (NSArray *)queryLatestItemNumber:(NSInteger)itemNumber FoodRecord:(NSDate *)date {
    NSInteger itemCount = itemNumber;
    NSMutableArray *foodRecord = [NSMutableArray array];
//    while (itemNumber) {
//        foodRecord = [[XKRWRecordService4_0 sharedService] ]
//    }
//    - (NSArray *)queryFoodRecord:(NSDate *)date
    return [NSArray new];
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
    id date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return [[NSCalendar currentCalendar] isDateInToday:(NSDate *)date];
}

@end
