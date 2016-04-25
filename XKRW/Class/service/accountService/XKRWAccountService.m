//
//  XKRWAccountService.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWAccountService.h"
#import "XKRWUserService.h"
#import "XKRWWeightService.h"
#import "XKRWUserDefaultService.h"
#import "XKRWCommHelper.h"
#import "XKSilentDispatcher.h"
//#import "XKRWSettingService.h"
#import "XKRWFatReasonService.h"
#import "XKRWCui.h"
#import "OpenUDID.h"

static XKRWAccountService *shareInstance;

@interface XKRWAccountService()

@end

@implementation XKRWAccountService



+(id)shareService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWAccountService alloc]init];
    });
    return shareInstance;
}


- (NSString *) getHomePagePic
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kHomeAd]];
    NSDictionary * dicTemp = [self syncBatchDataWith:url andPostForm:[NSDictionary dictionaryWithObjectsAndKeys:ADV_PIC_SIZE,@"imgwh", nil]];
    NSString * str = nil;

    str = dicTemp[@"data"];
    
    return str;
}


#pragma --mark  5.0版本重写注册接口
//注册接口
- (NSDictionary *)registeAccountWith:(NSString *)account
               andPassword:(NSString *)password
               andAuthCode:(NSString *)authCode
                 andAppKey:(NSString *)appkey
                   andzone:(NSString *)zone
                  needLong:(BOOL) needLong
{
    
    NSString *ver = [NSString stringWithFormat:@"i%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"ver": ver,
                                   @"account": account,
                                   @"password": password,
                                   @"device": [OpenUDID value],
                                   @"code":authCode,
                                   @"zone":zone,
                                   @"appkey":appkey,
                                    }];
    
    if(devicetoken != nil)
    {
        [params setObject:devicetoken forKey:@"device_token"];
    }
    
     NSURL *registerUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kNewServer,v5_registerUrl]];
     NSDictionary *result = [self syncBatchDataWith:registerUrl andPostForm:params withLongTime:needLong];
    if (result) {
        NSString *token = [result objectForKey:@"data"];
        [[XKRWUserService sharedService]setToken:token];
        [[XKRWUserService sharedService]getUserAllInfoFromRemoteServerByToken:token];
        [[XKRWUserService sharedService] getSignInDays];
    }
    return result;
}

//登录接口
- (void)loginWithAccount:(NSString *)account password:(NSString *)password needLong:(BOOL)needLong {
    
    NSString *ver = [NSString stringWithFormat:@"i%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSString *devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"];
    
    NSMutableDictionary *loginParaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"ver": ver,
                                                                                        @"account": account,
                                                                                        @"password": password,
                                                                                        @"device": [OpenUDID value]}];
    if(devicetoken != nil)
    {
        [loginParaDic setObject:devicetoken forKey:@"device_token"];
    }
    
    NSURL *loginRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auth/login/?os=iphone", kNewServer]];
    
    NSDictionary *new_loginResult = [self syncBatchDataWith:loginRequestURL andPostForm:loginParaDic withLongTime:needLong];
    
    if (new_loginResult) {
        NSString *token = [new_loginResult objectForKey:@"data"];
        [[XKRWUserService sharedService]setToken:token];
        [[XKRWUserService sharedService]getUserAllInfoFromRemoteServerByToken:token];
        [[XKRWUserService sharedService] getSignInDays];
    }
    
}



- (NSDictionary *)userThirdPartyLoginBytoken:(NSString *)access_token  openId:(NSString *)openid  thridType:(NSString *)type   needLong:(BOOL)needLong{
    
    NSString *ver = [NSString stringWithFormat:@"i%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSString *devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"];
    
    NSMutableDictionary * parames =  [NSMutableDictionary dictionaryWithDictionary:@{@"ver":ver,
                                                                                     @"access_token":access_token,
                                                                                     @"login_type":type,
                                                                                     @"device": [OpenUDID value]}];
   
    if (openid != nil) {
        [parames setValue:openid forKey:@"openid"];
    }
    
    if(devicetoken != nil){
        [parames setValue:devicetoken forKey:@"device_token"];
    }

    NSURL *loginRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auth/openLogin", kNewServer]];
    NSDictionary *new_loginResult = [self syncBatchDataWith:loginRequestURL andPostForm:parames withLongTime:needLong];
    
    if (new_loginResult) {
        NSString *token = [new_loginResult objectForKey:@"data"];
        [[XKRWUserService sharedService]setToken:token];
        [[XKRWUserService sharedService]getUserAllInfoFromRemoteServerByToken:token];
        [[XKRWUserService sharedService] getSignInDays];
    }
    return new_loginResult;
}


@end
