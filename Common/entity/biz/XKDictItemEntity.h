//
//  XKDictItemEntity.h
//  XKFamilyCare
//
//  Created by Rick Liao on 13-3-20.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKEntity.h"

@interface XKDictItemEntity : NSObject <XKEntity>

@property NSString *type;
@property NSString *code;
@property NSString *name;
@property NSString *icon;
@property NSString *parentCode;
@property NSString *ext;

@property XKDictItemEntity *parentItem;
@property (weak) XKDictItemEntity *chosenChildItem;

+ (XKDictItemEntity *)entityWithType:(NSString *)type
                                code:(NSString *)code
                                name:(NSString *)name
                                icon:(NSString *)icon
                          parentCode:(NSString *)parentCode
                                 ext:(NSString *)ext;

- (id)initWithType:(NSString *)type
              code:(NSString *)code
              name:(NSString *)name
              icon:(NSString *)icon
        parentCode:(NSString *)parentCode
               ext:(NSString *)ext;

- (BOOL)codeIsString:(NSString *)string;
- (BOOL)typeIsString:(NSString *)string;

- (XKDictItemEntity *)rootItem;

@end
