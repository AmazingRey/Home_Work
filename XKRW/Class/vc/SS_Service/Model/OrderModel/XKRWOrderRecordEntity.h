//
//  XKRWOrderRecordEntity.h
//  XKRW
//
//  Created by y on 15-3-18.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWOrderRecordEntity : NSObject

//订单编号
@property(nonatomic,strong)NSString *orderNo;

//产品名称
@property(nonatomic,strong)NSString *orderProductName;

//产品金额
@property(nonatomic,strong)NSString *money;

//订单构建时间
@property(nonatomic,strong)NSString *orderDate;

//用户评星
@property(nonatomic,strong)NSString *evaluateScore;

//用户最新评价时间
@property(nonatomic,strong)NSString *evaluateDate;

//每条交易号 下面购买数量
@property(nonatomic,strong)NSString *orderCount;

//用户  id
@property(nonatomic,assign)NSInteger uid;

//每条交易记录的id
@property(nonatomic,assign)NSInteger recordId;

//用户评论 内容
@property(nonatomic,strong)NSString *content;


@end
