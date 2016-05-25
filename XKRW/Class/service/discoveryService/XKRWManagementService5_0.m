//
//  XKRWManagementService5_0.m
//  XKRW
//
//  Created by Jack on 15/6/3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWManagementService5_0.h"
#import "JSONKit.h"
#import "XKRWUserService.h"
#import "XKRWCommentEtity.h"
#import "XKRWReplyEntity.h"
#import "XKRWReplyView.h"
#import "XKRWShareAdverEntity.h"
#import "XKRWIntelligentListEntity.h"
#import "XKRWUserService.h"
#import "XKRW-Swift.h"
static XKRWManagementService5_0 *shareInstance;
@implementation XKRWManagementService5_0
{
    NSUserDefaults *blogRankDefault;
}
//单例
+(instancetype)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWManagementService5_0 alloc]init];
    });
    return shareInstance;
}

#pragma mark - 发现
#pragma mark -

- (NSDictionary *)getBlogRankListFromServer {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetBlogRank]];
    NSDictionary *dic = [self syncBatchDataWith:url andPostForm:nil];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *tempDic in dic[@"data"][@"ranks"]) {
        XKRWIntelligentListEntity *entity = [XKRWIntelligentListEntity new];
        entity.iconUrl = tempDic[@"avatar"];
        entity.nickName = tempDic[@"nickname"];
        entity.levelUrl = tempDic[@"level"];
        entity.beLikedNum = [tempDic[@"rev_goods"] integerValue];
        [dataArray addObject:entity];
    }
    NSString *week_start = dic[@"data"][@"week_start"];
    NSString *week_end = dic[@"data"][@"week_end"];
    NSDictionary *dataDictionary = @{@"success":dic[@"success"],@"entityArray":dataArray,@"week_start":week_start,@"week_end":week_end,@"my_score":dic[@"data"][@"my_score"]};
    return dataDictionary;
}


/**
 *  删除评论
 *
 *  @param blogid     文章id
 *  @param comment_id 评论id
 *
 *  @return 
 */
- (NSDictionary *)deleteCommentWithBlogId:(NSString *)blogid andComment_id:(NSNumber *)comment_id
{
    NSURL *delCommentUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kDelComment]];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:blogid,@"blogid",comment_id,@"comment_id", nil];
    NSDictionary *delCommentDic = [self syncBatchDataWith:delCommentUrl andPostForm:param];
    return delCommentDic;
}

// 写评论
- (NSMutableDictionary *)writeCommentWithMessage:(NSString *)massege Blogid:(NSString *)blogid sid:(NSInteger)sid fid:(NSInteger)fid type:(NSInteger)type
{
    NSURL *addCommentUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kAddComment]];
    NSString *userNickname = [[XKRWUserService sharedService]getUserNickName];
    NSDictionary *param;
    if (type == 2) {
        param = @{@"msg":massege,@"blogid":blogid,@"sid":@(sid),@"fid":@(fid),@"nickname":userNickname,@"type":@(type)};
    } else {
         param = @{@"msg":massege,@"blogid":blogid,@"sid":@(sid),@"fid":@(fid),@"nickname":userNickname};
    }
    NSMutableDictionary *addCommentDic = [NSMutableDictionary dictionaryWithDictionary:[self syncBatchDataWith:addCommentUrl andPostForm:param]];
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    XKLog(@"%@",addCommentDic[@"data"]);
    [returnDic setObject:addCommentDic[@"success"] forKey:@"success"];
    if (addCommentDic[@"data"][@"passed"]!= nil && ![addCommentDic[@"data"][@"passed"] boolValue]) {
        [returnDic setObject:addCommentDic[@"data"][@"passed"] forKey:@"passed"];
        [returnDic setObject:addCommentDic[@"data"][@"msg"] forKey:@"message"];
    } else {
        if (addCommentDic[@"success"]) {
            
            if (fid == 0 && sid == 0) {
                XKRWCommentEtity *entity = [XKRWCommentEtity new];
                entity.iconUrl = addCommentDic[@"data"][@"sender_avatar"];
                entity.levelUrl = addCommentDic[@"data"][@"sender_level"];
                entity.nameStr = addCommentDic[@"data"][@"sender_name"];
                entity.declaration = addCommentDic[@"data"][@"sender_manifesto"];
                entity.commentStr = addCommentDic[@"data"][@"content"][@"content"];
                entity.time = [addCommentDic[@"data"][@"ctime"] integerValue];
                entity.comment_id = addCommentDic[@"data"][@"id"];
                [entity calculateTimeShowStr];
                // 计算msg的高度
                [entity calculateCommentStrHeight];
                
                // 判断是否显示“全文”按钮
                if (entity.mainCommentHeight <= ExactlySixLinesHeight) {
                    entity.isShowBtn = NO;
                    entity.currentHeight = entity.commentHeight;
                }else{
                    entity.isShowBtn = YES;
                    entity.currentHeight = ExactlySixLinesHeight;
                }

                [returnDic setObject:entity forKey:@"comment"];
            } else {
            XKRWReplyEntity *entity = [[XKRWReplyEntity alloc] init];
            entity.replyContent = addCommentDic[@"data"][@"content"][@"content"];
            entity.fid = [addCommentDic[@"data"][@"fid"] integerValue];
            entity.sid = [addCommentDic[@"data"][@"sid"] integerValue];
            entity.nickName = addCommentDic[@"data"][@"sender_name"];
            entity.receiver_Name = addCommentDic[@"data"][@"receiver_name"];
            entity.mainId = [addCommentDic[@"data"][@"id"] integerValue];
            [returnDic setObject:entity forKey:@"comment"];
            }
        }
    }
    return returnDic;
}

// 获取评论列表
- (NSMutableDictionary *)getCommentFromServerWithBlogId:(NSString *)blogId Index:(NSNumber *)index andRows:(NSNumber *)rows type:(NSNumber *)type
{
    NSURL *commentUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetComment]];
    NSDictionary *param;
    if (type == nil) {
        param = @{@"blogid":blogId,@"index":index,@"rows":rows};
    } else {
        param = @{@"type":type,@"blogid":blogId,@"index":index,@"rows":rows};
    }
    
    NSMutableDictionary *CommentReturnDic = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *commentDic = [self syncBatchDataWith:commentUrl andPostForm:param];
    XKLog(@"评论%@",commentDic);
    // 获取总数
    [CommentReturnDic setObject:commentDic[@"data"][@"total"] forKey:@"commentNum"];
    
    for (NSDictionary *temp in commentDic[@"data"][@"comment"]) {
        
        [array addObject:[self getCommentEntityFromDic:temp]];
    }
    [CommentReturnDic setObject:array forKey:@"comment"];
    return CommentReturnDic;
}


- (XKRWCommentEtity *)getCommentEntityFromDic:(NSDictionary *)temp
{
    XKRWCommentEtity *entity = [[XKRWCommentEtity alloc] init];
    entity.comment_id = [NSNumber numberWithInteger:[temp[@"id"] integerValue]];
    entity.iconUrl = temp[@"avatar"];
    entity.nameStr = temp[@"nickname"];
    entity.declaration = temp[@"manifesto"];
    if (temp[@"content"] != nil && ![temp[@"content"] isKindOfClass:[NSNull class]]     ) {
        NSArray *contentArray = [temp objectForKey:@"content"];
        if(contentArray.count > 0){
            entity.commentStr = temp[@"content"][0][@"content"];
        }else{
            entity.commentStr = @"";
        }
    }
    
    entity.levelUrl = temp[@"level"];
    entity.time = [temp[@"time"] integerValue];
    [entity calculateTimeShowStr];
    // 计算msg的高度
    [entity calculateCommentStrHeight];
    
    // 判断是否显示“全文”按钮
    if (entity.mainCommentHeight <= ExactlySixLinesHeight) {
        entity.isShowBtn = NO;
        entity.currentHeight = entity.commentHeight;
    }else{
        entity.isShowBtn = YES;
        entity.currentHeight = ExactlySixLinesHeight;
    }
    
    if (temp[@"sub_cmts"] && [temp[@"sub_cmts"] count]) {
        entity.sub_Array = [NSMutableArray array];
        for (NSDictionary *sub_temp in temp[@"sub_cmts"]) {
            XKRWReplyEntity *subEntity = [[XKRWReplyEntity alloc] init];
            subEntity.mainId = [sub_temp[@"id"] integerValue];
            subEntity.fid = [sub_temp[@"fid"] integerValue];
            subEntity.sid = [sub_temp[@"sid"] integerValue];
            subEntity.replyContent = sub_temp[@"content"][0][@"content"];
            subEntity.nickName = sub_temp[@"sender_name"];
            subEntity.receiver_Name = sub_temp[@"receiver_name"];
            [entity.sub_Array addObject:subEntity];
        }
        XKRWReplyView *view = [[XKRWReplyView alloc] initWithDataArray:entity.sub_Array];
        entity.currentHeight += view.size.height;
    }

    return entity;
}

//从网络获取瘦身分享话题列表内容
- (NSMutableArray *)getBlogMoreArticlesWithTopic:(NSNumber *)topic AndPagetime:(NSNumber *)pagetime
{
    NSURL *fitnessShareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetBlogMoreArticle]];

    NSDictionary *parm = [NSDictionary dictionaryWithObjectsAndKeys:pagetime,@"pagetime",@(10),@"size",topic,@"topic", nil];
    
    NSDictionary *blogMoreDic = [self syncBatchDataWith:fitnessShareUrl andPostForm:parm];
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSDictionary *temp in blogMoreDic[@"data"]) {
        
        XKRWArticleListEntity *entity = [[XKRWArticleListEntity alloc] init];
        entity.headImageUrl = temp[@"avatar"];
        entity.blogId = temp[@"blogid"];
        
        NSData *data = [temp[@"cover_pic"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *coverPicDc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        entity.coverImageUrl = coverPicDc[@"url"];
        
        entity.coverEnabled = [coverPicDc[@"flag"] integerValue];
        
        entity.recommendState = [temp[@"status"] intValue];
        
        entity.createTime = [temp[@"ctime"] intValue];
        entity.bePraisedNum = [temp[@"goods"] integerValue];
        entity.userDegreeImageUrl = temp[@"level"];
        entity.manifesto = temp[@"manifesto"];
        entity.userNickname = temp[@"nickname"];
        entity.title = temp[@"title"];
        entity.articleViewNums = [temp[@"views"] integerValue];
        entity.manifesto = temp[@"manifesto"];
        XKLog(@"%@**%@",temp[@"topic_key"],temp[@"topic_name"]);
        XKRWTopicEntity *topicEntity = [[XKRWTopicEntity alloc] initWithId:[temp[@"topic_key"] integerValue] name:temp[@"topic_name"] enabled:YES];
        
        entity.topic = topicEntity;
        
        [mutArray addObject:entity];
        
    }
    
    return mutArray;
}
//从网络获取瘦身分享推荐内容
- (NSMutableArray *)getBlogRecommendFromServerWithPage:(NSNumber *)page
{
    NSURL *fitnessShareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetBlogRecommendArticle]];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",@"10",@"size", nil];
    
    NSDictionary *blogRecommendDic = [self syncBatchDataWith:fitnessShareUrl andPostForm:parm];
   
    return [self dealDataArrayToArticleListEntityArray:blogRecommendDic[@"data"]];
}

- (NSMutableArray *)dealDataArrayToArticleListEntityArray:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *temp in array) {
        XKRWArticleListEntity *entity = [XKRWArticleListEntity new];
        entity.headImageUrl = temp[@"avatar"];
        entity.blogId = temp[@"blogid"];
        
        NSData *data = [temp[@"cover_pic"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *coverPicDc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        entity.coverImageUrl = coverPicDc[@"url"];
        
        entity.coverEnabled = [coverPicDc[@"flag"] integerValue];
        
        entity.articleState = [temp[@"del_status"] intValue];
        entity.recommendState = [temp[@"status"] intValue];
        entity.praisedTime = [temp[@"good_time"] intValue];
        entity.createTime = [temp[@"ctime"] intValue];
        entity.bePraisedNum = [temp[@"goods"] integerValue];
        entity.userDegreeImageUrl = temp[@"level"];
        entity.manifesto = temp[@"manifesto"];
        entity.userNickname = temp[@"nickname"];
        entity.title = temp[@"title"];
        entity.articleViewNums = [temp[@"views"] integerValue];
        entity.manifesto = temp[@"manifesto"];
        
        XKRWTopicEntity *topicEntity = [[XKRWTopicEntity alloc] initWithId:[temp[@"topic_key"] integerValue] name:temp[@"topic_name"] enabled:YES];
        
        entity.topic = topicEntity;
        [mutArray addObject:entity];
    }
    
    return mutArray;
}


//从网络获取运营内容
-(NSDictionary *)downloadArticleFromServer
{
    NSURL *mamagementUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kManagementArticleURL]];
    
    NSDictionary *managementDic = [self syncBatchDataWith:mamagementUrl andPostForm:[NSDictionary dictionary]];
    
    return managementDic;
}

//从本地获取运营内容
-(NSMutableDictionary *)getArticleInfoFromDB
{
    NSMutableArray *othersArray = [[NSMutableArray alloc]init];
    NSMutableArray *lhyyArray = [[NSMutableArray alloc]init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQueryWithFormat:@"SELECT module,value AS content,seq,nid,complete,day,category,date,read,readNum,bigImage,smallImage,showType,subtitle FROM management ORDER BY day DESC"];
        while ([result next]) {
            //旧的
            XKRWManagementEntity5_0 *entity = [[XKRWManagementEntity5_0 alloc]init];
            if ([self isNull:[result stringForColumn:@"content"]]) {
                continue;
            }
            //如果是灵活运营，就把item单独取出来存入array
            if ([[result stringForColumn:@"module"] isEqualToString:@"lhyy"]) {
                if ( (![self isNull:[result stringForColumn:@"module"]]) &&  (![self isEmptyString:[result stringForColumn:@"module"]]) ) {
                    NSArray *array = [[result stringForColumn:@"content"] objectFromJSONString];
                    for (NSDictionary *dic in array) {
                        XKRWManagementEntity5_0 *entity = [[XKRWManagementEntity5_0 alloc]init];
                        entity.module = @"lhyy";
                        entity.content = dic;
                        entity.read = [dic[@"read"] intValue];
                        entity.readNum = [NSString stringWithFormat:@"%@",dic[@"pv"]];
                        entity.smallImage = dic[@"s_image"];
                        entity.bigImage = dic[@"b_image"];
                        entity.subtitle = dic[@"subtitle"];
                        entity.showType = [dic[@"show_type"] integerValue];
                        [lhyyArray addObject:entity];
                    }
                }
                continue;
            }
            [result setResultToObject:entity];
            [othersArray addObject:entity];
            
        }
    }];
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:othersArray,@"others",lhyyArray,@"lhyy", nil];
}

//保存下载的运营内容到本地
-(void)saveDownloadArticleInfoToDB:(NSDictionary*)dic
{
    //历史数据
    NSDictionary *history = [self getArticleInfoFromDB];
    
    NSArray *array = [dic[@"data"] allKeys];
    
    for (int i = 0; i< [array count]; i++) {
        XKRWManagementEntity5_0 *entity = [[XKRWManagementEntity5_0 alloc]init];
        entity.module = array[i];
        if ([entity.module isEqualToString:@"jfzs"]) {
            entity.seq = 1;
            entity.category = eOperationKnowledge;//减肥知识
        }
        else if ([entity.module isEqualToString:@"lizhi"]) {
            entity.seq = 2;
            entity.category = eOperationEncourage;//励志
        }
        else if ([entity.module isEqualToString:@"ydtj"]) {
            entity.seq = 3;
            entity.category = eOperationSport;//运动
        }
        else if ([entity.module isEqualToString:@"mrss"]) {
            entity.seq = 4;
            entity.category = eOperationFamous;//名人瘦瘦
        }else if ([entity.module isEqualToString:@"jfdrx"]) {
            entity.seq = 5;
            entity.category = eOperationTalentShow;//减肥达人秀
        }
        else if ([entity.module isEqualToString:@"pk"]) {
            entity.seq = 6;
            entity.category = eOperationPK;//一起PK
        }
        
        id value = dic[@"data"][entity.module];
        
        if (( [value isKindOfClass:[NSArray class] ]  &&  [(NSArray*)value count] == 0) || [value isEqual:@""] ) {
            continue ;
        }
        
        if ( ([value isKindOfClass:[NSDictionary class] ] && [[(NSDictionary*)value allKeys ] count]== 0 )|| [value isEqual:@""]) {
            continue ;
        }
        
        //模块不为空 并且不是灵活运营
        if (![self isNull:dic[@"data"][entity.module]] && !(entity.category == eOperationOthers))
        {
            if (((entity.category == eOperationSport || entity.category == eOperationEncourage) || entity.category == eOperationKnowledge ||entity.category == eOperationTalentShow ||entity.category == eOperationPK || (entity.category == eOperationFamous)) &&  [dic[@"data"][entity.module] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *tempDic = dic[@"data"][entity.module];
                entity.content = tempDic;
                entity.nid = ((NSString *)tempDic[@"nid"]).intValue;
                entity.date = tempDic[@"update_time"];
                entity.articleDate =  tempDic[@"date"];
                entity.readNum = tempDic[@"pv"];
                entity.bigImage = tempDic[@"b_image"];
                entity.smallImage = tempDic[@"s_image"];
                entity.showType = [tempDic[@"show_type"] integerValue];
                entity.subtitle = tempDic[@"subtitle"];
            }else{
                entity.date = @"";
            }
            entity.complete = NO;
            entity.day = [[NSDate date] timeIntervalSince1970] / (60*60*24);
            //写数据库操作
            [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
                if (entity.category !=  eOperationOthers) //除了灵活运营
                {
                    //查询 除灵活运营的文章nid
                    //若nid一致的话 不插入
                    //若nid 一致 替换
                    NSArray *xArr = [history objectForKey:@"others"];
                    if(xArr.count == 0 || !xArr)  //没有数据,就插入
                    {
                        [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date,:read,:readNum,:bigImage,:smallImage,:showType,:subtitle)" withParameterObject:entity];
                    }
                    else
                    {//如果有数据
                        for (XKRWManagementEntity5_0 *obj in  xArr)
                        {
                            if (obj.category == entity.category)
                            { //相同类别下 文章
                                
                                FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT read, complete from management where module = '%@' and nid = %ld", entity.module, (long)entity.nid]];
                                while ([set next]) {
                                    int read = [set intForColumn:@"read"];
                                    BOOL complete = [set boolForColumn:@"complete"];
                                    entity.read = read;
                                    entity.complete = complete;
                                    break;
                                }
                                [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date,:read,:readNum,:bigImage,:smallImage,:showType,:subtitle)" withParameterObject:entity];
                            }
                        }
                    }
                }
            }];
        }
        
        
        //灵活运营  单独处理
        if ([array[i] isEqualToString:@"lhyy"]) {
            
            id value = dic[@"data"][@"lhyy"];
            
            if (( [value isKindOfClass:[NSArray class] ]  &&  [(NSArray*)value count] == 0) || [value isEqual:@""] ) {
                continue ;
            }
            //遍历灵活运营 数组中的字典
            
            XKRWManagementEntity5_0 *entity = [[XKRWManagementEntity5_0 alloc]init];
            entity.seq = 7;
            entity.category = eOperationOthers;//灵活运营
            entity.module = @"lhyy";
            entity.date = @"0";
            entity.complete = NO;
            entity.day = [[NSDate date] timeIntervalSince1970] / (60*60*24);
            NSDictionary *tempDic = [[NSDictionary alloc] init];
            tempDic = dic[@"data"][@"lhyy"];
            for(NSDictionary *obj in tempDic){
                if(!obj[@"read"]){
                    [obj setValue:@"0" forKey:@"read"];
                }
            }
            NSDictionary *contentDic = [[NSDictionary alloc] init];
            contentDic = tempDic;
            entity.content = contentDic;
            
            [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
                NSArray *lhyyHistoryArray = [history objectForKey:@"lhyy"];
                
                if(!lhyyHistoryArray){
                    
                    [db executeUpdate:@"INSERT INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date,:read,:readNum,:bigImage,:smallImage,:showType,:subtitle)" withParameterObject:entity];
                    
                }else{
                    //存在灵活运营
                    [db executeUpdate:@"REPLACE INTO management VALUES(:module,:content,:seq,:nid,:complete,:day,:category,:date,:read,:readNum,:bigImage,:smallImage,:showType,:subtitle)" withParameterObject:entity];
                }
            }];
        }
        
    }
}

#pragma mark - 更多文章
#pragma mark -
//从服务器获取更多文章
-(void)getMoreArticleInfoFromServerType:(XKOperation)type andPage:(NSInteger)pages needLong:(BOOL)needLong{
    NSURL *moreArticleInfoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kManagementMoreArticleURL]];
    NSString *categoryName = [self getStringCategoryByEnum:type];
    NSString *day = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    NSDictionary *requestPara = @{@"type":categoryName,
                                  @"date":day,
                                  @"page":[NSString stringWithFormat:@"%ld",(long)pages],
                                  @"pagesize":[NSString stringWithFormat:@"%d",10]
                                  };
    NSArray *historyArray = [self syncBatchDataWith:moreArticleInfoURL andPostForm:requestPara withLongTime:needLong][@"data"];
    ;
    XKLog(@"historyArray = %@",historyArray);
    XKLog(@"pages = %ld,count = %lu",(long)pages,(unsigned long)historyArray.count);
    __block NSDictionary *tempDic = [[NSDictionary alloc] init];
    
    if(![self isNull:historyArray]){
        BOOL isDownloadAllRecord = NO;
        if([historyArray count] < 10){
            isDownloadAllRecord = YES;
        }
        for (int i=0 ; i< historyArray.count; i++) {
            XKRWArticleDetailEntity *entity = [[XKRWArticleDetailEntity alloc] init];
            tempDic = historyArray[i];
            entity.beishu = tempDic[@"beishu"];
            entity.category = type;
            entity.beishu = tempDic[@"beishu"];
            entity.date = tempDic[@"date"];
            entity.nid = tempDic[@"nid"];
            
            if (tempDic[@"pv"] == [NSNull null]) {
                entity.readNum = @"0";
            }else{
                entity.readNum = tempDic[@"pv"];//注意这个有可能为空值
            }
            entity.title = tempDic[@"title"];
            entity.url = tempDic[@"url"];
            if (isDownloadAllRecord && i == [historyArray count] - 1) {
                entity.leastrecord = YES;
            }
            
            
            [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
                [db executeUpdate:@"REPLACE INTO manage_history_record VALUES(:nid,:content,:category,:beishu,:date,:readNum,:title,:url,:read,:leastrecord)" withParameterObject:entity];
            }];
        }
    }else{//数组为空值
        __block XKRWArticleDetailEntity *entity = [[XKRWArticleDetailEntity alloc] init];
        [self readDefaultDBWithTask:^(FMDatabase *db) {
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM manage_history_record WHERE category = ? ORDER BY date ASC LIMIT 1",[NSString stringWithFormat:@"%i",type]];//
            while ([resultSet next]) {
                [resultSet setResultToObject:entity];
            }
        }];
        entity.leastrecord = YES;
        [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"REPLACE INTO manage_history_record VALUES(:nid,:content,:category,:beishu,:date,:readNum,:title,:url,:read,:leastrecord)" withParameterObject:entity];
        }];
        
    }
}

//根据类别 获取本地更多文章数据
-(NSMutableArray *)getMoreArticleFromDBByCategory:(XKOperation)category {
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:100];
    
    NSMutableArray  *queryArray =   [self query:[NSString stringWithFormat:@"SELECT * FROM manage_history_record WHERE category = %i ORDER BY date DESC",category]];
    
    
    for (int i = 0; i < [queryArray count]; i++) {
        NSDictionary *dic = [queryArray objectAtIndex:i];
        XKRWArticleDetailEntity *entity = [[XKRWArticleDetailEntity alloc]init];
        entity.category =  (XKOperation )[[dic objectForKey:@"category"] integerValue];
        
        if ([dic objectForKey:@"content"] == [NSNull null]) {
            entity.content = nil;
        }else{
            entity.content = [dic objectForKey:@"content"];
        }
        
        entity.beishu = [dic objectForKey:@"beishu"];
        entity.date = [dic objectForKey:@"date"];
        entity.leastrecord = [[dic objectForKey:@"leastrecord"] boolValue];
        entity.nid = [dic objectForKey:@"nid"];
        entity.read = [[dic objectForKey:@"read"] integerValue];
        entity.readNum =[dic objectForKey:@"readNum"];
        entity.title =[dic objectForKey:@"title"];
        entity.url = [dic objectForKey:@"url"];
        
        [array addObject:entity];
    }
    

    return array;
}


//从本地 获取文章详细信息
-(XKRWArticleDetailEntity *)getArticleDetailFromDBByCategory:(XKOperation)category andId:(NSString *)nid {
    __block XKRWArticleDetailEntity *entity = nil;
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM manage_history_record WHERE category = ? AND nid = ?",itoa(category),nid];
        while ([result next]) {
            entity = [[XKRWArticleDetailEntity alloc]init];
            [result setResultToObject:entity];
        }
    }];
    return entity;
}

//根据类别和nid获取  当天的文章内容
-(XKRWManagementEntity5_0 *)getTodayArticleEntityBy:(XKOperation)category andNid:(NSString *)nid {
    __block XKRWManagementEntity5_0 *entity = [[XKRWManagementEntity5_0 alloc]init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT module,value AS content,seq,nid,complete,day,category,date,read FROM management WHERE nid = ? and module = ?",nid,[self getStringCategoryByEnum:category]];
        while ([result next]) {
            [result setResultToObject:entity];
        }
    }];
    
    return entity;
}

//从服务器获取PK详情信息
-(XKRWArticleDetailEntity *)getPKDetailFromServerByNid:(NSString *)nid{
    NSURL *togetherPKInfoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetTogetherPKDetailURL]];
    NSURL *getVoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetPKVoteURL]];
    //票数
    NSDictionary *voteRequestPara = @{@"nid":nid};
    NSDictionary *voteDic = [self syncBatchDataWith:getVoteURL andPostForm:voteRequestPara withLongTime:YES];
    
    //其它信息
    NSDictionary *requestPara = @{@"id":nid, @"type": @"PKInfo"};
    NSDictionary *responseDic = [self syncBatchDataWith:togetherPKInfoURL andPostForm:requestPara withLongTime:YES];
    XKRWArticleDetailEntity *entity = [[XKRWArticleDetailEntity alloc] init];
    if(responseDic[@"success"] && voteDic[@"success"]){
        entity.content = responseDic[@"data"];
        entity.zfps = voteDic[@"data"][@"zfps"];
        entity.ffps = voteDic[@"data"][@"ffps"];
    }
    return entity;
}

- (XKRWOperationArticleListEntity *)getArticleDetailFromServerByNid:(NSString *)nid andType:(NSString *)type {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetTogetherPKDetailURL]];
    NSDictionary *param = @{@"id":nid,@"type":type};
    NSDictionary *dic = [self syncBatchDataWith:url andPostForm:param];
    XKRWOperationArticleListEntity *entity = [XKRWOperationArticleListEntity new];
    
    if (dic[@"success"]) {
        entity.nid = dic[@"data"][@"nid"];
        entity.title = dic[@"data"][@"title"];
        entity.updateTime = dic[@"data"][@"update_time"];
        entity.date = dic[@"data"][@"date"];
        entity.field_answers_value = dic[@"data"][@"field_answers_value"];
        entity.field_question_value = dic[@"data"][@"field_question_value"];
        entity.field_zhengda_value = dic[@"data"][@"field_zhengda_value"];
        entity.pv = [dic[@"data"][@"pv"] integerValue];
        entity.showType = dic[@"data"][@"show_type"];
        entity.smallImageUrl = dic[@"data"][@"s_image"];
        entity.bigImageUrl = dic[@"data"][@"b_image"];
        entity.url = dic[@"data"][@"url"];
        entity.star = dic[@"data"][@"star"];
        
        return entity;
    } else {
        return nil;
    }
    
}

- (NSDictionary *)getPKNum:(NSString *)nid
{
    NSURL *getVoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetPKVoteURL]];
    NSDictionary *voteRequestPara = @{@"nid":nid};
    NSDictionary *voteDic = [self syncBatchDataWith:getVoteURL andPostForm:voteRequestPara withLongTime:YES];
    return voteDic;
}



#pragma mark - 星星
#pragma mark -

/**
 *  从服务器获取用户星星数
 */

- (NSDictionary*)getUserStarNumFromServer
{
    NSURL *starNumRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer, kGetUserStarNum]];
    NSDictionary *starNumDic = [self syncBatchDataWith:starNumRequest andPostForm:nil];
    XKLog(@"%@",starNumDic);
    return starNumDic;
}

/**
 *  设置当天 获得星星的文章
 *  complete = 1 表示获得了 星星变灰
 *  complete = 0 表示还没摘 星星
 */
-(void)setArticleStarToGet:(NSDictionary*)dic
{
    NSString *nids = dic[@"data"][@"nids"];
    NSArray *nidArray = [nids componentsSeparatedByString:@","];
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"UPDATE management SET complete = 0"];
        if ([nidArray count] > 0)
        {
            for (NSString *nid in nidArray) {
                [db executeUpdate:@"UPDATE management SET complete = 1 WHERE nid = ?",nid];
            }
        }
    }];
}
/**
 *  提交完成任务nid
 */
- (void)uploadCompleteTask:(NSString *)taskId {
    
    NSURL *completeTaskRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kUploadCompleteTask]];
    NSString *str = nil;
    NSDictionary *dataDic = @{@"nid": taskId};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *requestPara = @{@"data": str};
    
    NSDictionary *dic = [self syncBatchDataWith:completeTaskRequest andPostForm:requestPara];
    XKLog(@"dic %@",dic);
    
    [self completeTaskWithTaskId:taskId];
}

-(void)completeTaskWithTaskId:(NSString *)taskId {
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"UPDATE management SET complete = 1 WHERE nid = ?",taskId];
    }];
    NSInteger starNum = [[XKRWUserService sharedService] getUserStarNum];
    [[XKRWUserService sharedService] setUserStarNum:starNum + 1];
    [[XKRWUserService sharedService] saveUserInfo];
}

//PK提交 1 正方 0 反方
-(NSDictionary *)uploadTogetherPK:(NSString *)side andPKId:(NSString *)nid {
    
    NSURL *voteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kPKVote]];
    
    NSDictionary *requestPara = @{@"nid": nid,
                                  @"val": side};
    
    NSDictionary* backData =[self syncBatchDataWith:voteURL andPostForm:requestPara];
    
    
    NSDictionary *resultDic = backData[@"data"];
    
    return resultDic;
    
}

#pragma mark - 设置为阅读过
#pragma mark -

-(void)setReadStatusToDB:(XKRWManagementEntity5_0 *)entity{
    
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"UPDATE management SET read = 1 WHERE nid = ? and module = ?",entity.content[@"nid"], entity.module];
    }];
    XKLog(@"entity.content.nid is %@  module = %@",entity.content[@"nid"],entity.module);
    
}

//设置灵活运营的状态
-(void)setArticleDetailReadStatusToDB:(XKRWArticleDetailEntity *)entity andModule:(XKOperation)module{
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isSuccess =    [db executeUpdate:@"UPDATE manage_history_record SET read = 1 WHERE nid = ? and category = ?",entity.nid, [NSString stringWithFormat:@"%i",module]];
        XKLog(@"%d",isSuccess);
    }];
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

/**
 *  字符串 转  数字
 */
-(XKOperation)yunYingStringToNumber:(NSString*)string
{
    if([string isEqualToString:@"jfzs"])
    {
        return eOperationKnowledge;
    }
    else if ([string isEqualToString:@"lizhi"])
    {
        return eOperationEncourage;
    }
    else if ([string isEqualToString:@"ydtj"])
    {
        return eOperationSport;
    }
    else if ([string isEqualToString:@"pk"])
    {
        return eOperationPK;
    }
    else if ([string isEqualToString:@"mrss"])
    {
        return eOperationFamous;
    }
    else if ([string isEqualToString:@"jfdrx"])
    {
        return eOperationTalentShow;
    }
    else if ([string isEqualToString:@"lhyy"])
    {
        return eOperationOthers;
    }
    else
    {
        return 0;
    }
}

- (void) setHadPKNum:(NSString *)nid
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"HADPK_%ld_%@",(long)[[XKRWUserService sharedService]getUserId],nid ]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) checkHadPKNum:(NSString *)nid
{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"HADPK_%ld_%@",(long)[[XKRWUserService sharedService]getUserId],nid]];
}

#pragma --mark  发现页5.2 新接口
- (NSMutableArray *)getUserJoinTeamInfomation{
    
    NSURL *joinTeamUrl  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetUserJoinTeam]];
    NSDictionary *result = [ self syncBatchDataWith:joinTeamUrl andPostForm:nil withLongTime:YES];
    
    if([[result objectForKey:@"success"] intValue] == 1){
        
        [[XKRWUserService sharedService].currentGroups removeAllObjects]; //重新保存用户已加入的过的小组信息
        
        NSArray *dataArray = [result objectForKey:@"data"];
        NSMutableArray *teamArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (int i = 0; i < dataArray.count; i++) {
            NSDictionary *teamInfoDic = [dataArray objectAtIndex:i];
            XKRWGroupItem *groupItem = [[XKRWGroupItem alloc]init];
            groupItem.groupId = [teamInfoDic objectForKey:@"id"];
            groupItem.groupName = [teamInfoDic objectForKey:@"name"];
            groupItem.groupNum = [teamInfoDic objectForKey:@"nums"];
            groupItem.groupIcon = [teamInfoDic objectForKey:@"icon"];
            groupItem.grouptype = [teamInfoDic objectForKey:@"type"];
            groupItem.groupCTime = [teamInfoDic objectForKey:@"ctime"];
            groupItem.groupDescription = [teamInfoDic objectForKey:@"description"];
            groupItem.postNums = [NSString stringWithFormat:@"%@",[teamInfoDic objectForKey:@"post_nums"]];
            // 加入到全局  用户已加入的小组。这是唯一的入口
            if (![[XKRWUserService sharedService].currentGroups containsObject:groupItem.groupId]) {
                [[XKRWUserService sharedService].currentGroups addObject:groupItem.groupId];
            }
            [teamArray addObject:groupItem];
        }
        return teamArray;
    }else
    {
        return [NSMutableArray array];
    }
}

- (NSDictionary *)getDiscoverOperationState{
    NSURL *joinTeamUrl  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetDiscoverOperationState]];

    NSDictionary *result = [ self syncBatchDataWith:joinTeamUrl andPostForm:nil withLongTime:YES];
    return result;
}

- (NSMutableArray *)getOperationArticleListWithType:(NSString *)type andPage:(NSInteger)page andPageSize:(NSInteger) pageSize{
    
    NSURL *operationArticleUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetOperationTypeData]];
    
    NSDictionary *params = @{@"type":type,@"page":[NSNumber numberWithInteger:page],@"pagesize":[NSNumber numberWithInteger:pageSize]};
    
    NSDictionary *result = [self syncBatchDataWith:operationArticleUrl andPostForm:params withLongTime:YES];
    
    NSArray *dataArray = [result objectForKey:@"data"];
    
    NSMutableArray *operationArray =[NSMutableArray arrayWithCapacity:dataArray.count];
    
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        XKRWOperationArticleListEntity *operationArticleEntity = [[XKRWOperationArticleListEntity alloc] init];
        operationArticleEntity.nid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nid"]];
        operationArticleEntity.title = [dic objectForKey:@"title"];
        operationArticleEntity.updateTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"update_time"]];
        operationArticleEntity.date = [dic objectForKey:@"date"];
        operationArticleEntity.pv = [[dic objectForKey:@"pv"] integerValue];
        operationArticleEntity.showType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"show_type"]];
        operationArticleEntity.smallImageUrl =[dic objectForKey:@"s_image"];
        operationArticleEntity.bigImageUrl =[dic objectForKey:@"b_image"];
        operationArticleEntity.url =[dic objectForKey:@"url"];

        if (dic[@"field_answers_value"]&&dic[@"field_question_value"]&&dic[@"field_zhengda_value"]&&dic[@"star"])
        {
            operationArticleEntity.field_answers_value =[dic objectForKey:@"field_answers_value"];
            operationArticleEntity.field_question_value =[dic objectForKey:@"field_question_value"];
            operationArticleEntity.field_zhengda_value =[dic objectForKey:@"field_zhengda_value"];
            operationArticleEntity.star = [dic objectForKey:@"star"];
        }
        
        operationArticleEntity.starState = [[dic objectForKey:@"star"]integerValue];
        
        [operationArray addObject:operationArticleEntity];
    }
    return operationArray;
}


- (void)setOperationArticleHadReadWithTitle:(NSString *)operationArticleTitle withID:(NSString *)operationArticleID {
    XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[UIApplication sharedApplication].delegate ;
    
    NSManagedObjectContext *managedObjectContext =   appdelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"OperationEntity"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"operationID = %@ and userID = %d",operationArticleID,[[XKRWUserService sharedService ] getUserId]];
    
    NSArray *resultArray = [managedObjectContext executeFetchRequest:request error:nil];
    
    if(resultArray.count == 0 )
    {
        OperationEntity *entity  = [NSEntityDescription insertNewObjectForEntityForName:@"OperationEntity" inManagedObjectContext:appdelegate.managedObjectContext];
        
        if(entity != nil){
            entity.operationID = operationArticleID;
            entity.operationTitle = operationArticleTitle;
            entity.userID = [NSNumber numberWithInteger:[[XKRWUserService sharedService] getUserId]];
            NSError * savingError = nil;
            if ([managedObjectContext save:&savingError]) {
                NSLog(@"success");
            }else {
                NSLog(@"failed to save the context error = %@", savingError);
            }
        }else{
            NSLog(@"failed to create the new person");
        }
    }
}

- (BOOL)operationArticleHadReadWithOperationArticleID:(NSString *)operationArticleID{
    XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *objectContect = appdelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"OperationEntity"];
    request.predicate = [NSPredicate predicateWithFormat:@"operationID = %@ and userID = %d",operationArticleID,[[XKRWUserService sharedService] getUserId]];
    
    @try {
         NSArray *array = [objectContect executeFetchRequest:request error:nil];
        if (array.count > 0) {
            return YES;
        }else{
            return NO;
        }
    }
    @catch (NSException *exception) {
       
    }
    @finally {
       
    }
}



@end
