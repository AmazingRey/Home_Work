//
//  XKRWUserDefaultService.m
//  XKRW
//
//  Created by Jiang Rui on 14-3-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWUserDefaultService.h"
#import "XKRWUserService.h"
#import "XKRW-Swift.h"

@implementation XKRWUserDefaultService


+(BOOL)alarmStatus{
    //3.0.1 升级跟用户绑定

    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"localAlarmStatus%ld",(long)[[self class] getCurrentUserId]]]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"localAlarmStatus%ld",(long)[[self class] getCurrentUserId]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"localAlarmCloseStatus"];
}



+(void) setAppGroundStatusChanged:(BOOL) change{

    [[NSUserDefaults standardUserDefaults] setBool:change forKey:@"AppGroundStatusChanged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL) isPrivateUsed{
    BOOL use = NO;
    NSString *passWord = [XKRWUserDefaultService getPrivacyPassword];
    
    if (passWord == nil || [passWord isEqualToString:@""]) {
        
    }
    else{
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AppGroundStatusChanged"]) {
            use = YES;
        }
        
    }

    return use;
}

//设置当前的UserID
+ (void)setCurrentUserId:(NSInteger)userId {
    [[NSUserDefaults standardUserDefaults] setInteger:userId forKey:@"USERID"];
    if (userId != 0) {
        [self setLogin:YES];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前的UserID
+ (NSInteger)getCurrentUserId {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"USERID"];
}

//设置当前登录状态
+ (void)setLogin:(BOOL)islogin {
    [[NSUserDefaults standardUserDefaults] setBool:islogin forKey:@"ISLOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前是否登录
+ (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ISLOGIN"];
}

//设置隐私密码
+ (void)setPrivacyPassword:(NSString *)password
{
     NSString * key = [NSString stringWithFormat:@"PRIVACYPASSWORD%ld",(long)[[XKRWUserService sharedService] getUserId]];
     NSUserDefaults *userDefult = [NSUserDefaults standardUserDefaults];
    [userDefult setObject:password forKey:key];
    [userDefult synchronize];
}

//获取隐私密码
+(NSString *)getPrivacyPassword
{
    NSString * key = [NSString stringWithFormat:@"PRIVACYPASSWORD%ld",(long)[[XKRWUserService sharedService] getUserId]];
   return [[NSUserDefaults standardUserDefaults] objectForKey:key];

}

+(void)setForgetPrivacyPassword:(BOOL)isForget
{
    NSString * key = [NSString stringWithFormat:@"ISOPENPW%ld",(long)[[XKRWUserService sharedService] getUserId]];
    [[NSUserDefaults standardUserDefaults] setBool:isForget forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isForgetPrivacyPassword
{
    NSString * key = [NSString stringWithFormat:@"ISOPENPW%ld",(long)[[XKRWUserService sharedService] getUserId]];

  return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}




/*设置方案更新日期*/
+(BOOL) setSchemeUpdateDate{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kSchemeUpdate,(long)uid];
    NSUserDefaults *userDefult = [NSUserDefaults standardUserDefaults];
    [userDefult removeObjectForKey:key];
    NSString *date = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    [userDefult setObject:date forKey:key];
    [userDefult synchronize];
    return YES;
}

/*判断是否更新了方案*/
+ (BOOL) isSchemeUpdate
{
    BOOL isUpdate = NO;
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *upDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%li",kSchemeUpdate,(long)uid]];
    NSString *curDate = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    if ([upDate isEqualToString:curDate]) {
        isUpdate = YES;
    }
    return isUpdate;
}

/*设置当前注册登陆的进度*/
+(void)setStepForNewUser:(NSString *)step {
    [[NSUserDefaults standardUserDefaults] setObject:step forKey:@"LOGINSTEP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*获取当前用户的step*/
+(NSString *)getCurrentStep {
    XKLog(@"登录进度%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGINSTEP"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGINSTEP"];
}
/*判断用户是否是初次打开APP*/
+(void)setUserFirstOpenApp:(NSString*)forTheFirstOpen;
{
    [[NSUserDefaults standardUserDefaults] setObject:forTheFirstOpen forKey:@"ISFIRST"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*获取用户是否初次打开App*/
+(NSString*)getUserFirstOpenApp;
{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:@"ISFIRST"];
}

+ (BOOL)isShowServiceRedDot
{
    NSInteger uid = [[self class] getCurrentUserId];
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IS_SERVICE_SHOW_RED_DOT_%ld", (long)uid]];
    if (obj == nil) {
        [[self class] setShowServiceRedDot:YES];
        return YES;
    }
    return [obj boolValue];
}

+ (void)setShowServiceRedDot:(BOOL)flag
{
    NSInteger uid = [[self class] getCurrentUserId];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:flag]
                                              forKey:[NSString stringWithFormat:@"IS_SERVICE_SHOW_RED_DOT_%ld", (long)uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowMoreredDot
{
    NSInteger uid = [[self class] getCurrentUserId];
    id obj =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IS_MORE_SHOW_RED_DOT_%ld", (long)uid]];
    if (obj == nil) {
        return NO;
    }
    return [obj boolValue];
}

+ (void)setShowMoreRedDot:(BOOL)flag
{
    NSInteger uid = [[self class] getCurrentUserId];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:flag]
                                             forKey:[NSString stringWithFormat:@"IS_MORE_SHOW_RED_DOT_%ld", (long)uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否需要显示服务评估页 上得 hot热键
+ (BOOL)isShowAssessmentredDot
{
     NSInteger uid = [[self class] getCurrentUserId];
    id obj =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IS_Assessment_SHOW_RED_DOT_%ld", (long)uid]];
    if (obj == nil) {
        return YES;
    }
    return [obj boolValue];
}

//设置瘦身评估Hot  YES显示NO不显示
+ (void)setShowAssessmentredDot:(BOOL)flag
{
     NSInteger uid = [[self class] getCurrentUserId];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:flag]
                                             forKey:[NSString stringWithFormat:@"IS_Assessment_SHOW_RED_DOT_%ld", (long)uid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 保存三餐比例对象
 如果scale为空，则为删除
 */
+ (void)saveDietScale:(NSDictionary*)scale
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kMealScale,(long)uid];
    if (scale == nil) {
        scale = @{kBreakfast:[NSNumber numberWithInt:30],kLunch:[NSNumber numberWithInt:40],kSnack:[NSNumber numberWithInt:10],kDinner:[NSNumber numberWithInt:20]};
    }
    [[NSUserDefaults standardUserDefaults] setObject:scale forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*获取三餐比例*/
+ (NSDictionary*) getDietScale{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kMealScale,(long)uid];
    NSDictionary *scale = [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
    if (!scale) {
        scale = @{kBreakfast:[NSNumber numberWithInt:30],kLunch:[NSNumber numberWithInt:40],kSnack:[NSNumber numberWithInt:10],kDinner:[NSNumber numberWithInt:20]};
        [[self class] saveDietScale:scale];
        return scale;
    }
    return scale;
}

/*根据餐次类型，获取比例*/
+ (uint32_t)getDiectScaleWithType:(MealType) type
{
    uint32_t scale = 30;
    NSDictionary *scale_dict = [[self class] getDietScale];
    NSString *key = kBreakfast;
    switch (type) {
        case eMealLunch:
            key = kLunch;
            break;
        case eMealDinner:
            key = kDinner;
            break;
        case eMealSnack:
            key = kSnack;
            break;
        default:
            break;
    }
    scale = [[scale_dict objectForKey:key] intValue];
    return scale;
}



/*获取DIY食谱的最后更新时间*/
+ (NSNumber*)getSynTimeOfDIYDiet
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kDIYDietUpdateTime,(long)uid];
    NSNumber *uptime = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:key ];
    if (!uptime) {
        uptime = [NSNumber numberWithLong:0];
    }
    return uptime;
}
/*保存DIY食谱更新时间*/
+ (void) setSynTimeOfDIYDiet:(long)time
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kDIYDietUpdateTime,(long)uid];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber*) getSynTimeOfRecord
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kRecordUpdateTime,(long)uid];
    NSNumber *uptime = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:key ];
    if (!uptime) {
        uptime = [NSNumber numberWithLong:0];
    }
    return uptime;
}
/*保存记录更新时间*/
+ (void) setSynTimeOfRecord:(long)time
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kRecordUpdateTime,(long)uid];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*保存收藏更新时间*/
+ (void) setSynTimeOfCollection:(long)time
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kCollectionUpdateTime,(long)uid];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setSynTimeOfForecast:(long)time
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kForecastUpdateTime,(long)uid];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:time] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber*) getSynTimeOfForecast
{
    NSInteger uid = [[self class] getCurrentUserId];
    NSString *key = [NSString stringWithFormat:@"%@_%li",kForecastUpdateTime,(long)uid];
    NSNumber *uptime = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:key ];
    if (!uptime) {
        uptime = [NSNumber numberWithLong:0];
    }
    return uptime;
}

//保存上次获取推荐应用的时间戳,单位秒
+ (void) setSynTime:(NSString *)strSynTime
{
    [[NSUserDefaults standardUserDefaults] setObject:strSynTime forKey:@"CooperationResultSynTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取上次获取推荐应用的时间戳
+ (NSString *)getSynTime
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *strSynTime = [defaults objectForKey:@"CooperationResultSynTime"];
    if ([strSynTime length] == 0) {
        strSynTime = @"1";
    }
    return strSynTime;

}

+ (void)setWeightSynTime:(uint32_t)synTime
{
    [[NSUserDefaults standardUserDefaults] setInteger:synTime forKey:[NSString stringWithFormat:@"weight_syn_time_%li",(long)[[XKRWUserService sharedService] getUserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (int32_t)getWeightSynTime
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    int32_t strSynTime = (int32_t)[defaults integerForKey:[NSString stringWithFormat:@"weight_syn_time_%li",(long)[[XKRWUserService sharedService] getUserId]]];
    return strSynTime;
}


+(void)showLoginVC:(XKRWBaseVC *)target andIfNeedBack:(BOOL)back andSucessCallBack:(void (^)())sucess andFailCallBack:(void (^)(BOOL))fail {
    
    [[self class] showLoginVCWithTarget:target andNeedCoderCreate:NO andIfNeedBack:back andSucessCallBack:sucess andFailCallBack:fail];
}

+ (void) showLoginVCWithTarget:(XKRWBaseVC *)target andNeedCoderCreate:(BOOL)needCoder andIfNeedBack:(BOOL) back andSucessCallBack:(void (^)()) sucess andFailCallBack:(void (^)(BOOL userCancel)) fail
{
    XKRWLoginVC *loginNaviVC = [[XKRWLoginVC alloc] initWithNibName:@"XKRWLoginVC" bundle:nil];
    loginNaviVC.loginSuccess = sucess;
    loginNaviVC.loginFailed = fail;
    loginNaviVC.hidesBottomBarWhenPushed = YES;
//    XKRWNavigationController *navi = [[XKRWNavigationController alloc] initWithRootViewController:loginNaviVC withNavigationBarType:NavigationBarTypeDefault];
    [target.navigationController pushViewController:loginNaviVC animated:NO];
}

@end
