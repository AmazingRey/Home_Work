//
//  XKRWCityControlService.h
//  XKRW
//
//  Created by Leng on 14-4-30.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWCityControlService : XKRWBaseService

+(id)shareService;


- (void) updateLocationInfoWithCity:(int)cid andProvence:(int) pid andDes:(int) did;
//增加静默时间选择
- (void) updateLocationInfoWithCity:(int)cid andProvence:(int) pid andDes:(int) did andNeedLong:(BOOL) needLong;


//本地
-(NSString *) getPorvienceWithID:(NSInteger)index;
-(NSArray *) getPorvience;
-(NSArray *) getCityWithPrivence:(NSInteger)pid;


//获取城市列表

-(NSString *) getNameWithID:(NSInteger) nameID;

-(NSArray *) getCityList;

-(NSArray *) getCityListWithKey:(NSString *)key;

-(NSArray *) getCityListWithCityName:(NSString *)key;

@end
