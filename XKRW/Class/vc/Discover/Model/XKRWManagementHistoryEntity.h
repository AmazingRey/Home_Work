//
//  XKRWManagementHistoryEntity.h
//  XKRW
//
//  Created by Jiang Rui on 14-4-12.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWManagementHistoryEntity : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *date;

@property (nonatomic) XKOperation category;

@property (nonatomic,strong) NSString *nid;

@property (nonatomic) BOOL leastrecord;

@end
