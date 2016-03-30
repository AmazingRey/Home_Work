//
//  XKUserService.h
//  XKCommon
//
//  Created by Wei Zhou on 13-4-3.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKService.h"
#import "xkcm.h"
#import "user.h"
#import "XKUserInfoEntity.h"

@interface XKUserService : XKService

+(XKUserService *)sharedService;
//用户服务
-(ReturnMessage *)changeUserName:(NSString *)newUserName;//用户改名
//生日格式 yyyy-MM-dd
- (void)updateBirthdayWithUserID:(NSString *)userID birthday:(NSString *)birthday;
//更新所在地
- (void)updateLocationWithUserID:(NSString *)userID
                    districtCode:(NSString *)districtCode
                    districtName:(NSString *)districtName;

//取得腕表信息
- (WatchInfo *)watchInfoWithUserID:(NSString *)userID;
// 获得登录用户个人信息,并且保存在本地
- (XKUserInfoEntity *)downloadUserInfo;

// 获得登录用户本地个人信息
- (XKUserInfoEntity *)localUserInfo;

@end
