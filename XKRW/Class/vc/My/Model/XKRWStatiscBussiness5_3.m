//
//  XKRWStatiscBussiness5_3.m
//  XKRW
//
//  Created by ss on 16/5/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//


#import "XKRWStatiscBussiness5_3.h"
#import "XKRWUserService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWWeightService.h"
#import "XKRWAlgolHelper.h"

@implementation XKRWStatiscBussiness5_3

- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
    }
    return self;
}

//周计划
-(NSArray *)array{
    if (!_array) {
        NSNumber *days = [self getTotalHasRecordDays];
        NSInteger num = ceilf(days.integerValue / 7.0);
        _array = [NSMutableArray arrayWithCapacity:num];
        for (int i = 0; i < num; i++) {
            XKRWStatiscEntity5_3 *entity = [[XKRWStatiscEntity5_3 alloc] init];
            entity.type = 1;
            entity.index = i;
            entity.num = num - i;
            entity.dateRange = [self getDateRange:i];
            entity.arrDaysDate = [self getWeekDaysInIndex:i];
            entity.weight = [self getWeightSpecific:i];
            entity.weightChange = entity.weight - [[XKRWWeightService shareService] getWeightRecordWithDate:[self getDateRangeStart:i]];
            entity.dayRecord = [NSNumber numberWithInteger:[self getHasRecordDays:Days curDate:[self getDateRangeEnd:i]]];
            entity.dayAchieve = [NSNumber numberWithInteger:[self getPerfectDays:Days curDate:[self getDateRangeEnd:i]]];
            
            entity.normalIntake = [NSNumber numberWithFloat:[self getNormalIntake:entity.arrDaysDate]];
            entity.actualIntake = [NSNumber numberWithFloat:[self getActualRangeIntake:entity.arrDaysDate]];
            entity.recommondIntake = [NSNumber numberWithFloat:[self getRecommondIntake:entity.arrDaysDate]];
            entity.decreaseIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.actualIntake.floatValue)];
            entity.targetIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.recommondIntake.floatValue)];
            
            entity.decreaseSport = [NSNumber numberWithFloat:[self getActualRangeSport:entity.arrDaysDate]];
            entity.targetSport = [NSNumber numberWithFloat:[self getRecommondSport:entity.arrDaysDate]];
            entity.timeSport = [NSNumber numberWithInteger:[self getSportTotalTime:entity.arrDaysDate]];
            
            [_array addObject:entity];
        }
    }
    return _array;
}

//统计分析
-(XKRWStatiscEntity5_3 *)statiscEntity{
    if (!_statiscEntity) {
        _statiscEntity = [[XKRWStatiscEntity5_3 alloc] init];
        _statiscEntity.type = 2;
        _statiscEntity.startDateStr = [self getPlanStartDate];
        _statiscEntity.dateRange = [NSString stringWithFormat:@"%@-至今",[self getPlanStartDate]];
        _statiscEntity.arrDaysDate = [self getAllDaysInIndex];
        _statiscEntity.weight = [self getCurrentWeight];
        _statiscEntity.weightChange = [self getTotalWeightChange];
        _statiscEntity.dayRecord = [NSNumber numberWithInteger:[self getHasRecordDays:[[self getTotalHasRecordDays] integerValue] curDate:[NSDate date]]];
        ;
        _statiscEntity.dayAchieve = [NSNumber numberWithInteger:[self getPerfectDays:_statiscEntity.dayRecord.integerValue curDate:nil]];
        
        _statiscEntity.normalIntake = [NSNumber numberWithFloat:[self getNormalIntake:_statiscEntity.arrDaysDate]];
        _statiscEntity.actualIntake = [NSNumber numberWithFloat:[self getActualRangeIntake:_statiscEntity.arrDaysDate]];
        _statiscEntity.recommondIntake = [NSNumber numberWithFloat:[self getRecommondIntake:_statiscEntity.arrDaysDate]];
        _statiscEntity.decreaseIntake = [NSNumber numberWithFloat:(_statiscEntity.normalIntake.floatValue - _statiscEntity.actualIntake.floatValue)];
        _statiscEntity.targetIntake = [NSNumber numberWithFloat:(_statiscEntity.normalIntake.floatValue - _statiscEntity.recommondIntake.floatValue)];
        
        _statiscEntity.decreaseSport = [NSNumber numberWithFloat:[self getActualRangeSport:_statiscEntity.arrDaysDate]];
        _statiscEntity.targetSport = [NSNumber numberWithFloat:[self getRecommondSport:_statiscEntity.arrDaysDate]];
        _statiscEntity.timeSport = [NSNumber numberWithInteger:[self getSportTotalTime:_statiscEntity.arrDaysDate]];
        
    }
    return _statiscEntity;
}

#pragma mark calculateMethod
/**
 *  获取统计分析开始日期
 *
 *  @return 开始日期的nsstring
 */
-(NSString *)getPlanStartDate{
    NSInteger resetTime = [[[XKRWUserService sharedService]getResetTime] integerValue];
    NSDate *crearDate  = [NSDate dateWithTimeIntervalSince1970:resetTime];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    df.dateFormat = @"yyyy年MM月dd日";
    return [df stringFromDate:crearDate];
}

/**
 *  获取第几周的日期范围
 *
 *  @param index 第几周
 *
 *  @return 该周日期范围（nsstring 类型）
 */
-(NSString *)getDateRange:(int)index{
    NSString *dateStart = @"2016年5月12日";
    NSString *dateEnd = @"2016年5月18日";
    NSString *dateRegister = [[XKRWUserService sharedService] getREGDate]; //带-的 2014-12-11
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    df.dateFormat = @"yyyy年MM月dd日";
    NSInteger timestamp =(long) [[df dateFromString:dateRegister] timeIntervalSince1970];

    if ([[XKRWUserService sharedService] getResetTime]) {
        NSInteger resetTime = [[[XKRWUserService sharedService] getResetTime] integerValue];
        if (timestamp < resetTime)
        {
            NSArray *arr = [self getWeekDaysInIndex:index];
            dateStart = [df stringFromDate:[arr firstObject]];
            dateEnd = [df stringFromDate:[arr lastObject]];
        }
    }
    return [NSString stringWithFormat:@"%@-%@",dateStart,dateEnd];
}

/**
 *  获取日期范围内第一天
 *
 *  @param index 第几周
 *
 *  @return 该周内第一天日期
 */
-(NSDate *)getDateRangeStart:(int)index{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    df.dateFormat = @"yyyy年MM月dd日";
    NSString *dateRegister = [[XKRWUserService sharedService] getREGDate];
    NSInteger timestamp =(long) [[df dateFromString:dateRegister] timeIntervalSince1970];
    if ([[XKRWUserService sharedService] getResetTime]) {
        NSInteger resetTime = [[[XKRWUserService sharedService] getResetTime] integerValue];
        if (timestamp < resetTime)
        {
            return [NSDate dateWithTimeIntervalSince1970:resetTime-DrecreaseDateInterval*index];
        }else{
            return [NSDate dateWithTimeIntervalSince1970:timestamp];
        }
    }
    return nil;
}


/**
 *  获取日期范围内最后一天
 *
 *  @param index 第几周
 *
 *  @return 该周内最后日期
 */
-(NSDate *)getDateRangeEnd:(int)index{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    df.dateFormat = @"yyyy年MM月dd日";
    NSString *dateRegister = [[XKRWUserService sharedService] getREGDate];
    NSInteger timestamp =(long) [[df dateFromString:dateRegister] timeIntervalSince1970];
    if ([[XKRWUserService sharedService] getResetTime]) {
        NSInteger resetTime = [[[XKRWUserService sharedService] getResetTime] integerValue];
        if (timestamp < resetTime)
        {
            NSDate *crearDate  = [NSDate dateWithTimeIntervalSince1970:resetTime-DrecreaseDateInterval*index];
            return [crearDate dateByAddingTimeInterval:DateInterval];
            
        }else{
            return [NSDate dateWithTimeIntervalSince1970:timestamp];
        }
    }
    return nil;
}

/**
 *  获取特定index的所有日期NSDate对象（一周7个）
 *
 *  @param index 第几周
 *
 *  @return 该周的每天的日期所构成的数组（正序，小在前，大在后）
 */
-(NSArray *)getWeekDaysInIndex:(int)index{
//    NSDate *endDate = [self getDateRangeEnd:index];
    NSDate *endDate = [[NSDate date] offsetDay:-Days*index];
    NSInteger resetTime = [[[XKRWUserService sharedService]getResetTime] integerValue];
    NSDate *createDate  = [NSDate dateWithTimeIntervalSince1970:resetTime];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:Days];
    for (int i = 0 ; i < Days; i++) {
        NSDate *date = [endDate offsetDay:-i];
        [arr addObject:date];
        if ([date isDayEqualToDate:createDate]) {
            break;
        }
    }
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *p1 = (NSDate*)obj1;
        NSDate *p2 = (NSDate*)obj2;
        if ([p1 earlierDate:p2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([p2 earlierDate:p1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return [arr copy];
}

/**
 *  获取所有日期的数组
 *
 *  @return 所有计划内日期数组
 */
-(NSArray *)getAllDaysInIndex{
    NSInteger days = [[self getTotalHasRecordDays] integerValue];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:days];
    for (int i = 0 ; i < days; i++) {
        NSDate *date = [[NSDate date] offsetDay:-i];
        [arr addObject:date];
    }
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *p1 = (NSDate*)obj1;
        NSDate *p2 = (NSDate*)obj2;
        if ([p1 earlierDate:p2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([p2 earlierDate:p1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    return arr;
}

-(CGFloat)getCurrentWeight{
    CGFloat currentWeight = [[XKRWUserService sharedService] getCurrentWeight]/1000.f;
    return currentWeight;
}

/**
 *  获取该周最新记录的体重
 *
 *  @param i 第几周
 *
 *  @return 体重
 */
-(CGFloat)getWeightSpecific:(int)i{
    CGFloat weight = [[XKRWWeightService shareService] getWeightRecordWithDate:[self getDateRangeEnd:i]];
    if (weight == 0) {
        weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[self getDateRangeEnd:i]];
    }
    return weight;
}

-(CGFloat)getTotalWeightChange{
    CGFloat currentWeight = [[XKRWUserService sharedService] getCurrentWeight]/1000.f;
    NSDate *earlyDate = [[NSDate date] dateByAddingTimeInterval:-DateInterval];
    CGFloat earlyWeight = [[XKRWWeightService shareService] getWeightRecordWithDate:earlyDate];
    return (currentWeight - earlyWeight);
//    NSString *txt = @"";
//    if (currentWeight > earlyWeight) {
//        txt = [NSString stringWithFormat:@"增重%.1f",currentWeight - earlyWeight];
//    }else{
//        txt = [NSString stringWithFormat:@"减重%.1f",earlyWeight - currentWeight];
//    }
//    return txt;
}


/**
 *  获取记录过的天数
 *
 *  @param days 过去多少天的
 *  @param date 此时间点之前的
 *
 *  @return 这个区间记录过的天数
 */
-(NSInteger)getHasRecordDays:(NSInteger)days curDate:(NSDate *)date{
    NSArray *arraySport = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:days withType:RecordTypeSport withCurrentDate:date];
    NSInteger nullSport = [self theNumberOfExecutionStatus:arraySport andState:0];
    
    NSArray *arrayEat = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:days withType:RecordTypeBreakfirst withCurrentDate:date];
    NSInteger nullEat = [self theNumberOfExecutionStatus:arrayEat andState:0];
    return MAX(arrayEat.count-nullEat, arraySport.count-nullSport);
}

- (NSInteger)theNumberOfExecutionStatus:(NSArray *)array andState:(NSInteger) state
{
    NSInteger num = 0;
    for (int i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i]integerValue] == state) {
            num ++;
        }
    }
    return num;
}

/**
 *  获取完成计划的天数
 *
 *  @param days 过去多少天的
 *  @param date 此时间点之前的
 *
 *  @return 这个区间完成计划的天数
 */
-(NSInteger)getPerfectDays:(NSInteger)days curDate:(NSDate *)date{
    NSInteger j = 0;
    
    NSDictionary *dicSport = [[XKRWRecordService4_0 sharedService] getSchemeStatesOfDays:days withType:RecordTypeSport withDate:date];
    
    NSDictionary *dicEat = [[XKRWRecordService4_0 sharedService] getSchemeStatesOfDays:days withType:RecordTypeBreakfirst withDate:date];
    
    for (NSString *dateStr in [dicSport allKeys]) {
        NSNumber *stateSport = [dicSport objectForKey:dateStr];
        if (stateSport.integerValue != 0 ) {
            NSNumber *stateEat = [dicEat objectForKey:dateStr];
            if (stateEat.integerValue != 0) {
                j++;
            }
        }
    }
    return j;
}

/**
 *  获取一周内正常所需摄入
 *
 *  @param arrDate 该周内
 *
 *  @return 总需kcal
 */
-(CGFloat)getNormalIntake:(NSArray *)arrDate{
    CGFloat cal = 0.0;
    for (NSDate *date in arrDate) {
        cal += [XKRWAlgolHelper dailyIntakEnergyOfDate:date];
    }
    return cal;
}

/**
 *  获取实际摄入的kcal数值
 *
 *  @param arrDate 日期构成的数组
 *
 *  @return 饮食摄入总kcal
 */
-(CGFloat)getActualRangeIntake:(NSArray *)arrDate{
    CGFloat cal = 0.0;
    for (NSDate *date in arrDate) {
        cal += [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:efoodCalories andDate:date];
    }
    return cal;
}

/**
 *  获取一周内推荐摄入
 *
 *  @param arrDate 该周内
 *
 *  @return 总推荐摄入kcal
 */
-(CGFloat)getRecommondIntake:(NSArray *)arrDate{
    CGFloat cal = 0.0;
    for (NSDate *date in arrDate) {
        cal += [XKRWAlgolHelper dailyIntakeRecomEnergyOfDate:date];
    }
    return cal;
}

/**
 *  获取一周内推荐运动消耗
 *
 *  @param arrDate 该周内
 *
 *  @return 总推荐运动消耗kcal
 */
-(CGFloat)getRecommondSport:(NSArray *)arrDate{
    CGFloat cal = 0.0;
    for (NSDate *date in arrDate) {
        cal += [XKRWAlgolHelper dailyConsumeSportEnergyOfDate:date];
    }
    return cal;
}

/**
 *  获取实际运动消耗的kcal数值
 *
 *  @param arrDate 日期构成的数组
 *
 *  @return 运动消耗总kcal
 */
-(CGFloat)getActualRangeSport:(NSArray *)arrDate{
    CGFloat cal = 0.0;
    for (NSDate *date in arrDate) {
        cal += [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:eSportCalories andDate:date];
    }
    return cal;
}

/**
 *  运动时长总计
 *
 *  @param arrDate 日期构成的数组
 *
 *  @return 运动时长总计数
 */
-(NSInteger)getSportTotalTime:(NSArray *)arrDate{
    NSInteger time = 0;
    for (NSDate *date in arrDate) {
        time += [XKRWAlgolHelper getSportRecordAndSportSchemeRecordTimeWithDate:date];
    }
    return time;
}

/**
 *  方案重置总天数
 *
 *  @return 方案开始执行的总天数
 */
-(NSNumber *)getTotalHasRecordDays{
    NSInteger resetTime = [[[XKRWUserService sharedService]getResetTime] integerValue];
    NSDate *createDate  = [NSDate dateWithTimeIntervalSince1970:resetTime];
    NSInteger days = [NSDate daysBetweenDate:createDate andDate:_date];
    
    return [NSNumber numberWithInteger:days + 1];
}

@end
