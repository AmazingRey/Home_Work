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

@implementation XKRWStatiscBussiness5_3{
    NSInteger num;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self statiscEntity];
        });
    }
    return self;
}

//周计划
-(NSMutableDictionary *)dicEntities{
    if (!_dicEntities) {
        NSNumber *days = [self getTotalHasRecordDays];
        num = ceilf(days.integerValue / 7.0);
        _dicEntities = [NSMutableDictionary dictionaryWithCapacity:num];
    }
    return _dicEntities;
}

//日期dic
-(NSDictionary *)dicPicker{
    if (!_dicPicker) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:num];
        for (NSInteger i = 0; i<num; i++) {
            [dic setObject:[self getDateRange:i] forKey:[NSNumber numberWithInteger:i]];
        }
        _dicPicker = dic;
    }
    return _dicPicker;
}

//统计分析
-(XKRWStatiscEntity5_3 *)statiscEntity{
    if (!_statiscEntity) {
        XKRWStatiscEntity5_3 *entity = [[XKRWStatiscEntity5_3 alloc] init];
        entity.type = 2;
        entity.startDateStr = [self getPlanStartDate];
        entity.dateRange = [NSString stringWithFormat:@"%@-至今",[self getPlanStartDate]];
        entity.arrDaysDate = [self getAllDaysInIndex];
        entity.weight = [self getCurrentWeight];
        entity.weightChange = [self getTotalWeightChange];
        entity.dayRecord = [NSNumber numberWithInteger:[self getHasRecordDays:[[self getTotalHasRecordDays] integerValue] curDate:[NSDate date]]];
        ;
        entity.dayAchieve = [NSNumber numberWithInteger:[self getPerfectDays:entity.dayRecord.integerValue curDate:nil]];
        
        entity.normalIntake = [NSNumber numberWithFloat:[self getNormalIntake:entity.arrDaysDate]];
        entity.actualIntake = [NSNumber numberWithFloat:[self getActualRangeIntake:entity.arrDaysDate]];
        entity.recommondIntake = [NSNumber numberWithFloat:[self getRecommondIntake:entity.arrDaysDate]];
        entity.decreaseIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.actualIntake.floatValue)];
        entity.targetIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.recommondIntake.floatValue)];
        
        entity.decreaseSport = [NSNumber numberWithFloat:[self getActualRangeSport:entity.arrDaysDate]];
        entity.targetSport = [NSNumber numberWithFloat:[self getRecommondSport:entity.arrDaysDate]];
        entity.timeSport = [NSNumber numberWithInteger:[self getSportTotalTime:entity.arrDaysDate]];
        _statiscEntity = entity;
    }
    return _statiscEntity;
}


//set周数
-(void)setWeekIndex:(NSInteger)weekIndex{
    if (_weekIndex != weekIndex) {
        _weekIndex = weekIndex;
    }
    [self addWeekEntityToArray:_weekIndex];
}

-(void)addWeekEntityToArray:(NSInteger)index{
    if (![[self.dicEntities allKeys] containsObject:[NSNumber numberWithInteger:index]]){
        XKRWStatiscEntity5_3 *entity = [self loadWeekData:index];
        [self.dicEntities setObject:entity forKey:[NSNumber numberWithInteger:index]];
    }
}

-(XKRWStatiscEntity5_3 *)loadWeekData:(NSInteger)i{
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
    entity.isAchieveIntakeTarget = entity.decreaseIntake.floatValue - entity.targetIntake.floatValue >= 0 ? YES : NO;
    
    entity.decreaseSport = [NSNumber numberWithFloat:[self getActualRangeSport:entity.arrDaysDate]];
    entity.targetSport = [NSNumber numberWithFloat:[self getRecommondSport:entity.arrDaysDate]];
    entity.timeSport = [NSNumber numberWithInteger:[self getSportTotalTime:entity.arrDaysDate]];
    entity.isAchieveSportTarget = entity.decreaseSport.floatValue >= entity.targetSport.floatValue *.9 ? YES : NO;
    return entity;
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
-(NSString *)getDateRange:(NSInteger)index{
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
     NSString *dateRange = @"";
    if ([dateStart isEqualToString:dateEnd]) {
        dateRange = dateStart;
    }else{
        dateRange = [NSString stringWithFormat:@"%@-%@",dateStart,dateEnd];
    }
    return dateRange;
}

/**
 *  获取日期范围内第一天
 *
 *  @param index 第几周
 *
 *  @return 该周内第一天日期
 */
-(NSDate *)getDateRangeStart:(NSInteger)index{
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
-(NSDate *)getDateRangeEnd:(NSInteger)index{
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
-(NSArray *)getWeekDaysInIndex:(NSInteger)index{
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
    NSInteger daysRecord = [[self getTotalHasRecordDays] integerValue];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:daysRecord];
    for (int i = 0 ; i < daysRecord; i++) {
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
-(CGFloat)getWeightSpecific:(NSInteger)i{
    CGFloat weight = [[XKRWWeightService shareService] getWeightRecordWithDate:[self getDateRangeEnd:i]];
    if (weight == 0) {
        weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[self getDateRangeEnd:i]];
    }
    return weight;
}

-(CGFloat)getTotalWeightChange{
    if (_statiscEntity.arrDaysDate.count == 1) {
        return 0;
    }
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
-(NSInteger)getHasRecordDays:(NSInteger)daysRecord curDate:(NSDate *)date{
    NSArray *arraySport = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:daysRecord withType:RecordTypeSport withCurrentDate:date];
    NSInteger nullSport = [self theNumberOfExecutionStatus:arraySport andState:0];
    
    NSArray *arrayEat = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:daysRecord withType:RecordTypeBreakfirst withCurrentDate:date];
    NSInteger nullEat = [self theNumberOfExecutionStatus:arrayEat andState:0];
    return MAX(arrayEat.count-nullEat, arraySport.count-nullSport);
}

- (NSInteger)theNumberOfExecutionStatus:(NSArray *)array andState:(NSInteger) state
{
    NSInteger numWeek = 0;
    for (int i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i]integerValue] == state) {
            numWeek ++;
        }
    }
    return numWeek;
}

/**
 *  获取完成计划的天数
 *
 *  @param days 过去多少天的
 *  @param date 此时间点之前的
 *
 *  @return 这个区间完成计划的天数
 */
-(NSInteger)getPerfectDays:(NSInteger)daysAchieve curDate:(NSDate *)date{
    NSInteger j = 0;
    
    NSDictionary *dicSport = [[XKRWRecordService4_0 sharedService] getSchemeStatesOfDays:daysAchieve withType:RecordTypeSport withDate:date];
    
    NSDictionary *dicEat = [[XKRWRecordService4_0 sharedService] getSchemeStatesOfDays:daysAchieve withType:RecordTypeBreakfirst withDate:date];
    
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
    NSInteger daysHasRecord = [NSDate daysBetweenDate:createDate andDate:_date];
    
    return [NSNumber numberWithInteger:daysHasRecord + 1];
}

@end
