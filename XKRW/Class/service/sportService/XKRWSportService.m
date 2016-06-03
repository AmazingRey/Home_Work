//
//  XKRWSportService.m
//  XKRW
//
//  Created by zhanaofan on 14-3-4.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWSportService.h"
#import "NSDictionary+XKUtil.h"
#import "XKSilentDispatcher.h"


static XKRWSportService *shareServiceInstance;

@implementation XKRWSportService

+(id)shareService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareServiceInstance = [[XKRWSportService alloc] init ];
    });
    return shareServiceInstance;
}

- (NSMutableArray*) sportCateList
{
    return [self query:@"SELECT * FROM sport_category"];
}

- (NSArray *)getSportDetailByIds:(NSArray *)ids {
    
    NSMutableArray *returnValue = [NSMutableArray new];
    
    for (NSString *sportid in ids) {
        XKRWSportEntity *entity = [self sportDetailWithId:(uint32_t)[sportid integerValue]];
        
        if (entity.sportId != 0) {
            [returnValue addObject:entity];
            
        } else {
            entity = [self syncQuerySportWithId:(uint32_t)[sportid integerValue]];
            [returnValue addObject:entity];
        }
    }
    return returnValue;
}

- (XKRWSportEntity *)sportDetailWithId:(uint32_t)sportId
{
    return [self sportDetailWithId:sportId andSportName:nil];
}

- (XKRWSportEntity *)sportDetailWithId:(uint32_t)sportId andSportName:(NSString *)name{

    XKRWSportEntity __block *sportEntity = [[XKRWSportEntity alloc] init];
    if (name && name.length) {
        sportEntity.sportName = name;
    }
    NSString *key = [self genKey:sportId ];
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        FMResultSet *fmrst = [db executeQuery:@"SELECT data FROM caches WHERE id = ?",key];
        while ([fmrst next]) {
            NSData  *_data_rst = [NSData dataWithData: [fmrst dataNoCopyForColumn:@"data"]];
            sportEntity = [NSKeyedUnarchiver unarchiveObjectWithData:_data_rst];
        }
        [fmrst close];
    }];
    return sportEntity;
}


//保存运动缓存
- (BOOL) saveSportCache:(uint32_t) sportId withData:(NSData*)data
{
    BOOL __block isOK = NO;
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        isOK = [db executeUpdate:@"REPLACE INTO caches VALUES (?,?,?,?)",[self genKey:sportId],data,[NSNumber numberWithInt:0],[NSNumber numberWithInt:1]];
        
    }];
    return isOK;
}

- (XKRWSportEntity*) syncQuerySportWithId:(uint32_t)sportId
{
    XKRWSportEntity *sportEntity = [[XKRWSportEntity alloc] init];
    NSString *api_url = [NSString stringWithFormat:@"%@/content/detail/?type=sport", kNewServer];
    NSDictionary *param = @{@"id": @(sportId)};

        NSDictionary *rst = [self syncBatchDataWith:XKURL(api_url) andPostForm:param];
        if (rst ) {
            NSDictionary *value = [rst objectForKey:@"data"];
            
            [self dealSportDataWithDictionary:value inEntity:sportEntity];
            
            if (sportEntity.sportId != 0) {
                [self saveSportCache:sportId withData:[NSKeyedArchiver archivedDataWithRootObject:sportEntity]];
            }
            return sportEntity;
        }
        return sportEntity;
}




- (NSArray *)batchDownloadSportWithIDs:(NSString *)ids {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/content/all/?type=sport", kNewServer]];
    NSDictionary *param = @{@"ids": ids};
    
    NSDictionary *rst = [self syncBatchDataWith:url andPostForm:param];
    
    if (rst) {
        NSMutableArray *returnValue = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in rst[@"data"]) {
            
            XKRWSportEntity *entity = [[XKRWSportEntity alloc] init];
            [self dealSportDataWithDictionary:dict inEntity:entity];
            
            if (entity.sportId) {
                [self saveSportCache:entity.sportId withData:[NSKeyedArchiver archivedDataWithRootObject:entity]];
                [returnValue addObject:entity];
            }
        }
        return returnValue;
    }
    return nil;
}

- (void)silenceBatchDownloadSportWithIDs:(NSString *)ids {
    
    @try {
        [self batchDownloadSportWithIDs:ids];
    }
    @catch (NSException *exception) {
        NSLog(@"batch download sport failed");
    }
}

- (void)dealSportDataWithDictionary:(NSDictionary *)value inEntity:(XKRWSportEntity *)sportEntity {
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        sportEntity.sportId = [[value objectForKey:@"id"] intValue];
        sportEntity.sportName = [value objectForKey:@"name"];
        sportEntity.sportMets = [[value objectForKey:@"mets"] floatValue];
        sportEntity.cateId = [[value objectForKey:@"type_id"] intValue];
        sportEntity.sportPic = [value objectForKey:@"index_pic"];
        sportEntity.sportTime = [[value objectForKey:@"need_time"] intValue];
        
        sportEntity.sportUnit = (SportUnit)[value[@"unit"] integerValue];
//        sportEntity.vedioPic = [value objectForKey:@"dongzuo_pic"];
        sportEntity.sportIntensity= [value objectForKey:@"labor_desc"];//运动强度
        sportEntity.sportEffect = [value objectForKey:@"effect"];
        sportEntity.sportCareTitle = [value objectForKey:@"notice_title"];
        sportEntity.sportCareDesc = [value objectForKey:@"notice_desc"];
        sportEntity.sportActionDesc = [value objectForKey:@"act_desc"];
        sportEntity.sportActionPic = [value objectForKey:@"act_pic"];
        sportEntity.sportVedio = [value objectForKey:@"vedio"];
        
        sportEntity.iFrame = value[@"shipin_iframe"];
    }
}


- (NSString *)genKey:(uint32_t)sportId
{
    return [NSString stringWithFormat:@"%@_%i",kCacheKeyOfSport,sportId];
}

//- (NSArray *) syncQuerySportWithCategory:(uint32_t) cateId
//{
//    NSString *api_url = [NSString stringWithFormat:@"%@/sportapi/postlistforgroup", kServer ];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:cateId],@"type_id",[NSNumber numberWithInt:0],@"pageSize",[NSNumber numberWithInt:1],@"page",nil];
//    NSArray *data;
////    NSMutableArray *rst = [[NSMutableArray alloc] init];
//    @try {
//        NSDictionary *rst = [self syncBatchDataWith:XKURL(api_url) andPostForm:dict];
//        NSArray *arr = [rst objectForKey:@"data"];
//        if (arr && ![arr isKindOfClass:[NSNull class]]) {
//            data = [NSArray arrayWithArray:arr];
//        }
//        else data = nil;
//    }
//    @catch (NSException *exception) {
//#ifdef XK_DEV
//        NSLog(@"获取运动详情：%@",[exception reason] );
//#endif
//        @throw exception;
//    }
//    return data;
//
//}

- (NSArray *)searchSportWithKey:(NSString *)key page:(int)page pageSize:(int)pageSize {
    
    if (page == 0) {
        page = 1;
    }
    if (pageSize == 0) {
        pageSize = 30;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kSearchURL]];
    NSDictionary *param = @{@"type": @"sport", @"key": key, @"page": @(page), @"size": @(pageSize)};
    
    NSDictionary *rst = [self syncBatchDataWith:url andPostForm:param];
    
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    for (NSDictionary *temp in rst[@"data"][@"sport"]) {
        XKRWSportEntity *entity = [[XKRWSportEntity alloc] init];
        [self dealSportDataWithDictionary:temp inEntity:entity];
        
        if (entity.sportId != 0) {
            [sports addObject:entity];
        }
    }
    return sports;
}

//- (NSArray *) syncQuerySportWithKey:(NSString*) key page:(uint32_t)page pageSize:(uint32_t) pageSize 
//{
//
//  
//    
//    NSString *api_url = [NSString stringWithFormat:@"%@/sportapi/postlistforkey", kServer ];
//    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:pageSize],@"pageSize",nil];
////    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",[NSNumber numberWithInt:0],@"pageSize",[NSNumber numberWithInt:1],@"page",nil];
//    NSArray *data;
//    //    NSMutableArray *rst = [[NSMutableArray alloc] init];
//    @try {
//        NSDictionary *rst = [self syncBatchDataWith:XKURL(api_url) andPostForm:dict];
//        NSArray *arr = [rst objectForKey:@"data"];
//        if (arr && ![arr isKindOfClass:[NSNull class]] ) {
//            data = [NSArray arrayWithArray:arr];
//        }
//        else data = nil;
//    }
//    @catch (NSException *exception) {
//#ifdef XK_DEV
//        NSLog(@"");
////       @throw exception;
//#endif
//    }
//    return data;
//
//}
//
//- (XKRWSchemeEntity *)randomSportSchem:(uint32_t)sid
//{
//    NSString *uri =  [NSString stringWithFormat:@"%@/%@/%i",kServer,kShakeSportUrl,sid];
//    NSDictionary *para = @{@"no_fangan_id":[NSNumber numberWithInt:sid]};
//    @try {
//        NSDictionary *rst =[self syncBatchDataWith:XKURL(uri) andPostForm:para];
//        NSDictionary *data = [rst objectForKey:@"data"];
//        if (data && ![data isKindOfClass:[NSNull class]]) {
//            XKRWSchemeEntity *sportScheme = [[XKRWSchemeEntity alloc] init];
//            sportScheme.type = 0;
//            sportScheme.title = [data objectForKey:@"name"];
//            sportScheme.sid = [[data objectForKey:@"id"] intValue];
//            sportScheme.energy = 0;
////            NSArray *sports = [data objectForKey:@"params"];
////            if ([sports count] > 0) {
////                for (NSDictionary *dict in sports) {
////                    
////                }
////            }
//        }
//    }
//    @catch (NSException *exception) {
//        @throw exception;
//    }
//    
//    return nil;
//}
@end
