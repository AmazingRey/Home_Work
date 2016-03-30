//
//  XKRWDBControlService.h
//  XKRW
//
//  Created by XiKang on 14-6-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWDBControlService : XKRWBaseService

+(instancetype)sharedService;

- (void) updateDBTable;

//删除 5.1.3 以下 版本脏数据
- (void)delete_V5_1_2DirtyData;

@end
