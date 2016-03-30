//
//  XKRWRecordCustomEntity.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordCustomEntity.h"

@implementation XKRWRecordCustomEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.rid        = [dictionary[@"rid"] unsignedIntValue];
        self.uid        = [dictionary[@"uid"] unsignedIntValue];
        self.recordType = [dictionary[@"type"] intValue];
        self.number     = [dictionary[@"number"] intValue];
        self.unit       = dictionary[@"unit"];
        self.calorie    = [dictionary[@"calorie"] intValue];
        self.date       = [NSDate dateFromString:dictionary[@"date"] withFormat:@"yyyy-MM-dd"];
        self.serverid   = [dictionary[@"server_id"] intValue];
        self.sync       = [dictionary[@"sync"] intValue];
        
        if (!self.recordType) {
            self.name      = dictionary[@"sport_name"];
            self.custom_id = [dictionary[@"sport_id"] intValue];
        } else {
            self.name      = dictionary[@"food_name"];
            self.custom_id = [dictionary[@"food_id"] intValue];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryInRecordTable
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithUnsignedInteger:self.rid] forKey:@"rid"];
    [dict setObject:[NSNumber numberWithUnsignedInteger:self.uid] forKey:@"uid"];
    [dict setObject:[NSNumber numberWithInt:self.recordType] forKey:@"type"];
    [dict setObject:[NSNumber numberWithInteger:self.number] forKey:@"number"];
    [dict setObject:self.unit forKey:@"unit"];
    [dict setObject:[NSNumber numberWithInteger:self.calorie] forKey:@"calorie"];
    [dict setObject:[NSDate stringFromDate:self.date withFormat:@"yyyy-MM-dd"]
             forKey:@"date"];
    [dict setObject:[NSNumber numberWithInt:self.serverid] forKey:@"server_id"];
    [dict setObject:[NSNumber numberWithInt:self.sync] forKey:@"sync"];
    
    if (!self.recordType) {
        [dict setObject:self.name forKey:@"sport_name"];
        [dict setObject:[NSNumber numberWithInt:self.custom_id] forKey:@"sport_id"];
    } else {
        [dict setObject:self.name forKey:@"food_name"];
        [dict setObject:[NSNumber numberWithInt:self.custom_id] forKey:@"food_id"];
    }
    return dict;
}
@end
