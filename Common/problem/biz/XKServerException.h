//
//  XKServerException.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKRuntimeException.h"

@interface XKServerException : XKRuntimeException

@property NSInteger httpStatusCode;
@property NSURL *url;

+ (id)exception;
+ (id)exceptionWithUrl:(NSURL *)url
        httpStatusCode:(NSInteger)httpStatusCode;
+ (id)exceptionWithUrl:(NSURL *)url
        httpStatusCode:(NSInteger)httpStatusCode
                 cause:(NSObject *)cause;
+ (id)exceptionWithCause:(NSObject *)cause;

- (id)initWithNothing;
- (id)initWithUrl:(NSURL *)url
   httpStatusCode:(NSInteger)httpStatusCode;
- (id)initWithUrl:(NSURL *)url
   httpStatusCode:(NSInteger)httpStatusCode
            cause:(NSObject *)cause;
- (id)initWithCause:(NSObject *)cause;

@end
