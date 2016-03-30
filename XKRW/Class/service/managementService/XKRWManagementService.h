//
//  XKRWManagementService.h
//  XKRW
//
//  Created by Jiang Rui on 14-4-3.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWManagementEntity.h"
#import "XKRWManageHistoryDetailEntity.h"

@interface XKRWManagementService : XKRWBaseService

//单例
+(id)sharedService;


//获取当前的运营内容
-(NSMutableDictionary *)getManagementInfo ;

//获取当前用户星星数和已经回答问题
-(void)getUserStarNumFromRemote;


//PK提交 1 正方 0 反方
-(BOOL)uploadTogetherPK:(NSString *)side andPKId:(NSString *)nid ;


//从本地获取运营历史数据详细信息
-(XKRWManageHistoryDetailEntity *)getManagementInfoCategory:(XKOperation)category andId:(NSString *)nid;

//根据类别获取本地运营历史数据
-(NSArray *)getManagementHistoryByCategory:(XKOperation)category;

//获得根据类别和nid获取当天的manageentity
-(XKRWManagementEntity *)getTodayManagementEntityBy:(XKOperation)category andNid:(NSString *)nid;


-(NSDictionary*)getYyUserInfoFromServer;


//保存内容
-(void)saveManagementInfo:(NSDictionary*)dic;


//保存 星星数
-(void)saveStarNum:(NSDictionary*)dic;


//读取星星数
- (void)readStarNum;


//获取重要通知
- (NSDictionary *)getImportantNotice:(NSNumber *) noticeId;





@end
