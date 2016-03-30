//
//  XKAppService.m
//  calorie
//
//  Created by JiangRui on 12-11-28.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "XKAppService.h"
#import "XKThriftClientFactory.h"
#import "XKRPCUtil.h"
#import "XKUtil.h"
#import "XKAuthService.h"
#import "XKSilentDispatcher.h"
#import "XKAppInfoHelper.h"

@implementation XKAppService
static XKAppService *_sharedInstance;

//单例
+(XKAppService *)sharedService
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[XKAppService alloc]init];
    }
    return _sharedInstance;
}


-(VersionInfo *)validateVersion
{
    AppServiceClient *client = [self rpcClientForClass:AppServiceClient.class];
    VersionInfo *result = [client validateVersion:[XKRpcUtil commArgsForNoneAuth]];
    return result;
}

-(void)registerXKCPNSWithDeviceToken:(NSString *)deviceToken{
	if ([self IsXKCPNSRegistered] == 1) {
        AppServiceClient *client = [self rpcClientForClass:AppServiceClient.class];
        [client registerAPNSForIOS:[XKRpcUtil commArgsForDigestAuth] deviceToken:deviceToken];
        [self setXKCPNSRegistered:YES];
	}
}

-(void)cancelXKCPNSWithDeviceToken:(NSString *)deviceToken{
    if ([self IsXKCPNSRegistered] == 2) {
        AppServiceClient *client = [self rpcClientForClass:AppServiceClient.class];
        [client cancelAPNSForIOS:[XKRpcUtil commArgsForNoneAuth] deviceToken:deviceToken];
        [self setXKCPNSRegistered:NO];
	}
}

-(void)setXKCPNSRegistered:(int)flag{
	@synchronized(self){
        [self.defaultUserDefaults setInteger:flag forKey:@"APS_IsXKCPNSRegistered"];
        [self.defaultUserDefaults synchronize];
    }
}
-(int)IsXKCPNSRegistered{
    int flag = 0;
    @synchronized(self){
        flag = (int)[self.defaultUserDefaults integerForKey:@"APS_IsXKCPNSRegistered"];
    }
	return flag;
}

-(void)setDeviceToken:(NSString *)deviceToken{
    @synchronized(self){
        [self.defaultUserDefaults setObject:deviceToken forKey:@"APS_DeviceToken"];
        [self.defaultUserDefaults synchronize];
    }
}
-(NSString *)deviceToken{
    NSString *deviceToken = nil;
    @synchronized(self){
        deviceToken = [self.defaultUserDefaults stringForKey:@"APS_DeviceToken"];
    }
	return deviceToken;
}

-(void)setIsXKCPNSSupported:(BOOL)isXKCPNSSupportd{
    @synchronized(self){
        [self.defaultUserDefaults setBool:isXKCPNSSupportd forKey:@"APS_IsSupported"];
        [self.defaultUserDefaults synchronize];
    }
}
-(BOOL)isXKCPNSSupportd{
    BOOL isXKCPNSSupportd = NO;
    @synchronized(self){
        isXKCPNSSupportd = [self.defaultUserDefaults boolForKey:@"APS_IsSupported"];
    }
    return isXKCPNSSupportd;
}

-(void)applyForAPNS{
#warning Not supported above iOS 8.0
    // aps supported
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound)];
}

-(void)registerOrCancelXKCPNSWithDeviceToken:(NSString *)deviceToken{
	if ([XKAuthService sharedService].isLogin) {
		[self registerXKCPNSWithDeviceToken:deviceToken];
	} else {
		[self cancelXKCPNSWithDeviceToken:deviceToken];
	}
}

-(void)didXKCPNS{
    if ([self isXKCPNSSupportd]) {
        NSString *deviceToken = [self deviceToken];
        if (deviceToken == nil) {
            [self applyForAPNS];
        } else {
            [XKSilentDispatcher asynExecuteRpcTask:^{
                [self registerOrCancelXKCPNSWithDeviceToken:deviceToken];
            }];
        }
    }
}

-(void)didXKCPNSAfterAPSRegisteredWithDeviceToken:(NSData *)deviceToken{
    NSString *dToken = [deviceToken description];
    dToken = [[dToken substringWithRange:NSMakeRange(1, [dToken length]-2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    XKAppService *appService = [XKAppService sharedService];
    [appService setDeviceToken:dToken];
    [XKSilentDispatcher executeRpcTask:^{
        [appService registerOrCancelXKCPNSWithDeviceToken:dToken];
    }];
}

-(void)didXKCPNSAfterAPSFailedWithError:(NSError *)error{
    // Called after registering APNS
    if ([XKAppInfoHelper isInformalReleaseType]) {
        XKLog(@"Fail to get the APNS token for [%@].", error);
    }
}

@end
