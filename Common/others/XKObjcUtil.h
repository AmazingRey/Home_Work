//
//  XKObjcUtil.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-9.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface XKObjcPropertyInfo : NSObject

+ (id)infoWithProperty:(objc_property_t)property;

- (id)initWithProperty:(objc_property_t)property;

@property (readonly) NSString *name;
@property (readonly) NSString *typeString; // 当属性为基本类型时的值参见apple开发文档“Property Attribute Description Examples”相关；当属性为ID类型时为值"ID"；当属性为Object类型时为相应类名
@property (readonly) Class typeClass; // 当该属性类型并非为Object时为nil

- (BOOL)isPrimaryType;
- (BOOL)isIDType;
- (BOOL)isObjectType;

@end

@interface XKObjcUtil : NSObject

// 注意：下面这几个property操作的方法，都是操作对象类的所有属性，包括其父类的属性
//      但不支持被覆盖的父类属性，即如果子类中具有和父类属性同名的属性（即使它们类型不同），则父类中的同名属性不会被返回或操作
+ (NSArray *)propertyArrayForClass:(Class)class;
+ (NSDictionary *)propertyDictionaryForClass:(Class)class;

+ (NSArray *)propertyForClass:(Class)class name:(NSString *)name;

+ (BOOL)propertyExistForClass:(Class)class name:(NSString *)name;

+ (void)copyPropertiesForSrc:(id)src dest:(id)dest;

@end
