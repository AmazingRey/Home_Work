//
//  XKRWPlanService.m
//  XKRW
//
//  Created by Shoushou on 16/4/11.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanService.h"

@implementation XKRWPlanService

- (XKRWRecordEntity4_0 *)getAllRecordOfDay:(NSDate *)date {
    return [[XKRWRecordService4_0 sharedService] getAllRecordOfDay:date];
}

- (BOOL)saveRecord:(id)recordEntity ofType:(XKRWRecordType)type {
    return [[XKRWRecordService4_0 sharedService] saveRecord:recordEntity ofType:type];
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


@end
