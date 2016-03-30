//
//  XKRWManageHistoryDetailEntity.h
//  XKRW
//
//  Created by Jiang Rui on 14-4-17.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWManageHistoryDetailEntity : NSObject

@property (nonatomic) XKOperation category;

@property (nonatomic,strong) NSDictionary *content;

@property (nonatomic,strong) NSString *nid;

@end
