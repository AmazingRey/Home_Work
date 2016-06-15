//
//  XKRWAppDelegate.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-9.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "XKRWAccountService.h"
#import "XKRWAppDelegate.h"
#import "XKAppInfoHelper.h"
#import "XKUtil.h"
#import "XKConfigUtil.h"
#import "XKRWCommHelper.h"
#import "NSDate+Helper.h"
#import "XKRWLocalNotificationService.h"
#import "XKRWBaseVC.h"
#import "LRatingRemaindTool.h"
#import "WXApi.h"
#import <AVFoundation/AVFoundation.h>
#import "XKCuiUtil.h"
#import "XKSilentDispatcher.h"
#import "MobClick.h"
#import "UMFeedback.h"
#import "UMessage.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "XKRWAdService.h"

#import <AdSupport/AdSupport.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AlipaySDK/AlipaySDK.h>


#pragma --mark 5.0  添加的头文件    （废弃使用storyboard）
#import "XKRWPrivacyPassWordVC.h"
#import "XKRWRootVC.h"
#import "XKRWNavigationController.h"
#import "XKRW-Swift.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "XTSafeCollection.h"
@implementation XKRWAppDelegate
#pragma mark - 推送
#pragma mark -

//收到本地通知 －UIApplicationDelegate
- (void) application:(UIApplication *)application  didReceiveLocalNotification:(UILocalNotification *)notification{
    //清理图标 数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    NSString *keyValue = notification.userInfo[@"alertName"];
    NSDictionary * dicTemp  = notification.userInfo;
    NSInteger type = [[dicTemp valueForKey:@"type"] integerValue];
      if (keyValue.length || !type) {
        return;
    }
    
    //判断系统是否禁音，闹钟铃声是否与当前时间相等
    BOOL isSilence = [[AVAudioSession sharedInstance] setActive:YES error:nil];
    BOOL check = [[XKRWLocalNotificationService shareInstance] checkAlarmWithHour:dicTemp[@"hour"]
                                                                 andMin:dicTemp[@"minutes"]];
    SystemSoundID soundID = 1002;

    if (isSilence && check) {
        AudioServicesPlaySystemSound(soundID);

    }
    
    if (keyValue == nil || keyValue.length == 0) {// type = 111 蜕变天数推送
        [XKCuiUtil showAlertWithTitle:[dicTemp objectForKey:@"label"] message:[dicTemp objectForKey:@"message"] okButtonTitle:@"OK" onOKBlock:^{
            AudioServicesDisposeSystemSoundID(soundID);
//            if ( (type == eAlarmWalk) || (type == eAlarmHabit)) {
//                return;
//            }
//            else{
//               
//            }
        }];
        
    } else {
        [XKRWLocalNotificationService cancelLocalNotification:@"alertBody" value:[notification.userInfo valueForKey:@"alertBody"]];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    
    NSString *device_Token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    XKLog(@"%@",device_Token);
    
    [[NSUserDefaults standardUserDefaults] setValue:device_Token forKey:@"DEVICETOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    XKLog(@"umeng message alias is: %@", [UMFeedback uuid]);
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            XKLog(@"%@", error);
            XKLog(@"%@", responseObject);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    XKLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //发送远程通知 提醒重要通知
    [[XKRWNoticeService sharedService]appOpenStateDealNotification:userInfo];
}



#pragma mark - iOS 8.0以上，新本地推送处理
//注册成功时调用的方法
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

//再非本界面收到本地消息时，下来消息会有快捷按钮
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    completionHandler();//处理完后一定要调用此block
}

#pragma mark - System's functions
#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.timeFormatterOne = [[NSDateFormatter alloc] init];
    self.timeFormatterOne.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [self.timeFormatterOne setDateFormat:@"yyyy-MM-dd"];
    
    self.timeFormatterTwo = [[NSDateFormatter alloc] init];
    self.timeFormatterTwo.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [self.timeFormatterTwo setDateFormat:@"yyyyMMdd"];
    
    // 用来打印数据库路径
    XKLog(@"+++++%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]);
    
    [XTSafeCollection setLogEnabled:NO];
#pragma --mark 处理APP关闭状态下远程通知
    dicInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dicInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:dicInfo forKey:RemoteNotificationContent];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [Fabric with:@[[Crashlytics class]]];

#pragma --mark  sharesdk  短信验证码
    [SMSSDK registerApp:msgAppKey withSecret:msgAppSecret];
    
#pragma --mark 讯飞语音
     NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",kIFlyAppId];
    [IFlySpeechUtility createUtility:initString];
     

    [self configUI];
    
    BOOL isOK = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
#pragma --mark 友盟分享组件
    [UMSocialData setAppKey:kYMAppKey];
    [UMSocialWechatHandler setWXAppId:@"wxb6b66842d5cb4870" appSecret:@"50e5b278f303938db2b7b1196aedb5f3" url:@"http://ss.xikang.com/"];
    
    [UMSocialQQHandler setQQWithAppId:@"100735359" appKey:@"1a0b23a764c82f6add6a77347e1d39ba" url:@"http://ss.xikang.com/"];
    //分享新浪微博  回调地址  可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://ss.xikang.com/"];
    
   // 开启友盟统计,默认以BATCH方式发送log.
    [MobClick startWithAppkey:kYMAppKey
                 reportPolicy:BATCH
                    channelId:@"Web"];
   
#pragma --mark 友盟用户反馈组件
    //友盟用户反馈
    [UMFeedback setAppkey:kYMAppKey];
    [UMessage startWithAppkey:kYMAppKey launchOptions:launchOptions];
    
#pragma --mark 友盟通知中心组件
    if (IOS_8_OR_LATER) {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    } else {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert];
    }

#if DEBUG
    //开始友盟调试
    [UMessage setLogEnabled:YES];
#endif
    //关闭状态时点击反馈消息进入反馈页
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [UMFeedback didReceiveRemoteNotification:notificationDict];
    
     [self dealWithUserFeedback];
    
//    /*判断是否从旧版本升级过来的*/
//    if ([XKRWCommHelper isUpdateFromV2]) {
//        [XKRWCommHelper updateHandelFromV2];
//    }
    
    //判断是否为今天第一次打开，如果是，处理一些缓存清理
    if ([XKRWCommHelper isFirstOpenToday]) {
        if ([XKRWUserDefaultService isLogin]) {
            [XKRWCommHelper firstOpenHandler];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowImageOnWindow"];
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
        
#pragma mark 闹钟消息注册
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        [self application:application didReceiveLocalNotification:locationNotification];
    }
    
    self.window.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:195/255.0 alpha:1];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                              forKey:@"HaveJustOpen"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                              forKey:@"IsNeedCheckUpdate"];
    
    self.openDate = [NSDate date];
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
//    XKRWShareCourseVC *rootvc = [[XKRWShareCourseVC alloc]initWithNibName:@"XKRWShareCourseVC" bundle:nil];
    XKRWRootVC *rootVC = [[XKRWRootVC alloc]init];
    rootVC.fromWhich = Appdelegate;
    XKRWNavigationController *nav = [[XKRWNavigationController alloc]initWithRootViewController:rootVC withNavigationBarType:NavigationBarTypeDefault];
    self.window.rootViewController = nav;

    [self.window makeKeyAndVisible];
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    return isOK;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [XKRWUserDefaultService setAppGroundStatusChanged:YES];
    NSString *passWord = [XKRWUserDefaultService getPrivacyPassword];
    if (passWord && ![passWord isEqualToString:@""]) {
        self.privacyPasswordVC.isVerified = false;
        self.privacyPasswordVC.privacyType = verify;
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:_privacyPasswordVC animated:false completion:NULL];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self dealWithUserFeedback];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if (![self.openDate isDayEqualToDate:[NSDate date]]) {
        // 跨天时，更新处理
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DATA_WHEN_DAY_CHANGED" object:nil];
    }
    self.openDate = [NSDate date];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//程序即将关闭
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //    [[XKRWAdService sharedService]updateAllShowtypeToZero];
    
}


#pragma mark -

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *urlStr = [NSString stringWithFormat:@"mailto:wangjingcan@stonetogold.net?subject=stg Bug Report &body=Thanks for your coorperation!<br><br><br>"
                        "AppName:stg<br>"\
                        "Version:%@<br>"\
                        "Build:%@<br>"\
                        "Details:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        @"1.0",@"",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)configAppInfo {
#ifdef XK_DEV
    [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeDevelopment];
#elif defined XK_TEST
    [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeTest];
#elif defined XK_RP
    [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeReleasePreview];
#elif defined XK_RELEASE
    [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeRelease];
#endif
}

-(void)configAppSetting {
    //jiangr todo
    [XKConfigUtil setString:@"slim3.db" forKey:@"DefaultDBFileName"];
    //旧版本的数据库名
    if ([XKRWCommHelper isUpdateFromV2] && [XKRWCommHelper fileExists:@"slim.db"]) {
        [XKConfigUtil setString:@"slim.db" forKey:@"oldVersionDbName"];
    }
    [XKConfigUtil setString:kYMAppKey forKey:@"YouMengAppKey"];

}

- (void)configUI {
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // 设置导航栏字体、位置
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: XKDefaultFontWithSize(14)} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(-8, -1) forBarMetrics:UIBarMetricsDefault];
    // 设置搜索栏取消按钮颜色
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: XKMainSchemeColor} forState:UIControlStateNormal];
}

- (void)dealWithUserFeedback
{
    feedbackClient = [UMFeedback sharedInstance];
    feedbackClient.delegate = self ;
    [feedbackClient get];
}


- (void)getFinishedWithError:(NSError *)error
{
    if (!error)
    {
        //如果新消息的回复大于0   则表示有新的消息
        if ([feedbackClient.theNewReplies count]> 0) {
            
            [XKRWUserDefaultService setShowMoreRedDot:YES];
        }
    } else {
        XKLog(@"%@",error);
    }
}



#pragma mark - Handle open URL
#pragma mark -

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.description hasPrefix:@"wx"]) {
        
        return [UMSocialSnsService handleOpenURL:url];
        
    } else if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             XKLog(@"result = %@",resultDic);
                                             
                                         }];
        return YES;
        
    } else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.description hasPrefix:@"wx"]) {
        
        return [UMSocialSnsService handleOpenURL:url];
        
    } else if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            XKLog(@"AliPay result = %@",resultDic);
        }];
        return YES;
        
    } else {
        return [UMSocialSnsService handleOpenURL:url];
    }}

#pragma mark - WeChat's delegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
 
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess: {
                
                strMsg = @"支付结果：成功！";
                XKLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentResultNotification
                                                                    object:@{@"success": @YES,
                                                                             @"type": @"wx"}];
                
                break;
            }
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                XKLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentResultNotification
                                                                    object:@{@"success": @NO,
                                                                             @"type": @"wx"}];
                break;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.neusoft.FailedBankCD" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XKRWCoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XKRWCoreDataModel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark XKRWPrivacyPassWordVCDelegate
- (XKRWPrivacyPassWordVC *)privacyPasswordVC{
    NSString *passWord = [XKRWUserDefaultService getPrivacyPassword];
    if (!_privacyPasswordVC) {
            _privacyPasswordVC = [[XKRWPrivacyPassWordVC alloc] initWithNibName:@"XKRWPrivacyPassWordVC" bundle:[NSBundle mainBundle]];
            _privacyPasswordVC.isVerified = false;
            _privacyPasswordVC.privacyType = verify;
            _privacyPasswordVC.delegate = self;
    }
    _privacyPasswordVC.passWord = passWord;
    return _privacyPasswordVC;
}

- (void)verifySucceed{
    self.privacyPasswordVC.isVerified = true;
    [self.privacyPasswordVC dismissViewControllerAnimated:true completion:^{
//        self.privacyPasswordVC = nil;
    }];
}
@end
