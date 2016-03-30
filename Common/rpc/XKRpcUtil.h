//
//  XKRpcUtil.h
//  calorie
//
//  Created by JiangRui on 13-1-16.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "xkcm.h"

@interface XKRpcUtil : NSObject

//生成Digest认证模式下的CommArgs(增加ClientCount等)
+ (CommArgs *)commArgsForDigestAuth;
//生成None认证模式下的CommArgs(增加ClientCount等)
+ (CommArgs *)commArgsForNoneAuth;

+(BOOL)is_resSign: (NSString *) userAccount ClientId: (NSString *) clientId  UserID: (NSString *) userID Server_resSign:(NSString *) resSign;
@end
