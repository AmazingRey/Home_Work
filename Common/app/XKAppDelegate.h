//
//  XKAppDelegate.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-20.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 具体实现参见代码
// 使用友盟统计除崩溃统计以外功能的条件：应用的编译类型为XK_RP或XK_RELEASE
//                                 且 配置项YouMengAppKey存在
// 使用友盟统计崩溃统计功能的条件：应用的编译类型为XK_RP或XK_RELEASE
//                            且 配置项YouMengAppKey存在
//                            且 配置项forbidYouMengHandleCrash为NO(其缺省值为NO)
// 使用自定义Handler（XKProblemUtil）处理预想外问题的条件：应用的编译类型为XK_TEST
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

// 从root画面往指定segueID的目的画面跳转，需要事先准备好相应segueID的跳转设置
- (void)performSegueFromRoot:(NSString *)segueID;

// 子类必须覆盖实现，用以设定应用的编译类型
// 子类通常使用下面这样的代码实现即可：
//    - (void)configAppInfo {
//    #ifdef XK_DEV
//        [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeDevelopment];
//    #elif defined XK_TEST
//        [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeTest];
//    #elif defined XK_RP
//        [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeReleasePreview];
//    #elif defined XK_RELEASE
//        [XKAppInfoHelper setReleaseType:XKAppInfoReleaseTypeRelease];
//    #endif
//    }
- (void)configAppInfo;
// 子类必须覆盖实现，用以设定应用的配置
// 等将来实现使用配置文件设定应用配置时，本方法即可废弃
- (void)configAppSetting;

// 用以子类覆盖实现，以进行应用的最终处理工作（例如资源的释放，必要信息的保存等）
// 该处理在以下三个时机会被调用：
//          XKAppDelegate的applicationWillResignActive:
//          XKAppDelegate的applicationWillTerminate:
//          XKProblemUtil处理预想外问题时
- (void)performAppFinaltask;

@end
