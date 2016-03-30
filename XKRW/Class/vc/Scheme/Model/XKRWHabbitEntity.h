//
//  XKRWHabbitEntity.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWHabbitEntity : NSObject

@property (nonatomic) NSInteger hid;
@property (nonatomic) NSString *name;
/**
 *  改善情况，0表示未改变，1表示改善了
 */
@property (nonatomic) NSInteger situation;

- (instancetype)initWithHid:(NSInteger)hid andName:(NSString *)name andSituation:(NSInteger)situation;

- (NSArray *)getButtonImages;

@end
