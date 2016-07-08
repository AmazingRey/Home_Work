//
//  XKRWPaymentResultVC.h
//  XKRW
//
//  Created by XiKang on 15-3-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWPaymentResultVC : XKRWBaseVC

@property (nonatomic, assign) BOOL isHidenIslimResult;
/**
 *  页面初始化方法
 *
 *  @param isSuccess 是否支付成功
 *  @param obj       通知post的对象
 *
 *  @return self实例
 */
- (instancetype)initWithFlag:(BOOL)isSuccess andObj:(id)obj;
/**
 *  pop后回到floor层
 *
 *  @attention  Root NavigationController所属页面为0层，依次递增
 *
 *  @param floor 层数
 */
- (void)setPopToViewControllerWithFloor:(NSInteger)floor;

@end
