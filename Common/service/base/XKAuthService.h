//
//  XKAuthService.h
//  calorie
//
//  Created by JiangRui on 13-1-16.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKService.h"
#import "auth.h"
#import "xkcm.h"
//Auth需要实现的协议

@interface XKAuthService : XKService


@property (atomic) BOOL isLogin;

//单例
+(XKAuthService *)sharedService;


//登陆
-(LoginResult *)logInWithAccountName:(NSString *)accountname
                            password:(NSString *)password;
//注销
-(void)logOut;


@end
