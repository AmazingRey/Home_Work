//
//  XKRWProductEntity.h
//  XKRW
//
//  Created by XiKang on 15-3-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  产品实例
 */
@interface XKRWProductEntity : NSObject
/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  描述
 */
@property (nonatomic, strong) NSString *desc;
/**
 *  价格
 */
@property (nonatomic, strong) NSString *price;
/**
 *  product id 商品号
 */
@property (nonatomic, assign) NSInteger pid;
/**
 *  支付平台
 */
@property (nonatomic, strong) NSArray *paymentPlatform;

@end
