//
//  XKDictItemEntity.m
//  XKFamilyCare
//
//  Created by Rick Liao on 13-3-20.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDictItemEntity.h"

@implementation XKDictItemEntity

+ (XKDictItemEntity *)entityWithType:(NSString *)type
                                  code:(NSString *)code
                                  name:(NSString *)name
                                  icon:(NSString *)icon
                            parentCode:(NSString *)parentCode
                                 ext:(NSString *)ext{
    return [[XKDictItemEntity alloc] initWithType:type
                                               code:code
                                               name:name
                                               icon:icon
                                         parentCode:parentCode
                                              ext:ext];
}

- (id)initWithType:(NSString *)type
              code:(NSString *)code
              name:(NSString *)name
              icon:(NSString *)icon
        parentCode:(NSString *)parentCode
               ext:ext{
    self = [super init];

    if (self) {
        _type = type;
        _code = code;
        _name = name;
        _icon = icon;
        _parentCode = parentCode;
        _ext = ext;
    }
    
    return self;
}

- (BOOL)typeIsString:(NSString *)string {
    return [self.type isEqualToString:string];
}

- (BOOL)codeIsString:(NSString *)string {
    return [self.code isEqualToString:string];
}

- (XKDictItemEntity *)rootItem {
    XKDictItemEntity *rootItem = self;
    XKDictItemEntity *previousItem = self;
    
    while (previousItem.parentItem) {
        rootItem = self.parentItem;
        previousItem = self.parentItem;
    }
    
    return rootItem;
}

@end
