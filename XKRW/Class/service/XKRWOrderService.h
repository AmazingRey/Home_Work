//
//  XKRWOrderService.h
//  XKRW
//
//  Created by y on 15-3-9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWOrderEntity.h"
#import "XKRWProductEntity.h"

#import "XKRWOrderRecordEntity.h"

@interface XKRWOrderService : XKRWBaseService

#pragma mark - 网络数据

+ (id)sharedService;
/**
 *  获取商品列表
 *
 *  @return 商品列表
 */
- (NSArray *)getProductList;

/**
 *  获取产品记录
 */
-(NSDictionary*)getProductBuyRecord:(NSDictionary*)params;

/**
 *  帮助、意见反馈
 */
- (NSDictionary *)getUserAdviceByDic:(NSDictionary *)parameters;

/**
 *  订单评价
 */
- (NSDictionary *)userAppraiseByDic:(NSDictionary *)parameters;
/**
 *  支付订单接口
 *
 *  @param orderEntity 订单实体对象
 */
- (void)payOrder:(XKRWOrderEntity *)orderEntity;

/**
 *  获取支付宝支付订单详情
 *
 *  @param pid 商品id
 *
 *  @return 订单实例
 */
- (XKRWOrderEntity *)getAliPayOrderInfoByProductId:(NSInteger)pid;
/**
 *  获取微信订单详情
 *
 *  @param pid 商品id
 *
 *  @return 订单实例
 */
- (XKRWOrderEntity *)getWXPayOrderInfoByProductId:(NSInteger)pid;
///**
// *  支付状态是否开启
// *
// *  @return 状态是否可用
// */
//- (BOOL)showPurchaseEntry;

#pragma mark - 本地数据
/**
 *  获取订单实例
 *
 *  @return 订单实例
 */
+ (XKRWOrderEntity *)publicOrder;
/**
 *  清空订单实例
 */
+ (void)cleanPublicOrder;

//存贮 当前 记录实体
- (void)saveTheRecord:(XKRWOrderRecordEntity *)entity;


//读取当前 记录实体
-(NSMutableArray*)readUserOrderRecordByUid:(NSInteger)uid;




@end
