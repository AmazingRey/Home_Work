//
//  XKRWRecordSchemeEntity.h
//  XKRW
//
//  Created by Klein Mioke on 15/7/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWRecordSchemeEntity : NSObject

@property (nonatomic) NSInteger rid;

@property (nonatomic) NSInteger sid;

@property (nonatomic) NSInteger uid;

@property (nonatomic) NSInteger calorie;

@property (nonatomic) NSInteger create_time;
/**
 *  0 is none operation, 1 is no eat/ no sport, 2 is perfect, 3 is eat else/ do else, 4 is eat too much
 */
@property (nonatomic) NSInteger record_value;

@property (nonatomic) RecordType type;

@property (nonatomic) int sync;

@property (nonatomic) NSDate *date;

@end
