//
//  XKRWWeightService.m
//  XKRW
//
//  Created by Jiang Rui on 14-3-12.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWWeightService.h"
#import "ASIHTTPRequest.h"

#import "JSONKit.h"
#import "XKRWBusinessException.h"
#import "XKRWUserService.h"
#import "XKRWUserDefaultService.h"

#define kTimeoutTime 13

static XKRWWeightService *shareInstance;
@implementation XKRWWeightService
//单例
+(id)shareService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWWeightService alloc]init];
    });
    return shareInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark 体重记录
- (float) weeklyLoseWeight{
    float weight = [[XKRWUserService sharedService] getWeightChange];

    
    NSDate * oldst = [NSDate dateFromString:[self getOldDate] withFormat:@"yyyyMMdd"];
    NSDate *todaydate = [NSDate today];
    float timePass = [todaydate timeIntervalSinceDate:oldst];
    
    int week = abs(timePass/(7*24*60*60));
    if (week<1) {
        week = 1;
    }
    return weight/week;
}

//平均每周减肥 计算
-(float)weeklyLoseWeightSpeed
{
    float weight = [[XKRWUserService sharedService] getWeightChange];

    NSInteger holdDays = [[XKRWUserService sharedService] getInsisted];
    if (holdDays < 7) {
        holdDays = 7 ;
    }
    NSInteger week =  round(holdDays / 7.0); //四舍五入
    
    CGFloat weekLose = weight / week ;
    return weekLose;
}


- (void)saveWeightRecord:(NSString *)weight date:(NSDate *)weightDate sync:(NSString *)sync andTimeRecord:(NSDate *)recordTime
{
    if (![weight intValue]) {
        return;
    }
    time_t unixTime = 0;
    
    if (recordTime) {
        
        NSString * string = [recordTime stringWithFormat:@"yyyy-MM-dd"];
        unixTime = (time_t) [[NSDate dateFromString:string] timeIntervalSince1970];
        
    }else{
        
        NSDate * todayRecord = [NSDate date];
        NSString * string = [todayRecord stringWithFormat:@"yyyy-MM-dd"];
        unixTime = (time_t) [[NSDate dateFromString:string] timeIntervalSince1970];
    }
    
    NSString *wDate = [weightDate convertToStringWithFormat:@"yyyyMMdd"];
    NSString * sql = [NSString stringWithFormat:@"select timestamp from weightrecord where date = %@ and userid = %ld",wDate,(long)[XKRWUserDefaultService getCurrentUserId]];
    time_t timestamp =  [[[self fetchRow:sql] objectForKey:@"timestamp"] doubleValue] ;

    if (unixTime >= timestamp) {
        [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
            NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
            NSString *year = [weightDate convertToStringWithFormat:@"yyyy"];
            NSString *month = [weightDate convertToStringWithFormat:@"MM"];
            NSString *day = [weightDate convertToStringWithFormat:@"dd"];
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userid,@"userid",weight,@"weight",wDate,@"date",year,@"year",month,@"month",day,@"day",sync,@"sync",[NSNumber numberWithLong:unixTime],@"timestamp",nil];
            [db executeUpdate:@"REPLACE INTO weightrecord VALUES(:userid,:weight,:date,:year,:month,:day,:sync,:timestamp)" withParameterDictionary:dictionary];
        }];
    }else{
        
        XKLog(@"插入失败");
    
    }
    
    [self updateTheCurve];
}

-(void)updateTheCurve{
    
    NSString *oldValue = [self getOldWeight];
    NSString *youngValue =[self getCurrentWeightString];
    NSString *minValue = [self getMinWeight];
    NSString *maxValue = [self getMaxWeight];
    
    NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:oldValue,@"oldWeight",youngValue,@"youngWeight",minValue,@"minWeight",maxValue,@"maxWeight", nil];
    
    [[XKRWUserService sharedService] setUserWeightCurve:resultDic];
    [[XKRWUserService sharedService] saveUserWeightCurveData];
    
}
-(NSMutableArray *)getCurve{
    
    NSString *oldValue = [self getOldWeightFromACCount];
    
    NSString *youngValue =[self getCurrentWeightString];
    
    NSString *minValue = [self getMinWeight];
    
    NSString *maxValue = [self getMaxWeight];
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects:oldValue,maxValue,minValue,youngValue, nil];
    
    if (oldValue.length  == 0 && youngValue.length == 0 && minValue.length== 0 && maxValue.length== 0 ) {
        [array removeAllObjects];
    }
    
    
    return array;
}
- (NSArray *)getWeightRecordWithPreDate:(NSDate *)preDate nowDate:(NSDate *)nowDate nextDate:(NSDate *)nextDate
{
    NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM weightrecord WHERE (year = '%@' AND month = '%@' AND userid = '%@') OR (year = '%@' AND month = '%@' AND userid = '%@') OR (year = '%@' AND month = '%@' AND userid = '%@')",[preDate convertToStringWithFormat:@"yyyy"],[preDate convertToStringWithFormat:@"MM"],userid,[nowDate convertToStringWithFormat:@"yyyy"],[nowDate convertToStringWithFormat:@"MM"],userid,[nextDate convertToStringWithFormat:@"yyyy"],[nextDate convertToStringWithFormat:@"MM"],userid];
    
    NSArray *weightArray = [self queryData:sql];
    
    return weightArray;

}


-(NSArray *)getDayWeightRecord
{
     NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
    NSArray *array = nil;
    if (IS_IPHONE_5) {
        
        array = [self queryData:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by date desc limit 12;",userid]];
        
        }
    
    else
    {
        array = [self queryData:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by date desc limit 10;",userid]];
        
    }
    
    return array;
}


-(NSArray *)getWeekWeightRecord
{
    NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
    NSArray *array = nil;
    if (IS_IPHONE_5) {
        
         array = [self queryData:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by date desc limit 84;",userid]];
       
    }
    
    else
    {
        array = [self queryData:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by date desc limit 70;",userid]];
        
    }
    
    return array;
}


-(NSArray *)getMonthWeightRecord
{
    NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
    NSArray *array = nil;
    if (IS_IPHONE_5) {
        array = [self queryData:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by date desc limit 365;",userid]];
    }
    
    else
    {
         array = [self queryData:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by date desc limit 310;",userid]];
    }
    
    return array;
}

- (NSArray *) queryData:(NSString *)sql
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        FMResultSet *resultSet =  [db executeQuery:sql];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            [array addObject:dic];
        }
        
    }];
    
    return array;
    
}

- (void)deleteDataFromDB:(NSDate *)dd
{
    NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
    NSString *wDate = [dd convertToStringWithFormat:@"yyyyMMdd"];

    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *callBack){
    
       [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM weightrecord WHERE userid = '%@' AND date = '%@'",userid,wDate]];
        
    }];

    [self updateTheCurve];
    
}

//更新最早记录
- (void) updateOriWeight:(float)weight{
    //参数单位为克
    NSString *update = [NSString stringWithFormat:@"update `weightrecord` set weight = %f, sync = 0 where userid = '%ld' and date =(SELECT date  FROM `weightrecord` where userid = '%ld' order by date asc limit 1) ;",weight,(long)[[XKRWUserService sharedService] getUserId],(long)[[XKRWUserService sharedService] getUserId]];
    
    @try {
        
        if ([self executeSql:update]) {
            //更新本地用户数据
            [[XKRWUserService sharedService] setUserOrigWeight:weight];
            [[XKRWUserService sharedService] saveUserInfo];
            //上传数据
            [self batchUploadWeightToRemoteNeedLong:NO];
        }
    }
    @catch (NSException *exception) {
        
        XKLog(@"初始体重更新失败 %@",exception);
    }
    @finally {
        
    }

    
    //
}

//最早
- (NSString *)getOldWeight
{
   __block NSString *weight = @"";
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
        FMResultSet *resultSet =  [db executeQuery:[NSString stringWithFormat:@"SELECT weight FROM weightrecord where userid = '%@' order by date asc limit 1;",userid]];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            NSNumber  *number = [dic objectForKey:@"weight"];
            weight = [NSString stringWithFormat:@"%.1f",[number floatValue]/1000.0];
        }
        
    }];
    
    return weight;
}

//拿到最早注册的体重值   最初的体重  只要方案变了后才能 改变
- (NSString*)getStartingValueWeight
{
    __block NSString *weight = @"";
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
        FMResultSet *resultSet =  [db executeQuery:[NSString stringWithFormat:@"SELECT origweight FROM account where userid = '%@'limit 1;",userid]];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            NSNumber  *number = [dic objectForKey:@"origweight"];
            
            if ([number  integerValue]> 1000)
            {
                weight = [NSString stringWithFormat:@"%.1f",[number floatValue]/1000.0];

            }
            else
            {
                weight = [NSString stringWithFormat:@"%.1f",[number floatValue]];

            }
            
        }
        
    }];
    
    return weight;
}

- (NSString*)getOldWeightFromACCount
{
    __block NSString *weight = @"";
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
        FMResultSet *resultSet =  [db executeQuery:[NSString stringWithFormat:@"SELECT origweight FROM account where userid = '%@' order by date asc limit 1;",userid]];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            NSNumber  *number = [dic objectForKey:@"origweight"];
            

            weight = [NSString stringWithFormat:@"%.1f",[number floatValue]/1000.0];
            if ([number integerValue] < 200) { //有问题 
                weight = [NSString stringWithFormat:@"%.1f",[number floatValue]];

            }
        
            
        }
        
    }];
    
    return weight;

    
}

-(NSString *)getOldDate{
   
    NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
    NSString *resultSet =[NSString stringWithFormat:@"SELECT date FROM weightrecord where userid = '%@' order by date asc limit 1;",userid];
    NSDictionary *dicResult =  [self fetchRow:resultSet];
    return [dicResult objectForKey:@"date"];
}

-(NSString *)getOldMMdd{  // 20141122  2014-12-12

//    NSString * date = [self getOldDate];
//    if(date.length >0 && !([date rangeOfString:@"-"].length >0))
//    {
//         NSRange ran = {date.length- 4,4};
//        NSString  *str = [date substringWithRange:ran];
//        NSRange rangea = {0,2};
//        NSRange ranageDay = {2,2};
//        
//         str = [NSString stringWithFormat:@"%@/%@",[str substringWithRange:rangea],[str substringWithRange:ranageDay]];
//        return str;
//        
//    }
    NSString *temp = @"";
    NSString *dateStr = @"";
//    if (!date) {
        dateStr = [[XKRWUserService sharedService] getREGDate]; //带-的 2014-12-11
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    df.dateFormat = @"yyyy-MM-dd";
    NSInteger timestamp =(long) [[df dateFromString:dateStr]timeIntervalSince1970];
//    }
    if ([[XKRWUserService sharedService]getResetTime]) {
        NSInteger resetTime = [[[XKRWUserService sharedService]getResetTime] integerValue];
        if (timestamp < resetTime)
        {
           NSDate *crearDate  = [NSDate dateWithTimeIntervalSince1970:resetTime] ;
            dateStr = [df stringFromDate:crearDate];
        }
    }
    
    NSRange range = {dateStr.length- 5,5};
    temp  = [NSString stringWithString:[dateStr substringWithRange:range]];
  
        temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        if ([[temp substringToIndex:1] isEqualToString:@"/"])
        {
            NSRange range2 = {1,temp.length - 1};
            temp = [temp substringWithRange:range2];
        }
    
    return temp;
    
}


//4.0 最早的时间 体重时间
-(NSDate*)getOrWeightTime
{
    NSDate *oldDate;

    NSString *temp = @"";
    NSString *dateStr = @"";
//    if (!date) {
        dateStr = [[XKRWUserService sharedService] getREGDate];
        
//    }
    NSRange range = {dateStr.length- 5,5};
    temp  = [NSString stringWithString:[dateStr substringWithRange:range]];
    if([temp rangeOfString:@"-"].length > 0)
    {
        NSDateFormatter *df= [[NSDateFormatter alloc]init];
        df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        df.dateFormat = @"yyyy-MM-dd";
        oldDate = [df dateFromString:dateStr];
        
    }
    else
    {
        NSDateFormatter *df= [[NSDateFormatter alloc]init];
        df.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        df.dateFormat = @"yyyy/MM/dd";
        oldDate = [df dateFromString:dateStr];
    }
    
    NSInteger timestamp = [oldDate timeIntervalSince1970];
    if ([[XKRWUserService sharedService]getResetTime]) {
        NSInteger resetTime = [[[XKRWUserService sharedService]getResetTime] integerValue];
        if (timestamp < resetTime)
        {
            oldDate  = [NSDate dateWithTimeIntervalSince1970:resetTime];
        }
        
    }
    return oldDate;

}





-(NSString *)getNewMMdd{
    NSString * date = [[NSDate today] stringWithFormat:@"MM/dd"];
    return date;
}
-(float)weightDiscrepancy{
    return  [[self getOldWeight] floatValue] - [[self getCurrentWeightString] floatValue];
}
-(float)minWeight{
    return [[self getMinWeight] floatValue];
}
//最大
- (NSString *)getMaxWeight
{
    __block NSString *weight = @"";
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
        FMResultSet *resultSet =  [db executeQuery:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by weight desc limit 1;",userid]];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            NSNumber  *number = [dic objectForKey:@"weight"];
            weight = [NSString stringWithFormat:@"%.1f",[number floatValue]/1000.0];
        }
        
    }];
    return weight;

}

- (int) getMinValue{
    
   __block int weigt= 0;
    
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
        FMResultSet *resultSet =  [db executeQuery:[NSString stringWithFormat:@"SELECT weight,date FROM weightrecord where userid = '%@' order by weight asc limit 1;",userid]];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            NSNumber  *number = [dic objectForKey:@"weight"];
            weigt = [number intValue];
        }
        
    }];
    return weigt;
}
//最小
- (NSString *)getMinWeight
{
     NSString *weight = @"";
    weight = [NSString stringWithFormat:@"%.1f",[self getMinValue]/1000.0];
    return weight;

}
//当前
- (NSString *)getCurrentWeightString
{
    __block NSString *weight = @"";
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        NSString *userid = [NSString stringWithFormat:@"%li",(long)[[XKRWUserService sharedService] getUserId]];
        FMResultSet *resultSet =  [db executeQuery:[NSString stringWithFormat:@"SELECT weight FROM weightrecord where userid = '%@' order by date desc limit 1;",userid]];
        
        while ([resultSet next])
        {
            NSDictionary  *dic = resultSet.resultDictionary;
            NSNumber  *number = [dic objectForKey:@"weight"];
            if (number) {
                [[XKRWUserService sharedService] setCurrentWeight:[number floatValue]];
            }

            weight = [NSString stringWithFormat:@"%.1f",[number floatValue]/1000.0];
        }
        
    }];
    return weight;
}


/**
 *  获取离date最近日期的体重记录，4.0之前版本getUserCurrentWeight有时会有数据错误，可以改用此接口获取当前体重
 */
- (float)getNearestWeightRecordOfDate:(NSDate *)date
{
    NSInteger uid = [[XKRWUserService sharedService] getUserId];
//    NSDate *resetTime = [NSDate dateWithTimeIntervalSince1970:[[[XKRWUserService sharedService] getResetTime] integerValue]];
//    int dateFormat = [[date stringWithFormat:@"yyyyMMdd"] intValue];
    
    {
        NSString *dateStr = [NSDate stringFromDate:date withFormat:@"yyyyMMdd"];
        NSString *searchWeightRecordSql = [NSString stringWithFormat:@"SELECT date, weight FROM weightrecord WHERE userid = %ld AND date <= %@ ORDER BY date DESC LIMIT 1",(long)uid, dateStr];
        NSArray *weightRecordRecord = [self query:searchWeightRecordSql];
    
        NSString *origWeightSql = [NSString stringWithFormat:@"SELECT date, origweight FROM account WHERE userid = %ld", (long)uid];
        NSArray *result = [self query:origWeightSql];
        

        
        NSDate *origRecordDate = [NSDate dateWithTimeIntervalSince1970:[[[XKRWUserService sharedService] getResetTime] integerValue]];
        NSDate *weightRecordDate = [NSDate dateFromString:weightRecordRecord.firstObject[@"date"] withFormat:@"yyyyMMdd"];
        
        if ([origRecordDate isDayEqualToDate:date]) {
            searchWeightRecordSql = [NSString stringWithFormat:@"SELECT date, weight FROM weightrecord WHERE userid = %ld AND date = %@ ORDER BY date DESC LIMIT 1",(long)uid, dateStr];
            weightRecordRecord = [self query:searchWeightRecordSql];
            if (weightRecordRecord) {
                return [weightRecordRecord.firstObject[@"weight"] floatValue]/1000.f ;
            }else{
                return [result.firstObject[@"origweight"] floatValue]/1000.f ;
            }
        }else if ([date compare:origRecordDate] == NSOrderedDescending) {
            if ( [weightRecordDate compare:origRecordDate] == NSOrderedAscending || weightRecordRecord ==nil ||weightRecordRecord.count ==0 ) {
                return [result.firstObject[@"origweight"] floatValue]/1000.f ;
            }else{
                return [weightRecordRecord.firstObject[@"weight"] floatValue]/1000.f ;
            }
        } else {
            if (weightRecordRecord!=nil && weightRecordRecord.count > 0) {
                return [weightRecordRecord.firstObject[@"weight"] floatValue]/1000.f ;
            }
            return [result.firstObject[@"origweight"] floatValue]/1000.f ;
        }

    }

//
//
//    NSString *sql = nil;
//    if ([date timeIntervalSince1970] < [resetTime timeIntervalSince1970]) {
//        sql = [NSString stringWithFormat:@"SELECT date, weight FROM weightrecord WHERE userid = %ld AND date <= %d ORDER BY date DESC LIMIT 1", (long)uid, dateFormat];
//        
//        NSArray *result = [self query:sql];
//        
//        if (!result || !result.count) {
//            return [[XKRWUserService sharedService] getUserOrigWeight] / 1000.f;
//        }
//        return [result[0][@"weight"] floatValue] / 1000.f;
//    } else {
//        int resetDateFormat = [[resetTime stringWithFormat:@"yyyyMMdd"] intValue];
//        
//        float todayWeight =   [self getWeightRecordWithDate:date];
//        
//        if (todayWeight != 0) {
//            return todayWeight;
//        }else{
//            sql = [NSString stringWithFormat:@"SELECT date, origweight FROM account WHERE userid = %ld", (long)uid];
//            NSArray *result = [self query:sql];
//            if (result) {
//                NSTimeInterval timeDate = [result[0][@"date"] integerValue];
//                NSDate *todayDate = [NSDate today];
//                if (timeDate >= [todayDate timeIntervalSince1970] && timeDate < [todayDate timeIntervalSince1970] + 60 * 60 *24) {
//                    NSInteger  origweight = [result[0][@"origweight"] integerValue];
//                    return origweight /1000.f;
//                }else{
//                    sql = [NSString stringWithFormat:@"SELECT date, weight FROM weightrecord WHERE userid = %ld AND date < %d AND date >= %d ORDER BY date DESC LIMIT 1", (long)uid, dateFormat, resetDateFormat];
//                    NSArray *result = [self query:sql];
//                    if (!result || !result.count) {
//                        return [[XKRWUserService sharedService] getUserOrigWeight] / 1000.f;
//                    }
//                    return [result[0][@"weight"] floatValue] / 1000.f;
//                }
//            }else{
//                XKLog(@"获取初始体重失败...");
//                return 0;
//            }
//        }
//    }
}

- (NSInteger) getCreateTimeOfDate:(NSDate *)date {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    int dateFormat = [[date stringWithFormat:@"yyyyMMdd"] intValue];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * From weightrecord where userid = %ld AND date = %d",(long)uid,dateFormat];
    
    NSArray *array = [self query:sql];
    
    if (array.count) {
        return [array.firstObject[@"timestamp"] integerValue];
    }
    return 0;

}

- (float)getWeightRecordWithDate:(NSDate *)date {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    int dateFormat = [[date stringWithFormat:@"yyyyMMdd"] intValue];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM weightrecord WHERE userid = %ld AND date = %d",(long)(long)uid,dateFormat];
    NSArray *array = [self query:sql];
    if (array.count) {
        return [array.firstObject[@"weight"] floatValue] / 1000.f;
    } else return 0.f;
}
@end
