//
//  XKObjcUtil.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-9.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKObjcUtil.h"

enum XKObjcPropertyTypeKind {
    XKObjcPropertyTypeKindPrimary = 0,    // 基本类型
    XKObjcPropertyTypeKindID,             // ID
    XKObjcPropertyTypeKindObject          // 对象
};
typedef enum XKObjcPropertyTypeKind XKObjcPropertyTypeKind;

static NSMutableDictionary *_dataDict = nil;


@interface XKObjcPropertyInfo ()

@property (readonly) XKObjcPropertyTypeKind typeKind;

@end

@implementation XKObjcPropertyInfo

+ (id)infoWithProperty:(objc_property_t)property {
    return [[self alloc] initWithProperty:property];
}

- (id)initWithProperty:(objc_property_t)property {
    self = [super init];
    
    if (self) {
        _name = [NSString stringWithUTF8String:property_getName(property)];
        
        const char *attributes = property_getAttributes(property);
        //printf("attributes=%s\n", attributes);
        char buffer[1 + strlen(attributes)];
        strcpy(buffer, attributes);
        char *state = buffer, *attribute;
        
        while ((attribute = strsep(&state, ",")) != NULL) {
            if (attribute[0] == 'T' && attribute[1] != '@') {
                // it's a C primitive type:
                /*
                 if you want a list of what will be returned for these primitives, search online for
                 "objective-c" "Property Attribute Description Examples"
                 apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
                 */
                _typeKind = XKObjcPropertyTypeKindPrimary;
                _typeString = [[NSString alloc] initWithBytes:attribute + 1
                                                  length:strlen(attribute) - 1
                                                encoding:NSASCIIStringEncoding];
                _typeClass = nil;
            } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
                // it's an ObjC id type:
                _typeKind = XKObjcPropertyTypeKindID;
                _typeString = @"id";
                _typeClass = nil;
            } else if (attribute[0] == 'T' && attribute[1] == '@') {
                // it's another ObjC object type:
                _typeKind = XKObjcPropertyTypeKindObject;
                _typeString = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
                _typeClass = NSClassFromString(_typeString);
            }
        }
    }
    
    return self;
}

- (BOOL)isPrimaryType {
    return _typeKind == XKObjcPropertyTypeKindPrimary;
}

- (BOOL)isIDType {
    return _typeKind == XKObjcPropertyTypeKindID;
}

- (BOOL)isObjectType {
    return _typeKind == XKObjcPropertyTypeKindObject;
}

@end


@implementation XKObjcUtil

+ (void)initialize {
    if(self == XKObjcUtil.class) {
        _dataDict = [NSMutableDictionary dictionary];
    } // else NOP
}

+ (NSArray *)propertyArrayForClass:(Class)class {
    return [[self propertyDictionaryForClass:class] allValues];
}

+ (NSDictionary *)propertyDictionaryForClass:(Class)class {
    NSDictionary *props = nil;
    
    if (class) {
        NSString *className = NSStringFromClass(class);
        props = _dataDict[className];
        
        if (!props) {
            props = [self createPropertiesDictForClass:class];
            _dataDict[className] = props;
        }
    }
    
    return props;
}

+ (NSDictionary *)createPropertiesDictForClass:(Class)class {
    NSMutableArray *classes = [NSMutableArray array];
    Class currentClass = class;
    
    while (currentClass != NSObject.class && currentClass != Nil) {
        [classes addObject:currentClass];
        currentClass = class_getSuperclass(currentClass);
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    XKObjcPropertyInfo *propInfo = nil;
    
    objc_property_t *props = NULL;
    u_int count = 0;
    
    for (NSInteger i = classes.count - 1; i >= 0; --i) {
        currentClass = classes[i];
        
        props = class_copyPropertyList(currentClass, &count);
        
        for (int j = 0; j < count; ++j) {
            propInfo = [XKObjcPropertyInfo infoWithProperty:props[j]];
            result[propInfo.name] = propInfo;
        }
        
        free(props);
    }
    
    return result;
}

+ (NSArray *)propertyForClass:(Class)class name:(NSString *)name {
    return [self propertyDictionaryForClass:class][name];
}

+ (BOOL)propertyExistForClass:(Class)class name:(NSString *)name {
    return [self propertyForClass:class name:name] != nil;
}

+ (void)copyPropertiesForSrc:(id)src dest:(id)dest {
    if(src && dest) {
        NSArray *srcPropInfos = [self propertyArrayForClass:[src class]];
        NSDictionary *destPropInfos = [self propertyDictionaryForClass:[dest class]];
        
        NSString *key = nil;
        id value = nil;
        
        for (XKObjcPropertyInfo *info in srcPropInfos) {
            key = info.name;
            
            if (destPropInfos[key] != nil) {
                value = [src valueForKey:key];
                [dest setValue:value forKey:key];
            }
        }
    }
}

@end
