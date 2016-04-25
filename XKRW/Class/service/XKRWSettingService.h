//
//  XKRWSettingService.h
//  XKRW
//
//  Created by zhanaofan on 14-3-13.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseSettingService.h"

@interface XKRWSettingService : XKRWBaseSettingService

+(id)shareService;

/*设置三餐比例*/
- (BOOL) setMealScales:(NSDictionary*)scales;
/*获取三餐比例*/
- (NSDictionary*) getMealScales;
/*保存到服务器上*/
- (void) saveToRemote:(NSDictionary *)scale;
/*从服务器获取数据*/
- (BOOL) syncFromRemote;
@end
