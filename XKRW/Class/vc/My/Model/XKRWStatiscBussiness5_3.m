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

/**
 *  注册日期
 *
 *  @return 注册日期str 2014-12-12
 */
-(NSString *)dateRegisterStr{
    if (!_dateRegisterStr) {
        _dateRegisterStr = [[XKRWUserService sharedService] getREGDate];
    }
    return _dateRegisterStr;
}

/**
 *  重置方案时间
 *
 *  @return 方案重置的time interval
 */
-(NSNumber *)resetTime{
    if (_resetTime == 0) {
        NSDate *startDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"StartTime_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
        _resetTime = [NSNumber numberWithInteger:[startDate timeIntervalSince1970]];
    }
    return _resetTime;
}

/**
 *  日期格式
 *
 *  @return 标准日期格式
 */
-(NSDateFormatter *)dateFormat{
    if (!_dateFormat) {
        _dateFormat = [[NSDateFormatter alloc]init];
        _dateFormat.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        _dateFormat.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFormat;
}

/**
 *  方案总开始天数
 *
 *  @return 天数 NSNumber
 */
-(NSNumber *)totalDays{
    if (!_totalDays) {
        _totalDays = [self getTotalHasRecordDays];
    }
    return _totalDays;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
        if (self.totalDays != 0) {
            _totalNum = self.totalDays.integerValue / 7.0;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self statiscEntity];
//            });
        }else{
            _totalNum = 0;
        }
    }
    return self;
}

//周计划
-(NSMutableDictionary *)dicEntities{
    if (!_dicEntities) {
        _dicEntities = [NSMutableDictionary dictionaryWithCapacity:_totalNum];
    }
    return _dicEntities;
}

//日期dic
-(NSDictionary *)dicPicker{
    if (!_dicPicker) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:_totalNum];
        for (NSInteger i = 0; i < _totalNum; i++) {
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
        entity.dateRange = [self getStatiscDateStr];
        entity.arrDaysDate = [self getAllDaysInIndex];
        
        entity.weight = [self getCurrentWeight];
        entity.weightChange = [self getTotalWeightChange];
        
        
        entity.normalIntake = [NSNumber numberWithFloat:[self getNormalIntake:entity]];
        entity.actualIntake = [NSNumber numberWithFloat:[self getActualRangeIntake:entity]];
        entity.recommondIntake = [NSNumber numberWithFloat:[self getRecommondIntake:entity]];
        entity.decreaseIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.actualIntake.floatValue)];
        entity.targetIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.recommondIntake.floatValue)];
        
        entity.decreaseSport = [NSNumber numberWithFloat:[self getActualRangeSport:entity]];
        entity.targetSport = [NSNumber numberWithFloat:[self getRecommondSport:entity]];
        entity.timeSport = [NSNumber numberWithInteger:[self getSportTotalTime:entity.arrDaysDate]];
        entity.dayRecord = [NSNumber numberWithInteger:[self getHasRecordDays:entity]];
        ;
        entity.dayAchieve = [NSNumber numberWithInteger:[self getPerfectDays:entity]];
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
    entity.num = _totalNum;
    entity.dateRange = [self getDateRange:i];
   
    entity.arrDaysDate = [self getWeekDaysInIndex:i];
    entity.weight = [self getWeightSpecific:entity.arrDaysDate];
    entity.weightChange = [self getWeekWeightChange:entity.arrDaysDate];
    entity.normalIntake = [NSNumber numberWithFloat:[self getNormalIntake:entity]];
    entity.actualIntake = [NSNumber numberWithFloat:[self getActualRangeIntake:entity]];
    entity.recommondIntake = [NSNumber numberWithFloat:[self getRecommondIntake:entity]];
    entity.decreaseIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.actualIntake.floatValue)];
    entity.targetIntake = [NSNumber numberWithFloat:(entity.normalIntake.floatValue - entity.recommondIntake.floatValue)];
    entity.isAchieveIntakeTarget = entity.decreaseIntake.floatValue - entity.targetIntake.floatValue >= 0 ? YES : NO;
    entity.decreaseSport = [NSNumber numberWithFloat:[self getActualRangeSport:entity]];
    entity.targetSport = [NSNumber numberWithFloat:[self getRecommondSport:entity]];
    entity.timeSport = [NSNumber numberWithInteger:[self getSportTotalTime:entity.arrDaysDate]];
    entity.isAchieveSportTarget = entity.decreaseSport.floatValue >= entity.targetSport.floatValue *.9 ? YES : NO;
    entity.dayRecord = [NSNumber numberWithInteger:[self getHasRecordDays:entity]];
    entity.dayAchieve = [NSNumber numberWithInteger:[self getPerfectDays:entity]];
    return entity;
}

#pragma mark calculateMethod
/**
 *  获取统计分析开始日期
 *
 *  @return 开始日期的nsstring
 */
-(NSString *)getStatiscDateStr{
    NSDate *createDate = [NSDate date];
    if (self.resetTime.integerValue != 0) {
        createDate = [NSDate dateWithTimeIntervalSince1970:self.resetTime.integerValue];
    }
    return [NSString stringWithFormat:@"%@-至今",[self.dateFormat stringFromDate:createDate]];
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
    NSInteger timestamp =(long) [[self.dateFormat dateFromString:self.dateRegisterStr] timeIntervalSince1970];

    if (self.resetTime) {
        if (timestamp < self.resetTime.integerValue)
        {
            NSArray *arr = [self getWeekDaysInIndex:index];
            dateStart = [self.dateFormat stringFromDate:[arr lastObject]];
            dateEnd = [self.dateFormat stringFromDate:[arr firstObject]];
        }
    }
     NSString *dateRange = @"";
    if ([dateStart isEqualToString:dateEnd]) {
        dateRange = dateStart;
    }else{
        dateRange = [NSString stringWithFormat:@"第%ld周 %@-%@",(long)(index+1),dateStart,dateEnd];
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
    NSInteger timestamp =(long) [[self.dateFormat dateFromString:self.dateRegisterStr] timeIntervalSince1970];
    if (self.resetTime) {
        if (timestamp < self.resetTime.integerValue)
        {
            return [NSDate dateWithTimeIntervalSince1970:self.resetTime.integerValue-DrecreaseDateInterval*index];
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
    NSInteger timestamp =(long) [[self.dateFormat dateFromString:self.dateRegisterStr] timeIntervalSince1970];
    if (self.resetTime) {
        if (timestamp < self.resetTime.integerValue)
        {
            NSDate *crearDate  = [NSDate dateWithTimeIntervalSince1970:self.resetTime.integerValue-DrecreaseDateInterval*index];
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
    NSDate *endDate = [NSDate date];
    NSDate *createDate  = [[NSDate dateWithTimeIntervalSince1970:self.resetTime.integerValue] offsetDay:Days*index];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:Days];
    for (int i = 0 ; i < Days; i++) {
        NSDate *date = [createDate offsetDay:i];
        [arr addObject:date];
        if ([date isDayEqualToDate:endDate]) {
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
    NSInteger daysRecord = [self.totalDays integerValue];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:daysRecord];
    for (int i = 0 ; i < daysRecord; i++) {
        NSDate *date = [[NSDate date] offsetDay:-i];
        [arr addObject:date];
    }
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *p1 = (NSDate*)obj1;
        NSDate *p2 = (NSDate*)obj2;
        if ([p1 earlierDate:p2]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([p2 earlierDate:p1]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    return arr;
}

-(CGFloat)getCurrentWeight{
    CGFloat currentWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]];
    return currentWeight;
}

/**
 *  获取该周最新记录的体重
 *
 *  @param i 第几周
 *
 *  @return 体重
 */
-(CGFloat)getWeightSpecific:(NSArray *)arrDate{
    NSDate *date = [arrDate firstObject];
    CGFloat weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:date];
    return weight;
}


/**
 *  获取总体体重记录变化
 *
 *  @return 变化值
 */
-(CGFloat)getTotalWeightChange{
    if (_statiscEntity.arrDaysDate.count == 1) {
        return 0;
    }
    CGFloat currentWeight = [self getCurrentWeight];
    NSDate *earlyDate = [[NSDate date] dateByAddingTimeInterval:-DateInterval];
    CGFloat earlyWeight = [[XKRWWeightService shareService] getWeightRecordWithDate:earlyDate];
    if (earlyWeight == 0) {
        earlyWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:earlyDate];
    }
    return (currentWeight - earlyWeight);
}

/**
 *  获取周体重的变化值
 *
 *  @param arrDate 传入的该周的日期数组
 *
 *  @return 该周的变化值
 */
-(CGFloat)getWeekWeightChange:(NSArray *)arrDate{
    if (arrDate.count == 1) {
        return 0;
    }
    NSDate *earlyDate = [arrDate lastObject];
    CGFloat earlyWeight = [[XKRWWeightService shareService] getWeightRecordWithDate:earlyDate];
    if (earlyWeight == 0) {
        earlyWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:earlyDate];
    }
    
    NSDate *laterDate = [arrDate firstObject];
    CGFloat laterWeight = [[XKRWWeightService shareService] getWeightRecordWithDate:laterDate];
    if (laterWeight == 0) {
        laterWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:earlyDate];
    }
    
    return (laterWeight - earlyWeight);
}

/**
 *  获取记录过的天数
 *
 *  @param days 过去多少天的
 *  @param date 此时间点之前的
 *
 *  @return 这个区间记录过的天数
 */
-(NSInteger)getHasRecordDays:(XKRWStatiscEntity5_3 *)entity{
    NSInteger j = 0;    
    NSArray *arrIntake = [entity.dicActualIntake allKeys];
    NSArray *arrSport = [entity.dicSportActual allKeys];
    
    if (arrIntake.count < arrSport.count) {
        for (NSString *date in arrIntake) {
            if ([arrSport containsObject:date]) {
                j++;
            }
        }
    }else{
        for (NSString *date in arrSport) {
            if ([arrIntake containsObject:date]) {
                j++;
            }
        }
    }
    return j;

//    NSArray *arraySport = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:daysRecord withType:RecordTypeSport withCurrentDate:date];
//    NSInteger nullSport = [self theNumberOfExecutionStatus:arraySport andState:0];
//    
//    NSArray *arrayEat = [[XKRWRecordService4_0 sharedService]getSchemeStateOfNumberOfDays:daysRecord withType:RecordTypeBreakfirst withCurrentDate:date];
//    NSInteger nullEat = [self theNumberOfExecutionStatus:arrayEat andState:0];
//    return MAX(arrayEat.count-nullEat, arraySport.count-nullSport);
}

//- (NSInteger)theNumberOfExecutionStatus:(NSArray *)array andState:(NSInteger) state
//{
//    NSInteger numWeek = 0;
//    for (int i = 0; i < [array count]; i++) {
//        if ([[array objectAtIndex:i]integerValue] == state) {
//            numWeek ++;
//        }
//    }
//    return numWeek;
//}

/**
 *  获取完成计划的天数
 *
 *  @return 完成计划的天数
 */
-(NSInteger)getPerfectDays:(XKRWStatiscEntity5_3 *)entity{
    NSInteger j = 0;
    XKSex sex = [[XKRWUserService sharedService] getSex];
    float limit = sex == 0?1400:1200;
    
    NSMutableDictionary *dicIntake = [NSMutableDictionary dictionary];
    for (NSString *dateStr in [entity.dicActualIntake allKeys]) {
        NSNumber *actualIntake = [entity.dicActualIntake objectForKey:dateStr];
        NSNumber *recommondIntake = [entity.dicRecommondIntake objectForKey:dateStr];
        if (actualIntake.floatValue >= limit){
            if (recommondIntake.integerValue >= actualIntake.floatValue) {
                [dicIntake setObject:actualIntake forKey:dateStr];
            }
        }
    }
    
    NSMutableDictionary *dicSport = [NSMutableDictionary dictionary];
    for (NSString *dateStr in [entity.dicSportActual allKeys]) {
        NSNumber *actualSport = [entity.dicSportActual objectForKey:dateStr];
        NSNumber *recommondSport = [entity.dicSportRecommond objectForKey:dateStr];
        if (actualSport.floatValue >= recommondSport.floatValue) {
            [dicSport setObject:actualSport forKey:dateStr];
        }
    }
    
    NSArray *arrIntake = [dicIntake allKeys];
    NSArray *arrSport = [dicSport allKeys];
    
    if (arrIntake.count < arrSport.count) {
        for (NSString *date in arrIntake) {
            if ([arrSport containsObject:date]) {
                j++;
            }
        }
    }else{
        for (NSString *date in arrSport) {
            if ([arrIntake containsObject:date]) {
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
-(CGFloat)getNormalIntake:(XKRWStatiscEntity5_3 *)entity{
    CGFloat cal =  [XKRWAlgolHelper dailyIntakEnergyOfDates:entity];
    return cal;
}

/**
 *  获取实际摄入的kcal数值
 *
 *  @param arrDate 日期构成的数组
 *
 *  @return 饮食摄入总kcal
 */
-(CGFloat)getActualRangeIntake:(XKRWStatiscEntity5_3 *)entity {
    CGFloat cal = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:efoodCalories andDates:entity];
    return cal;
}

/**
 *  获取一周内推荐摄入
 *
 *  @param arrDate 该周内
 *
 *  @return 总推荐摄入kcal
 */
-(CGFloat)getRecommondIntake:(XKRWStatiscEntity5_3 *)entity{
    CGFloat cal =  [XKRWAlgolHelper dailyIntakeRecomEnergyOfDates:entity];
    return cal;
}

/**
 *  获取一周内推荐运动消耗
 *
 *  @param arrDate 该周内
 *
 *  @return 总推荐运动消耗kcal
 */
-(CGFloat)getRecommondSport:(XKRWStatiscEntity5_3 *)entity{
    CGFloat cal =  [XKRWAlgolHelper dailyConsumeSportEnergyOfDates:entity];
    return cal;
}

/**
 *  获取实际运动消耗的kcal数值
 *
 *  @param arrDate 日期构成的数组
 *
 *  @return 运动消耗总kcal
 */
-(CGFloat)getActualRangeSport:(XKRWStatiscEntity5_3 *)entity{
    CGFloat cal = [[XKRWRecordService4_0 sharedService] getTotalCaloriesWithType:eSportCalories andDates:entity];
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
    NSInteger timestamp =(long) [[self.dateFormat dateFromString:self.dateRegisterStr] timeIntervalSince1970];
    
    if (self.resetTime.integerValue != 0) {
        if (timestamp < self.resetTime.integerValue) {
            NSDate *createDate  = [NSDate dateWithTimeIntervalSince1970:self.resetTime.integerValue];
            NSInteger daysHasRecord = [NSDate daysBetweenDate:createDate andDate:_date];
            return [NSNumber numberWithInteger:daysHasRecord + 1];
        }
    }
    return 0;
}

@end
