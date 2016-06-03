//
//  XKRWRecordFoodEntity.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordFoodEntity.h"

@implementation XKRWRecordFoodEntity

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.rid        = [dict[@"rid"] integerValue];
        self.uid        = [dict[@"uid"] integerValue];
        self.foodId     = [dict[@"food_id"] integerValue];
        self.foodName   = dict[@"food_name"];
        self.recordType = [dict[@"record_type"] integerValue];
        self.calorie    = [dict[@"calorie"] integerValue];
        self.number     = [dict[@"number"] integerValue];
        self.unit       = [dict[@"unit"] integerValue];
        self.serverid   = [dict[@"server_id"] integerValue];
        self.date       = [NSDate dateFromString:dict[@"date"] withFormat:@"yyyy-MM-dd"];
       
        self.foodLogo   = dict[@"image_url"];
        self.foodEnergy = [dict[@"food_energy"] integerValue];
        self.sync       = [dict[@"sync"] integerValue];
        
        self.unit_new = dict[@"unit_new"] || ![dict[@"unit_new"] isKindOfClass:[NSNull class]] ? dict[@"unit_new"] : nil;
        
        if (dict[@"number_new"] && ![dict[@"number_new"] isKindOfClass:[NSNull class]]) {
            self.number_new = [dict[@"number_new"] integerValue];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryInRecordTable
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithInteger:self.rid] forKey:@"rid"];
    if (!self.foodName) {
        self.foodName = @"";
    }
    [dic setObject:self.foodName forKey:@"food_name"];
    [dic setObject:[NSNumber numberWithInteger:self.foodId] forKey:@"food_id"];
    [dic setObject:[NSNumber numberWithInteger:self.uid] forKey:@"uid"];
    [dic setObject:[NSNumber numberWithInt:self.recordType] forKey:@"record_type"];
    [dic setObject:[NSNumber numberWithInteger:self.calorie] forKey:@"calorie"];
    [dic setObject:[NSNumber numberWithInteger:self.number] forKey:@"number"];
    [dic setObject:[NSNumber numberWithInteger:self.unit] forKey:@"unit"];
    [dic setObject:[NSNumber numberWithInteger:self.serverid] forKey:@"server_id"];
    [dic setObject:[NSDate stringFromDate:self.date withFormat:[NSDate dateFormatString]] forKey:@"date"];
    if (!self.foodLogo) {
        self.foodLogo = @"";
    }
    [dic setObject:self.foodLogo forKey:@"image_url"];
    [dic setObject:[NSNumber numberWithInteger:self.foodEnergy] forKey:@"food_energy"];
    [dic setObject:[NSNumber numberWithInteger:self.sync] forKey:@"sync"];
    
    if (self.unit_new) {
        [dic setObject:self.unit_new forKey:@"unit_new"];
    } else {
        [dic setObject:[NSNull new] forKey:@"unit_new"];
    }
    [dic setObject:@(self.number_new) forKey:@"number_new"];
    
    return dic;
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"\n{\n  rid = %ld,\n  uid = %ld,\n  foodName = %@,\n  foodID = %ld,  recordType = %ld,\n  calorie = %ld,\n  number = %ld,\n  serverid = %ld,\n unit = %ld,\n  imageURL = %@,\n  date = %@,\n}\n", (long)_rid, (long)_uid, self.foodName, (long)self.foodId, (long)_recordType, (long)_calorie, (long)_number, (long)_serverid, (long)_unit, self.foodLogo, _date];
    return string;
}
@end
