//
//  XKRWPayOrderVC.h
//  XKRW
//
//  Created by XiKang on 15-3-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
@class XKRWProductEntity;
@interface XKRWPayOrderVC : XKRWBaseVC

@property (nonatomic, strong) NSString *pid;
/**
 *  以产品id初始化界面，自动搜索相应pid的产品信息和支付信息
 *
 *  @param pid product id
 *
 *  @return XKRWPayOrderVC实例
 */
@property (nonatomic, strong) XKRWProductEntity *product;

- (id)initWithPID:(NSString *)pid;

@end
