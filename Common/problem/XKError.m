//
//  XKError.m
//  calorie
//
//  Created by Rick Liao on 13-1-30.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKError.h"

@implementation XKError

+ (id)errorWithType:(NSInteger)type
              brief:(NSString *)brief
             detail:(NSString *)detail
              cause:(NSObject *)cause {
    return [[self alloc] initWithType:type brief:brief detail:detail cause:cause];
}

+ (id)errorWithBrief:(NSString *)brief
              detail:(NSString *)detail
               cause:(NSObject *)cause {
    return [[self alloc] initWithBrief:brief detail:detail cause:cause];
}

+ (id)errorWithType:(NSInteger)type
             detail:(NSString *)detail
              cause:(NSObject *)cause {
    return [[self alloc]initWithType:type detail:detail cause:cause];
}

+ (id)errorWithType:(NSInteger)type
              brief:(NSString *)brief
             detail:(NSString *)detail {
    return [[self alloc] initWithType:type brief:brief detail:detail];
}

+ (id)errorWithDetail:(NSString *)detail
                cause:(NSObject *)cause {
    return [[self alloc] initWithDetail:detail cause:cause];
}

+ (id)errorWithType:(NSInteger)type
             detail:(NSString *)detail {
    return [[self alloc] initWithType:type detail:detail];
}

+ (id)errorWithDetail:(NSString *)detail {
    return [[self alloc] initWithDetail:detail];
}

+ (id)error {
    return [[self alloc] initWithNothing];
}

- (id)initWithType:(NSInteger)type
             brief:(NSString *)brief
            detail:(NSString *)detail
             cause:(NSObject *)cause {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    if (brief) {
        userInfo[@"XKProblemBrief"] = brief;
    } // else NOP
    if (detail) {
        userInfo[@"XKProblemDetail"] = detail;
    } // else NOP
    if (cause) {
        userInfo[@"XKProblemCause"] = cause;
    } // else NOP;
    
    return [self initWithDomain:[self defaultDomain] code:type userInfo:userInfo];
}

- (id)initWithBrief:(NSString *)brief
             detail:(NSString *)detail
              cause:(NSObject *)cause {
    return [self initWithType:[self defaultType]
                        brief:brief
                       detail:detail
                        cause:cause];
}

- (id)initWithType:(NSInteger)type
            detail:(NSString *)detail
             cause:(NSObject *)cause {
    return [self initWithType:type
                        brief:[self defaultBrief]
                       detail:detail
                        cause:cause];
}

- (id)initWithType:(NSInteger)type
             brief:(NSString *)brief
            detail:(NSString *)detail {
    return [self initWithType:type
                        brief:brief
                       detail:detail
                        cause:nil];
}

- (id)initWithDetail:(NSString *)detail
               cause:(NSObject *)cause {
    return [self initWithType:kXKProblemUndefinedType
                        brief:NSStringFromClass(self.class)
                       detail:detail
                        cause:cause];
}

- (id)initWithType:(NSInteger)type
            detail:(NSString *)detail {
    return [self initWithType:type
                        brief:[self defaultBrief]
                       detail:detail
                        cause:nil];
}

- (id)initWithDetail:(NSString *)detail {
    return [self initWithType:[self defaultType]
                        brief:[self defaultBrief]
                       detail:detail
                        cause:nil];
}

- (id)initWithNothing {
    return [self initWithType:[self defaultType]
                        brief:[self defaultBrief]
                       detail:nil
                        cause:nil];
}

- (NSInteger)defaultType {
    return kXKProblemUndefinedType;
}

- (NSString *)defaultBrief {
    return NSStringFromClass(self.class);
}

- (NSString *)defaultDomain {
    return [NSBundle mainBundle].bundleIdentifier;
}

- (NSInteger)type {
    return self.code;
}

- (NSString *)brief {
    return self.userInfo[@"XKProblemBrief"];
}

- (NSString *)detail {
    return self.userInfo[@"XKProblemDetail"];
}

- (NSObject *)cause {
    return self.userInfo[@"XKProblemCause"];
}

@end
