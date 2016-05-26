
//
//  XKRWBaseService.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWUserService.h"
#import "XKRWConstValue.h"
#import "XKRWBusinessException.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "XKRWUserDefaultService.h"
#import "XKRWAppDelegate.h"
#import "XKRWNeedLoginAgain.h"
#import "XKRWRegException.h"
#import "CWStatusBarNotification.h"
#import "XKRWNetWorkException.h"
#import "AFNetworking.h"

@implementation XKRWBaseService

- (NSDictionary *) syncBatchDataUrl:(NSURL *)url andForm:(NSDictionary *)dictionary andOutTime:(int32_t)outTime {
    
    NSString *token = [[XKRWUserService sharedService] getToken];
    
    NSMutableDictionary *postValue = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    BOOL hasToken = NO;
    for (NSString *key in postValue.allKeys) {
        if ([key isEqualToString:@"token"]) {
            hasToken = YES;
            break;
        }
    }
    if (!hasToken && token) {
        [postValue setObject:token forKey:@"token"];
    }
    
    XKLog(@"\nURL: %@\nPost Value :\n%@", url.description, postValue);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] initWithDictionary:request.allHTTPHeaderFields];
    if (!headerFields) {
        headerFields = [[NSMutableDictionary alloc] init];
    }
    [headerFields setObject:@"YES" forKey:@"X-RNCache"];
    
    request.allHTTPHeaderFields = headerFields;

    request.timeoutInterval = outTime ? outTime : 10;
    
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    
    for (NSString *key in postValue) {
        if (bodyString.length == 0) {
            [bodyString appendFormat:@"%@=%@", key, postValue[key]];
        } else {
            [bodyString appendFormat:@"&%@=%@", key, postValue[key]];
        }
    }
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];     [operation start];
    [operation waitUntilFinished];
    
    NSData *result = operation.responseData;
    

    if (!result) {
        @throw [XKRWNetWorkException exceptionWithDetail:@"网络连接有问题,请稍后再试"];
    }
    
    NSError *error = nil;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        XKLog(@"%@",operation.responseString);
        XKLog(@"parse error: %@", error);
        NSString *data = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        XKLog(@"%@", data);
    }
    if ([resultDic[@"success"] intValue] == 0) {
        
        XKLog(@"请求地址：%@ ,错误原因：%@",url,resultDic);
        
        if (resultDic[@"error"]) {
            
            NSString * code = resultDic[@"error"][@"code"];
            if ([code isEqualToString:@"015"] ||
                [code isEqualToString:@"019"]
                )
            {
                NSString * msg = nil;
                if ([code isEqualToString:@"015"]) {
                    msg = @"您的帐号曾经在其他设备上登录，请您重新登录。";
                } else {
                    msg = @"身份验证过期，请重新登录";
                }
                @throw [XKRWNeedLoginAgain exceptionWithDetail:msg];
            }
            else if ([code isEqualToString:@"erPerson20103"]){
                @throw [XKRWRegException exceptionWithName:@"请求异常" reason:resultDic[@"error"][@"msg"] userInfo:nil];
            }
            else if ([code isEqualToString:@"004"]) {
                @throw [XKRWBusinessException exceptionWithName:@"返回参数为空" reason:resultDic[@"error"][@"msg"] userInfo:nil];
            }
            else {
                XKLog(@"%@",resultDic[@"error"][@"msg"]);
                @throw [XKRWBusinessException exceptionWithName:@"请求异常" reason:resultDic[@"error"][@"msg"] userInfo:nil];
            }
        }
        else {
            @throw [XKRWBusinessException exceptionWithName:@"服务器错误" reason:@"网络异常,请稍后再试" userInfo:nil];
        }
    }
    else {
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = resultDic;
            
            if (dictionary[@"exp"]) {
                id exp = dictionary[@"exp"];
                
                NSString *expString;
                if ([exp isKindOfClass:[NSString class]]) {
                    expString = [NSString stringWithFormat:@"获得%@点经验值!", exp];
                } else if ([exp isKindOfClass:[NSNumber class]]) {
                    expString = [NSString stringWithFormat:@"获得%d点经验值!", [((NSNumber *)exp) intValue]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XKRWCui hideProgressHud];
                    [XKRWCui showInformationHudWithText:expString];
//                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
//                    notification.notificationLabelBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//                    notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
//                    notification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
//                    [notification displayNotificationWithMessage:expString forDuration:2];
                });
            }
        }
    }
    return resultDic;
}

-(NSDictionary *)syncBatchDataWith:(NSURL *)url andPostForm:(NSDictionary *)dictionary {
    return [self syncBatchDataUrl:url andForm:dictionary andOutTime:0];
}

-(NSDictionary *)syncBatchDataWith:(NSURL *)url andPostForm:(NSDictionary *)dictionary withLongTime:(BOOL)longTime{

    if (longTime) {
        return [self syncBatchDataUrl:url andForm:dictionary andOutTime:20];
    }else{
        return [self syncBatchDataUrl:url andForm:dictionary andOutTime:0];
    }
}

//传头像
-(NSDictionary *)syncHeaderDataWithUrl:(NSString *)url andPostData:(NSData *)temp {
    NSString *token = [[XKRWUserService sharedService] getToken];

    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",url,token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] initWithDictionary:request.allHTTPHeaderFields];
    if (!headerFields) {
        headerFields = [[NSMutableDictionary alloc] init];
    }
    [headerFields setObject:@"YES" forKey:@"X-RNCache"];
    
    request.allHTTPHeaderFields = headerFields;
    request.timeoutInterval = 20;
    request.HTTPBody = [NSMutableData dataWithData:temp];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
    [operation waitUntilFinished];
    
    NSData *result = operation.responseData;
    if (!result) {
        @throw [XKRWBusinessException exceptionWithName:@"网络异常" reason:@"网络连接有问题,请稍后再试" userInfo:nil];
    }
    NSDictionary *resultDic =[result objectFromJSONData];
    if ([resultDic[@"success"] intValue] == 0) {
        if (resultDic[@"error"]) {
            NSString *  code = resultDic[@"error"][@"code"];
            if ([code isEqualToString:@"015"] ||
                [code isEqualToString:@"019"]
                )//token已经失效
            {
                NSString * msg = nil;
                if ([code isEqualToString:@"015"]) {
                    msg = @"您的帐号曾经在其他设备上登录，请您重新登录。";
                }else{
                    msg = @"身份验证过期，请重新登录";
                }
                //token已经失效，需要在主线程提示一下
                
                @throw [XKRWNeedLoginAgain exceptionWithDetail:msg];
                
            }
            
             @throw [XKRWBusinessException exceptionWithName:@"请求异常" reason:resultDic[@"error"][@"msg"] userInfo:nil];
        }
        else {
            @throw [XKRWBusinessException exceptionWithName:@"服务器错误" reason:@"网络有问题,请稍后再试" userInfo:nil];
        }
        
    }
    return resultDic;
}

/////////////////////////////////////////////////////////////////////
// 执行增删改的sql语句，返回执行结果
/////////////////////////////////////////////////////////////////////

- (BOOL) executeSql:(NSString *)sql,...{
    va_list args;
    va_start(args, sql);
    BOOL __block isOK = YES;
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        if (sql) {
            isOK = [db executeUpdate:sql];
        }
    }];
    va_end(args);
    return isOK;
}

- (uint32_t) uniqueId
{
    uint32_t __block uniqueId = 0;
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        if ([db executeUpdate:@"INSERT INTO uniqueid VALUES (NULL)"]) {
            uniqueId = (uint32_t)[db lastInsertRowId];
        }
    }];
    return uniqueId;
}
/////////////////////////////////////////////////////////////////////
// 执行增删改的sql语句，返回执行结果
/////////////////////////////////////////////////////////////////////
- (BOOL) executeSqlWithDictionary:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments{
    BOOL __block isOK = YES;
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        if (sql) {
            isOK = [db executeUpdate:sql withParameterDictionary:arguments];
        }
    }];
    return isOK;
}

/////////////////////////////////////////////////////////////////////
//提供sql语句 执行查询操作
/////////////////////////////////////////////////////////////////////
- (NSMutableArray*)query:(NSString*)sql
{
    NSMutableArray __block *rst = [[NSMutableArray alloc] init];
    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
        FMResultSet *fmrst = [db executeQuery:sql];
        while ([fmrst next]) {
            NSDictionary *_dict_rst = [fmrst resultDictionary];
            [rst addObject:_dict_rst];
        }
        [fmrst close];
    }];
    if ([rst count] > 0) {
        return rst;
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////
//查询单条纪录，并将纪录保存在 obj中。返回字典
/////////////////////////////////////////////////////////////////////
- (NSDictionary*) fetchRow:(NSString*) sql
{
    NSArray *rst = [self query:sql];
    if ([rst count] > 0) {
        return rst[0];
    }
    return nil;
}

//判断字符串为空
-(BOOL)isEmptyString:(NSString *)string {
    if ((string == nil || [string isEqualToString:@""]) || [string isMemberOfClass:[NSNull class]]) {
        return YES;
    }
    else {
        return NO;
    }
}

//判断对象为空
-(BOOL)isNull:(NSObject *)object {
    if (object == nil || [object isMemberOfClass:[NSNull class]]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (nullable NSDictionary *) noExceptionSyncBatchDataUrl:(nonnull NSURL *)url
                                                andForm:(nullable NSDictionary *)dictionary
                                             andOutTime:(int32_t)outTime {
    
    NSString *token = [[XKRWUserService sharedService] getToken];
    
    NSMutableDictionary *postValue = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    BOOL hasToken = NO;
    for (NSString *key in postValue.allKeys) {
        if ([key isEqualToString:@"token"]) {
            hasToken = YES;
            break;
        }
    }
    if (!hasToken && token) {
        [postValue setObject:token forKey:@"token"];
    }
    
    XKLog(@"\nURL: %@\nPost Value :\n%@", url.description, postValue);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] initWithDictionary:request.allHTTPHeaderFields];
    if (!headerFields) {
        headerFields = [[NSMutableDictionary alloc] init];
    }
    [headerFields setObject:@"YES" forKey:@"X-RNCache"];
    
    request.allHTTPHeaderFields = headerFields;
    request.timeoutInterval = outTime ? outTime : 10;
    
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    
    for (NSString *key in postValue) {
        if (bodyString.length == 0) {
            [bodyString appendFormat:@"%@=%@", key, postValue[key]];
        } else {
            [bodyString appendFormat:@"&%@=%@", key, postValue[key]];
        }
    }
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
    [operation waitUntilFinished];
    
    NSData *result = operation.responseData;
    
    if (!result) {
        return nil;
    }
    NSError *error = nil;
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        XKLog(@"parse error: %@", error);
        NSString *data = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        XKLog(@"%@", data);
    }
    // if success, check whether need to show exp hint
    else {
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = resultDic;
            
            if (dictionary[@"exp"]) {
                id exp = dictionary[@"exp"];
                
                NSString *expString;
                if ([exp isKindOfClass:[NSString class]]) {
                    expString = [NSString stringWithFormat:@"获得%@点经验值!", exp];
                } else if ([exp isKindOfClass:[NSNumber class]]) {
                    expString = [NSString stringWithFormat:@"获得%d点经验值!", [((NSNumber *)exp) intValue]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XKRWCui showInformationHudWithText:expString];
//                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
//                    notification.notificationLabelBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//                    notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
//                    notification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
//                    [notification displayNotificationWithMessage:expString forDuration:2];
                });
            }
        }
    }
    return resultDic;
}

@end
