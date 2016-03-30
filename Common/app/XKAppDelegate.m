//
//  XKAppDelegate.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-20.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "MobClick.h"
#import "XKProblemUtil.h"
#import "XKAppInfoHelper.h"
#import "XKConfigUtil.h"
#import "XKMustBeOverridedMethodException.h"
#import "XKAppDelegate.h"
#import "XKUtil.h"
#import "XKAppService.h"
#import "XKSilentDispatcher.h"
#import "XKReceiveAPNNotification.h"
#import "XKDefine.h"


@implementation XKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   
    [self configAppInfo];
    
    [self configAppSetting];
    
    NSString *youMengAppKey = [XKConfigUtil stringForKey:@"YouMengAppKey"];
    BOOL forbidYouMengHandleCrash = [XKConfigUtil boolForKey:@"forbidYouMengHandleCrash"];
    
    if (youMengAppKey && ![XKAppInfoHelper isInformalReleaseType]) {
        if (forbidYouMengHandleCrash) {
            [MobClick setCrashReportEnabled:NO];
        }
        
        [MobClick startWithAppkey:youMengAppKey
                     reportPolicy:BATCH
                        channelId:nil];
    }
    
    if ([XKAppInfoHelper releaseType] == XKAppInfoReleaseTypeTest) {
        [XKProblemUtil installDefaultUnexpectedProblemHandlerWithFinalTask:^{
            [self performAppFinaltask];
        }];
    }
    // aps supported
    XKAppService *appService = [XKAppService sharedService];
    [appService setIsXKCPNSSupported:YES];
    [appService didXKCPNS];
    
    // 用以解决IOS6中某些情况下文本框无法输入的问题
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self performAppFinaltask];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self performBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // aps supported
    [[XKAppService sharedService] didXKCPNS];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self performReceiveRemoteNotifiaction:userInfo];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self performAppFinaltask];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[XKAppService sharedService] didXKCPNSAfterAPSRegisteredWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
	[[XKAppService sharedService] didXKCPNSAfterAPSFailedWithError:error];
}

- (void)configAppInfo {
    XK_THROW_MUST_BE_OVERRIDED_INSTANCE_METHOD_EXCEPTION;
}

- (void)configAppSetting {
    XK_THROW_MUST_BE_OVERRIDED_INSTANCE_METHOD_EXCEPTION;
}

- (void)performReceiveRemoteNotifiaction:(NSDictionary *)userInfo{
    // NOP
}

- (void)performBecomeActive{
    // NOP
}

- (void)performAppFinaltask {
    // NOP
}

- (void)performSegueFromRoot:(NSString *)segueID {
    UIViewController *rootVC = self.window.rootViewController;
    
    if (rootVC.presentedViewController) {
        [rootVC dismissViewControllerAnimated:NO completion:nil];
    } // else NOP
    
    [rootVC performSegueWithIdentifier:segueID sender:rootVC];
}



@end