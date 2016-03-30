//
//  XKRWRecordEntity4_0.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordEntity4_0.h"
#import "XKRWFatReasonService.h"

@implementation XKRWRecordEntity4_0

- (instancetype)init
{
    if (self = [super init]) {
        self.uid = (uint32_t)[XKRWUserDefaultService getCurrentUserId];
    }
    return self;
}

- (NSMutableArray *)FoodArray
{
    if (!_FoodArray) {
        _FoodArray = [NSMutableArray array];
    }
    return _FoodArray;
}

- (NSMutableArray *)SportArray
{
    if (!_SportArray) {
        _SportArray = [NSMutableArray array];
    }
    return _SportArray;
}

- (NSMutableArray *)customFoodArray
{
    if (!_customFoodArray) {
        _customFoodArray = [NSMutableArray array];
    }
    return _customFoodArray;
}

- (NSMutableArray *)customSportArray
{
    if (!_customSportArray) {
        _customSportArray = [NSMutableArray array];
    }
    return _customSportArray;
}

- (NSMutableArray *)habitArray
{
//    if (!_habitArray) {
//        _habitArray = [NSMutableArray arrayWithArray:[self getUserHabit]];
//    }
    return _habitArray;
}

- (XKRWRecordCircumferenceEntity *)circumference
{
    if (!_circumference) {
        _circumference = [[XKRWRecordCircumferenceEntity alloc] init];
    }
    return _circumference;
}

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (NSString *)jointHabitString
{
    if (self.habitArray != nil) {
        
        NSMutableString *jointString = [NSMutableString stringWithString:@""];
        
        [self.habitArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XKRWHabbitEntity *entity = (XKRWHabbitEntity *)obj;
            if (idx) {
                [jointString appendFormat:@",%ld_%ld", (long)entity.hid, (long)entity.situation];
            } else {
                [jointString appendFormat:@"%ld_%ld", (long)entity.hid, (long)entity.situation];
            }
        }];
        return jointString;
    }
    return @"";
}

- (void)splitHabitStringIntoArray:(NSString *)jointString
{
    if (![jointString isKindOfClass:[NSString class]]) {
        return;
    }
    if ([jointString isEqualToString:@""]) {
        return;
    }
    
    if (!self.habitArray) {
        self.habitArray = [NSMutableArray array];
    }
    [self.habitArray removeAllObjects];
    
    NSArray *array = [jointString componentsSeparatedByString:@","];;
    
    for (NSString *habitString in array) {
        XKRWHabbitEntity *entity = [[XKRWHabbitEntity alloc] init];
        NSArray *components = [habitString componentsSeparatedByString:@"_"];
        entity.hid = ((NSString *)components[0]).intValue;
        switch (entity.hid) {
            case 1:
                entity.name = @"饮食油腻";
                break;
            case 2:
                entity.name = @"吃零食";
                break;
            case 3:
                entity.name = @"喝饮料";
                break;
            case 4:
                entity.name = @"饮酒";
                break;
            case 5:
                entity.name = @"饮酒";
                break;
            case 6:
                entity.name = @"饮酒";
                break;
            case 7:
                entity.name = @"吃肥肉";
                break;
            case 8:
                entity.name = @"吃坚果";
                break;
            case 9:
                entity.name = @"吃宵夜";
                break;
            case 10:
                entity.name = @"吃饭晚";
                break;
            case 11:
                entity.name = @"吃饭快";
                break;
            case 12:
                entity.name = @"饮食不规律";
                break;
            case 13:
                entity.name = @"活动量小";
                break;
            case 14:
                entity.name = @"缺乏锻炼";
                break;
            default:
                break;
        }
        entity.situation = ((NSString *)components[1]).intValue;
        BOOL flag = YES;
        for (XKRWHabbitEntity *temp in _habitArray) {
            if (temp.hid == entity.hid || [temp.name isEqualToString:entity.name]) {
                flag = NO;
                break;
            }
        }
        if (flag) {
            [_habitArray addObject:entity];
        }
    }
}

- (NSDictionary *)dictionaryInRecordTable
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithUnsignedInteger:_rid] forKey:@"rid"];
    [dict setObject:[NSNumber numberWithUnsignedInteger:_uid] forKey:@"uid"];
    
    [dict setObject:[NSNumber numberWithFloat:_weight] forKey:@"weight"];
    [dict setObject:[NSNumber numberWithFloat:_circumference.waistline] forKey:@"waistline"];
    [dict setObject:[NSNumber numberWithFloat:_circumference.bust] forKey:@"bust"];
    [dict setObject:[NSNumber numberWithFloat:_circumference.hipline] forKey:@"hipline"];
    [dict setObject:[NSNumber numberWithFloat:_circumference.arm] forKey:@"arm"];
    [dict setObject:[NSNumber numberWithFloat:_circumference.thigh] forKey:@"thigh"];
    [dict setObject:[NSNumber numberWithFloat:_circumference.shank] forKey:@"shank"];
    
    if ([self jointHabitString]) {
        [dict setObject:[self jointHabitString] forKey:@"habit"];
    } else {
        [dict setObject:[NSNull null] forKey:@"habit"];
    }
    [dict setObject:[NSNumber numberWithInt:_menstruation] forKey:@"menstruation"];
    [dict setObject:[NSNumber numberWithFloat:_sleepingTime] forKey:@"sleep_time"];
    [dict setObject:[NSNumber numberWithUnsignedInteger:(unsigned int)[_getUp timeIntervalSince1970]] forKey:@"get_up_time"];
    [dict setObject:[NSNumber numberWithInt:_water] forKey:@"water"];
    [dict setObject:[NSNumber numberWithInt:_mood] forKey:@"mood"];
    if (!_remark) {
        _remark = @"";
    }
    [dict setObject:_remark forKey:@"remark"];
    
    [dict setObject:[_date stringWithFormat:@"yyyy-MM-dd"] forKey:@"date"];
    [dict setObject:[NSNumber numberWithInt:self.sync] forKey:@"sync"];
    
    return dict;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.rid = [dictionary[@"rid"] intValue];
        self.uid = [dictionary[@"uid"] intValue];
        
        self.weight = [dictionary[@"weight"] floatValue];
        self.circumference.waistline = [dictionary[@"waistline"] floatValue];
        self.circumference.bust = [dictionary[@"bust"] floatValue];
        self.circumference.hipline = [dictionary[@"hipline"] floatValue];
        self.circumference.arm = [dictionary[@"arm"] floatValue];
        self.circumference.thigh = [dictionary[@"thigh"] floatValue];
        self.circumference.shank = [dictionary[@"shank"] floatValue];
        
        [self splitHabitStringIntoArray:dictionary[@"habit"]];
        self.menstruation = [dictionary[@"menstruation"] intValue];
        self.sleepingTime = [dictionary[@"sleep_time"] floatValue];
        self.getUp = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"get_up_time"] unsignedIntValue]];
        
        self.water = [dictionary[@"water"] intValue];
        self.mood = [dictionary[@"mood"] intValue];
        
        self.remark = dictionary[@"remark"];
        self.date = [NSDate dateFromString:dictionary[@"date"] withFormat:@"yyyy-MM-dd"];
        self.sync = [dictionary[@"sync"] intValue];
    }
    return self;
}

- (NSArray *)getUserHabit
{
    NSArray *array = [[XKRWFatReasonService sharedService] getQuestionAnswer];
    
    return [[XKRWFatReasonService sharedService] getHabitEntitiesWithFatReasonEntities:array];
}

- (void)reloadHabitArray
{
    if (!self.habitArray) {
        self.habitArray = [NSMutableArray array];
    }
    [self.habitArray removeAllObjects];
    [self.habitArray addObjectsFromArray:[self getUserHabit]];
}

@synthesize sleepingTime = _sleepingTime;

- (float)sleepingTime
{
    if (_sleepingTime < 0.f) {
        _sleepingTime = 0.f;
    }
    return _sleepingTime;
}

- (void)setSleepingTime:(float)sleepingTime
{
    if (sleepingTime < 0) {
        _sleepingTime = 0;
    } else {
        _sleepingTime = sleepingTime;
    }
}

@synthesize mood = _mood;

- (int)mood
{
    if (_mood < 0.f) {
        _mood = 0.f;
    }
    return _mood;
}

- (void)setMood:(int)mood
{
    if (mood < 0) {
        _mood = 0;
    } else {
        _mood = mood;
    }
}

@synthesize water = _water;

- (int)water {
    if (_water < 0) {
        _water = 0;
    }
    return _water;
}

- (void)setWater:(int)water {
    if (water < 0) {
        _water = 0;
    } else {
        _water = water;
    }
}
@end
