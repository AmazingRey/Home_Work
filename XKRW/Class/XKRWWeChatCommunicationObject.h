//
//  XKRWWeChatCommunicationObject.h
//  XKRW
//
//  Created by 忘、 on 14-11-11.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "WXApiObject.h"

//typedef NS_ENUM(NSInteger, WXBizProfileType) {
//    WXBizProfileType_Normal,
//    WXBizProfileType_Device
//};

@interface XKRWWeChatCommunicationObject : BaseReq


@property (nonatomic,assign) enum WXBizProfileType profileType;

@property (nonatomic,strong) NSString *username;

@property (nonatomic,strong) NSString *extMsg;

@end
