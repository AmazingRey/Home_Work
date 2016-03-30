//
//  XKRWFatReasonService.h
//  XKRW
//
//  Created by yaowq on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWFatReasonEntity.h"

@class XKRWHabbitEntity;

@interface XKRWFatReasonService : XKRWBaseService
@property (nonatomic ,strong)NSMutableArray *array;
//单例
+(id)sharedService;

//上传服务器
- (BOOL)uploadQuestionAswerToRemoteServerNeedLong:(BOOL) need;
//从服务器下载数据
- (void)downloadQuenstionAnswer;
//本地导入数据后更新用户信息
-(void)updateTringUser;

//清理temp数据
- (void) deleteTemp;
//将信息暂存在temp中
- (void) addToTemp:(NSArray *)array;
//删除temp中最后一个对象，当用户点击back时候调用
- (void)tempRemoveLastObject;

- (NSArray *) getTemp;

//从缓存加入数据库
- (void) addTempToDB;

//保存数据到数据库
- (void)saveQuenstionAnswer:(NSArray *)array;
- (void)saveQuenstionAnswer:(NSArray *)array WithUID:(NSInteger) u_ID;


//获取文案index 范围 0 ~ 10
- (int32_t) getAlarmDescriptionIndex;


//详情查看
-(int32_t) getReasonIDWIthQid:(int32_t)qID andAID:(int32_t) aID;



//获取详情数组
-(NSArray *) getDetailReasonSet;
//删除表数据
- (void)deleteQuestionAnswerFromDB;

- (id)isFromRecord;

- (void)setFromRecord:(id)obj;


#pragma --mark   5.0版本

- (void) saveFatReasonToDB:(NSArray *)array  andUserId:(NSInteger)userID andSync:(NSInteger) sync;
//从数据库获取数据
- (NSArray *)getQuestionAnswer;

- (int32_t)getReasonDescriptionWithID:(int32_t)qID andAID:(int32_t)aID;


- (NSInteger) getBadHabitNum;
- (NSString *)getFatReasonFromDB;
- (void)saveFatReasonToRemoteServer;

#pragma mark - 5.1 new

- (nonnull NSArray<XKRWHabbitEntity *> *)getHabitEntitiesWithString:(nonnull NSString *)qa_string;
- (nonnull NSArray<XKRWHabbitEntity *> *)getHabitEntitiesWithFatReasonEntities:(nonnull NSArray<XKRWFatReasonEntity *> *)fatReasons;

@end
