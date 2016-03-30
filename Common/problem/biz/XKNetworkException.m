//
//  XKNetworkException.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKNetworkException.h"

NSInteger const kXKNetworkExceptionTypeNoResponse = 1;
NSInteger const kXKNetworkExceptionTypeDataLoss = 2;

@implementation XKNetworkException

+ (id)exceptionWithType:(NSInteger)type cause:(NSObject *)cause {
    return [[self alloc] initWithType:type cause:cause];
}

+ (id)exceptionWithType:(NSInteger)type {
    return [[self alloc] initWithExceptionType:type];
}

- (id)initWithType:(NSInteger)type cause:(NSObject *)cause {
    return [self initWithType:type detail:[self detailForType:type] cause:cause];
}

- (id)initWithExceptionType:(NSInteger)type {
    return [self initWithType:type detail:[self detailForType:type]];
}

- (NSString *)detailForType:(NSInteger)type {
    NSString *detail = nil;
    
    if (type == kXKNetworkExceptionTypeNoResponse) {
        detail = @"当前网络不可用";
    } else if (type == kXKNetworkExceptionTypeDataLoss) {
        detail = @"当前网络不稳定";
    }
    
    return detail;
}

@end
