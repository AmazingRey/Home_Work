//
//  NSDictionary+XKUtil.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-30.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XKUtil)

// 创建一个字典，并把obj的所有属性拷贝到该字典中,注意：
//     如果obj中某属性为nil，字典中将不会有该key-value(已有的话会被清除)
+ (NSDictionary *)dictionaryWithPropertiesFromObject:(id)obj;

// 把obj的所有属性拷贝到本字典中,注意：
//     如果obj中某属性为nil，字典中将不会有该key-value(已有的话会被清除)
- (void)addEntriesWithPropertiesFromObject:(id)obj;
// 把本字典中的所有key-value拷贝到obj中,注意：
//     1.只有字典中的key为NSString类型时，相应key-value才会被拷贝
//     2.如果obj中没有某key对应的属性，也不进行拷贝（但不会报错）
//     3.对于NSNull的value，在obj中的设值为nil
- (void)setPropertiesToObject:(id)obj;

+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2;
- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict;

@end
