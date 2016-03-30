//
//  XKSinaWeiBoService.m
//  calorie
//
//  Created by JiangRui on 12-11-26.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

/*
#import "XKBusinessError.h"
#import "XKUtil.h"
#import "XKSinaMessageHelper.h"
#import "XKSinaWeiBoService.h"

@implementation XKSinaWeiBoService

static SinaWeibo *sinaweibo;
//+(XKSinaWeiBoService *)createServiceWithDelegate:(id<WeiBoDelegate>)delegate
//{
//    XKSinaWeiBoService *instance = [[XKSinaWeiBoService alloc]initWithDelegate:delegate];
//    return instance;
//}

+(XKSinaWeiBoService *)createServiceWithAppKey:(NSString *)AppKey appSecret:(NSString *)AppSecret appRedirectURI:(NSString *)AppRedirectURI delegate:(id<WeiBoDelegate>)delegate
{
    XKSinaWeiBoService *instance = [[XKSinaWeiBoService alloc]initWithAppKey:AppKey appSecret:AppSecret appRedirectURI:AppRedirectURI andDelegate:delegate];
    return instance;
}


-(id)initWithAppKey:(NSString *)AppKey appSecret:(NSString *)AppSecret appRedirectURI:(NSString *)AppRedirectURI andDelegate:(id<WeiBoDelegate>)delegate
{
    self = [super init];
    if (sinaweibo == nil) {
        sinaweibo = [[SinaWeibo alloc]initWithAppKey:AppKey
                                           appSecret:AppSecret
                                      appRedirectURI:AppRedirectURI
                                         andDelegate:self];
        [self initSinaWeiBo];
        
    }
    sinaweibo.delegate = self;
    UIDelegate = delegate;
    return self;
}

//-(id)initWithAppKey:(NSString *)AppKey appSecret:(NSString *)AppSecret appRedirectURI:(NSString *)AppRedirectURI Delegate:(id<WeiBoDelegate>)delegate
//{
//    self = [super init];
//    if (self)
//    {
//        if (sinaweibo == nil) {
//            sinaweibo = [[SinaWeibo alloc]initWithAppKey:AppKey
//                                               appSecret:AppSecret
//                                          appRedirectURI:AppRedirectURI
//                                             andDelegate:self];
//            UIDelegate = delegate;
//            [self initSinaWeiBo];
//        }
//    }
//    return self;
//}
-(void)initSinaWeiBo
{
    NSUserDefaults *defaults = [XKUtil defaultUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
}
-(BOOL)isLogIn
{
    return [sinaweibo isAuthValid];
}
-(void)logIn
{
     [sinaweibo logIn];
}
-(void)sendMessage:(NSString *)message andPhoto:(UIImage *)image
{
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               message, @"status",
                               image, @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}
-(void)sendMessage:(NSString *)message
{
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:message, @"status", nil]
                   httpMethod:@"POST"
                     delegate:self];
}
-(void)logOut
{
    [sinaweibo logOut];
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    if (UIDelegate && [UIDelegate respondsToSelector:@selector(weiBoLogInSuccess)]) {
        [UIDelegate weiBoLogInSuccess];
    }
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
    if (UIDelegate && [UIDelegate respondsToSelector:@selector(weiBoLogOutSuccessed)]) {
        [UIDelegate weiBoLogOutSuccessed];
    }
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    if (UIDelegate && [UIDelegate respondsToSelector:@selector(weiboLogInCancelled)]) {
        [UIDelegate weiboLogInCancelled];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    if (UIDelegate && [UIDelegate respondsToSelector:@selector(weiBoLogInFailedWithError:)]) {
        
        XKBusinessError *_error = [XKBusinessError errorWithType:error.code
                                                          detail:[XKSinaMessageHelper getDetailByErrorCode:error.code]
                                                           cause:error];
        
        [UIDelegate weiBoLogInFailedWithError:_error];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
    if (UIDelegate && [UIDelegate respondsToSelector:@selector(accessTokenInvalidOrExpired:)]) {
        XKBusinessError *_error = [XKBusinessError errorWithType:error.code
                                                          detail:[XKSinaMessageHelper getDetailByErrorCode:error.code]
                                                           cause:error];
        [UIDelegate accessTokenInvalidOrExpired:_error];
    }
}
#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        if (UIDelegate && [UIDelegate respondsToSelector:@selector(messageSendFailedWithError:)]) {
            XKBusinessError *_error = [XKBusinessError errorWithType:error.code
                                                              detail:[XKSinaMessageHelper getDetailByErrorCode:error.code]
                                                               cause:error];
            [UIDelegate messageSendFailedWithError:_error];
        }
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        if (UIDelegate && [UIDelegate respondsToSelector:@selector(messageSendFailedWithError:)]) {
            XKBusinessError *_error = [XKBusinessError errorWithType:error.code
                                                              detail:[XKSinaMessageHelper getDetailByErrorCode:error.code]
                                                               cause:error];
            
            [UIDelegate messageSendFailedWithError:_error];
        }
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        if (UIDelegate && [UIDelegate respondsToSelector:@selector(messageSendSuccessed)]) {
            [UIDelegate messageSendSuccessed];
        }
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        if (UIDelegate && [UIDelegate respondsToSelector:@selector(messageSendSuccessed)]) {
            [UIDelegate messageSendSuccessed];
        }
    }
}
#pragma mark -- 存储AuthData
- (void)removeAuthData
{
    [[XKUtil defaultUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[XKUtil defaultUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[XKUtil defaultUserDefaults] synchronize];
}

@end
 
 */
