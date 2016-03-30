//
//  XKRWManagementService.m
//  XKRW
//
//  Created by Jiang Rui on 14-4-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWManagementService.h"
#import "XKRWUserService.h"
#import "XKRWUserDefaultService.h"
#import "XKRWManagementHistoryEntity.h"
#import "XKRWManageHistoryDetailEntity.h"
#import "JSONKit.h"
#import "XKRWGroupItem.h"
static XKRWManagementService *shareInstance;

@implementation XKRWManagementService

//单例
+(id)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWManagementService alloc]init];
    });
    return shareInstance;
}

//保存  运营 内容
-(void)saveManagementInfo:(NSDictionary*)dic
{
    //历史数据
    NSDictionary *history = [self getManagementInfo];

    NSArray *array = [dic[@"data"] allKeys];
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0; i< [array count]; i++) {
            XKRWManagementEntity *entity = [[XKRWManagementEntity alloc]init];
            entity.module = array[i];
            if ([entity.module isEqualToString:@"jfzs"]) {
                entity.seq = 1;
                entity.category = eOperationKnowledge;
            }
            else if ([entity.module isEqualToString:@"lizhi"]) {
                entity.seq = 2;
                entity.category = eOperationEncourage;
            }
            else if ([entity.module isEqualToString:@"ydtj"]) {
                entity.seq = 3;
                entity.category = eOperationSport;
            }
            else if ([entity.module isEqualToString:@"mrss"]) {
                entity.seq = 4;
                entity.category = eOperationFamous;
            }else if ([entity.module isEqualToString:@"jfdrx"]) {
                entity.seq = 5;
                entity.category = eOperationTalentShow;
            }
            
            
            else if ([entity.module isEqualToString:@"pk"]) {
                entity.seq = 6;
                entity.category = eOperationPK;
            }
            else if ([entity.module isEqualToString:@"lhyy"]) {
                entity.seq = 7;
                entity.category = eOperationOthers;
                
                }
            id value = dic[@"data"][entity.module];

            
            if (( [value isKindOfClass:[NSArray class] ]  &&  [(NSArray*)value count] == 0) || [value isEqual:@""] ) {
                continue   ;
            }
            
            if ( ([value isKindOfClass:[NSDictionary class] ] && [[(NSDictionary*)value allKeys ] count]== 0 )|| [value isEqual:@""]) {
                continue  ;
            }
            
            
            if (![self isNull:dic[@"data"][entity.module]]
                ) {
                
                entity.content = dic[@"data"][entity.module];
                
                if (((entity.category == eOperationSport || entity.category == eOperationEncourage) || entity.category == eOperationKnowledge ||entity.category == eOperationTalentShow ||entity.category == eOperationPK || (entity.category == eOperationFamous)) &&  [dic[@"data"][entity.module] isKindOfClass:[NSDictionary class]]) {
                    
                    XKLog(@"data返回%@",(NSString *)dic[@"data"]);
                    XKLog(@"module返回%@",(NSString *)dic[@"data"][entity.module]);
                    XKLog(@"nid返回%@",(NSString *)dic[@"data"][entity.module][@"nid"]);
                    
                    entity.nid = ((NSString *)dic[@"data"][entity.module][@"nid"]).intValue;
                    entity.date = dic[@"data"][entity.module][@"dateText"];
                }
                else {
                    //灵活运营模块没有日期
                    entity.date = @"0";
                }
            }
            
            entity.complete = NO;
            entity.day = [[NSDate date] timeIntervalSince1970] / (60*60*24);
            
            if (entity.category !=  eOperationOthers) //除了灵活运营 包括pk  名人瘦瘦
            {
                
                //查询 除灵活运营的 文章nid  nid一致的话 不插入  若nid 一致 替换
                NSArray *xArr = [history objectForKey:@"others"];
                if(xArr.count == 0 || !xArr)  //没有数据
                {
                 [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date)" withParameterObject:entity];
                }
                else
                {
                    for (XKRWManagementEntity *obj in  xArr)
                    {
                        if (obj.category == entity.category)
                        { //相同类别下 文章
                            
                            if (obj.nid == entity.nid)
                            { //文章一致  不更新
                                
                            }
                            else
                            {
                                [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date)" withParameterObject:entity];
                            }
                        }
                    }
                }
            }
            else
            {
            [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date)" withParameterObject:entity];
            }
        }
    }];

}



- (NSDictionary *)getImportantNotice:(NSNumber *) noticeId;
{
    NSURL *importantNoticeRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kImportantNotice]];
    NSDictionary *requestPara;
    if (noticeId) {
        requestPara = @{@"nid":noticeId};
    }else{
        requestPara = [NSDictionary dictionary];
    }
    
    
    NSDictionary *requestDic = [self syncBatchDataWith:importantNoticeRequest andPostForm:requestPara withLongTime:10];
    
    return requestDic;
    
}

//保存星星数
-(void)saveStarNum:(NSDictionary*)dic
{
    NSString *nids = dic[@"data"][@"nids"];
    NSArray *nidArray = [nids componentsSeparatedByString:@","];
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"UPDATE management SET complete = 0"];
        if ([nidArray count] > 0) {
            for (NSString *nid in nidArray) {
                [db executeUpdate:@"UPDATE management SET complete = 1 WHERE nid = ?",nid];
            }
        }
    }];

}

//读取星星数
- (void)readStarNum
{
    
}

//获取当前的运营内容
-(NSMutableDictionary *)getManagementInfo {
    NSMutableArray *managementArray = [[NSMutableArray alloc]init];
    NSMutableArray *lhyyArray = [[NSMutableArray alloc]init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQueryWithFormat:@"SELECT module,value AS content,seq,nid,complete,day,category,date FROM management ORDER BY day DESC,seq ASC LIMIT 7"];
        while ([result next]) {
            XKRWManagementEntity *entity = [[XKRWManagementEntity alloc]init];
            if ([self isNull:[result stringForColumn:@"content"]]) {
                continue;
            }
            //如果是灵活运营，就把item单独取出来存入array
            if ([[result stringForColumn:@"module"] isEqualToString:@"lhyy"]) {
                if ( (![self isNull:[result stringForColumn:@"module"]]) &&  (![self isEmptyString:[result stringForColumn:@"module"]]) ) {
                    NSArray *array = [[result stringForColumn:@"content"] objectFromJSONString];
                    for (NSDictionary *dic in array) {
                        XKRWManagementEntity *entity = [[XKRWManagementEntity alloc]init];
                        entity.module = @"lhyy";
                        entity.content = dic;
                        [lhyyArray addObject:entity];
                    }
                }
                continue;
            }
            [result setResultToObject:entity];
            [managementArray addObject:entity];

        }

    }];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:managementArray,@"others",lhyyArray,@"lhyy", nil];
}

//获取当前用户星星数和已经回答问题
-(void)getUserStarNumFromRemote {
    NSURL *starNumRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetUserStarNum]];
    NSString *token = [[XKRWUserService sharedService] getToken];
    if (token == nil) {
        return;
    }
    NSDictionary *starNumDic = [self syncBatchDataWith:starNumRequest andPostForm:@{@"token": token}];
    
    [[XKRWUserService sharedService] setUserStarNum:((NSString *)starNumDic[@"data"][@"stars"]).intValue];
    [[XKRWUserService sharedService] saveUserInfo];
    NSString *nids = starNumDic[@"data"][@"nids"];
    NSArray *nidArray = [nids componentsSeparatedByString:@","];
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"UPDATE management SET complete = 0"];
        if ([nidArray count] > 0) {
            for (NSString *nid in nidArray) {
                [db executeUpdate:@"UPDATE management SET complete = 1 WHERE nid = ?",nid];
            }
        }
    }];
}


//根据类别获取本地运营历史数据
-(NSArray *)getManagementHistoryByCategory:(XKOperation)category {
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:20];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM management_history WHERE category = ? ORDER BY date DESC",[NSString stringWithFormat:@"%i",category]];
        while ([resultSet next]) {
            XKRWManagementHistoryEntity *entity = [[XKRWManagementHistoryEntity alloc]init];
            [resultSet setResultToObject:entity];
            [array addObject:entity];
        }
    }];
    return array;
}


//从本地获取运营历史数据详细信息
-(XKRWManageHistoryDetailEntity *)getManagementInfoCategory:(XKOperation)category andId:(NSString *)nid {
    __block XKRWManageHistoryDetailEntity *entity = nil;
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM manage_history_record WHERE category = ? AND nid = ?",itoa(category),nid];
        while ([result next]) {
            entity = [[XKRWManageHistoryDetailEntity alloc]init];
            [result setResultToObject:entity];
        }
    }];
    return entity;
}


//PK提交 1 正方 0 反方
-(BOOL)uploadTogetherPK:(NSString *)side andPKId:(NSString *)nid {
    
    BOOL voteSucess = YES;
    NSURL *voteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kPKVote]];
    
    NSDictionary *requestPara = @{@"token": [[XKRWUserService sharedService] getToken],
                                  @"pkid": nid,
                                  @"value": side};
    
    NSDictionary* backData =[self syncBatchDataWith:voteURL andPostForm:requestPara];
    NSDictionary *resultDic = backData[@"data"];
    if ([backData[@"error"][@"code"] intValue] == 500 ) {
        voteSucess = NO;
    }
    __block XKRWManagementEntity *entity = [[XKRWManagementEntity alloc] init];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT module,value AS content,seq,nid,complete,day,category,date  FROM management WHERE nid = ? and module = ?",nid,@"pk"];
        while ([result next]) {
            [result setResultToObject:entity];
        }
        
        NSMutableDictionary *dic = [entity.content mutableCopy];
        dic[@"zfps"] = resultDic[@"positive"];
        dic[@"ffps"] = resultDic[@"negative"];
        entity.content = dic;
        [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date)" withParameterObject:entity];
    }];
    return voteSucess;
}

//获得根据类别和nid获取当天的manageentity
-(XKRWManagementEntity *)getTodayManagementEntityBy:(XKOperation)category andNid:(NSString *)nid {
    __block XKRWManagementEntity *entity = [[XKRWManagementEntity alloc]init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT module,value AS content,seq,nid,complete,day,category,date FROM management WHERE nid = ? and module = ?",nid,[self getStringCategoryByEnum:category]];
        while ([result next]) {
            [result setResultToObject:entity];
        }
    }];
    
    return entity;
}

#pragma --mark tools function
//根据cate enum 返回 相应 字符串
-(NSString *)getStringCategoryByEnum:(XKOperation)operation {
    NSString *categoryName = nil;
    switch (operation) {
        case eOperationKnowledge:
            categoryName = @"jfzs";
            break;
        case eOperationEncourage:
            categoryName = @"lizhi";
            break;
        case eOperationSport:
            categoryName = @"ydtj";
            break;
        case eOperationPK:
            categoryName = @"pk";
            break;
        case eOperationFamous:
            categoryName = @"mrss";
            break;
        case eOperationTalentShow:
            categoryName = @"jfdrx";
            break;
            
        case eOperationOthers:
            categoryName = @"lhyy";
            
        default:
            break;
    }
    return categoryName;
}


-(NSDictionary*)getYyUserInfoFromServer
{
    NSURL *mamagementyyUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,KManagementContact]];
    NSDictionary *nagementyyDic = [self syncBatchDataWith:mamagementyyUrl andPostForm:nil];
    return nagementyyDic;
}






@end
