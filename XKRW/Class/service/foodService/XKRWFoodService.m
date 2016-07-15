//
//  XKRWFoodService.m
//  XKRW
//
//  Created by zhanaofan on 14-1-23.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFoodService.h"
#import "NSDictionary+XKUtil.h"


#define searchKeyOfFood @"FoodGroup"
#define searchKeyOfSport @"SportGroup"

static XKRWFoodService *shareNoticeInstance;

@implementation XKRWFoodService

//单例
+(id)shareService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareNoticeInstance = [[XKRWFoodService alloc] init ];
    });
    return shareNoticeInstance;
}

//获取本地缓存的食物信息
- (XKRWFoodEntity *)getFoodWithId:(NSInteger)foodId
{
    XKRWFoodEntity __block *foodEntity = [[XKRWFoodEntity alloc] init];
//    foodEntity.foodId = foodId;
    NSString *key = [self genKey:foodId];
    [self readDefaultDBWithTask:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT data FROM caches WHERE id = ? "];
        FMResultSet *fmrst = [db executeQuery:sql,key];
        while ([fmrst next]) {
            NSData  *_data_rst = [NSData dataWithData: [fmrst dataNoCopyForColumn:@"data"]];
            //            [rst addObject:_dict_rst];
            foodEntity = [NSKeyedUnarchiver unarchiveObjectWithData:_data_rst];
        }
        [fmrst close];
    }];
    return foodEntity;
}
//保存食物缓存
- (BOOL) saveFoodCache:(NSInteger) foodId withData:(NSData*)data
{
    BOOL __block isOK = NO;
    NSString *key = [self genKey:foodId ];
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        isOK = [db executeUpdate:@"REPLACE INTO caches  VALUES (?,?,?,?)",key,data,[NSNumber numberWithInt:0],[NSNumber numberWithInt:1]];
        
    }];
    return isOK;
}
- (NSString *)genKey:(NSInteger)foodId
{
    return [NSString stringWithFormat:@"%@_%li",kCacheKeyOfFood,(long)foodId];
}

//获取分类信息
- (NSMutableArray *)fetchCategoryWithType:(NSInteger)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM category WHERE cateType=%li",(long)type ];
    return [self query:sql];
}


- (NSArray*) getRecordWithDay:(NSString *) day
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM record WHERE uid=%li AND day='%@'",(long)UID,day];
    return [self query:sql];
}

- (XKRWRecordEntity*) getRecordWityId:(NSInteger)rid
{
    XKRWRecordEntity *recordEntity = [[XKRWRecordEntity alloc] init];
    NSDictionary *dict = [self fetchRow:[ NSString stringWithFormat:@"SELECT * FROM record WHERE rid = %li",(long)rid ]];
    [dict setPropertiesToObject:recordEntity];
    return recordEntity;
}

- (BOOL) removeRecordWithId:(NSInteger) rid
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM record WHERE id=%li",(long)rid ];
    return [self executeSql:sql];
}

- (XKRWFoodEntity *) syncQueryFoodWithId:(NSInteger)foodId
{
    XKRWFoodEntity *foodEntity = [[XKRWFoodEntity alloc] init];
    if (![XKUtil isNetWorkAvailable]) {
        return foodEntity;
    }
    
    NSString *api_url = [NSString stringWithFormat:@"%@/content/detail/?type=food", kNewServer];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:foodId], @"id", nil];

    NSDictionary *rst = [self syncBatchDataWith:XKURL(api_url) andPostForm:dict];
    if (rst ) {
        NSDictionary *value = [rst objectForKey:@"data"];
        
        [self dealFoodDictionary:value inFoodEntity:foodEntity];
        
        // cache, can be removed
        [self saveFoodCache:foodId withData:[NSKeyedArchiver archivedDataWithRootObject:foodEntity]];
        
        //Modifed by Mioke, save to food_detail table
        [self saveFoodDetail:foodEntity];
        
        return foodEntity;
    }
    return nil;
}

- (NSArray *)batchDownloadFoodWithIDs:(NSString *)ids {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/content/all/?type=food", kNewServer]];
    NSDictionary *param = @{@"ids": ids};
    
    NSDictionary *rst = [self syncBatchDataWith:url andPostForm:param];
    
    if (rst) {
        NSMutableArray *returnValue = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in rst[@"data"]) {
            
            XKRWFoodEntity *entity = [[XKRWFoodEntity alloc] init];
            [self dealFoodDictionary:dict inFoodEntity:entity];
            // cache
            [self saveFoodCache:entity.foodId withData:[NSKeyedArchiver archivedDataWithRootObject:entity]];
            
            // food_detail table
            [self saveFoodDetail:entity];
            
            [returnValue addObject:entity];
        }
        return returnValue;
    }
    return nil;
}

- (void)dealFoodDictionary:(NSDictionary *)content inFoodEntity:(XKRWFoodEntity *)foodEntity {
    
    foodEntity.foodId = [content[@"id"] integerValue];
    foodEntity.foodLogo = content[@"logo"];
    foodEntity.foodEnergy = [content[@"calorie"] integerValue];
    foodEntity.fitSlim = [content[@"grade"] integerValue];
    foodEntity.foodName = content[@"name"];
    foodEntity.foodNutri = content[@"nutri"];
    
    if ([content.allKeys containsObject:@"unit_weight"]) {
        
        foodEntity.foodUnit = content[@"unit_weight"];
    }
}

- (void) saveSearchKey:(NSString*)key keyType:(SchemeType)keyType
{
    if (key == nil) {
        return;
    }
    NSString *filePath = [self getFilePath:keyType];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:filePath ];
    if (arr != nil) {
//        if ([arr count] > 10) {
//            NSRange range = {9, [arr count] - 10};
//            [arr removeObjectsInRange:range];
//        }
        [arr removeObject:key];
        [arr insertObject:key atIndex:0];
    }else{
        arr = [NSMutableArray arrayWithObjects:key, nil];
    }
    [arr writeToFile:filePath atomically:NO];
}

//清除所有的Key
- (void) removeAllKeys:(SchemeType) keyType
{
    NSString *filePath = [self getFilePath:keyType];
    NSArray *arr = [NSArray array];
    [arr writeToFile:filePath atomically:NO];
}

//删除指定的搜索key
- (void) removeSearchKey:(NSString *) key keyType:(SchemeType)keyTYpe
{
    NSString *filePath = [self getFilePath:keyTYpe];
    NSMutableArray *marr = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSUInteger len = [marr count];
    if (len > 0) {
        [marr removeObject:key];
        if (len > [marr count]) {
            [marr writeToFile:filePath atomically:NO];
        }
    }
}

- (NSArray *) getSearchKey:(SchemeType)keyType
{
    NSArray *logs = [NSArray arrayWithContentsOfFile:[self getFilePath:keyType]];
    return logs;
}

- (NSString *) getFilePath:(SchemeType)keyType
{
    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
    NSString *filename = [NSString stringWithFormat:@"key_food_%li", (long)uid];
    if (keyType == eSchemeSport) {
        filename = [NSString stringWithFormat:@"key_sport_%li", (long)uid];
        return [XKRWFileManager getFileFullPathWithName:filename inGroup:searchKeyOfSport];
    }
    return [XKRWFileManager getFileFullPathWithName:filename inGroup:searchKeyOfFood];
}

- (BOOL)saveFoodDetail:(XKRWFoodEntity *)foodEntity {
    
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO food_detail VALUES (?,?)"];
    __block BOOL flag = NO;
    
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        flag = [db executeUpdate:sql, [NSNumber numberWithInteger:foodEntity.foodId], [NSKeyedArchiver archivedDataWithRootObject:foodEntity]];
    }];
    return flag;
}

- (XKRWFoodEntity *)getFoodDetailFromDBWithFoodId:(NSInteger)foodId {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM food_detail WHERE food_id = %ld", (long)foodId];
    XKRWFoodEntity *entity = [[XKRWFoodEntity alloc] init];
    
    NSArray *rst = [self query:sql];
    if (rst.count == 0) {
        return nil;
    }
    entity = [NSKeyedUnarchiver unarchiveObjectWithData:rst.lastObject[@"data"]];
    return entity;
}

- (XKRWFoodEntity *)getFoodDetailByFoodId:(NSInteger)foodId {
    
    XKRWFoodEntity *entity = [self getFoodDetailFromDBWithFoodId:foodId];
    
    if (entity == nil) {
        entity = [self syncQueryFoodWithId:foodId];
    }
    return entity;
}

- (NSArray *)getNutriArray {
    NSArray *nutriArrar = @[kCaloric,
                            kCarbohydrate,
                            kFat,
                            kProtein,
                            kCellulose,
                            kVitaminA,
                            kVitaminC,
                            kVitaminE,
                            kCarotene ,
                            kThiamine,
                            kRiboflavin ,
                            kNiacin,
                            kCholesterol,
                            kMa,
                            kCa,
                            kFe,
                            kZn,
                            kCu ,
                            kMn,
                            kKalium,
                            kP,
                            kNa,
                            kSe];
    return nutriArrar;
}

#pragma mrak - 5.0 new

- (NSArray *)searchFoodsWithKey:(NSString *)key page:(int)page pageSize:(int)pageSize {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kSearchURL]];
    NSDictionary *param = @{@"type": @"food", @"key": key, @"page": @(page), @"size": @(pageSize)};
    
    NSDictionary *rst = [self syncBatchDataWith:url andPostForm:param];
    
    NSMutableArray *foods = [[NSMutableArray alloc] init];
    for (NSDictionary *temp in rst[@"data"][@"sport"]) {
        XKRWFoodEntity *entity = [[XKRWFoodEntity alloc] init];
        [self dealFoodDictionary:temp inFoodEntity:entity];
        
        if (entity.foodId != 0) {
            [foods addObject:entity];
        }
    }
    return foods;
}
@end
