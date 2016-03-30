//
//  XKRWRecordSportEntity.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordSportEntity.h"

@implementation XKRWRecordSportEntity

- (instancetype)init
{
    if (self = [super init]) {
        self.recordType = RecordTypeSport;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.rid        = [dict[@"rid"] intValue];
        self.uid        = [dict[@"uid"] intValue];
        self.sportId    = [dict[@"sport_id"] intValue];
        self.sportName  = dict[@"sport_name"];
        self.recordType = [dict[@"record_type"] intValue];
        self.calorie    = [dict[@"calorie"] intValue];
        self.number     = [dict[@"number"] intValue];
        self.unit       = [dict[@"unit"] intValue];
        self.serverid   = [dict[@"server_id"] intValue];
        self.date       = [NSDate dateFromString:dict[@"date"] withFormat:@"yyyy-MM-dd"];
        self.imageURL   = dict[@"image_url"];
        self.sync       = [dict[@"sync"] intValue];
        self.sportMets  = [dict[@"sport_METS"] floatValue];
    }
    return self;
}

- (NSDictionary *)dictionaryInRecordTable
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithUnsignedInteger:self.rid] forKey:@"rid"];
    [dict setObject:[NSNumber numberWithUnsignedInteger:self.uid] forKey:@"uid"];
    [dict setObject:[NSNumber numberWithUnsignedInteger:_recordType] forKey:@"record_type"];
    [dict setObject:[NSNumber numberWithUnsignedInteger:self.sportId] forKey:@"sport_id"];
    if (!self.sportName) {
        self.sportName = @"";
    }
    [dict setObject:self.sportName forKey:@"sport_name"];
    [dict setObject:[NSNumber numberWithInteger:self.calorie] forKey:@"calorie"];
    [dict setObject:[NSNumber numberWithInteger:self.number] forKey:@"number"];
    [dict setObject:[NSNumber numberWithInt:self.unit] forKey:@"unit"];
    [dict setObject:[NSNumber numberWithInt:self.serverid] forKey:@"server_id"];

    [dict setObject:[NSDate stringFromDate:self.date withFormat:@"yyyy-MM-dd"] forKey:@"date"];
    if (!self.imageURL) {
        self.imageURL = @"";
    }
    [dict setObject:self.imageURL forKey:@"image_url"];
    [dict setObject:[NSNumber numberWithInt:self.sync] forKey:@"sync"];
    [dict setObject:[NSNumber numberWithFloat:self.sportMets] forKey:@"sport_METS"];
    
    return dict;
}
@end
