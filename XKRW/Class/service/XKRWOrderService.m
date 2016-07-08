//
//  XKRWOrderService.m
//  XKRW
//
//  Created by y on 15-3-9.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWOrderService.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

static XKRWOrderService *shareInstance = nil;
static XKRWOrderEntity *orderInstance = nil;

@interface XKRWOrderService ()
#pragma mark - 私有APi
/**
 *  获取订单详情
 *
 *  @param type 平台方式，ali=支付宝,wx=微信
 *  @param mode 模式，mob=支付宝移动,wap=支付宝网页
 *  @param pid  商品id
 *
 *  @return 订单详情字典
 */
- (NSDictionary *)getOrderInfoByType:(NSString *)type
                                mode:(NSString *)mode
                           productId:(NSInteger)pid;

@end

@implementation XKRWOrderService

#pragma mark - 网络数据
+(id)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWOrderService alloc]init];
    });
    return shareInstance;
}

- (NSArray *)getProductList {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kGetProductList]];
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
    NSMutableArray *list = [NSMutableArray array];
    
    for (NSDictionary *dic in result[@"data"]) {
        
        XKRWProductEntity *entity = [[XKRWProductEntity alloc] init];
        
        entity.title = dic[@"title"];
        entity.price = dic[@"price"];
        entity.desc = dic[@"description"];
        entity.pid = [NSString stringWithFormat:@"%@",dic[@"pid"]];
        
        [list addObject:entity];
    }
    return list;
}

- (XKRWOrderEntity *)getSSBuyOrderInfoByType:(NSString *)type outTradeNo:(NSString *)outTradeNo title:(NSString *)title price:(CGFloat)price {
    NSURL *url = [NSURL URLWithString:@"http://119.29.81.84:9118/order.php"];
    NSDictionary *param = @{@"type":type,
                            @"out_trade_no":outTradeNo,
                            @"title":title,
                            @"description":@"ssbuy.xikang.com",
                            @"price":[NSNumber numberWithFloat:price]
                            };
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:param];
    NSDictionary *data = result[@"data"];
    
    if (!result[@"success"] || !data) {
        return nil;
    }
    
    XKRWOrderEntity *entity = [[XKRWOrderEntity alloc] init];
    if ([type isEqualToString:@"ali"]) {
        entity.identity = type;
        entity.aliOrder = data[@"order"];
        entity.orderTitle = data[@"title"];
        entity.orderNO = data[@"out_trade_no"];
        
        return entity;
    } else {
        entity.identity = type;
        entity.orderTitle = data[@"title"];
        entity.orderDescription = data[@"description"];
        entity.price = data[@"price"];
        entity.appId = data[@"appid"];
        entity.nonceStr = data[@"noncestr"];
        entity.package = data[@"package"];
        entity.prepayId = data[@"prepayid"];
        entity.timeStamp = [data[@"timestamp"] unsignedIntValue];
        entity.sign = data[@"sign"];
        entity.orderNO = data[@"out_trade_no"];
        return entity;
    }
    
}

- (NSDictionary *)getOrderInfoByType:(NSString *)type mode:(NSString *)mode productId:(NSInteger)pid {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kGetOrderInfo]];
    NSDictionary *param = @{@"type": type,
                            @"mode": mode,
                            @"pid": [NSNumber numberWithInteger:pid],
                            @"do": @"get"};
    
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:param];
    
    return result;
}

- (XKRWOrderEntity *)getAliPayOrderInfoByProductId:(NSInteger)pid {
    
    XKRWOrderEntity *entity = [[XKRWOrderEntity alloc] init];
    entity.identity = @"ali";
    
    NSDictionary *info = [self getOrderInfoByType:@"ali" mode:@"mob" productId:pid];
    
    entity.aliOrder = info[@"data"][@"order"];
    entity.orderTitle = info[@"data"][@"title"];
    entity.orderNO = info[@"data"][@"out_trade_no"];
    
    return entity;
}

- (XKRWOrderEntity *)getWXPayOrderInfoByProductId:(NSInteger)pid {
    
    XKRWOrderEntity *entity = [[XKRWOrderEntity alloc] init];
    entity.identity = @"wx";
    
    NSDictionary *info = [self getOrderInfoByType:@"wx" mode:@"mob" productId:pid][@"data"];
    
    entity.orderTitle = info[@"title"];
    entity.orderDescription = info[@"description"];
    entity.price = info[@"price"];
    entity.appId = info[@"appid"];
    entity.nonceStr = info[@"noncestr"];
    entity.package = info[@"package"];
    entity.prepayId = info[@"prepayid"];
    entity.timeStamp = [info[@"timestamp"] unsignedIntValue];
    entity.sign = info[@"sign"];
    entity.orderNO = info[@"out_trade_no"];
    
    return entity;
}

- (void)payOrder:(XKRWOrderEntity *)orderEntity {
    
    if (!orderEntity.identity || !orderEntity.identity.length) {
        
        XKLog(@"\n==============\nORDER's identity is empty, please check your code");
        return;
    }
    if ([orderEntity.identity isEqualToString:@"wx"]) {
        
        PayReq *request = [[PayReq alloc] init];
        
        [WXApi registerApp:orderEntity.appId];
        
        request.partnerId = @"1232971701";
        request.prepayId = orderEntity.prepayId;
        request.package = orderEntity.package;
        request.nonceStr = orderEntity.nonceStr;
        request.timeStamp = orderEntity.timeStamp;
        request.sign = orderEntity.sign;
        
        [WXApi sendReq:request];
        
    } else if ([orderEntity.identity isEqualToString:@"ali"]) {
        
        [[AlipaySDK defaultService] payOrder:orderEntity.aliOrder fromScheme:@"shoushouAliPay"
                                    callback:^(NSDictionary *resultDic) {
                                        XKLog(@"ali callback:%@", resultDic);
                                        
                                        NSString *result = resultDic[@"result"];
                                        
                                        NSArray *array = [result componentsSeparatedByString:@"&"];
                                        for (NSString *string in array) {
                                            if ([string hasPrefix:@"success"]) {
                                                
                                                if ([string hasSuffix:@"\"true\""]) {
                                                    //do success
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentResultNotification object:@{@"success": @YES, @"type": @"ali"}];
                                                    
                                                } else {
                                                    //do failed
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentResultNotification object:@{@"success": @NO, @"type": @"ali"}];
                                                }
                                                break;
                                            }
                                        }
                                    }];
    }
}

//获取购买记录

- (NSDictionary*)getProductBuyRecord:(NSDictionary*)params
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kNewServer,@"/user/ordCmtList/"];
    NSURL *url = [NSURL URLWithString:urlString];
    //    NSDictionary *dic = [self syncBatchDataWith:url andPostForm:params];
    NSDictionary *dic =  [self syncBatchDataWith:url andPostForm:params withLongTime:YES];
    return dic;
}

//帮助 意见反馈
- (NSDictionary *)getUserAdviceByDic:(NSDictionary*)parameters
{
    NSDictionary *dic;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kNewServer,@"/user/feedback/"];
    NSURL *url = [NSURL URLWithString:urlString];
    dic = [self syncBatchDataWith:url andPostForm:parameters];
    
    return dic;
}

//订单评价
- (NSDictionary *)userAppraiseByDic:(NSDictionary*)parameters {
    
    NSDictionary *dic;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kNewServer,@"/user/cmtOrder/"];
    NSURL *url = [NSURL URLWithString:urlString];
    dic = [self syncBatchDataWith:url andPostForm:parameters];
    return dic;
}

#pragma mark - 本地数据

+ (XKRWOrderEntity *)publicOrder {
    
    if (!orderInstance) {
        orderInstance = [[XKRWOrderEntity alloc] init];
    }
    return orderInstance;
}

+ (void)cleanPublicOrder {
    
    orderInstance = nil;
}

//存贮 当前 记录实体
- (void)saveTheRecord:(XKRWOrderRecordEntity*)entity
{
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback)
     {
        BOOL success =  [db executeUpdate:@"REPLACE INTO OrderTable VALUES(:orderNo,:orderProductName,:recordId,:uid,:money,:orderDate,:evaluateScore,:evaluateDate,:orderCount,:content)" withParameterObject:entity];
         
         XKLog(@"%d",success);
     }];
}

//读取当前 记录实体
- (NSMutableArray*)readUserOrderRecordByUid:(NSInteger)uid
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        NSString *aql = [NSString stringWithFormat:@"SELECT * FROM OrderTable where uid == '%ld' ",(long)uid];
        FMResultSet *resultSet = [db executeQuery:aql];
        while ([resultSet next]) {
            XKRWOrderRecordEntity *entity = [[XKRWOrderRecordEntity alloc]init];
            [resultSet setResultToObject:entity];
            [array addObject:entity];
        }
    }];
    return array;
}


@end
