//
//  XKRWVersionService.h
//  XKRW
//
//  Created by yaowq on 14-3-28.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWVersionService : XKRWBaseService

+ (id)shareService;
/**
 *  检查版本号、及是否是新安装或升级
 *
 *  @param block 通过版本号、是否是新安装或者升级，执行相应操作
 *  @param mark  是否需要标记记录到最新版本号，如果标记，之后isNewUpdate返回为NO
 */
- (void)checkVersion:(BOOL (^)(NSString *currentVersion, BOOL isNewUpdate, BOOL isNewSetUp))block
      needUpdateMark:(BOOL)mark;


- (void)doSomeFixWithInfo:(BOOL (^)(NSString *currentVersion, BOOL currentUserNeedExecute))block;


- (void)checkVersionToShowRedDot:(void (^)(BOOL isShowRedDot))block;

@end
