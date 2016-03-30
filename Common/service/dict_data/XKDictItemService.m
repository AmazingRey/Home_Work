//
//  XKCodeNameItemService.m
//  XKFamilyCare
//
//  Created by Wei Zhou on 13-3-21.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDictItemService.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "XKDatabaseUtil.h"
#import "FMDatabase+XKPersistence.h"
#import "FMResultSet+XKPersistence.h"

@implementation XKDictItemService

static XKDictItemService *_sharedInstance;

+ (XKDictItemService *) sharedService
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[XKDictItemService alloc] init];
    }
    return _sharedInstance;
}

- (XKDictItemEntity *) dictItemWithCode: (NSString *) code itemType: (NSString *) itemType {
    __block XKDictItemEntity *entity = nil;

    [self readDefaultReadonlyDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT code,name,itype AS type,parent_code AS parentCode,icon,ext FROM item_dictionary WHERE itype = ? AND code = ? ",itemType,code];
        while ([result next]) {
            entity = [[XKDictItemEntity alloc] init];
            [result setResultToObject:entity];
        }
    }];
    
    return entity;
}

- (NSArray *) dictItemArrayWithType: (NSString *) itemType {
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    [self readDefaultReadonlyDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT code,name,itype AS type,parent_code AS parentCode,icon,ext FROM item_dictionary WHERE itype = ?  ORDER BY priority ",itemType];
        while ([result next]) {
            XKDictItemEntity *entity  = [[XKDictItemEntity alloc] init];
            [result setResultToObject:entity];
            [itemArray addObject:entity];
        }
    }];

    return itemArray;
}

- (NSArray *) dictItemArrayWithType: (NSString *) itemType parentCode:(NSString *) parentCode {
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];

    [self readDefaultReadonlyDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT code,name,itype AS type,parent_code AS parentCode,icon,ext FROM item_dictionary WHERE itype = ? AND parent_code = ? ORDER BY priority ",itemType,parentCode];
        while ([result next]) {
            XKDictItemEntity *entity  = [[XKDictItemEntity alloc] init];
            [result setResultToObject:entity];
            [itemArray addObject:entity];
        }
    }];
    
    return itemArray;

}

- (NSDictionary *) itemDictWithType:(NSString *)itemType
                         parentCode:(NSString *)parentCode
                 propertyNameForKey:(NSString *)key
               propertyNameForValue:(NSString *)value{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [self readDefaultReadonlyDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT code,name,itype AS type,parent_code AS parentCode,icon,ext FROM item_dictionary WHERE itype = ? AND parent_code = ? ",itemType,parentCode];
        while ([result next]) {
            NSDictionary *resultDict = [result resultDictionary];
            [dict setValue:[resultDict objectForKey:key] forKey:[resultDict objectForKey:value]];
        }
    }];
    return dict;
}

@end
