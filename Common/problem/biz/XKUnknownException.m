//
//  XKUnknownException.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKUnknownException.h"

@implementation XKUnknownException

+ (id)exceptionWithCause:(NSObject *)cause {
    return [[self alloc] initWithCause:cause];
}

+ (id)exception {
    return [[self alloc] initWithNothing];
}

- (id)initWithCause:(NSObject *)cause {
    return [self initWithDetail:[self defaultDetail] cause:cause];
}

- (id)initWithNothing {
    return [self initWithDetail:[self defaultDetail]];
}

- (NSString *)defaultDetail {
    return @"Unknown problem occured.";
}

@end
