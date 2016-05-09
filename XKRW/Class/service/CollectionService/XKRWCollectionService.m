
//  XKRWCollectionService.m
//  XKRW
//
//  Created by Jack on 15/5/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWCollectionService.h"
#import "XKRWNeedLoginAgain.h"
#import "XKRWUserService.h"
#import "XKRWSportEntity.h"
#import "XKRWUserService.h"
//收藏操作sql语句    等最后修改好之后还需要检查
static NSString *updateCollectionSql = @"REPLACE INTO CollectionTable_5 ( uid, collect_type,original_id,collect_name, content_url, category_type, image_url, food_energy, date) VALUES ( :uid, :collect_type, :original_id,:collect_name, :content_url, :category_type, :image_url, :food_energy, :date)";
//删除操作
static NSString *deleteCollectionSql = @"DELETE FROM CollectionTable_5 WHERE original_id = :original_id";

static NSString *deleteAllCollectionSql = @"DELETE FROM CollectionTable_5";

static XKRWCollectionService *sharedInstance = nil;

@implementation XKRWCollectionService
+ (id)sharedService
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[XKRWCollectionService alloc] init];
    });
    return sharedInstance;
}


- (BOOL)collectToDB:(XKRWCollectionEntity *)entity
{
    __block BOOL isSuccess = NO;
    NSDictionary *dict = [entity dictionaryInCollectionTable];
    
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        isSuccess =   [db executeUpdate:updateCollectionSql withParameterDictionary:dict];
        
    }];
    return isSuccess;
}

#pragma - mark DELETE

- (BOOL)deleteCollectionInDB:(XKRWCollectionEntity *)entity
{
    BOOL __block isComplete = NO;
    NSDictionary *param = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:entity.originalId]
                                                      forKey:@"original_id"];
    isComplete = [self executeSqlWithDictionary:deleteCollectionSql withParameterDictionary:param];
    if (isComplete) {
        NSLog(@"删除收藏成功");
    }else{
        NSLog(@"删除收藏失败");
    }
    return isComplete;
}

#pragma - mark QUERY

- (NSMutableArray *)queryCollectionWithType:(NSInteger)type{

    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CollectionTable_5 WHERE collect_type=%li and uid=%ld ORDER BY date DESC",(long)type,(long)[[XKRWUserService sharedService] getUserId]];
    NSArray *data =[self query:sql];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:data.count];
    
    if (type == 1) {
        for (int i = 0 ; i < data.count; i++) {
            NSDictionary *temp = [data objectAtIndex:i];
            XKRWFoodEntity *entity = [XKRWFoodEntity new];
            entity.foodId = [temp[@"original_id"] integerValue];
            entity.foodName = temp[@"collect_name"];
            entity.foodLogo = temp[@"image_url"];
            entity.foodEnergy = [temp[@"food_energy"] integerValue];
            [mutableArray addObject:entity];
        }
    }else{
         for (int i = 0 ; i < data.count; i++) {
            NSDictionary *temp = [data objectAtIndex:i];
             XKRWSportEntity *entity = [XKRWSportEntity new];
             entity.sportId = [temp[@"original_id"] intValue];
             entity.sportName = temp[@"collect_name"];
             entity.sportPic = temp[@"image_url"];
             [mutableArray addObject:entity];
         }
    }
    return mutableArray;
}

-(BOOL)queryCollectionWithCollectType:(NSInteger)type andNid:(NSInteger)nid{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CollectionTable_5 WHERE collect_type=%li And original_id = %li",(long)type,(long)nid];
    NSMutableArray *arr = [self query:sql];
    if([arr count]==0){
        return NO;
    }else{//已经收藏过了 返回YES
        return YES;
    }
}

-(NSDictionary *)queryByCollectType:(NSInteger)type andNid:(NSInteger)nid{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CollectionTable_5 WHERE collect_type=%li And original_id = %li",(long)type,(long)nid];
    NSDictionary *dic = [self fetchRow:sql];
    
    return dic;
}


#pragma mark - Save to remote  保存数据到服务器
#pragma mark -
/**
 *  Base functoin, transfer data to remote server
 *
 *  @param dictionary data
 *  @param type       request type
 *  @param date       request date
 */
//接口可以用时，要注意再调整这里

- (id)saveToRemote:(NSDictionary *)dictionary type:(NSString *)type date:(NSDate *)date
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kSaveUserCollection]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:type forKey:@"type"]; //这里的type Key
   
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"error=%@", error);
        return nil;
    }
    NSString *jsonString = nil;
    if (jsonData.length) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"收藏错误: 请求数据异常");
        return nil;
    }
    [param setObject:jsonString forKey:@"data"];
    if (!date) {
        NSLog(@"收藏错误: 收藏内容时间戳为空");
        return nil;
    }
   
    NSDictionary *response = [self syncBatchDataWith:url andPostForm:param];
    if ([[response objectForKey:@"success"] intValue]) {
            [XKRWUserDefaultService setSynTimeOfCollection:[[NSDate date] timeIntervalSince1970]];
            return [response objectForKey:@"success"];
    } else {
        return nil;
    }
}

/**
 *  收藏同步到服务器
 *
 *  @param entity 收藏的实例
 */
- (NSDictionary *)saveCollectionToRemote:(XKRWCollectionEntity *)entity
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *collectType = [[NSString alloc] init];
    if (entity.collectType == 0) {
        collectType = @"article";
        [dic setObject:@((int)[entity.date timeIntervalSince1970]) forKey:@"create_time"];
        [dic setObject:entity.collectName forKey:@"name"];
        [dic setObject:[self yunyingNumberToString:entity.categoryType] forKey:@"type"];
        [dic setObject:[NSNumber numberWithInteger:entity.originalId] forKey:@"nid"];
        [dic setObject:entity.contentUrl forKey:@"url"];
    }else if (entity.collectType == 1){
        collectType = @"food";
        [dic setObject:@((int)[entity.date timeIntervalSince1970]) forKey:@"create_time"];
        [dic setObject:entity.collectName forKey:@"name"];
        [dic setObject:[NSNumber numberWithInteger:entity.originalId] forKey:@"nid"];
        [dic setObject:[NSNumber numberWithInteger:entity.foodEnergy] forKey:@"desc"];
        [dic setObject:entity.imageUrl forKey:@"url"];
    }else if (entity.collectType == 2){
        collectType = @"sport";
        [dic setObject:@((int)[entity.date timeIntervalSince1970]) forKey:@"create_time"];
        [dic setObject:entity.collectName forKey:@"name"];
        [dic setObject:[NSNumber numberWithInteger:entity.originalId] forKey:@"nid"];
    }else{
        collectType = @"";
    }
    NSString *response = [self saveToRemote:dic type:collectType date:entity.date];
    if (response) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:SUCCESS,@"isSuccess",entity ,@"entity",nil];
        return dict;
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ERROR,@"isSuccess",entity ,@"entity", nil];
        return dict;
    }
}



#pragma mark - 其他
#pragma mark -
/**
 *  枚举-数字 转字符串
 */
-(NSString *)yunyingNumberToString:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"jfzs";
            break;
        case 2:
            return @"lizhi";
            break;
        case 3:
            return @"ydtj";
            break;
        case 4:
            return @"mrss";
            break;
        case 5:
            return @"jfdrx";
            break;
        case 6:
            return @"pk";
            break;
        case 7:
            return @"lhyy";
            break;
            
        default:
            break;
    }
    return @"";
}

/**
 *  字符串 转  数字
 */
-(NSInteger)yunyingStringToNumber:(NSString*)string
{
    if([string isEqualToString:@"jfzs"])
    {
        return 1;
    }
    else if ([string isEqualToString:@"ydtj"])
    {
        return 2;
    }
    else if ([string isEqualToString:@"lizhi"])
    {
        return 3;
    }
    else if ([string isEqualToString:@"ydtj"])
    {
        return 4;
    }
    else if ([string isEqualToString:@"mrss"])
    {
        return 5;
    }
    else if ([string isEqualToString:@"pk"])
    {
        return 6;
    }
    else if ([string isEqualToString:@"lhyy"])
    {
        return 7;
    }
    else
    {
        return 0;
    }
}


#pragma --mark  5.0  收藏接口 重新整理

#pragma mark - Download from Remote 从服务器拉取数据

- (NSDictionary *)downloadFromRemoteType:(NSInteger)collectType date:(NSDate *)date
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kGetUserCollection]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *type = [[NSString alloc] init];
    if(collectType == 0){
        type = @"article";
    }else if (collectType == 1){
        type = @"food";
    }else if (collectType == 2){
        type = @"sport";
    }
    [param setObject:type forKey:@"type"];
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:param];
    return result;
}

- (void)getCollectionRemoteData
{
    NSDictionary * dic = [self downloadFromRemoteType:0 date:nil];
    [self saveDownloadDataToDB:[dic objectForKey:@"data"]];
}


#pragma --mark  将远程现在的数据保存到本地数据库
- (void)saveDownloadDataToDB:(NSDictionary *)dictionary
{
   
    NSInteger uid = [[XKRWUserService sharedService] getUserId];

    NSString *type = [[NSString alloc]init];
    
    if([dictionary objectForKey:@"article"]!=nil)
    {
        type = @"article";
        if ([dictionary[type] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *circumference in dictionary[type]) {
                XKRWCollectionEntity *temp_entity = [[XKRWCollectionEntity alloc]init];
                temp_entity.date = [NSDate dateWithTimeIntervalSince1970:[circumference[@"create_time"] intValue]];
                temp_entity.collectType  = 0;
                temp_entity.categoryType = [self yunyingStringToNumber:circumference[@"type"]];
                temp_entity.collectName  = circumference[@"name"];
                temp_entity.contentUrl   = circumference[@"url"];
                temp_entity.originalId   = [circumference[@"nid"] intValue];
                temp_entity.uid          = uid;
                if (![self collectToDB:temp_entity]) {
                    NSLog(@"同步所有数据时保存文章失败");
                   
                }
            }
        }
        
    }
    
     if ([dictionary objectForKey:@"food"] != nil)
    {
        type = @"food";
        if ([dictionary[type] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *circumference in dictionary[type]) {
                
                NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[circumference[@"create_time"] intValue]];
                XKRWCollectionEntity *temp_entity = [[XKRWCollectionEntity alloc]init];
                temp_entity.date = recordDate;
                temp_entity.collectType = 1;
                temp_entity.collectName = circumference[@"name"];
                temp_entity.originalId  = [circumference[@"nid"] intValue];
                temp_entity.foodEnergy  = [circumference[@"desc"] intValue];
                temp_entity.imageUrl    = circumference[@"url"];
                temp_entity.uid         = uid;
                if (![self collectToDB:temp_entity]) {
                    NSLog(@"同步所有数据时保存食物失败");
                                   }
            }
        }
    }
    
    
    if ([dictionary objectForKey:@"sport"] != nil)
    {
        type = @"sport";
        if ([dictionary[type] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *circumference in dictionary[type]) {
                
                NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:[circumference[@"create_time"] intValue]];
                XKRWCollectionEntity *temp_entity = [[XKRWCollectionEntity alloc]init];
                temp_entity.date = recordDate;
                temp_entity.collectType = 2;
                temp_entity.collectName = circumference[@"name"];
                temp_entity.originalId  = [circumference[@"nid"] intValue];
                temp_entity.uid         = uid;
                if (![self collectToDB:temp_entity]) {
                    NSLog(@"同步所有数据时保存运动失败");
                  
                }
            }
        }
        
    }
}

#pragma mark - Delete from remote
- (BOOL)deleteFromRemoteWithCollecType:(NSInteger)collectType date:(NSDate *)date
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kNewServer, kDeleteUserCollection];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *type = [[NSString alloc] init];
    if(collectType == 0)
    {
        type = @"article";
    }
    else if(collectType == 1)
    {
        type = @"food";
    }
    else if (collectType == 2)
    {
        type = @"sport";
    }
    
    [param setObject:type forKey:@"type"]; //这里的type Key
    [param setObject:date forKey:@"del"];
    
    NSDictionary *result;
    
    result = [self syncBatchDataWith:[NSURL URLWithString:urlString]
                         andPostForm:param];
    if ([result objectForKey:@"success"]) {
        return [[result objectForKey:@"success"] boolValue];
    }
    else
    {
        return NO;
    }
}

-(BOOL)deleteCollectionFromRemote:(XKRWCollectionEntity *)entity
{
    BOOL isSuccess = [self deleteFromRemoteWithCollecType:entity.collectType date:entity.date];
    return isSuccess;
}

@end
