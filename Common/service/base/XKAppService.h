//
//  XKAppService.h
//  calorie
//
//  Created by Jiang Rui on 12-11-28.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "app.h"
#import "XKService.h"

@interface XKAppService : XKService

//单例
+(XKAppService *)sharedService;

-(VersionInfo *)validateVersion; //检查版本状态

-(void)registerXKCPNSWithDeviceToken:(NSString *)deviceToken;
-(void)cancelXKCPNSWithDeviceToken:(NSString *)deviceToken;

-(void)setXKCPNSRegistered:(int)flag;
-(int)IsXKCPNSRegistered;

-(void)setDeviceToken:(NSString *)deviceToken;
-(NSString *)deviceToken;

-(void)setIsXKCPNSSupported:(BOOL)isXKCPNSSupportd;
-(BOOL)isXKCPNSSupportd;

// send APS request
-(void)applyForAPNS;

-(void)registerOrCancelXKCPNSWithDeviceToken:(NSString *)deviceToken;

-(void)didXKCPNS;

-(void)didXKCPNSAfterAPSRegisteredWithDeviceToken:(NSData *)deviceToken;
-(void)didXKCPNSAfterAPSFailedWithError:(NSError *)error;

@end
