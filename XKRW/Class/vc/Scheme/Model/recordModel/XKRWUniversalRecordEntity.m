//
//  XKRWUniversalRecordEntity.m
//  XKRW
//
//  Created by Klein Mioke on 15/7/2.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWUniversalRecordEntity.h"

@implementation XKRWUniversalRecordEntity

- (void)setSchemeSituationValue:(NSInteger)situation withType:(RecordType)type {

    if (self.type != RecordTypeScheme) {
        return;
    }
    [self.value removeAllObjects];
    [self.value setObject:@(situation) forKey:@"value"];
    [self.value setObject:@(type) forKey:@"type"];
}

- (NSDictionary *)dictionaryInDatabase {
    return @{@"rid": @(self.rid),
             @"uid": @(self.uid),
             @"create_time": @(self.create_time),
             @"type": @(self.type),
             @"value": [NSKeyedArchiver archivedDataWithRootObject:self.value],
             @"sync": @(self.sync)};
}

- (instancetype)initWithDictionaryInDatabase:(NSDictionary *)dictionay {
    
    if (self = [super init]) {
        self.rid = [dictionay[@"rid"] integerValue];
        self.uid = [dictionay[@"uid"] integerValue];
        self.create_time = [dictionay[@"create_time"] integerValue];
        self.type = (RecordType)[dictionay[@"type"] integerValue];
        self.value = [NSKeyedUnarchiver unarchiveObjectWithData:dictionay[@"value"]];
        self.sync = [dictionay[@"sync"] intValue];
    }
    return self;
}

- (NSMutableDictionary *)value {
    
    if (!_value) {
        _value = [NSMutableDictionary dictionary];
    }
    return _value;
}
@end
