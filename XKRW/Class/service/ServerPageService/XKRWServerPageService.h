//
//  XKRWServerPageService.h
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWIslimModel.h"
#import "XKRWIslimCommentModel.h"
/**
 *  购买状态
 */
typedef NS_ENUM(NSInteger, PurchaseState) {
    /**
     *  还未购买
     */
    PurchaseStateNotYet,
    /**
     *  已经付款，但未使用
     */
    PurchaseStatePurchased,
    /**
     *  已全部完成
     */
    PurchaseStateDone
};

@interface XKRWServerPageService : XKRWBaseService

+ (id)sharedService;

#pragma mark - 网络方法
#pragma mark - 免费兑换
/**
 *  参与免费兑换活动
 *
 *  @return 参与成功或失败
 */
- (BOOL)participateFreeExchange;
/**
 *  获取用户免费兑换剩余天数
 */
- (NSNumber *)getFreeExchangeRestDays;
/** 
 *  免费兑换iSlim
 *
 *  @return 是否成功
 */
- (BOOL)exchangeiSlim;
/**
 *  @brief 上传兑换码
 *
 *  @attention 结果字典中的KEY: flag:是否成功 msg:成功或失败信息 total:剩余次数
 *
 *  @return 结果字典
 */
- (NSDictionary *)uploadExchangeCode:(NSString *)exchangeCode;
/**
 *  通过标示符获取兑换码兑换方法文案
 *
 *  @param identifer 标示符
 *
 *  @return 兑换方法数组
 */
- (NSArray *)getExchangeWaysWithIdentifer:(NSString *)identifer;


#pragma mark - iSlim购买及评估
/**
 *  是否显示购买入口
 *
 *  @return 是否显示的boolean
 */
- (BOOL)isShowPurchaseEntry;
/**
 *  是否显示购买入口，新接口，本地上传version版本号
 *
 *  @attention  此接口为网络同步请求接口，如果需要异步或提前获取状态请调用needRequestStateOfSwitch
 *
 *  @see    - (BOOL)needRequestStateOfSwitch
 *
 *  @return
 */
- (BOOL)isShowPurchaseEntry_uploadVersion;
/**
 *  是否需要开关请求数据
 *
 *  @return
 */
- (BOOL)needRequestStateOfSwitch;
/**
 *  获取用户购买状态
 *
 *  @attention KEY: state, data; state为PurchaseStateDone和PurchaseStatePurchased时，data为剩余评估次数
 *
 *  @return 状态字典
 */
- (NSDictionary *)getUserPurchaseState;
/**
 *  上传评估答案
 *
 *  @return 评估结果模型
 */
- (XKRWIslimModel *)uploadEvaluateAnswer;
/**
 *  从服务器获取最近评估结果
 *
 *  @return 评估结果Model
 */
- (XKRWIslimModel *)getiSlimReportFromRemote;
/**
 *  从本地文件读取评估结果Model
 *
 *  @return 评估结果Model
 */
- (XKRWIslimModel *)getIslimModelFromLocalFile;
/**
 *  获取总评论数
 *
 *  @return 结果字典
 */
- (NSDictionary *)getServerDataFromNetwork;
/**
 *  由id、type获取评论
 *
 *  @param commentId 评论id
 *  @param type      类型
 *
 *  @return 评论模型
 */
- (XKRWIslimCommentModel *)getCommentDataFromNetworkWithCommentID:(NSString *)commentId commentType:(NSString *)type;

#pragma mark - 本地方法
#pragma mark -
/**
 *  保存iSlim瘦身评估问题答案，每步都需要调用此方法
 */
- (void)saveAnswer:(id)answer step:(NSInteger)page;
/**
 *  删除最后答题的答案
 */
- (void)deleteLastAnswer;
/**
 *  删除所有答案,释放内存
 */
- (void)deleteAnswers;
/**
 *  获取答案
 *
 *  @return 答案数组
 */
- (NSArray *)getAnswers;

#pragma mark - 免费兑换
/**
 *  保存兑换所剩天数
 *
 *  @param days 所剩天数
 */
- (void)saveExchangeRestDays:(NSInteger)days;
/**
 *  获取兑换所剩天数
 *
 *  @return 所剩天数
 */
- (NSInteger)getExchangeRestDays;
/**
 *  删除兑换天数
 */
- (void)deleteExchangeRestDays;

#pragma mark - 评估
/**
 *  获取评估剩余次数
 *
 *  @attention  本地存储，不安全
 *  @return 剩余评估次数
 */
- (NSInteger)getEvaluateChances;
/**
 *  是否使用过
 *
 *  @important KEY: islim
 *
 *  @return 是否评估过
 */
- (BOOL)isUsed:(NSString *)identifer;

#pragma mark - 其他

/**
 *  是否展示排序图片提醒
 *
 *  @return 是否需要展示
 */
- (BOOL)isShowSortRemindImageView;
/**
 *  设置排序图片提醒
 *
 *  @important KEY: islim
 */
- (void)setShowSortRemindImageView:(BOOL)flag;

/**
 *  是否显示上拉下拉图片提醒
 *  @return 是否需要展示
 */
- (BOOL)isShowPullUpImageView;


/**
 *  设置上拉下拉图片提醒
 *
 */
- (void)setShowPullUpImageView:(BOOL)flag;

/**
 *  islim 中的广告位请求
 */
- (NSMutableArray *)requestIslimDataForAdd;
#pragma mark - 内测功能

#ifdef DEBUG

- (void)给我一千次iSlim次机会;

#endif

@end
