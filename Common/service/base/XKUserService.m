//
//  XKUserService.m
//  XKCommon
//
//  Created by Wei Zhou on 13-4-3.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKUserService.h"
#import "xkcm.h"
#import "user.h"
#import "XKRpcUtil.h"
#import "XKUtil.h"
#import "XKObjcUtil.h"

@implementation XKUserService

static XKUserService * _sharedInstance;

+(XKUserService *)sharedService
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[XKUserService alloc]init];
    }
    return _sharedInstance;
}

//用户改名
-(ReturnMessage *)changeUserName:(NSString *)newUserName
{
    UserServiceClient *client = [self rpcClientForClass:UserServiceClient.class];
    CommArgs *commparam = [XKRpcUtil commArgsForDigestAuth];
    ReturnMessage *result = nil;
    result = [client changeUserName:commparam newUserName:newUserName];
    
    if (result != nil && result.isSucceed) {
        NSMutableDictionary *loginResultDic = [[NSMutableDictionary alloc]initWithDictionary:[[self defaultUserDefaults] objectForKey:@"loginResult"]];
        [loginResultDic setObject:newUserName forKey:@"userName"];
        [[self defaultUserDefaults] setObject:loginResultDic forKey:@"loginResult"];
        [[self defaultUserDefaults] synchronize];
    }
    
    return result;
}

- (void)updateBirthdayWithUserID:(NSString *)userID birthday:(NSString *)birthday{
    UserServiceClient *client = [self rpcClientForClass:UserServiceClient.class];
    CommArgs *commparam = [XKRpcUtil commArgsForDigestAuth];
    [client updateBirthday:commparam userId:userID birthday:birthday];
}

- (void)updateLocationWithUserID:(NSString *)userID
                    districtCode:(NSString *)districtCode
                    districtName:(NSString *)districtName{
    UserServiceClient *client = [self rpcClientForClass:UserServiceClient.class];
    CommArgs *commparam = [XKRpcUtil commArgsForDigestAuth];
    [client updateLocation:commparam userId:userID districtCode:districtCode district:districtName];
}

- (WatchInfo *)watchInfoWithUserID:(NSString *)userID{
    UserServiceClient *client = [self rpcClientForClass:UserServiceClient.class];
    CommArgs *commArgs = [XKRpcUtil commArgsForDigestAuth];
    return [client getWatchInfo:commArgs userID:userID];
}

- (XKUserInfoEntity *)downloadUserInfo{
    UserServiceClient *client = [self rpcClientForClass:UserServiceClient.class];
    CommArgs *commArgs = [XKRpcUtil commArgsForDigestAuth];
    UserInfo *userInfo = [client getUserInfo:commArgs];
    XKUserInfoEntity *myUserInfo = nil;
    if (userInfo != nil) {
        myUserInfo = [[XKUserInfoEntity alloc] init];
        [XKObjcUtil copyPropertiesForSrc:userInfo dest:myUserInfo];
        [[XKUtil defaultUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:myUserInfo] forKey:@"MyUserInfo"];
    }
    return myUserInfo;
}

- (XKUserInfoEntity *)localUserInfo{
    NSData *rawData = [[XKUtil defaultUserDefaults] objectForKey:@"MyUserInfo"];
    XKUserInfoEntity *myUserInfo = nil;
    if (rawData != nil) {
        myUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    }
    return myUserInfo;
}

@end
