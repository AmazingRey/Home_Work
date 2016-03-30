//
//  XKServerException.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-18.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKServerException.h"

@implementation XKServerException

+ (id)exception {
    return [[self alloc] initWithNothing];
}

+ (id)exceptionWithUrl:(NSURL *)url
        httpStatusCode:(NSInteger)httpStatusCode {
    return [[self alloc] initWithUrl:url httpStatusCode:httpStatusCode cause:nil];
}

+ (id)exceptionWithUrl:(NSURL *)url
        httpStatusCode:(NSInteger)httpStatusCode
                 cause:(NSObject *)cause {
    return [[self alloc] initWithUrl:url httpStatusCode:httpStatusCode cause:cause];
}

+ (id)exceptionWithCause:(NSObject *)cause {
    return [[self alloc] initWithCause:cause];
}

- (id)initWithNothing {
    return [self initWithDetail:[self defaultDetail]];
}

- (id)initWithUrl:(NSURL *)url
   httpStatusCode:(NSInteger)httpStatusCode {
    return [self initWithUrl:url httpStatusCode:httpStatusCode cause:nil];
}

- (id)initWithUrl:(NSURL *)url
   httpStatusCode:(NSInteger)httpStatusCode
            cause:(NSObject *)cause {
    self = [self initWithDetail:[NSString stringWithFormat:@"Server problem occured with the http status code [%ld] for the requested URL [%@].", (long)httpStatusCode, url] cause:cause];
    
    if (self) {
        self.httpStatusCode = httpStatusCode;
        self.url = url;
    }
    
    return self;
}

- (id)initWithCause:(NSObject *)cause {
    return [self initWithDetail:[self defaultDetail] cause:cause];
}

- (NSString *)defaultDetail {
    return @"Server problem occured.";
}

@end
