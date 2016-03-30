//
//  XKRWOrderEntity.h
//  XKRW
//
//  Created by XiKang on 15-3-17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kAliPay;
extern NSString *const kWXPay;

@interface XKRWOrderEntity : NSObject
/**
 *  订单识别字符串，用来区分订单的平台
 *  @attention ali, wx
 */
@property (nonatomic, strong) NSString *identity;
/**
 *  订单返回的错误代码
 */
@property (nonatomic, strong) NSString *errorCode;
/**
 *  订单、商品等标题
 */
@property (nonatomic, strong) NSString *orderTitle;
/**
 *  订单、商品等描述
 */
@property (nonatomic, strong) NSString *orderDescription;
/**
 *  订单号
 */
@property (nonatomic, strong) NSString *orderNO;
/**
 *  价格
 */
@property (nonatomic, strong) NSString *price;
/**
 *  在支付平台注册的id
 */
@property (nonatomic, strong) NSString *appId;

#pragma mark - 微信支付
/**
 *  微信支付用，临时字符串
 */
@property (nonatomic, strong) NSString *nonceStr;
/**
 *  微信支付用，打包字符串
 */
@property (nonatomic, strong) NSString *package;
/**
 *  预支付id
 */
@property (nonatomic, strong) NSString *prepayId;
/**
 *  时间戳
 */
@property (nonatomic, assign) UInt32 timeStamp;
/**
 *  签名
 */
@property (nonatomic, strong) NSString *sign;

#pragma mark - 支付宝支付
/**
 *  商户号，商户申请时生成
 */
@property (nonatomic, strong) NSString *partner;
/**
 *  销售商
 */
@property (nonatomic, strong) NSString *seller;
/**
 *  私钥
 */
@property (nonatomic, strong) NSString *privateKey;
/**
 *  交易代码
 */
@property (nonatomic, strong) NSString *tradeNO;
/**
 *  回调URL
 */
@property (nonatomic, strong) NSString *notifyURL;
/**
 *  服务，默认为@"mobile.securitypay.pay"
 */
@property (nonatomic, strong) NSString *service;
/**
 *  付款方式，默认为@"1"
 */
@property (nonatomic, strong) NSString *paymentType;
/**
 *  输入字符集 UTF8
 */
@property (nonatomic, strong) NSString *inputCharset;
/**
 *  订单寿命，30m
 */
@property (nonatomic, strong) NSString *itBPay;
/**
 *  显示URL， @"m.alipay.com"
 */
@property (nonatomic, strong) NSString *showURL;
/**
 *  服务器返回的aliOrder字符串，直接提交即可
 */
@property (nonatomic, strong) NSString *aliOrder;

#pragma mark - 其他属性
/**
 *  其他参数
 */
@property (nonatomic, strong) NSMutableDictionary *otherParam;
/**
 *  支付平台
 */
@property (nonatomic, strong) NSArray *paymentPlatform;

@end