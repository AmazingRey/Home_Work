//
//  XKCodeNameItemService.h
//  XKFamilyCare
//
//  Created by Wei Zhou on 13-3-21.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKService.h"
#import "XKDictItemEntity.h"

@interface XKDictItemService : XKService

+ (XKDictItemService *) sharedService;

- (XKDictItemEntity *) dictItemWithCode: (NSString *) code itemType: (NSString *) itemType;

- (NSArray *) dictItemArrayWithType: (NSString *) itemType;

- (NSArray *) dictItemArrayWithType: (NSString *) itemType parentCode:(NSString *) parentCode;

// 定制2个Item属性，作为字典kv,建议使用反射避免属性拼写类错误
- (NSDictionary *) itemDictWithType:(NSString *)itemType
                         parentCode:(NSString *)parentCode
                 propertyNameForKey:(NSString *)key
               propertyNameForValue:(NSString *)value;

@end
