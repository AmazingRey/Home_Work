//
//  XKRWBaseSettingService.h
//  XKRW
//
//  Created by zhanaofan on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWBaseSettingService : XKRWBaseService

//+(id)shareService;
/*保存配置*/
- (BOOL) saveValueWithKey:(id)data key:(NSString*)key;
/*根据KEY，获取配置*/
- (id) valueOfKey:(NSString*) key;
@end
