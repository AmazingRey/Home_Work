//
//  XKAuthService.m
//  calorie
//
//  Created by JiangRui on 13-1-16.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKAuthService.h"
#import "XKRPCUtil.h"
#import "XKThriftClientFactory.h"
#import "XKAppService.h"
#import "XKException.h"

@interface XKAuthService()

@end


@implementation XKAuthService

static XKAuthService * _sharedInstance;

+(XKAuthService *)sharedService
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[XKAuthService alloc]init];
    }
    return _sharedInstance;
}
//登陆
-(LoginResult *)logInWithAccountName:(NSString *)accountname password:(NSString *)password
{
    LoginResult *result = nil;
    XKAppService *appService = [XKAppService sharedService];
    BOOL isXKCPNSSupportd = [appService isXKCPNSSupportd];
    if (isXKCPNSSupportd) {
        CommArgs *commparam = [XKRpcUtil commArgsForNoneAuth];
        LoginExtInfo *loginExt = [[LoginExtInfo alloc] initWithApnsDeviceToken: [appService deviceToken]];
        AuthServiceClient *client = [self rpcClientForClass:AuthServiceClient.class];
        result = [client login:commparam userAccount:accountname password:password loginExtInfo:loginExt];

        BOOL isResRight = [XKRpcUtil is_resSign:accountname
                                       ClientId:result.digestAuthorizationRes.clientId
                                         UserID:result.authUserInfo.userId
                                 Server_resSign:result.digestAuthorizationRes.resSign];
        if (!isResRight) {
            @throw [XKException exceptionWithBrief:@"服务器异常" detail:@"服务器鉴权异常" cause:nil];
        }
        [appService setXKCPNSRegistered:loginExt.apnsDeviceToken!=nil];
        [self setIsLogin:YES];
        [appService didXKCPNS];
    } else {
        CommArgs *commparam = [XKRpcUtil commArgsForNoneAuth];
        LoginExtInfo *loginExt = [[LoginExtInfo alloc] initWithApnsDeviceToken: @""];
        AuthServiceClient *client = [self rpcClientForClass:AuthServiceClient.class];
        result = [client login:commparam userAccount:accountname password:password loginExtInfo:loginExt];
        [self setIsLogin:YES];
    }
    if (result != nil)
    {
        NSDictionary *loginResultDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        result.authUserInfo.userId,@"userId",
                                        result.authUserInfo.userName,@"userName",
                                        result.authUserInfo.figureUrl,@"figureUrl",
                                        result.digestAuthorizationRes.clientId,@"clientId",
                                        result.digestAuthorizationRes.initialToken,@"initialToken",
                                        [[NSNumber alloc]initWithInt:result.digestAuthorizationRes.initialCount],@"initialCount",
                                        [[NSNumber alloc]initWithInt:result.digestAuthorizationRes.authTtl],@"authTtl",
                                        result.digestAuthorizationRes.resSign,@"resSign",
                                        result.loginResultExtInfo.casTgt,@"casTgt",nil];
        [[self defaultUserDefaults] setObject:loginResultDic forKey:@"loginResult"];
        [[self defaultUserDefaults] setObject:accountname forKey:@"accountName"];
        [[self defaultUserDefaults] synchronize];
    }
    
    return result;
}

-(void)logOut
{
    XKAppService *appService = [XKAppService sharedService];
    BOOL isXKCPNSSupportd = [appService isXKCPNSSupportd];
    if (isXKCPNSSupportd) {
        CommArgs *commparam = [XKRpcUtil commArgsForDigestAuth];
        AuthServiceClient *client = [self rpcClientForClass:AuthServiceClient.class];
        LogoutExtInfo *logoutExt_ = [[LogoutExtInfo alloc] initWithApnsDeviceToken:[appService deviceToken]];
        [client logout:commparam logoutExtInfo:logoutExt_];
        [appService setXKCPNSRegistered:logoutExt_.apnsDeviceToken==nil];
        [self setIsLogin:NO];
        [appService didXKCPNS];
    } else {
        [self setIsLogin:NO];
        CommArgs *commparam = [XKRpcUtil commArgsForDigestAuth];
        AuthServiceClient *client = [self rpcClientForClass:AuthServiceClient.class];
        LogoutExtInfo *logoutExt_ = [[LogoutExtInfo alloc] initWithApnsDeviceToken:@""];
        [client logout:commparam logoutExtInfo:logoutExt_];
    }
}

-(BOOL)isLogin
{
    BOOL isLogin = NO;
    @synchronized(self){
        isLogin = [[self defaultUserDefaults] boolForKey:@"isLogin"];
    }
    return isLogin;
}
-(void)setIsLogin:(BOOL)isLogin
{
    @synchronized(self){
        [[self defaultUserDefaults] setBool:isLogin forKey:@"isLogin"];
        [[self defaultUserDefaults] synchronize];
    }
}

@end
