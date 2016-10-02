//
//  NSDictionary+XKUtil.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-30.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKObjcUtil.h"
#import "NSDictionary+XKUtil.h"

@implementation NSDictionary (XKUtil)

+ (NSDictionary *)dictionaryWithPropertiesFromObject:(id)obj {
    NSArray *props = [XKObjcUtil propertyArrayForClass:[obj class]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:props.count];
    
    NSString *key = nil;
    for (XKObjcPropertyInfo *prop in props) {
        key = prop.name;
        [dict setValue:[obj valueForKey:key] forKey:key];
    }
    
    return dict;
}

- (void)addEntriesWithPropertiesFromObject:(id)obj {
    NSArray *props = [XKObjcUtil propertyArrayForClass:[obj class]];
    
    NSString *key = nil;
    for (XKObjcPropertyInfo *prop in props) {
        key = prop.name;
        [self setValue:[obj valueForKey:key] forKey:key];
    }
}

- (void)setPropertiesToObject:(id)obj {
    NSArray *props = [XKObjcUtil propertyArrayForClass:[obj class]];
    
    NSString *key = nil;
    id value = nil;
    
    for (XKObjcPropertyInfo *prop in props) {
        key = prop.name;
        value = self[key];
        
        if (value) {
            if (value == [NSNull null]) {
                value = nil;
            }
            
            [obj setValue:value forKey:key];
        } // else NOP
    }
}

+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2 {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dict1];
    
    [dict2 enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if (![dict1 objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[dict1 objectForKey: key] dictionaryByMergingWith: (NSDictionary *) obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        }
    }];
    
    return (NSDictionary *) [result mutableCopy];
}
- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict {
    return [[self class] dictionaryByMerging: self with: dict];
}

@end
