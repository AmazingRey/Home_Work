//
//  XKRWAccountService.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-18.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWAccountService : XKRWBaseService

@property (nonatomic) BOOL isLogin;

//单例

+(id)shareService;

/**
 *  获取应用打开时 首页广告图片
 *
 *  @return 返回广告图片dic
 */
- (NSDictionary *)getHomePagePic;


///**
// *  判断用户是否升级
// *
// *  @return 是否升级app
// */
//- (BOOL)isUpdate;


#pragma --mark   5.0 版本 重写注册接口

/**
 *  注册接口
 *
 *  @param account  帐号
 *  @param password 密码
 *  @param authCode 验证码
 *  @param appkey   AppKey
 *  @param zone     注册地区区号
 *  @param needLong 网络请求等待时间
 *
 *  @return 返回注册成功或失败信息
 */
- (NSDictionary *)registeAccountWith:(NSString *)account
               andPassword:(NSString *)password
               andAuthCode:(NSString *)authCode
                 andAppKey:(NSString *)appkey
                   andzone:(NSString *)zone
                  needLong:(BOOL) needLong;

/**
 *  登陆接口
 *
 *  @param account  帐号
 *  @param password 密码
 *  @param needLong 网络请求等待时间
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                needLong:(BOOL)needLong;

/**
 *  第三份登陆借口
 *
 *  @param access_token token
 *  @param openid       openId
 *  @param type         登录类型 （QQ，微信，微博）
 *  @param needLong     网络请求等待时间
 *
 *  @return 返回注册成功或失败信息
 */
- (NSDictionary *)userThirdPartyLoginBytoken:(NSString *)access_token
                            openId:(NSString *)openid
                         thridType:(NSString *)type
                          needLong:(BOOL)needLong;


@end
