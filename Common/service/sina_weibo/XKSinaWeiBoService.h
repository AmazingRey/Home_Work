//
//  XKSinaWeiBoService.h
//  calorie
//
//  Created by JiangRui on 12-11-26.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

/*
#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboConstants.h"
#import "XKError.h"
#import "XKService.h"

@protocol WeiBoDelegate;

@interface XKSinaWeiBoService : XKService<SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    id<WeiBoDelegate> UIDelegate;
}

+(XKSinaWeiBoService *)createServiceWithAppKey:(NSString *)AppKey appSecret:(NSString *)AppSecret appRedirectURI:(NSString *)AppRedirectURI delegate:(id<WeiBoDelegate>)delegate;

-(id)initWithAppKey:(NSString *)AppKey appSecret:(NSString *)AppSecret appRedirectURI:(NSString *)AppRedirectURI andDelegate:(id<WeiBoDelegate>)delegate;

//检测是否已经登陆(包括Token是否过期)
-(BOOL)isLogIn;

//发送微博(包括图片)
-(void)sendMessage:(NSString *)message andPhoto:(UIImage *)image;

//发送微博(不包括图片)
-(void)sendMessage:(NSString *)message;

//登陆(OAuth方式下直接弹出sina授权页面)
-(void)logIn;

//注销
-(void)logOut;
@end

//微博界面代理（封装了登陆代理和发送代理）
@protocol WeiBoDelegate <NSObject>
@optional

//sina微博登陆成功
-(void)weiBoLogInSuccess;

//sina微博登陆错误（OAuth一般不需要实现）
-(void)weiBoLogInFailedWithError:(XKError *)error;

//sina微博注销成功
-(void)weiBoLogOutSuccessed;

//sina微博注销失败(一般不需要实现)
-(void)weiBoLogOutFailed;

//sina微博发送成功
-(void)messageSendSuccessed;

//sina微博发送失败
-(void)messageSendFailedWithError:(XKError *)error;

//用户取消登陆
-(void)weiboLogInCancelled;

//用户鉴权失败
-(void)accessTokenInvalidOrExpired:(XKError *)error;

@end
 
 
 
 */
