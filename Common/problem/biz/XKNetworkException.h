//
//  XKNetworkException.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKBusinessException.h"

OBJC_EXTERN NSInteger const kXKNetworkExceptionTypeNoResponse;
OBJC_EXTERN NSInteger const kXKNetworkExceptionTypeDataLoss;

@interface XKNetworkException : XKBusinessException

+ (id)exceptionWithType:(NSInteger)type cause:(NSObject *)cause;
+ (id)exceptionWithType:(NSInteger)type;

- (id)initWithType:(NSInteger)type cause:(NSObject *)cause;
- (id)initWithExceptionType:(NSInteger)type;

@end
