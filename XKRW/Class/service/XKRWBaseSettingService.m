//
//  XKRWBaseSettingService.m
//  XKRW
//
//  Created by zhanaofan on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseSettingService.h"
static NSString *const settingTable = @"settings";
static XKRWBaseSettingService *shareInstance;

@implementation XKRWBaseSettingService

- (id) init
{
    if (self = [super init]) {
        //init
    }
    return self;
}


- (BOOL) saveValueWithKey:(id)data key:(NSString*)key
{
    BOOL __block isOK = NO;
    NSData *saveData ;
    if (![data isKindOfClass:[NSData class]]) {
        saveData = [NSKeyedArchiver archivedDataWithRootObject:data];
    }else{
        saveData = data;
    }
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ VALUES (?,?,?,?)",settingTable ];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        isOK = [db executeUpdate: sql,[NSNumber numberWithInteger:uid],key,saveData,[NSNumber numberWithInt:time]];
        
    }];
    return isOK;
}

- (id) valueOfKey:(NSString*) key
{
    id obj = nil;
    NSData __block *data = [NSData data];
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    [self readDefaultDBWithTask:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uid=%li AND key='%@'",settingTable,(long)uid,key];
        FMResultSet *fmrst = [db executeQuery:sql];
        while ([fmrst next]) {
            data = [NSData dataWithData: [fmrst dataNoCopyForColumn:@"value"]];
        }
        [fmrst close];
    }];
    if ([data length] > 0) {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        obj = [XKRWUtil toArrayOrNSDictionary:data];
    }
    return obj;
}

@end
