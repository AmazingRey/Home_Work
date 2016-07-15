//
//  FMResultSet+XKUtil.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-1.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "JSONKit.h"
#import "XKObjcUtil.h"
#import "FMResultSet+XKPersistence.h"

@implementation FMResultSet (XKPersistence)

- (void)setResultToObject:(id)obj {
    NSDictionary *dict = [self resultDictionary];
    NSString *key = nil;
    id value = nil;
    
    NSDictionary *props = [XKObjcUtil propertyDictionaryForClass:[obj class]];
    XKObjcPropertyInfo *prop = nil;
    Class class = nil;
    
    for (key in dict) {
        value = dict[key];
        
        if (value == [NSNull null] ) {
            value = nil;
        } else {
            prop = props[key];
            class = prop.typeClass;
            
            if ([class isSubclassOfClass:NSMutableArray.class]
                || [class isSubclassOfClass:NSMutableDictionary.class]) {
//                value = [value mutableObjectFromJSONString];
                
                NSData *jsonData = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                value = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
            } else if ([class isSubclassOfClass:NSArray.class]
                       || [class isSubclassOfClass:NSDictionary.class]) {
//                value = [value objectFromJSONString];
                
                NSData *jsonData = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                value = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            } // else NOP
        }
        [obj setValue:value forKey:key];
    }
}




- (void)setResultIgnoreAbsentPropertiesToObject:(id)obj {
    NSDictionary *dict = [self resultDictionary];
    
    id value = nil;
    
    NSArray *props = [XKObjcUtil propertyArrayForClass:[obj class]];
    NSString *key = nil;
    Class class = nil;
    
    for (XKObjcPropertyInfo *prop in props) {
        key = prop.name;
        value = dict[key];
        
        if (value) {
            if (value == [NSNull null]) {
                value = nil;
            } else {
                class = prop.typeClass;
                
                if ([class isSubclassOfClass:NSMutableArray.class]
                    || [class isSubclassOfClass:NSMutableDictionary.class]) {
//                    value = [value mutableObjectFromJSONString];
                    NSData *jsonData = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                    value = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    
                } else if ([class isSubclassOfClass:NSArray.class]
                           || [class isSubclassOfClass:NSDictionary.class]) {
//                    value = [value objectFromJSONString];
                    
                    NSData *jsonData = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                    value = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                } // else NOP
            }

            if (value) {
                if ([key isEqualToString:@"isAddGroup"]) {
                    [obj setValue:[NSNumber numberWithInteger:[value integerValue]] forKey:key];
                }else{
                    [obj setValue:value forKey:key];
                }
            }

        } // else NOP
    }
}

@end
