//
//  XKRWRecordService4_0.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordService4_0.h"
#import "JSONKit.h"
#import "NSDictionary+XKUtil.h"
#import "XKRWUserService.h"
#import "XKRW-Swift.h"

#import "XKRWNeedLoginAgain.h"
#import "MobClick.h"
#import "XKRWAlgolHelper.h"

static NSString *recordTable         = @"record_4_0";
static NSString *foodRecordTable     = @"food_record";
static NSString *sportRecordTable    = @"sport_record";
static NSString *customFoodReocrdTB  = @"custom_food_record";
static NSString *customSportRecordTB = @"custom_sport_record";

//记录食物操作sql语句
static NSString *insertFoodRecordSql = @"INSERT INTO food_record (uid, food_id, food_name, record_type, calorie, number, unit, image_url, food_energy, server_id, date, sync, number_new, unit_new) VALUES (:uid, :food_id, :food_name, :record_type, :calorie, :number, :unit, :image_url, :food_energy, :server_id, :date, :sync, :number_new, :unit_new)";
static NSString *updateFoodRecordSql = @"REPLACE INTO food_record (rid, uid, food_id, food_name, record_type, calorie, number, unit, image_url, food_energy, server_id, date, sync, number_new, unit_new) VALUES (:rid, :uid, :food_id, :food_name, :record_type, :calorie, :number, :unit, :image_url, :food_energy, :server_id, :date, :sync, :number_new, :unit_new)";
static NSString *deleteFoodRecordSql = @"DELETE FROM food_record WHERE rid = :rid";

//记录运动操作sql语句
static NSString *insertSportRecordSql = @"INSERT INTO sport_record (uid, sport_id, sport_name, record_type, calorie, number, unit, image_url, sport_METS, server_id, date, sync) VALUES (:uid, :sport_id, :sport_name, :record_type, :calorie, :number, :unit, :image_url, :sport_METS, :server_id, :date, :sync)";
static NSString *updateSportRecordSql = @"REPLACE INTO sport_record (rid, uid, sport_id, sport_name, record_type, calorie, number, unit, image_url, sport_METS, server_id, date, sync) VALUES (:rid, :uid, :sport_id, :sport_name, :record_type, :calorie, :number, :unit, :image_url, :sport_METS, :server_id, :date, :sync)";
static NSString *deleteSportRecordSql = @"DELETE FROM sport_record WHERE rid = :rid";

//记录自定义食物sql语句
static NSString *insertCustomFoodSql = @"INSERT INTO custom_food_record (uid, food_id, food_name, type, number, unit, calorie, server_id, date, sync) VALUES (:uid, :food_id, :food_name, :type, :number, :unit, :calorie, :server_id, :date, :sync)";
static NSString *updateCustomFoodSql = @"REPLACE INTO custom_food_record (rid, uid, food_id, food_name, type, number, unit, calorie, server_id, date, sync) VALUES (:rid, :uid, :food_id, :food_name, :type, :number, :unit, :calorie, :server_id, :date, :sync)";
static NSString *deleteCustomFoosSql = @"DELETE FROM custom_food_record WHERE rid = :rid";

//记录自定义运动SQL语句
static NSString *insertCustomSportSql = @"INSERT INTO custom_sport_record (uid, sport_id, sport_name, number, unit, calorie, server_id, date, sync) VALUES (:uid, :sport_id, :sport_name, :number, :unit, :calorie, :server_id, :date, :sync)";
static NSString *updateCustomSportSql = @"REPLACE INTO custom_sport_record (rid, uid, sport_id, sport_name, number, unit, calorie, server_id, date, sync) VALUES (:rid, :uid, :sport_id, :sport_name, :number, :unit, :calorie, :server_id, :date, :sync)";
static NSString *deleteCustomSportSql = @"DELETE FROM custom_sport_record WHERE rid = :rid";

//记录其他详情SQL语句
static NSString *insertRecordSql = @"REPLACE INTO record_4_0 (uid, weight, habit, menstruation, sleep_time, get_up_time, water, mood, remark, waistline, bust, hipline, arm, thigh, shank, date, sync) VALUES (:uid, :weight, :habit, :menstruation, :sleep_time, :get_up_time, :water, :mood, :remark, :waistline, :bust, :hipline, :arm, :thigh, :shank, :date, :sync)";
static NSString *updateRecordSql = @"REPLACE INTO record_4_0 (rid, weight, uid, habit, menstruation, sleep_time, get_up_time, water, mood, remark, waistline, bust, hipline, arm, thigh, shank, date, sync) VALUES (:rid, :weight, :uid, :habit, :menstruation, :sleep_time, :get_up_time, :water, :mood, :remark, :waistline, :bust, :hipline, :arm, :thigh, :shank, :date, :sync)";
static NSString *deleteRecordSql = @"DELETE FROM record_4_0 WHERE rid = :rid";

//==================================================================================================================


static XKRWRecordService4_0 *sharedInstance = nil;

@interface XKRWRecordService4_0 ()

@end

@implementation XKRWRecordService4_0

+ (id)sharedService
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[XKRWRecordService4_0 alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Web Service Operation
#pragma mark - Download from Remote

- (NSDictionary *)downloadFromRemoteFromdate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    uint32_t startTime;
    uint32_t endTime;
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone | NSCalendarUnitCalendar fromDate:fromDate];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:1];
    
    NSDate *_date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    startTime = (uint32_t)[_date timeIntervalSince1970];
    
    if ([toDate isDayEqualToDate:[NSDate date]]) {
        
        endTime = (uint32_t)[toDate timeIntervalSince1970];
    } else {
        comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone | NSCalendarUnitCalendar fromDate:toDate];
        [comps setHour:23];
        [comps setMinute:59];
        [comps setSecond:59];
        
        _date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        endTime = (uint32_t)[_date timeIntervalSince1970];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kNewServer, kGetUserRecord_5_0];
    NSDictionary *dic;
    
    NSDictionary *param = @{@"date_start": [NSNumber numberWithUnsignedInt:startTime],
                            @"date_end": [NSNumber numberWithUnsignedInt:endTime]};
    
    dic = [self syncBatchDataWith:[NSURL URLWithString:URLString]
                      andPostForm:param];
    return dic;
}

- (BOOL)saveDownloadDataToDB:(NSDictionary *)dictionary
{
    __block int count = 0;
    uint32_t uid = (uint32_t)[XKRWUserDefaultService getCurrentUserId];
    
    NSArray *weight = dictionary[@"weight"];
    if ([weight isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary *weightDict in weight) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[weightDict[@"create_time"] intValue]];
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            temp_entity.uid  = uid;
            temp_entity.weight = [weightDict[@"value"] floatValue];
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                XKLog(@"同步所有数据时保存体重失败");
                @throw [NSException exceptionWithName:@"保存体重失败" reason:@"保存体重失败,数据库写入失败" userInfo:nil];
            }
        }
    }
    
    NSArray *circum = dictionary[@"circumference"];
    if ([circum isKindOfClass:[NSArray class]]) {
        for (NSDictionary *circumference in dictionary[@"circumference"]) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[circumference[@"create_time"] integerValue]];
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            temp_entity.circumference.waistline = [circumference[@"waistline"] floatValue];
            temp_entity.circumference.bust      = [circumference[@"bust"] floatValue];
            temp_entity.circumference.hipline   = [circumference[@"hipline"] floatValue];
            temp_entity.circumference.arm       = [circumference[@"arm"] floatValue];
            temp_entity.circumference.thigh     = [circumference[@"thigh"] floatValue];
            temp_entity.circumference.shank     = [circumference[@"shank"] floatValue];
            temp_entity.uid                     = uid;
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                XKLog(@"同步所有数据时保存围度失败");
                @throw [NSException exceptionWithName:@"保存围度失败" reason:@",保存围度失败数据库写入失败" userInfo:nil];
            }
        }
    }
    
    if ([dictionary[@"habit"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *habitDict in dictionary[@"habit"]) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[habitDict[@"create_time"] integerValue]];
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            [temp_entity splitHabitStringIntoArray:habitDict[@"value"]];
            temp_entity.uid = uid;
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                
                @throw [NSException exceptionWithName:@"保存习惯失败" reason:@",保存习惯失败,数据库写入失败" userInfo:nil];
            }
        }
    }
    
    if ([dictionary[@"sleep"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *sleep in dictionary[@"sleep"]) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[sleep[@"create_time"] integerValue]];
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            temp_entity.sleepingTime = [sleep[@"sleepingTime"] floatValue];
            
            NSString *getUpString = [NSString stringWithFormat:@"%@ %@", [recordDate stringWithFormat:@"yyyy-MM-dd"], sleep[@"getUp"]];
            temp_entity.getUp = [NSDate dateFromString:getUpString withFormat:@"yyyy-MM-dd HH:mm:ss"];
            temp_entity.uid = uid;
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                @throw [NSException exceptionWithName:@"保存睡眠记录失败" reason:@"保存睡眠记录失败,数据库写入失败" userInfo:nil];
            }
        }
    }
    
    if ([dictionary[@"water"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *water in dictionary[@"water"]) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[water[@"create_time"] integerValue]];
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            temp_entity.water = [water[@"value"] intValue];
            temp_entity.uid = uid;
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                @throw [NSException exceptionWithName:@"保存饮水记录失败" reason:@"保存饮水记录失败,数据库写入失败" userInfo:nil];
            }
        }
    }
    
    
    if ([dictionary[@"mood"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *mood in dictionary[@"mood"]) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[mood[@"create_time"] integerValue]];
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            temp_entity.mood = [mood[@"value"] intValue];
            temp_entity.uid = uid;
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                @throw [NSException exceptionWithName:@"保存心情记录失败" reason:@"保存心情记录失败,数据库写入失败" userInfo:nil];
            }
        }
    }
    
    if ([dictionary[@"remark"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *remark in dictionary[@"remark"]) {
            
            NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[remark[@"create_time"] integerValue]];
            
            XKRWRecordEntity4_0 *temp_entity = [self queryOtherRecord:recordDate][0];
            if (!temp_entity) {
                temp_entity = [[XKRWRecordEntity4_0 alloc] init];
                temp_entity.date = recordDate;
            }
            temp_entity.remark = remark[@"value"];
            temp_entity.uid = uid;
            temp_entity.sync = 1;
            count ++;
            if (![self recordInfomationToDB:temp_entity]) {
                @throw [NSException exceptionWithName:@"保存备注记录失败" reason:@"保存备注记录失败,数据库写入失败" userInfo:nil];
            }
        }
    }
    
    NSArray *record = [dictionary objectForKey:@"record"];
    
    
    if ([record isKindOfClass:[NSArray class]]) {
        if (record && record.count) {
            
            NSMutableArray *dateArray = [NSMutableArray array];
            
            for (NSDictionary *temp in record) {
                
                NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:[temp[@"create_time"] integerValue]];
                NSString *dateString = [tempDate stringWithFormat:@"yyyy-MM-dd"];
                
                if (dateString && dateString.length > 0) {
                    
                    if (![dateArray containsObject:dateString]) {
                        [dateArray addObject:dateString];
                    }
                }
            }
            
//            for (NSString *string in dateArray) {
//                NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %d AND date = '%@' AND sync = 1", foodRecordTable, uid, string];
//                [self executeSql:sql];
//                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %d AND date = '%@' AND sync = 1", sportRecordTable, uid, string];
//                [self executeSql:sql];
//            }
            
            NSMutableString *deleteFood = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE uid = %d AND sync = 1 AND date in (", foodRecordTable, uid];
            NSMutableString *deleteSport = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE uid = %d AND sync = 1 AND date in (", sportRecordTable, uid];
            
            BOOL isFirst = YES;
            for (NSString *string in dateArray) {
                
                if (isFirst) {
                    [deleteFood appendFormat:@"'%@'", string];
                    [deleteSport appendFormat:@"'%@'", string];
                    isFirst = NO;
                } else {
                    [deleteFood appendFormat:@",'%@'", string];
                    [deleteSport appendFormat:@",'%@'", string];
                }
            }
            
            [deleteFood appendString:@")"];
            [deleteSport appendString:@")"];
            
            [self executeSql:deleteFood];
            [self executeSql:deleteSport];
            
//            NSMutableArray *undownloadFood = [[NSMutableArray alloc] init];
//            NSMutableArray *undownloadSport = [[NSMutableArray alloc] init];
            
            NSMutableArray *foodRecords = [[NSMutableArray alloc] init];
            NSMutableArray *sportRecords = [[NSMutableArray alloc] init];
            
            for (NSDictionary *temp in record) {
                
                if ([temp.allKeys containsObject:@"type"]) {
                    
                    if ([temp[@"type"] intValue]) {
                        
                        XKRWRecordFoodEntity *foodEntity = [[XKRWRecordFoodEntity alloc] init];
                        
                        foodEntity.foodName   = temp[@"itemName"];
                        foodEntity.foodId     = [temp[@"itemId"] intValue];
                        foodEntity.recordType = [temp[@"type"] intValue];
                        foodEntity.number     = [temp[@"number"] intValue];
                        foodEntity.unit       = [temp[@"unit"] intValue];
                        foodEntity.calorie    = [temp[@"calorie"] intValue];
                        foodEntity.serverid   = [temp[@"create_time"] intValue];
                        foodEntity.sync       = 1;
                        foodEntity.date       = [NSDate dateWithTimeIntervalSince1970:[temp[@"create_time"] integerValue]];
                        foodEntity.uid        = uid;
                        
                        if (temp[@"new_unit"] && ![temp[@"new_unit"] isKindOfClass:[NSNull class]]) {
                            foodEntity.unit_new = temp[@"new_unit"];
                        }
                        
                        if (temp[@"new_number"] && ![temp[@"new_number"] isKindOfClass:[NSNull class]]) {
                            foodEntity.number_new = [temp[@"new_number"] integerValue];
                        }
                        
                        [foodRecords addObject:foodEntity];
                        
                        
                    } else {
                        
                        XKRWRecordSportEntity *sportEntity = [[XKRWRecordSportEntity alloc] init];
                        
                        sportEntity.sportName  = temp[@"itemName"];
                        sportEntity.sportId    = [temp[@"itemId"] intValue];
                        sportEntity.recordType = [temp[@"type"] intValue];
                        sportEntity.number     = [temp[@"number"] intValue];
                        sportEntity.unit       = [temp[@"unit"] intValue];
                        sportEntity.calorie    = [temp[@"calorie"] intValue];
                        sportEntity.serverid   = [temp[@"create_time"] intValue];
                        sportEntity.sync       = 1;
                        sportEntity.date       = [NSDate dateWithTimeIntervalSince1970:[temp[@"create_time"] integerValue]];
                        sportEntity.uid        = uid;
                        
                        [sportRecords addObject:sportEntity];

                    }
                }
            }
            
            if (foodRecords.count > 100) {
                
                NSUInteger count = foodRecords.count / 100;
                
                for (int i = 0; i <= count; i ++) {
                    
                    NSUInteger len = 100;
                    if (i == count) {
                        len = foodRecords.count % 100;
                    }
                    NSArray *save = [foodRecords subarrayWithRange:NSMakeRange(100 * i, len)];
                    
                    if ([self batchSaveFoodRecordToDB:save]) {
                        XKLog(@"批量保存食物成功");
                    }
                }
                
            } else {
                if ([self batchSaveFoodRecordToDB:foodRecords]) {
                    XKLog(@"批量保存食物成功");
                }
            }
            
            if (sportRecords.count > 100) {
                
                NSUInteger count = sportRecords.count / 100;
                
                for (int i = 0; i <= count; i ++) {
                    
                    NSUInteger len = 100;
                    if (i == count) {
                        len = sportRecords.count % 100;
                    }
                    NSArray *save = [sportRecords subarrayWithRange:NSMakeRange(100 * i, len)];
                    
                    if ([self batchSaveSportRecordToDB:save]) {
                        XKLog(@"批量保存运动成功");
                    }
                }
            } else {
                if ([self batchSaveSportRecordToDB:sportRecords]) {
                    XKLog(@"批量保存运动成功");
                }
            }
            
        }
    }
    
    NSArray *custom = dictionary[@"custom"];
    
    if ([custom isKindOfClass:[NSArray class]]) {
        if (custom && custom.count) {
            
            NSMutableArray *dateArray = [NSMutableArray array];
            
            for (NSDictionary *temp in custom) {
                
                NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:[temp[@"create_time"] integerValue]];
                NSString *dateString = [tempDate stringWithFormat:@"yyyy-MM-dd"];
                
                if (dateString && dateString.length > 0) {
                    
                    if (![dateArray containsObject:dateString]) {
                        [dateArray addObject:dateString];
                    }
                }
            }
            
            for (NSString *string in dateArray) {
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %d AND date = '%@'", customFoodReocrdTB, uid, string];
                [self executeSql:sql];
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %d AND date = '%@'", customSportRecordTB, uid, string];
                [self executeSql:sql];
            }
            
            for (NSDictionary *temp in custom) {
                XKRWRecordCustomEntity *entity = [[XKRWRecordCustomEntity alloc] init];
                
                entity.serverid   = [temp[@"create_time"] intValue];
                entity.name       = temp[@"itemName"];
                entity.number     = [temp[@"number"] intValue];
                entity.unit       = temp[@"unit"];
                entity.calorie    = [temp[@"calorie"] intValue];
                entity.recordType = [temp[@"type"] intValue];
                entity.date       = [NSDate dateWithTimeIntervalSince1970:[temp[@"create_time"] integerValue]];
                entity.uid        = uid;
                entity.sync       = 1;
                count ++;
                if (entity.recordType) {
                    if (![self recordCustomFoodToDB:entity]) {
                        
                        XKLog(@"保存自定义食物记录失败,数据库写入失败");
                    }
                } else {
                    if (![self recordCustomSportToDB:entity]) {
                        
                        XKLog(@"保存自定义运动记录失败,数据库写入失败");
                    }
                }
            }
        }
    }
    
    NSArray *scheme = dictionary[@"scheme"];
    
    if (scheme && [scheme isKindOfClass:[NSArray class]]) {
        if (scheme.count) {
            
            NSMutableString *sql = [NSMutableString stringWithString:@"REPLACE INTO record_scheme (create_time, uid, sid, type, calorie, record_value, sync, date) VALUES "];
            
            for (NSDictionary *temp in scheme) {
                
                if ([temp[@"value"] intValue] == 0) {
                    continue;
                }
                NSString *dateString = [[NSDate dateWithTimeIntervalSince1970:[temp[@"create_time"] intValue]] stringWithFormat:@"yyyy-MM-dd"];
                
                NSString *append = [NSString stringWithFormat:@"(%d, %d, %d, %d, %d, %d, %d, '%@'),",
                                    [temp[@"create_time"] intValue],
                                    uid,
                                    [temp[@"sid"] intValue],
                                    [temp[@"type"] intValue],
                                    [temp[@"calorie"] intValue],
                                    [temp[@"value"] intValue],
                                    1,
                                    dateString];
                [sql appendString:append];
            }
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
            
            [self executeSql:sql];
        }
    }
    
    if (count) {
        return YES;
    }
    return NO;
}

//- (NSArray *)getUserRecordDate
//{
//    NSMutableArray *result = [NSMutableArray array];
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServer, kGetRecordDay]];
//    
//    NSDictionary *response = [self syncBatchDataWith:url andPostForm:nil];
//    if (response[@"success"]) {
//        result = response[@"data"];
//        
//        return result;
//    }
//    return nil;
//}
#pragma mark - Save to remote

- (BOOL)batchSaveRecordToRemoteWithEntities:(NSArray *)entities type:(NSString *)type isImport:(BOOL)isImport {
    
    if (entities && entities.count > 0) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, @"/record/addmulti/"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        
        [param setObject:type forKey:@"type"];
        
        if (isImport) {
            [param setObject:@"yes" forKey:@"import"];
        }
    
        NSMutableArray *data = [NSMutableArray array];
        
        if ([type isEqualToString:@"scheme"]) {
            
            for (XKRWRecordSchemeEntity *entity in entities) {
                
                NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
                
                [post setObject:@(entity.create_time) forKey:@"create_time"];
                [post setObject:@(entity.record_value) forKey:@"value"];
                [post setObject:@(entity.sid) forKey:@"sid"];
                [post setObject:@(entity.type) forKey:@"type"];
                [post setObject:@(entity.calorie) forKey:@"calorie"];
                
                [data addObject:post];
            }
            NSString *postString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            
            [param setObject:postString forKey:@"data"];
            
            XKLog(@"----");
            NSDictionary *rst = [self syncBatchDataWith:url andPostForm:param];
            XKLog(@"----");
            if ([rst[@"success"] integerValue]) {
                return YES;
            }
            return NO;
        }
        // TODO: other type
    }
    return YES;
}

/**
 *  Base functoin, transfer data to remote server
 *
 *  @param dictionary data
 *  @param type       request type
 *  @param date       request date
 */
- (id)saveToRemote:(NSDictionary *)dictionary type:(NSString *)type date:(NSDate *)date
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kSaveUserRecord_5_0]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:type forKey:@"type"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = nil;
    if (jsonData.length) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        XKLog(@"记录服务错误: 请求数据异常");
        return nil;
    }
    [param setObject:jsonString forKey:@"data"];
    if (!date) {
        XKLog(@"记录页错误: 记录内容时间戳为空");
        return nil;
    }
//    [param setObject:[NSNumber numberWithInt:[date timeIntervalSince1970]] forKey:@"date"];

    //***************************************************
    // TODO: - Whether must be closure by try/catch, under the situation of failed and offline operation
    // if wants to call the super.handleDownloadProblem, remove the try/catch closure or throw the exception again.
    // if wants to do extra operation in RecordService_4_0 to provide better packaged function, retain the try/catch.
    //***************************************************
    @try {
        NSDictionary *response = [self syncBatchDataWith:url andPostForm:param];
        return response[@"success"];
    }
    @catch (NSException *exception) {
        
        return @NO;
    }
}
/**
 *  记录食物同步到服务器
 *
 *  @param entity 记录的食物实例
 */
- (BOOL)saveFoodRecordToRemote:(XKRWRecordFoodEntity *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithInteger:entity.foodId] forKey:@"itemId"];
    [dic setObject:entity.foodName forKey:@"itemName"];
    [dic setObject:[NSNumber numberWithInt:entity.recordType] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInteger:entity.number] forKey:@"number"];
    [dic setObject:[NSNumber numberWithInteger:entity.unit] forKey:@"unit"];
    [dic setObject:[NSNumber numberWithInteger:entity.calorie] forKey:@"calorie"];
    [dic setObject:[NSNumber numberWithInteger:entity.serverid] forKey:@"create_time"];
    
    if (entity.unit_new) {
        [dic setObject:@(entity.number_new) forKey:@"new_number"];
        [dic setObject:entity.unit_new forKey:@"new_unit"];
    }
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"record" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}
/**
 *  记录运动同步到服务器
 *
 *  @param entity 运动记录实例
 */
- (BOOL)saveSportRecordToRemote:(XKRWRecordSportEntity *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithUnsignedInt:entity.sportId] forKey:@"itemId"];
    [dic setObject:entity.sportName forKey:@"itemName"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInteger:entity.calorie] forKey:@"calorie"];
    [dic setObject:[NSNumber numberWithInteger:entity.number] forKey:@"number"];
    [dic setObject:[NSNumber numberWithInt:entity.unit] forKey:@"unit"];
    [dic setObject:[NSNumber numberWithInt:entity.serverid] forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"record" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveCustomFoodOrSportToRemote:(XKRWRecordCustomEntity *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:entity.name forKey:@"name"];
    [dic setObject:[NSNumber numberWithInteger:entity.number] forKey:@"number"];
    [dic setObject:entity.unit forKey:@"unit"];
    [dic setObject:[NSNumber numberWithInteger:entity.calorie] forKey:@"calorie"];
    [dic setObject:[NSNumber numberWithInt:entity.recordType] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:entity.serverid] forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"custom" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveSchemeRecordToRemote:(XKRWRecordSchemeEntity *)entity {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(entity.create_time) forKey:@"create_time"];
    [dic setObject:@(entity.record_value) forKey:@"value"];
    [dic setObject:@(entity.sid) forKey:@"sid"];
    [dic setObject:@(entity.type) forKey:@"type"];
    [dic setObject:@(entity.calorie) forKey:@"calorie"];
    
    BOOL isSuccess = [[self saveToRemote:dic
                                    type:@"scheme"
                                    date:[NSDate dateWithTimeIntervalSince1970:entity.create_time]] boolValue];
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}


- (BOOL)saveUniversalRecordToRemote:(XKRWUniversalRecordEntity *)entity {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(entity.create_time) forKey:@"create_time"];
    
    if (entity.type == RecordTypeScheme) {
        [dic setDictionary:entity.value];
    } else {
        XKLog(@"WRONG TYPE TO USE THIS INTERFACE");
        // currently do nothing with type except scheme
        return NO;
    }
    BOOL isSuccess = [[self saveToRemote:dic
                                    type:@"scheme"
                                    date:[NSDate dateWithTimeIntervalSince1970:entity.create_time]] boolValue];
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

//*********************************************
//MARK: - 下面的接口，所传的create_time为固定时间
//REASON: create_time即当天00:00的时间戳+固定秒数，目的是解决Android端create_time为单一主键导致记录
//        的记录create_time不可重复，如以后修改，建议create_time+type做联合主键。
//*********************************************

- (BOOL)saveWeightToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithFloat:entity.weight] forKey:@"value"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 1;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"weight" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:EnergyCircleDataNotificationName object:EffectFoodAndSportCircle];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReLoadTipsData object:nil];
    }
    return isSuccess;
}

- (BOOL)saveCircumferenceToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithFloat:entity.circumference.waistline] forKey:@"waistline"];
    [dic setObject:[NSNumber numberWithFloat:entity.circumference.bust] forKey:@"bust"];
    [dic setObject:[NSNumber numberWithFloat:entity.circumference.hipline] forKey:@"hipline"];
    [dic setObject:[NSNumber numberWithFloat:entity.circumference.arm] forKey:@"arm"];
    [dic setObject:[NSNumber numberWithFloat:entity.circumference.thigh] forKey:@"thigh"];
    [dic setObject:[NSNumber numberWithFloat:entity.circumference.shank] forKey:@"shank"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 2;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"circumference" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveHabitRecordToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[entity jointHabitString] forKey:@"value"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 3;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"habit" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveMenstruationToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithInt:entity.menstruation] forKey:@"value"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 4;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"menstruation" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveSleepingTimeToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithFloat:entity.sleepingTime] forKey:@"sleepingTime"];
    
    NSString *param = [NSDate stringFromDate:entity.getUp withFormat:@"HH:mm:ss"];
    [dic setObject:param forKey:@"getUp"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 5;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"sleep" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveGetUpToRemote:(XKRWRecordEntity4_0 *)entity
{
    return [self saveSleepingTimeToRemote:entity];
}

- (BOOL)saveWaterToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithInt:entity.water] forKey:@"value"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 6;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"water" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveMoodToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithInt:entity.mood] forKey:@"value"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 7;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"mood" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}

- (BOOL)saveRemarkToRemote:(XKRWRecordEntity4_0 *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:entity.remark forKey:@"value"];
    
    long timeStamp = (long)[entity.date originTimeOfADay] + 8;
    [dic setObject:@(timeStamp) forKey:@"create_time"];
    
    BOOL isSuccess = [[self saveToRemote:dic type:@"remark" date:entity.date] boolValue];
    
    if (isSuccess) {
        entity.sync = 1;
    }
    return isSuccess;
}



#pragma mark - Delete from remote

- (BOOL)deleteFromRemoteWithId:(NSInteger)_id recordType:(NSString *)recordType
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kNewServer, kSaveUserRecord_5_0];
    NSDictionary *param = @{@"del": @(_id),
                            @"type": recordType};
    NSDictionary *result;
    
    
    // TODO: - Same question with saveToRemote:type:date:
    @try {
        result = [self syncBatchDataWith:[NSURL URLWithString:urlString]
                             andPostForm:param];
        
        if (!result) {
#ifdef DEBUG
            XKLog(@"删除记录错误，请检查服务器地址，或服务器异常");
#endif
        }
        if (result[@"success"]) {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
#ifdef DEBUG
        XKLog(@"删除记录错误:%@", exception);
#endif
        if ([exception isKindOfClass:[XKRWNeedLoginAgain class]]) {
            @throw exception;
        }
        return NO;
    }
}

- (BOOL)deleteFoodRecordFromRemote:(XKRWRecordFoodEntity *)entity
{
    BOOL isSuccess = [self deleteFromRemoteWithId:entity.serverid recordType:@"record"];
    
    if (!isSuccess) {
        entity.sync = -1;
    }
    return isSuccess;
}

- (BOOL)deleteSportRecordFromRemote:(XKRWRecordSportEntity *)entity
{
    BOOL isSuccess = [self deleteFromRemoteWithId:entity.serverid recordType:@"record"];
    
    if (!isSuccess) {
        entity.sync = -1;
    }
    return isSuccess;
}

- (BOOL)deleteCustomRecordFromRemote:(XKRWRecordCustomEntity *)entity
{
    BOOL isSuccess = [self deleteFromRemoteWithId:entity.serverid recordType:@"custom"];
    
    if (!isSuccess) {
        entity.sync = -1;
    }
    return isSuccess;
}

- (BOOL)deleteSchemeRecordFromRemote:(XKRWRecordSchemeEntity *)entity {
    
    BOOL isSuccess = [self deleteFromRemoteWithId:entity.create_time recordType:@"scheme"];
    if (!isSuccess) {
        entity.sync = -1;
    }
    return isSuccess;
}

- (BOOL)deleteUniversalRecordFromRemote:(XKRWUniversalRecordEntity *)entity {
    
    BOOL isSuccess = [self deleteFromRemoteWithId:entity.create_time recordType:@"universal"];
    return isSuccess;
}

#pragma mark - SQLite Operation

#pragma mark - INSERT and UPDATE
/**
 *  插入、修改数据库操作
 *
 *  @param sqlArray SQL语句数组，index:0为更新操作语句，index:1为插入操作语句
 *  @param dict     参数字典
 *  @param flag     插入/删除标示
 *
 *  @return 是否成功
 */
- (int)writeDBWithSql:(NSArray *)sqlArray andParameter:(NSDictionary *)dict insertOrUpdate:(int)flag
{
    __block int rid = 0;
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        if (flag) {
            if ([db executeUpdate:sqlArray[0] withParameterDictionary:dict]) {
                
                XKLog(@"保存成功");
                rid = -1;
                
            } else {
                XKLog(@"保存失败");
            }
            
        } else if ([db executeUpdate:sqlArray[1] withParameterDictionary:dict]) {
            
            XKLog(@"添加成功");
            rid = (int)db.lastInsertRowId;
            
        } else {
            XKLog(@"保存失败");
        }
    }];
    return rid;
}

- (BOOL)recordFoodToDB:(XKRWRecordFoodEntity *)entity
{
    if (entity.calorie <= 0) {
        XKLog(@"记录卡路里异常");
        return NO;
    }
    NSDictionary *dict = [entity dictionaryInRecordTable];
    NSArray *sqlArray = @[updateFoodRecordSql, insertFoodRecordSql];
    
    int rid = [self writeDBWithSql:sqlArray andParameter:dict insertOrUpdate:(int)entity.rid];
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        return YES;
    }
    return NO;
}

- (BOOL)recordSportToDB:(XKRWRecordSportEntity *)entity
{
    if (entity.calorie <= 0) {
        XKLog(@"记录卡路里异常");
        return NO;
    }
    NSDictionary *dict = [entity dictionaryInRecordTable];
    NSArray *sqlArray = @[updateSportRecordSql, insertSportRecordSql];
    
    int rid = [self writeDBWithSql:sqlArray andParameter:dict insertOrUpdate:entity.rid];
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        return YES;
    }
    return NO;
}

- (BOOL)recordCustomFoodToDB:(XKRWRecordCustomEntity *)entity
{
    if (entity.calorie <= 0) {
        XKLog(@"记录卡路里异常");
        return NO;
    }
    NSDictionary *dict = [entity dictionaryInRecordTable];
    NSArray *sqlArray = @[updateCustomFoodSql, insertCustomFoodSql];
    
    int rid = [self writeDBWithSql:sqlArray andParameter:dict insertOrUpdate:entity.rid];
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        return YES;
    }
    return NO;
}

- (BOOL)recordCustomSportToDB:(XKRWRecordCustomEntity *)entity
{
    if (entity.calorie <= 0) {
        XKLog(@"记录卡路里异常");
        return NO;
    }
    NSDictionary *dict = [entity dictionaryInRecordTable];
    NSArray *sqlArray = @[updateCustomSportSql, insertCustomSportSql];
    
    int rid = [self writeDBWithSql:sqlArray andParameter:dict insertOrUpdate:entity.rid];
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        return YES;
    }
    return NO;
}

- (BOOL)recordInfomationToDB:(XKRWRecordEntity4_0 *)entity
{
    NSDictionary *dict = [entity dictionaryInRecordTable];
    NSArray *sqlArray = @[updateRecordSql, insertRecordSql];
    
    int rid = [self writeDBWithSql:sqlArray andParameter:dict insertOrUpdate:entity.rid];
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        if (entity.weight > 0) {
            
            NSString *weight = [NSString stringWithFormat:@"%d", (int)(entity.weight * 1000)];
            
            [[XKRWWeightService shareService] saveWeightRecord:weight
                                                          date:entity.date
                                                          sync:[NSString stringWithFormat:@"%d", entity.sync]
                                                 andTimeRecord:nil];
        }
        return YES;
    }
    return NO;
}

- (BOOL)recordSchemeToDB:(XKRWRecordSchemeEntity *)entity {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithPropertiesFromObject:entity]];
    param[@"date"] = [entity.date stringWithFormat:@"yyyy-MM-dd"];
    
    NSArray *sqlArray = @[@"REPLACE INTO record_scheme (rid, create_time, uid, sid, type, calorie, record_value, sync, date) VALUES (:rid, :create_time, :uid, :sid, :type, :calorie, :record_value, :sync, :date)",
                          @"REPLACE INTO record_scheme (create_time, uid, sid, type, calorie, record_value, sync, date) VALUES (:create_time, :uid, :sid, :type, :calorie, :record_value, :sync, :date)"];
    int rid = [self writeDBWithSql:sqlArray andParameter:param insertOrUpdate:(int)entity.rid];
    
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        return YES;
    }
    return NO;
}

- (BOOL)batchSaveSchemeRecordsToDB:(NSArray *)array {
    
    int uid = (int)[XKRWUserDefaultService getCurrentUserId];
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"REPLACE INTO record_scheme (create_time, uid, sid, type, calorie, record_value, sync, date) VALUES "];
    
    for (XKRWRecordSchemeEntity *entity in array) {
        NSMutableString *append = [NSMutableString stringWithFormat:@"(%ld, %d, %ld, %d, %ld, %ld, %d, '%@'),", (long)entity.create_time, uid, (long)entity.sid, (int)entity.type, (long)entity.calorie, (long)entity.record_value, entity.sync, [entity.date stringWithFormat:@"yyyy-MM-dd"]];
        
        [sql appendString:append];
    }
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    
    if ([self executeSql:sql]) {
        
        return YES;
    }
    return NO;
}

- (BOOL)recordUniveralToDB:(XKRWUniversalRecordEntity *)entity {
    
    NSDictionary *param = [entity dictionaryInDatabase];
    NSArray *sqlArray = @[@"REPLACE INTO record_universal (rid, uid, type, create_time, value, sync) VALUES (:rid, :uid, :type, :create_time, :value, :sync)",
                          @"INSERT INTO record_universal (uid, type, create_time, value, sync) VALUES (:uid, :type, :create_time, :value, :sync)"];
    int rid = [self writeDBWithSql:sqlArray andParameter:param insertOrUpdate:(int)entity.rid];
    
    if (rid) {
        if (!entity.rid) {
            entity.rid = rid;
        }
        return YES;
    }
    return NO;
}

- (void)updateSyncState:(XKRWUniversalRecordEntity *)entity {
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE record_universal SET sync = %d WHERE rid = %d", entity.sync, (int)entity.rid];
    [self executeSql:sql];
}

- (BOOL)batchSaveFoodRecordToDB:(NSArray *)array {
    
    int uid = (int)[XKRWUserDefaultService getCurrentUserId];
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (server_id, uid, food_id, food_name, record_type, calorie, number, unit, image_url, food_energy, date, sync, number_new, unit_new) VALUES ", foodRecordTable];
    
    for (XKRWRecordFoodEntity *entity in array) {
        
        NSString *unit_new = @"";
        if (entity.unit_new && entity.unit_new.length > 0) {
            unit_new = entity.unit_new;
        }
        NSString *url = @"";
        if (entity.foodLogo && entity.foodLogo.length > 0) {
            url = entity.foodLogo;
        }
        
        NSMutableString *append = [NSMutableString stringWithFormat:@"(%ld, %d, %ld, '%@', %ld, %ld, %ld, %ld, '%@', %ld, '%@', %ld, %ld, '%@'),", (long)entity.serverid, uid, (long)entity.foodId, entity.foodName, (long)entity.recordType, (long)entity.calorie, (long)(long)entity.number, (long)entity.unit, url, (long)entity.foodEnergy, [entity.date stringWithFormat:@"yyyy-MM-dd"], (long)entity.sync, (long)entity.number_new, unit_new];
        
        [sql appendString:append];
    }
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    
    if ([self executeSql:sql]) {
        
        return YES;
    }
    return NO;
}

- (BOOL)batchSaveSportRecordToDB:(NSArray *)array {
    
    int uid = (int)[XKRWUserDefaultService getCurrentUserId];
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (server_id, uid, sport_id, sport_name, record_type, calorie, number, unit, image_url, sport_METS, date, sync) VALUES ", sportRecordTable];
    
    for (XKRWRecordSportEntity *entity in array) {
        NSMutableString *append = [NSMutableString stringWithFormat:@"(%u, %d, %u, '%@', %ld, %ld, %ld, %u, '%@', %f, '%@', %d),", entity.serverid, uid, entity.sportId, entity.sportName, (long)entity.recordType, (long)entity.calorie, (long)entity.number, entity.unit, entity.sportPic, entity.sportMets, [entity.date stringWithFormat:@"yyyy-MM-dd"], entity.sync];
        
        [sql appendString:append];
    }
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    
    if ([self executeSql:sql]) {
        
        return YES;
    }
    return NO;
}

#pragma mark DELETE
- (BOOL)deleteAllFoodRecordInDB
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %ld", foodRecordTable, (long)uid];
    
    return [self executeSql:sql];
}

- (BOOL)deleteAllSportRecordInDB
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %ld", sportRecordTable, (long)uid];
    
    return [self executeSql:sql];
}

- (BOOL)deleteAllCustomRecordInDBWithType:(int)type
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = nil;
    
    if (type) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %ld", customFoodReocrdTB, (long)uid];
    } else {
        sql =[NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %ld", customSportRecordTB, (long)uid];
    }
    return [self executeSql:sql];
}

- (BOOL)deleteFoodRecordInDB:(XKRWRecordFoodEntity *)entity
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:entity.rid]
                                                      forKey:@"rid"];
    return [self executeSqlWithDictionary:deleteFoodRecordSql withParameterDictionary:param];
}

- (BOOL)deleteSportRecordInDB:(XKRWRecordSportEntity *)entity
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:entity.rid]
                                                      forKey:@"rid"];
    return [self executeSqlWithDictionary:deleteSportRecordSql withParameterDictionary:param];
}

- (BOOL)deleteCustomFoodInDB:(XKRWRecordCustomEntity *)entity
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:entity.rid]
                                                      forKey:@"rid"];
    return [self executeSqlWithDictionary:deleteCustomFoosSql withParameterDictionary:param];
}

- (BOOL)deleteCustomSportInDB:(XKRWRecordCustomEntity *)entity
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:entity.rid]
                                                      forKey:@"rid"];
    return [self executeSqlWithDictionary:deleteCustomSportSql withParameterDictionary:param];
}

- (BOOL)deleteRecordInfoInDB:(XKRWRecordCustomEntity *)entity
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:entity.rid]
                                                      forKey:@"rid"];
    return [self executeSqlWithDictionary:deleteRecordSql withParameterDictionary:param];
}

- (BOOL)deleteSchemeRecordInDB:(XKRWRecordSchemeEntity *)entity {
    
    NSDictionary *param = @{@"rid": @(entity.rid)};
    return [self executeSqlWithDictionary:@"DELETE FROM record_scheme WHERE rid = :rid"
                  withParameterDictionary:param];
}

- (BOOL)deleteUniversalRecordInDB:(XKRWUniversalRecordEntity *)entity {
    
    NSDictionary *param = @{@"rid": @(entity.rid)};
    return [self executeSqlWithDictionary:@"DELETE FROM record_universal WHERE rid = :rid"
                  withParameterDictionary:param];
}

#pragma - mark QUERY
- (NSArray *)queryRecent_20_RecordTable:(NSString *)tableName {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql;
    
    NSMutableArray *array = [NSMutableArray array];
    if ([tableName isEqualToString:@"food_record"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld GROUP BY %@ ORDER BY date DESC LIMIT 20",tableName,(long)uid,@"food_id"];
        NSArray *data = [self query:sql];
        for (NSDictionary *temp in data) {
            XKRWFoodEntity *entity = [XKRWFoodEntity new];
            entity.foodId = [temp[@"food_id"] integerValue];
            entity.foodName = temp[@"food_name"];
            entity.foodLogo = temp[@"image_url"];
            entity.foodEnergy = [temp[@"calorie"] integerValue];
            [array addObject:entity];
        }
        
    } else if ([tableName isEqualToString:@"sport_record"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld GROUP BY %@ ORDER BY date DESC LIMIT 20",tableName,(long)uid,@"sport_name"];
        NSArray *data = [self query:sql];
        for (NSDictionary *sportTemp in data) {
            XKRWSportEntity *entity = [XKRWSportEntity new];
            entity.sportId = [sportTemp[@"sport_id"] intValue];
            entity.sportName = sportTemp[@"sport_name"];
            entity.sportPic = sportTemp[@"image_url"];
            entity.sportMets = [sportTemp[@"sport_METS"] floatValue];
            entity.sportUnit = [sportTemp[@"unit"] intValue];
            if (entity.sportId) {
                [array addObject:entity];
            } else continue;
        }
        
    } else return [NSArray new];
    
    return array;
}
- (NSArray *)queryRecordWithDate:(NSDate *)date table:(NSString *)tableName
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND date = '%@' AND sync != -1", tableName, (long)uid, dateString];
    return [self query:sql];
}

- (NSArray *)queryFoodRecord:(NSDate *)date
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *result = [self queryRecordWithDate:date table:foodRecordTable];
    
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordFoodEntity *entity = [[XKRWRecordFoodEntity alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (NSArray *)querySportRecord:(NSDate *)date
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *result = [self queryRecordWithDate:date table:sportRecordTable];
    
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordSportEntity *entity = [[XKRWRecordSportEntity alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

/**
 *  查找自定义记录，type=0为运动，type=1为食物
 */
- (NSArray *)queryCustomRecord:(NSDate *)date withType:(int)type
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *result = nil;
    if (type) {
        result = [self queryRecordWithDate:date table:customFoodReocrdTB];
        
    } else {
        result = [self queryRecordWithDate:date table:customSportRecordTB];
    }
    
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordCustomEntity *entity = [[XKRWRecordCustomEntity alloc] initWithDictionary:dict];
            XKLog(@"%@", entity.name);
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (NSArray *)queryOtherRecord:(NSDate *)date
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *result = [self queryRecordWithDate:date table:recordTable];
    
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordEntity4_0 *entity = [[XKRWRecordEntity4_0 alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (NSArray *)queryUnSyncFoodReocrd
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND sync != 1", foodRecordTable, (long)uid];
    
    NSArray *result = [self query:sql];
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordFoodEntity *entity = [[XKRWRecordFoodEntity alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (NSArray *)queryUnSyncSportReocrd
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND sync != 1", sportRecordTable, (long)uid];
    
    NSArray *result = [self query:sql];
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordSportEntity *entity = [[XKRWRecordSportEntity alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (NSArray *)queryUnSyncCustomReocrd
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND sync != 1", customFoodReocrdTB, (long)uid];
    
    NSArray *result = [self query:sql];
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordCustomEntity *entity = [[XKRWRecordCustomEntity alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
    }
    
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND sync != 1", customSportRecordTB, (long)uid];
    
    result = [self query:sql];
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordCustomEntity *entity = [[XKRWRecordCustomEntity alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
    }
    
    if (array.count) {
        return array;
    }
    return nil;
}

- (NSArray *)queryUnSyncInformaiotnRecord
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND sync != 1", recordTable, (long)uid];
    
    NSArray *result = [self query:sql];
    if (result.count) {
        for (NSDictionary *dict in result) {
            XKRWRecordEntity4_0 *entity = [[XKRWRecordEntity4_0 alloc] initWithDictionary:dict];
            [array addObject:entity];
        }
        return array;
    }
    return nil;
}

- (NSArray *)querySchemeRecordWithCreateTime:(NSInteger)create_time {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND create_time = %ld AND sync != -1", (long)uid, (long)create_time];
    
    NSArray *rst = [self query:sql];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary *temp in rst) {
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        [temp setPropertiesToObject:entity];
        entity.date = [NSDate dateFromString:temp[@"date"] withFormat:@"yyyy-MM-dd"];
        
        if (entity && entity.create_time) {
            [returnValue addObject:entity];
        }
    }
    if (returnValue.count) {
        return returnValue;
    } else {
        return nil;
    }
}

- (NSArray *)querySchemeRecordWithDate:(NSDate *)date {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSInteger begin = [date originTimeOfADay];
    NSInteger end = begin + 86399;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND create_time > %ld AND create_time < %ld AND sync != -1 ORDER BY type", (long)uid, (long)begin, (long)end];
    
    NSArray *rst = [self query:sql];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary *temp in rst) {
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        [temp setPropertiesToObject:entity];
        entity.date = [NSDate dateFromString:temp[@"date"] withFormat:@"yyyy-MM-dd"];
        
        if (entity.create_time) {
            [returnValue addObject:entity];
        }
    }
    return returnValue;
}

- (NSArray *)queryUnsyncSchemeRecord {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND sync != 1", (long)uid];
    
    NSArray *rst = [self query:sql];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary *temp in rst) {
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        [temp setPropertiesToObject:entity];
        entity.date = [NSDate dateFromString:temp[@"date"] withFormat:@"yyyy-MM-dd"];
        
        if (entity.create_time) {
            [returnValue addObject:entity];
        }
    }
    return returnValue;
}

- (NSArray *)queryUniversalRecordWithDate:(NSDate *)date type:(XKRWRecordType)type {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSInteger begin = [date originTimeOfADay];
    NSInteger end = begin + 86399;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_universal WHERE uid = %ld AND type = %d AND create_time > %ld AND create_time < %ld AND sync != -1", (long)uid, (int)type, (long)begin, (long)end];
    
    NSArray *rst = [self query:sql];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary *temp in rst) {
        XKRWUniversalRecordEntity *entity = [[XKRWUniversalRecordEntity alloc] initWithDictionaryInDatabase:temp];
        if (entity && entity.create_time) {
            [returnValue addObject:entity];
        }
    }
    return returnValue;
}

- (NSArray *)queryUniversalRecordWithCreateTime:(NSInteger)create_time type:(XKRWRecordType)type {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_universal WHERE uid = %ld AND type = %d AND create_time = %ld AND sync != -1", (long)uid, (int)type, (long)create_time];
    
    NSArray *rst = [self query:sql];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary *temp in rst) {
        XKRWUniversalRecordEntity *entity = [[XKRWUniversalRecordEntity alloc] initWithDictionaryInDatabase:temp];
        if (entity && entity.create_time) {
            [returnValue addObject:entity];
        }
    }
    if (returnValue.count) {
        return returnValue;
    } else {
        return nil;
    }
}

- (NSArray *)queryUnsyncUniversalRecord {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_universal WHERE uid = %ld AND sync != 1", (long)uid];
    
    NSArray *rst = [self query:sql];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary *temp in rst) {
        XKRWUniversalRecordEntity *entity = [[XKRWUniversalRecordEntity alloc] initWithDictionaryInDatabase:temp];
        if (entity && entity.create_time) {
            [returnValue addObject:entity];
        }
    }
    return returnValue;
}


#pragma mark - Public Interface 公共接口

#pragma mark - 5.0.1 new 

- (void)saveMenstruation:(BOOL)comeOrNot {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSString *key = [NSString stringWithFormat:@"%ld_MC_RECORD", (long)uid];
    [[NSUserDefaults standardUserDefaults] setObject:@(comeOrNot) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getMenstruationSituation {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSString *key = [NSString stringWithFormat:@"%ld_MC_RECORD", (long)uid];
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (value) {
        return [value boolValue];
    }
    return NO;
}

#pragma mark - 5.0 NEW 

//  (因新接口结构调整，5.0以后版本尽量使用以下接口，结构转换和校验都在此步进行。)   tag:保存..记录

- (BOOL)saveRecord:(id)recordEntity ofType:(XKRWRecordType)type {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    // record food
    if ([recordEntity isMemberOfClass:[XKRWRecordFoodEntity class]] && type == XKRWRecordTypeFood) {
        
        XKRWRecordFoodEntity *entity = recordEntity;
        entity.uid = uid;
        
        // deal with new unit
        if (entity.unit_new && entity.unit_new.length > 0) {
            NSInteger num = [entity.foodUnit[entity.unit_new] integerValue];
            entity.unit = 1;
            entity.number = num * entity.number_new;
            entity.calorie = entity.number * entity.foodEnergy / 100;
        }
        
        if (entity.serverid == 0) {
            entity.serverid = [[NSDate date] timeIntervalSince1970];
        }
        
        if (!entity.date) {
            entity.date = [NSDate dateWithTimeIntervalSince1970:entity.serverid];
        }
        entity.sync = 0;
        [self recordFoodToDB:recordEntity];
        if ([self saveFoodRecordToRemote:entity]) {
            [self recordFoodToDB:entity];
            return YES;
        } else {
            return NO;
        }
    }
    
    // record sport
    if ([recordEntity isMemberOfClass:[XKRWRecordSportEntity class]] && type == XKRWRecordTypeSport) {
        
        XKRWRecordSportEntity *entity = recordEntity;
        entity.sync = 0;
        entity.uid = (uint32_t)uid;
        
        if (entity.serverid == 0) {
            entity.serverid = [[NSDate date] timeIntervalSince1970];
        }
        
        if (!entity.date) {
            entity.date = [NSDate dateWithTimeIntervalSince1970:entity.serverid];
        }
        
        [self recordSportToDB:recordEntity];
        if ([self saveSportRecordToRemote:recordEntity]) {
            [self recordSportToDB:recordEntity];
            return YES;
        } else {
            return NO;
        }
    }
    
    // record custom
    if ([recordEntity isMemberOfClass:[XKRWRecordCustomEntity class]] && type == XKRWRecordTypeCustom) {
        
        XKRWRecordCustomEntity *entity = (XKRWRecordCustomEntity *)recordEntity;
        entity.sync = 0;
        entity.uid = (uint32_t)uid;
        
        if (entity.serverid == 0) {
            entity.serverid = [[NSDate date] timeIntervalSince1970];
        }
        if (!entity.date) {
            entity.date = [NSDate dateWithTimeIntervalSince1970:entity.serverid];
        }
        
        if (entity.recordType == 0) {
            [self recordCustomSportToDB:entity];
            
            if ([self saveCustomFoodOrSportToRemote:entity]) {
                [self recordCustomSportToDB:recordEntity];
                return YES;
            } else {
                return NO;
            }
        } else {
            
            [self recordCustomFoodToDB:entity];
            
            if ([self saveCustomFoodOrSportToRemote:entity]) {
                [self recordCustomFoodToDB:recordEntity];
                return YES;
            } else {
                return NO;
            }
        }
    }
    
    // record other info
    if ([recordEntity isMemberOfClass:[XKRWRecordEntity4_0 class]]) {
        
        XKRWRecordEntity4_0 *entity = (XKRWRecordEntity4_0 *)recordEntity;
        entity.sync = 0;
        entity.uid = (uint32_t)uid;
        
        // TODO: - Whether will be duplicated another row in database with same day.
        if (!entity.date) {
            entity.date = [NSDate date];
        }
        
        [self recordInfomationToDB:entity];
        
        BOOL isRemoteSuccess = NO;
        
        switch (type) {
            case XKRWRecordTypeWeight:
                isRemoteSuccess = [self saveWeightToRemote:entity];
                break;
            case XKRWRecordTypeCircumference:
                isRemoteSuccess = [self saveCircumferenceToRemote:entity];
                break;
            case XKRWRecordTypeHabit:
                isRemoteSuccess = [self saveHabitRecordToRemote:entity];
                break;
            case XKRWRecordTypeMenstruation:
                isRemoteSuccess = [self saveMenstruationToRemote:entity];
                break;
            case XKRWRecordTypeSleep:
                isRemoteSuccess = [self saveSleepingTimeToRemote:entity];
                break;
            case XKRWRecordTypeWater:
                isRemoteSuccess = [self saveWaterToRemote:entity];
                break;
            case XKRWRecordTypeMood:
                isRemoteSuccess = [self saveMoodToRemote:entity];
                break;
            case XKRWRecordTypeRemark:
                isRemoteSuccess = [self saveRemarkToRemote:entity];
                break;
            default:
                break;
        }
        
        if (isRemoteSuccess) {
            entity.sync = 1;
            [self recordInfomationToDB:entity];
            return YES;
        }
        return NO;
    }
    
    // record scheme
    if ([recordEntity isKindOfClass:[XKRWRecordSchemeEntity class]] && type == XKRWRecordTypeScheme) {
        
        XKRWRecordSchemeEntity *entity = recordEntity;
        entity.sync = 0;
        entity.uid = uid;
        
        // new create
        if (entity.create_time == 0) {
            entity.create_time = [[NSDate date] timeIntervalSince1970];
        }
        
        if (entity.type == RecordTypeSport) {
            if (entity.record_value == 1) {
                entity.calorie = 0;
            } else if (entity.record_value == 2) {
                entity.calorie = [XKRWAlgolHelper dailyConsumeSportEnergy];
            }
        } else {
            if (entity.record_value == 1) {
                entity.calorie = 0;
            } else if (entity.record_value == 2) {
                if(entity.type <5 ){
                    entity.calorie = [XKRWAlgolHelper getSchemeRecomandCalorieWithType:entity.type date:entity.date];
                }
            }
        }
        [self recordSchemeToDB:entity];
        
        BOOL isSuccess = [self saveSchemeRecordToRemote:entity];
        
        if (isSuccess) {
            [self recordSchemeToDB:entity];
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)deleteRecord:(id)recordEntity {
  
    // delete food
    if ([recordEntity isMemberOfClass:[XKRWRecordFoodEntity class]]) {
        
        ((XKRWRecordFoodEntity *)recordEntity).sync = -1;
        [self recordFoodToDB:recordEntity];
        
        if ([self deleteFoodRecordFromRemote:recordEntity]) {
            [self deleteFoodRecordInDB:recordEntity];
            return YES;
        } else {
            return NO;
        }
    }
    
    // record sport
    if ([recordEntity isMemberOfClass:[XKRWRecordSportEntity class]]) {
        
        ((XKRWRecordSportEntity *)recordEntity).sync = -1;
        [self recordSportToDB:recordEntity];
        
        if ([self deleteSportRecordFromRemote:recordEntity]) {
            [self deleteSportRecordInDB:recordEntity];
            return YES;
        } else {
            return NO;
        }
    }
    
    // record custom
    if ([recordEntity isMemberOfClass:[XKRWRecordCustomEntity class]]) {
        
        XKRWRecordCustomEntity *entity = (XKRWRecordCustomEntity *)recordEntity;
        entity.sync = -1;
        
        if (entity.recordType == 0) {
            [self recordCustomSportToDB:entity];
            
            if ([self deleteCustomRecordFromRemote:entity]) {
                [self deleteCustomSportInDB:recordEntity];
                return YES;
            } else {
                return NO;
            }
        } else {
            
            [self recordCustomFoodToDB:entity];
            
            if ([self deleteCustomRecordFromRemote:entity]) {
                [self deleteCustomFoodInDB:recordEntity];
                return YES;
            } else {
                return NO;
            }
        }
    }
    // record scheme
    if ([recordEntity isKindOfClass:[XKRWRecordSchemeEntity class]]) {
        
        XKRWRecordSchemeEntity *entity = recordEntity;
        
        if (entity.record_value == 0) {
            return NO;
        }
        entity.sync = -1;
        
        [self recordSchemeToDB:entity];
        
        BOOL isSuccess = [self deleteSchemeRecordFromRemote:entity];
        
        if (isSuccess) {
            [self deleteSchemeRecordInDB:entity];
            return YES;
        }
        return NO;
    }
    return NO;
}

/**
 *  Get scheme record, use Scheme ids to search
 *
 *  @param schemes     Scheme entities array
 *  @param date        Searching date
 *
 *  @return Scheme records
 */
- (NSArray *)getSchemeRecordWithSchemes:(NSArray *)schemes date:(NSDate *)date {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSInteger begin = [date originTimeOfADay];
    NSInteger end = begin + 86399;
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    for (XKRWSchemeEntity_5_0 *temp in schemes) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND create_time > %ld AND create_time < %ld AND sid = %ld AND type = %d AND sync != -1 ORDER BY create_time", (long)uid, (long)begin, (long)end, (long)temp.schemeID, (int)temp.schemeType];
        
        NSArray *rst = [self query:sql];
        if (rst.count > 2) {
            [self reportBug];
        }
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        
        if (rst && rst.count) {
            [rst.lastObject setPropertiesToObject:entity];
            entity.date = [NSDate dateFromString:rst.lastObject[@"date"] withFormat:@"yyyy-MM-dd"];
        } else {
            entity.type = (RecordType)temp.schemeType;
            entity.uid = uid;
            entity.sid = temp.schemeID;
            entity.calorie = temp.calorie;
            entity.record_value = 0;
            entity.sync = 1;
        }
        [returnValue addObject:entity];
    }
    return returnValue;
}

- (NSArray *)getSchemeRecordWithDate:(NSDate *)date {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND date = '%@' AND sync != -1 ORDER BY type", (long)uid, [date stringWithFormat:@"yyyy-MM-dd"]];
    
    NSArray *rst = [self query:sql];
    if (rst.count > 4) {
        [self reportBug];
        // TODO: do something with wrong number
    }
    for (NSDictionary *temp in rst) {
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        
        [temp setPropertiesToObject:entity];
        entity.date = [NSDate dateFromString:temp[@"date"] withFormat:@"yyyy-MM-dd"];
        [returnValue addObject:entity];
    }
    return returnValue;
}

- (XKRWRecordSchemeEntity *)getSchemeRecordWithDate:(NSDate *)date type:(RecordType)type {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSInteger begin = [date originTimeOfADay];
    NSInteger end = begin + 86399;
    
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND create_time > %ld AND create_time < %ld AND sync != -1 AND type = %ld ORDER BY create_time", (long)uid, (long)begin, (long)end, (long)type];
    
    NSArray *rst = [self query:sql];
    if (rst.count > 2) {
        [self reportBug];
        // TODO: do something with wrong number
    }
    for (NSDictionary *temp in rst) {
            
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        [temp setPropertiesToObject:entity];
        entity.date = [NSDate dateFromString:temp[@"date"] withFormat:@"yyyy-MM-dd"];
        
        [returnValue addObject:entity];
    }
    return returnValue.lastObject;
}

- (void)cleanWrongSchemeRecords {
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND date = '%@' AND sid = 0", (long)uid, date];
    
    NSArray *rst = [self query:sql];
    
    for (NSDictionary *temp in rst) {
        
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        [temp setPropertiesToObject:entity];
        entity.date = [NSDate dateFromString:temp[@"date"] withFormat:@"yyyy-MM-dd"];
        
        [self deleteRecord:entity];
    }
}

- (NSArray *)getSchemeStateOfNumberOfDays:(NSInteger)num withType:(RecordType)type withCurrentDate:(NSDate *)currentdate{
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    if (!currentdate) {
        currentdate = [NSDate date];
    }
   
    NSMutableArray *returnValue = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= num; i++) {
        NSString *date = [[currentdate offsetDay:-i+1] stringWithFormat:@"yyyy-MM-dd"];
        NSString *sql = nil;
        
        if (type == RecordTypeSport) {
            sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND date = '%@' AND type = 0 AND sync != -1", (long)uid, date];
        } else {
            sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND date = '%@' AND type != 0 AND sync != -1", (long)uid, date];
        }
        NSArray *rst = [self query:sql];
        
        if (rst == nil || rst.count == 0) {
            [returnValue addObject:@(0)];
            continue;
        }
        
        int state = 1;
        // if not record all meals, it begins with yellow stamp
        if (type != RecordTypeSport) {
            if (rst.count < 3) {
                state = 3;
            }
        }
        for (NSDictionary *temp in rst) {
            
            NSInteger recordValue = [temp[@"record_value"] integerValue];
            
            if (type == RecordTypeSport) {
                if (recordValue == 1 || recordValue == 0) {
                    state = 2;
                    break;
                } else if (recordValue == 3) {
                    state = 3;
                }
            } else {
                if (recordValue > 3) {
                    state = 2;
                    break;
                } else if (recordValue == 1 || recordValue == 3 || recordValue == 0) {
                    state = 3;
                }
            }
        }
        [returnValue addObject:@(state)];
    }
    return [[returnValue reverseObjectEnumerator] allObjects];
}

- (NSDictionary *)getHabitInfoWithDays:(NSInteger)days {
    
    NSMutableDictionary *returnValue = [NSMutableDictionary dictionary];
    NSMutableDictionary *count = [NSMutableDictionary dictionary];
    
    NSMutableArray *content = [NSMutableArray array];
    NSDate *now = [NSDate date];
    
    for (NSInteger i = days - 1; i >= 0; i --) {
        
        NSDate *day = [now offsetDay:-i];
        NSArray *rst = [self queryOtherRecord:day];
        
        if (rst) {
            XKRWRecordEntity4_0 *entity = rst.lastObject;
            
            if (!entity.habitArray) {
                [entity reloadHabitArray];
            }
            
            int habitNum = (int)entity.habitArray.count;
            int amendNum = 0;
            for (XKRWHabbitEntity *habit in entity.habitArray) {
                if (habit.situation == 1) {
                    amendNum ++;
                    if ([count.allKeys containsObject:@(habit.hid)]) {
                        [count setObject:@([count[@(habit.hid)] integerValue] + 1) forKey:@(habit.hid)];
                    } else {
                        [count setObject:@(1) forKey:@(habit.hid)];
                    }
                }
            }
            [content addObject:@{@"all": @(habitNum), @"amended": @(amendNum)}];
        } else {
            XKRWRecordEntity4_0 *entity = [[XKRWRecordEntity4_0 alloc] init];
            [entity reloadHabitArray];
            
            [content addObject:@{@"all": @(entity.habitArray.count), @"amended": @(0)}];
        }
    }
    [returnValue setObject:content forKey:@"content"];
    [returnValue setObject:count forKey:@"count"];
    
    return returnValue;
}

- (NSString *)getEatALotText {
    
    NSString *eat = [[NSUserDefaults standardUserDefaults] objectForKey:@"EAT_A_LOT_TEXT"];
    if (!eat) {
        eat = @"(自助餐,无节制饮食)";
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        @try {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/index/btn/", kNewServer]];
            NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:result[@"data"] forKey:@"EAT_A_LOT_TEXT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        @catch (NSException *exception) {
            
        }
    });
    return eat;
}

- (NSString *)getEatALotTextFromLocal {
    
    NSString *eat = [[NSUserDefaults standardUserDefaults] objectForKey:@"EAT_A_LOT_TEXT"];
    if (!eat) {
        eat = @"(自助餐,无节制饮食)";
    }
    return eat;
}

- (void)resetUserRecords {
    
    XKRWRecordEntity4_0 *entity = [self getOtherInfoOfDay:[NSDate date]];
    if(entity != nil){
        [self deleteHabitRecord:entity];
    }
}

- (void)resetCurrentUserWeight:(float)weight {
    
    XKRWRecordEntity4_0 *entity = [self getOtherInfoOfDay:[NSDate date]];
    
    if (entity) {
        entity.weight = weight;
        [self saveRecord:entity ofType:XKRWRecordTypeWeight];
    }
}

- (BOOL)doFixV5_0 {
    
    @try {
        return [[XKRWSchemeService_5_0 sharedService] v5_0_schemeRecordsFixment];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

#pragma mark -

- (NSInteger)getTotalCalorieOfDay:(NSDate *)date type:(int)type
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *foodSql = nil;
    NSString *customSql = nil;
    if (type) {
        //sql = [NSString stringWithFormat:@"SELECT SUM(%@.calorie + %@.calorie) FROM %@, %@ WHERE %@.date = %@ AND %@.date = %@ AND %@.uid = %d AND %@.uid = %d", foodRecordTable, customFoodReocrdTB, foodRecordTable, customFoodReocrdTB, foodRecordTable, dateString, customFoodReocrdTB, dateString, foodRecordTable, uid, customFoodReocrdTB, uid];
        foodSql = [NSString stringWithFormat:@"SELECT SUM(calorie) FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1", foodRecordTable, dateString, (long)uid];
        customSql = [NSString stringWithFormat:@"SELECT SUM(calorie) FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1", customFoodReocrdTB, dateString, (long)uid];
        
    } else {
        //        sql = [NSString stringWithFormat:@"SELECT SUM(%@.calorie + %@.calorie) FROM %@, %@ WHERE %@.date = %@ AND %@.date = %@ AND %@.uid = %d AND %@.uid = %d", sportRecordTable, customSportRecordTB, sportRecordTable, customSportRecordTB, sportRecordTable, dateString, customSportRecordTB, dateString, sportRecordTable, uid, customSportRecordTB, uid];
        foodSql = [NSString stringWithFormat:@"SELECT SUM(calorie) FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1", sportRecordTable, dateString, (long)uid];
        customSql = [NSString stringWithFormat:@"SELECT SUM(calorie) FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1", customSportRecordTB, dateString, (long)uid];
    }
    NSArray *result = [self query:foodSql];
    NSArray *customResult = [self query:customSql];
    NSDictionary *resultDict = result[0];
    NSDictionary *customRstDict = customResult[0];
    
    NSInteger sum = 0;
    
    if (![resultDict.allValues[0] isKindOfClass:[NSNull class]]) {
        sum += [resultDict.allValues[0] intValue];
    }
    if (![customRstDict.allValues[0] isKindOfClass:[NSNull class]]) {
        sum += [customRstDict.allValues[0] intValue];
    }
    return sum;
}


- (NSMutableDictionary *)getRecordTotalCalorieOfDay:(NSDate *)date andRecordType:(MealType ) type {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *sql = nil;
    NSString *schemeSql = nil;
    if (type == eSport) {
        schemeSql = [NSString stringWithFormat:@"SELECT record_value , calorie FROM record_scheme  WHERE date = '%@' AND uid = %ld and type = 0 ",dateString,(long)uid];
        
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1", sportRecordTable, dateString, (long)uid];
    }else if (type == eMealBreakfast){
        schemeSql = [NSString stringWithFormat:@"SELECT record_value , calorie FROM record_scheme  WHERE date = '%@' AND uid = %ld and type = 1 ",dateString,(long)uid];
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1 and record_type = 1 ", foodRecordTable, dateString, (long)uid];
    }else if (type == eMealLunch){
        schemeSql = [NSString stringWithFormat:@"SELECT record_value , calorie FROM record_scheme  WHERE date = '%@' AND uid = %ld and type = 2 ",dateString,(long)uid];
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1 and record_type = 2 ", foodRecordTable, dateString, (long)uid];
    }else if (type == eMealDinner){
        schemeSql = [NSString stringWithFormat:@"SELECT record_value , calorie FROM record_scheme  WHERE dat e = '%@' AND uid = %ld and type = 3 ",dateString,(long)uid];
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1 and record_type = 3 ", foodRecordTable, dateString, (long)uid];
    }else{
        schemeSql = [NSString stringWithFormat:@"SELECT record_value , calorie FROM record_scheme  WHERE date = '%@' AND uid = %ld and type = 4 ",dateString,(long)uid];
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date = '%@' AND uid = %ld AND sync != -1 and record_type = 4 ", foodRecordTable, dateString, (long)uid];
    
    }
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    NSArray *schemeResult = [self query:schemeSql];
    NSDictionary *resultDict = schemeResult[0];
    if ([[resultDict objectForKey:@"record_value"] integerValue]== 2) {
        [dic setObject:[resultDict objectForKey:@"calorie"] forKey:@"calorie"];
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSDictionary *foodDic = @{@"title":@"完美执行",@"calorie":[resultDict objectForKey:@"calorie"]};
        [mutableArray addObject:foodDic];
        [dic setObject:@"allRecord" forKey:mutableArray];
    }else{
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSArray *array = [self query:sql];
        NSInteger sum = 0;
        if(type == eSport ){
            for (int i = 0; i < array.count; i++) {
                NSDictionary *sportDic = [array objectAtIndex:i];
                XKRWRecordSportEntity *entity = [[XKRWRecordSportEntity alloc] init];
                entity.sportId = [sportDic[@"sport_id"] intValue];
                entity.sportName = sportDic[@"sport_name"];
                entity.sportPic = sportDic[@"image_url"];
                entity.sportMets = [sportDic[@"sport_METS"] floatValue];
                entity.sportUnit = [sportDic[@"unit"] intValue];
                entity.calorie = [sportDic[@"calorie"]  integerValue];
                sum += [sportDic[@"calorie"] integerValue];
                if (entity.sportId) {
                    [mutableArray addObject:entity];
                } else continue;
            }
        }else{
            for (int i = 0; i < array.count; i++) {
                NSDictionary *foodDic = [array objectAtIndex:i];
                XKRWFoodEntity *entity = [XKRWFoodEntity new];
                entity.foodId = [foodDic[@"food_id"] integerValue];
                entity.foodName = foodDic[@"food_name"];
                entity.foodLogo = foodDic[@"image_url"];
                entity.foodEnergy = [foodDic[@"calorie"] integerValue];
                sum += [foodDic[@"calorie"] integerValue];
                [mutableArray addObject:entity];
            }
        }
        
        [dic setObject:[NSNumber numberWithInteger:sum] forKey:@"calorie"];
        [dic setObject:mutableArray forKey:@"allRecord"];
        
    }
    return dic;
}



- (NSDictionary *)getSchemeRecordWithDate:(NSDate *)date andType:(NSInteger) type {
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    
    NSString *schemeSql = [NSString stringWithFormat:@"SELECT * FROM record_scheme  WHERE date = '%@' AND uid = %ld and type = %ld ",dateString,(long)uid,(long)type];
    NSArray *schemeResult = [self query:schemeSql];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    if (schemeResult.count > 0) {
        NSDictionary *resultDict = schemeResult[0];
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        entity.create_time = [[resultDict objectForKey:@"create_time"] integerValue];
        entity.record_value = [[resultDict objectForKey:@"record_value"] integerValue];
        entity.sid = [[resultDict objectForKey:@"sid"] integerValue];;
        entity.type = [[resultDict objectForKey:@"type"] integerValue];;
        entity.calorie = [[resultDict objectForKey:@"calorie"] integerValue];
        entity.uid = [[resultDict objectForKey:@"uid"] integerValue];
        [dic setObject:@1 forKey:@"schemeHadRecord"];
        [dic setObject:entity forKey:@"schemeEntity"];
        return dic;
    }else{
         return nil;
    }
}


/**
 *  记录运动的详情
 *
 *  @param date 该日期记录的
 *
 *  @return dictionary （key：运动   value：kcal）
 */
- (NSMutableArray *)getSportRecordAndSportSchemeRecordWithDate:(NSDate *)date {
    NSDictionary *sportSchemeDic = [self getSchemeRecordWithDate:date andType:5];
    NSMutableArray *mutableArray = [NSMutableArray mutableCopy];
    if (sportSchemeDic) {
        XKRWRecordSchemeEntity *entity = [sportSchemeDic objectForKey:@"schemeEntity"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"推荐运动45分钟" forKey:@"text"];
        [dic setObject:[NSNumber numberWithFloat:entity.calorie] forKey:@"calorie"];
        [mutableArray addObject:dic];
    }
    XKRWRecordEntity4_0 *recordEntity = [self getAllRecordOfDay:date];
    for (XKRWRecordSportEntity *sportEntity in recordEntity.SportArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@%ld分钟",sportEntity.sportName,sportEntity.number] forKey:@"text"];
        [dic setObject:[NSNumber numberWithFloat:sportEntity.calorie] forKey:@"calorie"];
        [mutableArray addObject:dic];
    }
    return mutableArray;
}


- (NSDictionary *)getCircumferenceAndWeightRecordOfDays:(NSInteger)numOfDays {
    
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *begin = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    NSString *end = [[[NSDate date] offsetDay: -numOfDays + 1] stringWithFormat:@"yyyy-MM-dd"];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND date >= '%@' AND date <= '%@' ORDER BY date ASC", recordTable, (long)uid, end, begin];
    
    NSArray *fmst = [self query:sql];
    
    NSMutableDictionary *weightDict = [NSMutableDictionary dictionary];
    [weightDict setObject:@"体重" forKey:@"name"];
    NSMutableDictionary *waistlineDict = [NSMutableDictionary dictionary];
    [waistlineDict setObject:@"腰围" forKey:@"name"];
    NSMutableDictionary *bustDict = [NSMutableDictionary dictionary];
    [bustDict setObject:@"胸围" forKey:@"name"];
    NSMutableDictionary *hiplineDict = [NSMutableDictionary dictionary];
    [hiplineDict setObject:@"臀围" forKey:@"name"];
    NSMutableDictionary *armDict = [NSMutableDictionary dictionary];
    [armDict setObject:@"臂围" forKey:@"name"];
    NSMutableDictionary *thighDict = [NSMutableDictionary dictionary];
    [thighDict setObject:@"大腿围" forKey:@"name"];
    NSMutableDictionary *shankDict = [NSMutableDictionary dictionary];
    [shankDict setObject:@"小腿围" forKey:@"name"];
    
    NSMutableArray *weight      = [NSMutableArray array];
    NSMutableArray *waistline   = [NSMutableArray array];
    NSMutableArray *bust        = [NSMutableArray array];
    NSMutableArray *hipline     = [NSMutableArray array];
    NSMutableArray *arm         = [NSMutableArray array];
    NSMutableArray *thigh       = [NSMutableArray array];
    NSMutableArray *shank       = [NSMutableArray array];
    
    
    for (NSDictionary *dict in fmst) {
        XKRWRecordEntity4_0 *entity = [[XKRWRecordEntity4_0 alloc] initWithDictionary:dict];
        NSDictionary *tempDict;
        if (entity.weight > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.weight], @"value",
                        entity.date, @"date",
                        nil];
            [weight addObject:tempDict];
        }
        
        if (entity.circumference.waistline > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.waistline], @"value",
                        entity.date, @"date",
                        nil];
            [waistline addObject:tempDict];
        }
        
        if (entity.circumference.bust > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.bust], @"value",
                        entity.date, @"date",
                        nil];
            [bust addObject:tempDict];
        }
        if (entity.circumference.hipline > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.hipline], @"value",
                        entity.date, @"date",
                        nil];
            [hipline addObject:tempDict];
        }
        
        if (entity.circumference.arm > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.arm], @"value",
                        entity.date, @"date",
                        nil];
            [arm addObject:tempDict];
        }
        
        if (entity.circumference.thigh > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.thigh], @"value",
                        entity.date, @"date",
                        nil];
            [thigh addObject:tempDict];
        }
        
        if (entity.circumference.shank > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.shank], @"value",
                        entity.date, @"date",
                        nil];
            [shank addObject:tempDict];
        }
    }
    [weightDict setObject:weight forKey:@"content"];
    [waistlineDict setObject:waistline forKey:@"content"];
    [bustDict setObject:bust forKey:@"content"];
    [hiplineDict setObject:hipline forKey:@"content"];
    [armDict setObject:arm forKey:@"content"];
    [thighDict setObject:thigh forKey:@"content"];
    [shankDict setObject:shank forKey:@"content"];
    
    [resultDictionary setObject:weightDict forKey:@"weight"];
    [resultDictionary setObject:waistlineDict forKey:@"waistline"];
    [resultDictionary setObject:bustDict forKey:@"bust"];
    [resultDictionary setObject:hiplineDict forKey:@"hipline"];
    [resultDictionary setObject:armDict forKey:@"arm"];
    [resultDictionary setObject:thighDict forKey:@"thigh"];
    [resultDictionary setObject:shankDict forKey:@"shank"];
    
    return resultDictionary;
}

- (NSDictionary *)getAllCircumferenceAndWeightRecord
{
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld ORDER BY date ASC", recordTable, (long)uid];
    
    NSArray *fmst = [self query:sql];
    
    NSMutableDictionary *weightDict = [NSMutableDictionary dictionary];
    [weightDict setObject:@"体重" forKey:@"name"];
    NSMutableDictionary *waistlineDict = [NSMutableDictionary dictionary];
    [waistlineDict setObject:@"腰围" forKey:@"name"];
    NSMutableDictionary *bustDict = [NSMutableDictionary dictionary];
    [bustDict setObject:@"胸围" forKey:@"name"];
    NSMutableDictionary *hiplineDict = [NSMutableDictionary dictionary];
    [hiplineDict setObject:@"臀围" forKey:@"name"];
    NSMutableDictionary *armDict = [NSMutableDictionary dictionary];
    [armDict setObject:@"臂围" forKey:@"name"];
    NSMutableDictionary *thighDict = [NSMutableDictionary dictionary];
    [thighDict setObject:@"大腿围" forKey:@"name"];
    NSMutableDictionary *shankDict = [NSMutableDictionary dictionary];
    [shankDict setObject:@"小腿围" forKey:@"name"];
    
    NSMutableArray *weight      = [NSMutableArray array];
    NSMutableArray *waistline   = [NSMutableArray array];
    NSMutableArray *bust        = [NSMutableArray array];
    NSMutableArray *hipline     = [NSMutableArray array];
    NSMutableArray *arm         = [NSMutableArray array];
    NSMutableArray *thigh       = [NSMutableArray array];
    NSMutableArray *shank       = [NSMutableArray array];
    
    
    for (NSDictionary *dict in fmst) {
        XKRWRecordEntity4_0 *entity = [[XKRWRecordEntity4_0 alloc] initWithDictionary:dict];
        NSDictionary *tempDict;
        if (entity.weight > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.weight], @"value",
                        entity.date, @"date",
                        nil];
            [weight addObject:tempDict];
        }
        
        if (entity.circumference.waistline > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.waistline], @"value",
                        entity.date, @"date",
                        nil];
            [waistline addObject:tempDict];
        }
        
        if (entity.circumference.bust > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.bust], @"value",
                        entity.date, @"date",
                        nil];
            [bust addObject:tempDict];
        }
        if (entity.circumference.hipline > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.hipline], @"value",
                        entity.date, @"date",
                        nil];
            [hipline addObject:tempDict];
        }
        
        if (entity.circumference.arm > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.arm], @"value",
                        entity.date, @"date",
                        nil];
            [arm addObject:tempDict];
        }
        
        if (entity.circumference.thigh > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.thigh], @"value",
                        entity.date, @"date",
                        nil];
            [thigh addObject:tempDict];
        }
        
        if (entity.circumference.shank > 0) {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:entity.circumference.shank], @"value",
                        entity.date, @"date",
                        nil];
            [shank addObject:tempDict];
        }
    }
    [weightDict setObject:weight forKey:@"content"];
    [waistlineDict setObject:waistline forKey:@"content"];
    [bustDict setObject:bust forKey:@"content"];
    [hiplineDict setObject:hipline forKey:@"content"];
    [armDict setObject:arm forKey:@"content"];
    [thighDict setObject:thigh forKey:@"content"];
    [shankDict setObject:shank forKey:@"content"];
    
    [resultDictionary setObject:weightDict forKey:@"weight"];
    [resultDictionary setObject:waistlineDict forKey:@"waistline"];
    [resultDictionary setObject:bustDict forKey:@"bust"];
    [resultDictionary setObject:hiplineDict forKey:@"hipline"];
    [resultDictionary setObject:armDict forKey:@"arm"];
    [resultDictionary setObject:thighDict forKey:@"thigh"];
    [resultDictionary setObject:shankDict forKey:@"shank"];
    
    return resultDictionary;
}
//eWeightType = 1,    //体重
//eBustType,          //胸围
//eArmType,           //臂围
//eWaistType,         //腰围
//eHipType,           //臀围
//eThighType,         //大腿围
//ecalfType,          //小腿围

- (BOOL) recordTableHavaDataWithDate:(NSString *)date AndType:(DataType ) dataType
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld and date = '%@'", recordTable, (long)uid,date];
    
    NSArray *resultArray = [self query:sql];
    
    if (resultArray!= nil && resultArray.count > 0) {
        NSDictionary *dic =  [resultArray objectAtIndex:0];
        
        NSString *value ;
        
        if (dataType == eWeightType) {
            value = [dic objectForKey:@"weight"];
        }else if (dataType == eBustType){
             value = [dic objectForKey:@"bust"];
        }else if (dataType == eArmType){
            value = [dic objectForKey:@"arm"];
        }else if (dataType == eWaistType){
            value = [dic objectForKey:@"waistline"];
        }else if (dataType == eHipType){
            value = [dic objectForKey:@"hipline"];
        }else if (dataType == eThighType){
            value = [dic objectForKey:@"thigh"];
        }else{
            value = [dic objectForKey:@"shank"];
        }
        
        if ([value floatValue] > 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}


- (XKRWRecordEntity4_0 *)getAllRecordOfDay:(NSDate *)date
{
    XKRWRecordEntity4_0 *entity = [self getOtherInfoOfDay:date];
    
    if (!entity) {
        entity = [[XKRWRecordEntity4_0 alloc] init];
        entity.date = date;
        entity.sync = 1;
    }
    if (!entity.habitArray) {
        entity.habitArray = [NSMutableArray array];
        [entity reloadHabitArray];
    }
    entity.FoodArray        = [NSMutableArray arrayWithArray:[self queryFoodRecord:date]];
    entity.SportArray       = [NSMutableArray arrayWithArray:[self querySportRecord:date]];
    entity.customFoodArray  = [NSMutableArray arrayWithArray:[self queryCustomRecord:date withType:1]];
    entity.customSportArray = [NSMutableArray arrayWithArray:[self queryCustomRecord:date withType:0]];
    
    return entity;
}

- (float)getWeightRecordOfDay:(NSDate *)date
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT weight FROM %@ WHERE uid = %ld AND date = '%@'", recordTable, (long)uid, dateString];
    
    NSArray *fmst = [self query:sql];
    if (fmst.count) {
        return [fmst[0][@"weight"] floatValue];
    }
    return 0.f;
    
}


- (NSArray *)getWeightRecordNumberOfDays:(NSInteger) days
{
    NSDate *now = [NSDate date];
    
    NSMutableArray *weightArray = [NSMutableArray arrayWithCapacity:days];
    for (NSInteger i = 1; i <= days; i++) {

        NSInteger timeInterval = [[now offsetDay:-i+1] timeIntervalSince1970];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        [weightArray addObject:[NSString stringWithFormat:@"%.1f",[[XKRWWeightService shareService]getNearestWeightRecordOfDate:date]]];
        }
    
    return [[weightArray reverseObjectEnumerator] allObjects];
}

- (XKRWRecordEntity4_0 *)getOtherInfoOfDay:(NSDate *)date
{
    return [self queryOtherRecord:date][0];
}

- (NSArray *)getRecordHistoryWithType:(int)type
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    if (type) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld AND sync != -1 ORDER BY rid DESC", foodRecordTable, (long)uid];
        NSArray *fmst = [self query:sql];
        int count = 0;
        for (NSDictionary *dict in fmst) {
            XKRWRecordFoodEntity *entity = [[XKRWRecordFoodEntity alloc] initWithDictionary:dict];
            __block BOOL flag = NO;
            
            if (!entity.foodLogo.length) {
                flag = YES;
            } else {
                [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    XKRWRecordFoodEntity *temp = (XKRWRecordFoodEntity *)obj;
                    if (entity.foodId == temp.foodId) {
                        flag = YES;
                        *stop = YES;
                    }
                }];
            }
            if (!flag) {
                if (count ++ <= 20) {
                    [result addObject:entity];
                } else {
                    break;
                }
            }
        }
    } else {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid = %ld ORDER BY rid DESC", sportRecordTable, (long)uid];
        NSArray *fmst = [self query:sql];
        
        int count = 0;
        
        for (NSDictionary *dict in fmst) {
            XKRWRecordSportEntity *entity = [[XKRWRecordSportEntity alloc] initWithDictionary:dict];
            __block BOOL flag = NO;
            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                XKRWRecordSportEntity *temp = (XKRWRecordSportEntity *)obj;
                if (entity.sportId == temp.sportId) {
                    flag = YES;
                    *stop = YES;
                }
            }];
            if (!flag) {
                if (count ++ <= 20) {
                    [result addObject:entity];
                } else {
                    break;
                }
            }
        }
    }
    return result;
}
/**
 *  我要的，标记下
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)getUserRecordDateFromDB
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT date FROM record_scheme WHERE uid = %ld AND sync != -1", (long)uid];
    NSArray *rst = [self query:sql];
    
    NSMutableArray *dateStringArray = [NSMutableArray array];
    
    for (NSDictionary *temp in rst) {
        if (![dateStringArray containsObject:temp[@"date"]]) {
            [dateStringArray addObject:temp[@"date"]];
        }
    }
    
//     add habit
    sql = [NSString stringWithFormat:@"SELECT DISTINCT date FROM record_4_0 WHERE uid = %ld AND habit IS NOT NULL AND habit != '' AND sync != -1", (long)uid];
    rst = [self query:sql];
    
    for (NSDictionary *temp in rst) {
        if (![dateStringArray containsObject:temp[@"date"]]) {
            [dateStringArray addObject:temp[@"date"]];
        }
    }
    for (NSString *dateString in dateStringArray) {
        NSDate *date = [NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd"];
        if (date) {
            [resultArr addObject:date];
        }

    }
    return resultArr;
}

- (BOOL)haveRecordOfDate:(NSDate *)date
{
    NSArray *result = [self queryOtherRecord:date];
    if (result && result.count) {
        return YES;
    }
    return NO;
}

- (NSArray *)getDietNutriIngredientWithDate:(NSDate *)date {
    
    NSArray *schemes = [self getSchemeRecordWithDate:date];
    
    NSMutableArray *result = [NSMutableArray array];
    NSArray *foods = [self queryFoodRecord:date];
    
    for (XKRWRecordSchemeEntity *scheme in schemes) {
        
        if (scheme.record_value < 3) {
            continue;
        }
        for (XKRWRecordFoodEntity *entity in foods) {
            
            if (entity.recordType != scheme.type) {
                continue;
            }
            
            @try {
                
            }
            @catch (NSException *exception) {
                
            }
            XKRWFoodEntity *foodEntity = [[XKRWFoodService shareService] getFoodDetailByFoodId:entity.foodId];
            CGFloat num = 0.f;
            if (entity.unit == eUnitGram) {
                num = entity.number / 100.f;
            } else if (entity.unit == eUnitKiloCalories) {
                num = entity.number / (float)foodEntity.foodEnergy;
            } else if (entity.unit == eUnitKilojoules) {
                num = entity.number * 0.239 / (float)foodEntity.foodEnergy;
            }
            
            for (int i = 0; i < foodEntity.foodNutri.count; i ++) {
                float sum = 0.f;
                NSString *key = foodEntity.foodNutri[i][@"nutr"];
                
                if (result.count > i) {
                    sum = [result[i][key] floatValue];
                }
                CGFloat gram = sum + [foodEntity.foodNutri[i][@"quantity"] floatValue] * num;
                
                NSDictionary *temp = @{key : [NSNumber numberWithFloat:gram]};
                
                if (result.count > i) {
                    result[i] = temp;
                } else {
                    [result addObject:temp];
                }
            }
        }
    }
    
#ifdef DEBUG
    for (NSDictionary *dict in result) {
        XKLog(@"%@ : %@", dict.allKeys[0], dict.allValues[0]);
    }
#endif
    return result;
}

- (NSDictionary *)getFatProteinCarbohydratePercentage:(NSDate *)date {
    
    NSArray *nutri = [self getDietNutriIngredientWithDate:date];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:0.f], kFat,
                                   [NSNumber numberWithFloat:0.f], kProtein,
                                   [NSNumber numberWithFloat:0.f], kCarbohydrate,nil];
    /**
     *  如果当天无记录，则都返回0%
     */
    if (!nutri.count) {
        return result;
    }
    int count = 0;
    float caloric, protein, carbohydrate;
    
    for (NSDictionary *dict in nutri) {
        if ([dict.allKeys[0] isEqualToString:kFat]) {
            count ++;
            caloric = [dict[kFat] floatValue];
        }
        if ([dict.allKeys[0] isEqualToString:kProtein]) {
            count ++;
            protein = [dict[kProtein] floatValue];
        }
        if ([dict.allKeys[0] isEqualToString:kCarbohydrate]) {
            count ++;
            carbohydrate = [dict[kCarbohydrate] floatValue];
        }
        if (count == 3) {
            break;
        }
    }
    result[kFat] = [NSNumber numberWithFloat:2.25 * caloric / (protein + carbohydrate + 2.25 * caloric)];
    result[kProtein] = [NSNumber numberWithFloat:protein / (protein + carbohydrate + 2.25 * caloric)];
    result[kCarbohydrate] = [NSNumber numberWithFloat:carbohydrate / (protein + carbohydrate + 2.25 * caloric)];
#ifdef DEBUG
    for (NSString *key in result.allKeys) {
        XKLog(@"%@ : %@", key, result[key]);
    }
#endif
    return result;
}

- (NSDictionary *)getFatProteinCarbohydrate:(NSDate *)date {
    
    NSArray *nutri = [self getDietNutriIngredientWithDate:date];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:0.f], kFat,
                                   [NSNumber numberWithFloat:0.f], kProtein,
                                   [NSNumber numberWithFloat:0.f], kCarbohydrate,nil];
    /**
     *  如果当天无记录，则都返回0
     */
    if (!nutri.count) {
        return result;
    }
    int count = 0;
    float fat, protein, carbohydrate;
    
    for (NSDictionary *dict in nutri) {
        if ([dict.allKeys[0] isEqualToString:kFat]) {
            count ++;
            fat = [dict[kFat] floatValue];
        }
        if ([dict.allKeys[0] isEqualToString:kProtein]) {
            count ++;
            protein = [dict[kProtein] floatValue];
        }
        if ([dict.allKeys[0] isEqualToString:kCarbohydrate]) {
            count ++;
            carbohydrate = [dict[kCarbohydrate] floatValue];
        }
        if (count == 3) {
            break;
        }
    }
    result[kFat] = @(fat);
    result[kProtein] = @(protein);
    result[kCarbohydrate] = @(carbohydrate);
#ifdef DEBUG
    for (NSString *key in result.allKeys) {
        XKLog(@"%@ : %@", key, result[key]);
    }
#endif
    return result;
}


- (NSDictionary *)getFatProteinCarbohydrateOfRecord:(NSDate *)date {
    
    NSArray *schemes = [self getSchemeRecordWithDate:date];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSArray *foods = [self queryFoodRecord:date];
    
    NSMutableArray *fat = [NSMutableArray array];
    NSMutableArray *protein = [NSMutableArray array];
    NSMutableArray *carborhydrate = [NSMutableArray array];
    
    for (XKRWRecordSchemeEntity *scheme in schemes) {
        
        for (XKRWRecordFoodEntity *entity in foods) {
            
            if (entity.recordType != scheme.type) {
                continue;
            }
            
            XKRWFoodEntity *foodEntity = [[XKRWFoodService shareService] getFoodDetailByFoodId:entity.foodId];
            CGFloat num = 0.f;
            if (entity.unit == eUnitGram) {
                num = entity.number / 100.f;
            } else if (entity.unit == eUnitKiloCalories) {
                num = entity.number / (float)foodEntity.foodEnergy;
            } else if (entity.unit == eUnitKilojoules) {
                num = entity.number * 0.239 / (float)foodEntity.foodEnergy;
            }
            
            for (NSDictionary *dict in foodEntity.foodNutri) {
                
                if ([dict[@"nutr"] isEqualToString:kFat]) {
                    NSDictionary *temp = @{entity.foodName: @(num*[dict[@"quantity"] floatValue])};
                    [fat addObject:temp];
                }
                if ([dict[@"nutr"] isEqualToString:kProtein]) {
                    NSDictionary *temp = @{entity.foodName: @(num*[dict[@"quantity"] floatValue])};
                    [protein addObject:temp];
                }
                if ([dict[@"nutr"] isEqualToString:kCarbohydrate]) {
                    NSDictionary *temp = @{entity.foodName: @(num*[dict[@"quantity"] floatValue])};
                    [carborhydrate addObject:temp];
                }
            }
        }
    }
    [result setObject:fat forKey:kFat];
    [result setObject:protein forKey:kProtein];
    [result setObject:carborhydrate forKey:kCarbohydrate];
    
    return result;
}

#pragma mark 数据同步

- (BOOL)checkNeedSyncData
{
    BOOL isNeedSync = NO;
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM record_4_0 WHERE uid = %ld AND sync != 1", (long)uid];
    NSDictionary *record_rst = [self fetchRow:sql];
    uint32_t record_num = [[record_rst objectForKey:@"number"] unsignedIntValue];
    
    if (record_num > 0) {
        return YES;
    }
    
    sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM record_scheme WHERE uid = %ld AND sync != 1", (long)uid];
    record_rst = [self fetchRow:sql];
    record_num = [[record_rst objectForKey:@"number"] unsignedIntValue];
    
    if (record_num > 0) {
        return YES;
    }
    
    sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM %@ WHERE uid = %ld AND sync != 1", foodRecordTable, (long)uid];
    record_rst = [self fetchRow:sql];
    record_num = [[record_rst objectForKey:@"number"] unsignedIntValue];
    
    if (record_num > 0) {
        return YES;
    }
    sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM %@ WHERE uid = %ld AND sync != 1", sportRecordTable, (long)uid];
    record_rst = [self fetchRow:sql];
    record_num = [[record_rst objectForKey:@"number"] unsignedIntValue];
    
    if (record_num > 0) {
        return YES;
    }
    sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM %@ WHERE uid = %ld AND sync != 1", customSportRecordTB, (long)uid];
    record_rst = [self fetchRow:sql];
    record_num = [[record_rst objectForKey:@"number"] unsignedIntValue];
    
    if (record_num > 0) {
        return YES;
    }
    sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS number FROM %@ WHERE uid = %ld AND sync != 1", customFoodReocrdTB, (long)uid];
    record_rst = [self fetchRow:sql];
    record_num = [[record_rst objectForKey:@"number"] unsignedIntValue];
    
    if (record_num > 0) {
        return YES;
    }
    return isNeedSync;
}

- (NSNumber *)syncOfflineRecordToRemote
{
    NSArray *array = [self queryUnSyncFoodReocrd];
    
    for (XKRWRecordFoodEntity *entity in array) {
        if (entity.sync == -1) {
            if ([self deleteFoodRecordFromRemote:entity]) {
                
                [self deleteFoodRecordInDB:entity];
            }
        } else {
            if ([self saveFoodRecordToRemote:entity]) {
                
                [self recordFoodToDB:entity];
            } else {
                return @NO;
            }
        }
    }
    
    array = [self queryUnSyncSportReocrd];
    
    for (XKRWRecordSportEntity *entity in array) {
        if (entity.sync == -1) {
            if ([self deleteSportRecordFromRemote:entity]) {
                
                [self deleteSportRecordInDB:entity];
            }
        } else {

            if ([self saveSportRecordToRemote:entity]) {
                
                [self recordSportToDB:entity];
            } else {
                return @NO;
            }
        }
    }
    array = [self queryUnSyncCustomReocrd];
    
    for (XKRWRecordCustomEntity *entity in array) {
        if (entity.sync == -1) {
            if ([self deleteCustomRecordFromRemote:entity]) {
                
                if (entity.recordType) {
                    [self deleteCustomFoodInDB:entity];
                } else {
                    [self deleteCustomSportInDB:entity];
                }
            }
        } else {

            if ([self saveCustomFoodOrSportToRemote:entity]) {
                
                if (entity.recordType) {
                    [self recordCustomFoodToDB:entity];
                } else {
                    [self recordCustomSportToDB:entity];
                }
            } else {
                return @NO;
            }
        }
    }
    
    array = [self queryUnsyncSchemeRecord];
    
    for (XKRWRecordSchemeEntity *entity in array) {
        
        if ([self saveSchemeRecordToRemote:entity]) {
            [self recordSchemeToDB:entity];
        } else {
            return @NO;
        }
    }
    
    
    array = [self queryUnSyncInformaiotnRecord];
    
    for (XKRWRecordEntity4_0 *entity in array) {
       
        if (entity.circumference.bust && entity.circumference.arm && entity.circumference.waistline && entity.circumference.hipline && entity.circumference.thigh && entity.circumference.shank) {
            
            [self saveCircumferenceToRemote:entity];
        }
        if (entity.weight > 0) {
            
            [self saveWeightToRemote:entity];
        }
        if (entity.water > 0) {
            
            [self saveWaterToRemote:entity];
        }
        [self saveMenstruationToRemote:entity];
        
        if (entity.getUp || entity.sleepingTime > 0) {
            
            [self saveGetUpToRemote:entity];
            [self saveSleepingTimeToRemote:entity];
        }
        if (entity.mood) {
            
            [self saveMoodToRemote:entity];
        }
        if (entity.remark && entity.remark.length > 0) {
            
            [self saveRemarkToRemote:entity];
        }
        [self saveHabitRecordToRemote:entity];
        
        [self recordInfomationToDB:entity];
    }
    /**
     *  YES for now.
     */
    return [NSNumber numberWithBool:YES];
}

- (NSDictionary *)syncServerRecordFromDate:(NSDate *)date
{
    NSDictionary *downloadData  = [self downloadFromRemoteFromdate:date toDate:[NSDate date]][@"data"];
    NSNumber *isUpdate = [NSNumber numberWithBool:[self saveDownloadDataToDB:downloadData]];
    return [NSDictionary dictionaryWithObjectsAndKeys:isUpdate, @"isNeedUpdate", SUCCESS, @"isSuccess", nil];
}

- (NSNumber *)syncRecordData
{
    NSDate *fromDate = [[self class] getRecordSyncDate];
    if ([[self syncOfflineRecordToRemote] boolValue]) {
        NSDictionary *result = [self syncServerRecordFromDate:fromDate];
        
        if ([result[@"isSuccess"] isEqualToString:SUCCESS]) {
            
            if ([result[@"isNeedUpdate"] boolValue]) {
                [[self class] setRecordSyncDate:[NSDate date]];
            }
            return @YES;
        }
        return @NO;
    }
    return @NO;
}

- (NSNumber *)syncTodayRecordData {
    NSDate *today = [NSDate today];
    if ([[self syncOfflineRecordToRemote] boolValue]) {
        NSDictionary *result = [self syncServerRecordFromDate:today];
        if ([result[@"isSuccess"] isEqualToString:SUCCESS]) {
            
            if ([result[@"isNeedUpdate"] boolValue]) {
                [[self class] setRecordSyncDate:[NSDate date]];
            }
            return @YES;
        }
        return @NO;
    }
    return @NO;
}

- (BOOL)downloadAllRecords {

    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:1000000000];
    
    if ([[self syncOfflineRecordToRemote] boolValue]) {
        NSDictionary *result = [self syncServerRecordFromDate:fromDate];
        
        if ([result[@"isSuccess"] isEqualToString:SUCCESS]) {
            
            if ([result[@"isNeedUpdate"] boolValue]) {
                [[self class] setRecordSyncDate:[NSDate date]];
            }
            return YES;
        }
        return NO;
    }
    return NO;
}

/**
 *  获取今天以前的一条数据。如果昨天有数据，返回昨天的数据，如果昨天没有则返回离昨天最近的一条数据
 */
- (float)getReciprocalSec
{
    float weight = 0 ;
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *sql = [NSString stringWithFormat:@"SELECT weight FROM %@ WHERE uid = %ld order by date desc limit 5 ", recordTable, (long)uid];
    
    NSArray *arr = [self query:sql];
    if (arr.count >= 2) {
        weight = [[arr[1] objectForKey:@"weight"] floatValue];
    }
    return weight;
}

+ (void)setRecordSyncDate:(NSDate *)date
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]]
                                              forKey:[NSString stringWithFormat:@"%ld_RecordSync", (long)uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)getRecordSyncDate
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *dateString = [[NSUserDefaults standardUserDefaults]
                            objectForKey:[NSString stringWithFormat:@"%ld_RecordSync", (long)uid]];
    if (dateString) {
        double interval = [dateString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        
        if ([date compare:[[NSDate today] offsetDay:-2]] == NSOrderedDescending) {
            return [[NSDate today] offsetDay:-2];
            
        } else {
            return date;
        }
        
    } else return [NSDate dateWithTimeIntervalSince1970:1000000000];
}

+ (BOOL)isNeedUpdate
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSNumber *needSync = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld_NeedSync", (long)uid]];
    if (needSync) {
        return [needSync boolValue];
    }
    return YES;;
}

+ (void)setNeedUpdate:(BOOL)need
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:need]
                                              forKey:[NSString stringWithFormat:@"%ld_NeedSync", (long)uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)needShowTipsInHPVC
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSNumber *needSync = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld_Tips_In_HP", (long)uid]];
    if (needSync) {
        return [needSync boolValue];
    }
    return YES;
}

+ (void)setNeedShowTipsInHPVC:(BOOL)need
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:need]
                                              forKey:[NSString stringWithFormat:@"%ld_Tips_In_HP", (long)uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)syncTrialUserData
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@, %@, %@, %@ WHERE uid = 0 AND sync = -1", foodRecordTable, sportRecordTable, customSportRecordTB, customFoodReocrdTB];
    
    int result = 1;
    result *= [self executeSql:sql];
    
    sql = [NSString stringWithFormat:@"UPDATE %@, %@, %@ ,%@ ,%@ SET uid = %ld, sync = 0 WHERE uid = 0", foodRecordTable, sportRecordTable, customFoodReocrdTB, customSportRecordTB, recordTable, (long)uid];
    result *= [self executeSql:sql];
    
    return result;
}

- (BOOL)deleteTrialUserData
{
    NSString *sql_deleteFood        = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = 0", foodRecordTable];
    NSString *sql_deleteSport       = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = 0", sportRecordTable];
    NSString *sql_deleteCustomFood  = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = 0", customFoodReocrdTB];
    NSString *sql_deleteCustomSport = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = 0", customSportRecordTB];
    NSString *sql_deleteRecordInfo  = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = 0", recordTable];
    
    int result = 1;
    result *= [self executeSql:sql_deleteFood];
    result *= [self executeSql:sql_deleteSport];
    result *= [self executeSql:sql_deleteCustomFood];
    result *= [self executeSql:sql_deleteCustomSport];
    result *= [self executeSql:sql_deleteRecordInfo];
    if (result) {
        return YES;
    }
    return NO;
}

- (CGFloat) getTotalCaloriesWithType:(XKCaloriesType) type andDate:(NSDate *)date {
    
    XKRWRecordEntity4_0 *recordEntity = [self getAllRecordOfDay:date];
    NSDictionary *  schemeDetail;
    CGFloat  calorie = 0;
    if (type == efoodCalories) {
        for (XKRWRecordFoodEntity *foodEntity in recordEntity.FoodArray) {
                calorie += foodEntity.calorie;
        }
        schemeDetail =[[XKRWRecordService4_0 sharedService] getSchemeRecordWithDate:date andType:6];
    }else if (type == eSportCalories){
          for (XKRWRecordSportEntity *sportEntity in recordEntity.SportArray) {
              calorie += sportEntity.calorie;
          }
        
       schemeDetail =[[XKRWRecordService4_0 sharedService] getSchemeRecordWithDate:date andType:5];
      
    }
    if (schemeDetail != nil) {
        XKRWRecordSchemeEntity *entity = [schemeDetail objectForKey:@"schemeEntity"];
        calorie += entity.calorie;
    }
    return calorie ;
}


- (BOOL) getUserRecordStateWithDate:(NSDate *)date {
     XKRWRecordEntity4_0 *recordEntity = [self getAllRecordOfDay:date];
    
    if (recordEntity.FoodArray.count == 0 && recordEntity.SportArray.count== 0) {
        return NO;
    }
    
    return YES;
}



//- (BOOL)isShowDataCenterRedDot
//{
//    NSInteger uid = [[XKRWUserService sharedService] getUserId];
//    
//    id obj =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IS_DATACENTER_SHOW_RED_DOT_%ld", (long)uid]];
//    
//    if (obj == nil) {
//        return YES;
//    }
//    return [obj boolValue];
//}


//- (void)setDataCenterRedDot:(BOOL)flag
//{
//    NSInteger uid = [[XKRWUserService sharedService] getUserId];
//    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:flag]
//                                             forKey:[NSString stringWithFormat:@"IS_DATACENTER_SHOW_RED_DOT_%ld", (long)uid]];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}

#pragma mark - Other Operation 其他处理
#pragma mark -

- (void)reportBug {
    [MobClick event:@"BUG_Scheme_Record"];
}

- (void)checkBugs {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if ([self checkSchemeRecord] > 0) {
            [MobClick event:@"BUG_Scheme_Record"];
        }
    });
}

- (NSInteger)checkSchemeRecord {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld", (long)UID];
    NSMutableArray *rst = [self query:sql];
    
    NSMutableArray *entities = [NSMutableArray array];
    for (NSDictionary *temp in rst) {
        
        XKRWRecordSchemeEntity *entity = [[XKRWRecordSchemeEntity alloc] init];
        [temp setPropertiesToObject:entity];
        
        [entities addObject:entity];
    }
    NSInteger bugsNumber = 0;
    
    for (int i = 0; i < entities.count; i ++) {
        XKRWRecordSchemeEntity *entity = entities[i];
        
        for (int j = i + 1; j < entities.count; j ++) {
            XKRWRecordSchemeEntity *compareEntity = entities[j];
            
            if (entity.type == compareEntity.type && [[NSDate dateWithTimeIntervalSince1970:entity.create_time] isDayEqualToDate:[NSDate dateWithTimeIntervalSince1970:compareEntity.create_time]]) {
                
                bugsNumber ++;
            }
        }
    }
    return bugsNumber;
}

+ (void)showLoginVCWithTarget:(id)target
               needBackButton:(BOOL)needBackButton
                andIfNeedBack:(BOOL)back
            andSucessCallBack:(void (^)())success
              andFailCallBack:(void (^)(BOOL userCancel))fail
{
//    XKRWLoginVC *vc = nil;
//    
//    if(((UIViewController *)target).storyboard == nil) {
//        
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        vc = (XKRWLoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"XKRWLoginVC"];
//        
//    } else {
//        vc = (XKRWLoginVC *)[((UIViewController *)target).storyboard instantiateViewControllerWithIdentifier:@"XKRWLoginVC"];
//    }
//    if (!vc) {
//        XKLog(@"未找到 LoginVC 于 StoryBoard 中");
//        return;
//    }
//    vc.loginSucess  = success;
//    vc.needBackButton = needBackButton;
//    vc.loginFail = fail;
//    vc.needBack = back;
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//    [target presentViewController:navi animated:YES completion:nil];
}

- (void)deleteHabitRecord:(XKRWRecordEntity4_0 *)entity
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    
    [entity.habitArray removeAllObjects];
    
    if ([self saveHabitRecordToRemote:entity]) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET habit = '' WHERE uid = %ld AND date = '%@'", recordTable, (long)uid, [entity.date stringWithFormat:@"yyyy-MM-dd"]];
        [self executeSql:sql];
    }
}

- (NSMutableDictionary *)getSchemeStatesOfDays:(NSInteger)num withType:(RecordType)type withDate:(NSDate *)curDate{
    
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    if (!curDate) {
        curDate = [NSDate date];
    }
    
    NSMutableDictionary *returnValue = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 1; i <= num; i++) {
        NSString *date = [[curDate offsetDay:-i+1] stringWithFormat:@"yyyy-MM-dd"];
        NSString *sql = nil;
        
        if (type == RecordTypeSport) {
            sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND date = '%@' AND type = 0 AND sync != -1", (long)uid, date];
        } else {
            sql = [NSString stringWithFormat:@"SELECT * FROM record_scheme WHERE uid = %ld AND date = '%@' AND type != 0 AND sync != -1", (long)uid, date];
        }

        NSArray *rst = [self query:sql];
        
        if (rst == nil || rst.count == 0) {
            [returnValue setObject:@(0) forKey:date];
            continue;
        }
        
        int state = 1;
        // if not record all meals, it begins with yellow stamp
        if (type != RecordTypeSport) {
            if (rst.count < 3) {
                state = 3;
            }
        }
        for (NSDictionary *temp in rst) {
            
            NSInteger recordValue = [temp[@"record_value"] integerValue];
            
            if (type == RecordTypeSport) {
                if (recordValue == 1 || recordValue == 0) {
                    state = 2;
                    break;
                } else if (recordValue == 3) {
                    state = 3;
                }
            } else {
                if (recordValue > 3) {
                    state = 2;
                    break;
                } else if (recordValue == 1 || recordValue == 3 || recordValue == 0) {
                    state = 3;
                }
            }
        }
        [returnValue setObject:@(state) forKey:date];
    }
    return returnValue;
}

@end