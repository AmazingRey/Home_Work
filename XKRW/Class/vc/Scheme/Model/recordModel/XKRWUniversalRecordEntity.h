//
//  XKRWUniversalRecordEntity.h
//  XKRW
//
//  Created by Klein Mioke on 15/7/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWUniversalRecordEntity : NSObject

@property (nonatomic) NSInteger rid;

@property (nonatomic) NSInteger uid;
/**
 *  服务器端id
 */
@property (nonatomic) NSInteger serverid __deprecated_msg("No use before version 5.0");

@property (nonatomic) NSInteger create_time;

@property (nonatomic) NSMutableDictionary *value;

@property (nonatomic) RecordType type;

@property (nonatomic) int sync;

//- (void)setSchemeSituationValue:(NSInteger)situation withType:(RecordType)type;

- (NSDictionary *)dictionaryInDatabase;

- (instancetype)initWithDictionaryInDatabase:(NSDictionary *)dictionay;

- (NSMutableDictionary *)value;

@end
