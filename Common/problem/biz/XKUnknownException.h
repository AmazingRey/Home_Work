//
//  XKUnknownException.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKRuntimeException.h"

@interface XKUnknownException : XKRuntimeException

+ (id)exceptionWithCause:(NSObject *)cause;
+ (id)exception;

- (id)initWithCause:(NSObject *)cause;
- (id)initWithNothing;

@end
