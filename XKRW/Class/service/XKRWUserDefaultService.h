//
//  XKRWUserDefaultService.h
//  XKRW
//
//  Created by Jiang Rui on 14-3-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWUserDefaultService : XKRWBaseService

+ (BOOL) alarmStatus;

+(BOOL) isPrivateUsed;

+(void) setAppGroundStatusChanged:(BOOL) change;

//设置当前的UserID
+(void)setCurrentUserId:(NSInteger)userId;

//获取当前的UserID
+(NSInteger)getCurrentUserId;

//设置当前登录状态
+(void)setLogin:(BOOL)islogin;

//获取当前是否登录
+(BOOL)isLogin;

//设置隐私密码
+(void)setPrivacyPassword:(NSString *)password;

//获取隐私密码
+(NSString *)getPrivacyPassword;

//移除隐私密码
+ (void)removePrivacyPassword;

//设置是否忘记隐私密码
+(void)setForgetPrivacyPassword:(BOOL)isForget;

//获取是否忘记隐私密码
+(BOOL)isForgetPrivacyPassword;


/*设置方案更新时间*/
+(BOOL) setSchemeUpdateDate;
/*判断是否更新了方案*/
+ (BOOL) isSchemeUpdate;

/*设置当前注册登陆的进度*/
+(void)setStepForNewUser:(NSString *)step;

/*获取当前用户的step*/
+(NSString *)getCurrentStep;

/*判断用户是否是初次打开APP*/
+(void)setUserFirstOpenApp:(NSString*)forTheFirstOpen;
 /*获取用户是否初次打开App*/
+(NSString*)getUserFirstOpenApp;

//是否显示服务页下面按钮上的小红点
//+ (BOOL)isShowServiceRedDot;
////设置服务页按钮上是否显示小红点
//+ (void)setShowServiceRedDot:(BOOL)flag;


/*保存三餐比例对象*/
+ (void)saveDietScale:(NSDictionary*)scale;
/*获取三餐比例*/
+ (NSDictionary*) getDietScale;
/*根据餐次类型，获取比例*/
+ (uint32_t)getDiectScaleWithType:(MealType) type;
/*获取DIY食谱的最后更新时间*/
+ (NSNumber*)getSynTimeOfDIYDiet;
/*保存DIY食谱更新时间*/
+ (void) setSynTimeOfDIYDiet:(long)time;
/*获取记录的最后更新时间*/
+ (NSNumber*) getSynTimeOfRecord;
/*保存记录值更新时间*/
+ (void) setSynTimeOfRecord:(long)time;
/*保存预测更新时间*/
+ (void) setSynTimeOfForecast:(long)time;
/*获取预测值的最后更新时间*/
+ (NSNumber*) getSynTimeOfForecast;

//保存上次获取推荐应用的时间戳
+ (void) setSynTime:(NSString *)strSynTime;

//获取上次获取推荐应用的时间戳
+ (NSString *)getSynTime;

//保存体重记录的时间戳
+ (void)setWeightSynTime:(uint32_t)synTime;

//获取体重记录的时间戳
+ (int32_t)getWeightSynTime;


//4.2 收藏
+ (void) setSynTimeOfCollection:(long)time;

+ (BOOL)isShowMoreredDot;

+ (void)setShowMoreRedDot:(BOOL)flag;

//+ (BOOL)isShowAssessmentredDot;   //是否显示瘦身评估Hot

//+ (void)setShowAssessmentredDot:(BOOL)flag;  //设置瘦身评估Hot  YES显示NO不显示

//登录
+ (void) showLoginVC:(id)target andIfNeedBack:(BOOL) back andSucessCallBack:(void (^)()) sucess andFailCallBack:(void (^)(BOOL userCancel)) fail;
+ (void) showLoginVCWithTarget:(id)target andNeedCoderCreate:(BOOL)needCoder andIfNeedBack:(BOOL) back andSucessCallBack:(void (^)()) sucess andFailCallBack:(void (^)(BOOL userCancel)) fail;


@end
