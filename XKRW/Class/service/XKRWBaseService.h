//
//  XKRWBaseService.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKService.h"
#import "FMDatabase+XKPersistence.h"
#import "FMResultSet+XKPersistence.h"

@interface XKRWBaseService : XKService
@property (nonatomic,assign) int timeout;

/**
 *  同步获取数据
 *
 *  @param url        url地址
 *  @param dictionary 参数字典
 *  @param outTime    超时时间
 *
 *  @return 数据结果
 */
- (NSDictionary *) syncBatchDataUrl:(NSURL *)url andForm:(NSDictionary *)dictionary andOutTime:(int32_t)outTime;

//同步获得数据并且返回
- (NSDictionary *) syncBatchDataWith:(NSURL *)url andPostForm:(NSDictionary *)dictionary;

//使用默认时间
- (NSDictionary *) syncBatchDataWith:(NSURL *)url andPostForm:(NSDictionary *)dictionary withLongTime:(BOOL) longTime;

//上传头像
- (NSDictionary *) syncHeaderDataWithUrl:(NSString *)url andPostData:(NSData *)temp ;
//根据sql,获取返回数据
- (NSMutableArray*) query:(NSString*)sql;
//获取单条记录
- (NSDictionary *) fetchRow:(NSString*) sql;
//执行sql查询
- (BOOL) executeSql:(NSString *)sql,...;

- (BOOL) executeSqlWithDictionary:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
/*生成唯一ID*/
- (uint32_t) uniqueId;
//判断字符串为空
- (BOOL) isEmptyString:(NSString *)string;

//判断对象为空
- (BOOL) isNull:(NSObject *)object;

- (nullable NSDictionary *) noExceptionSyncBatchDataUrl:(nonnull NSURL *)url andForm:(nullable NSDictionary *)dictionary andOutTime:(int32_t)outTime;

@end
