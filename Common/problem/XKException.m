//
//  XKException.m
//  calorie
//
//  Created by Rick Liao on 13-1-30.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKException.h"

@implementation XKException

+ (id)exceptionWithType:(NSInteger)type
                  brief:(NSString *)brief
                 detail:(NSString *)detail
                  cause:(NSObject *)cause {
    return [[self alloc] initWithType:type brief:brief detail:detail cause:cause];
}

+ (id)exceptionWithBrief:(NSString *)brief
                  detail:(NSString *)detail
                   cause:(NSObject *)cause {
    return [[self alloc] initWithBrief:brief detail:detail cause:cause];
}

+ (id)exceptionWithType:(NSInteger)type
                 detail:(NSString *)detail
                  cause:(NSObject *)cause {
    return [[self alloc]initWithType:type detail:detail cause:cause];
}

+ (id)exceptionWithType:(NSInteger)type
                  brief:(NSString *)brief
                 detail:(NSString *)detail {
    return [[self alloc] initWithType:type brief:brief detail:detail];
}

+ (id)exceptionWithDetail:(NSString *)detail
                    cause:(NSObject *)cause {
    return [[self alloc] initWithDetail:detail cause:cause];
}

+ (id)exceptionWithType:(NSInteger)type
                 detail:(NSString *)detail {
    return [[self alloc] initWithType:type detail:detail];
}

+ (id)exceptionWithDetail:(NSString *)detail {
    return [[self alloc] initWithDetail:detail];
}

+ (id)exception {
    return [[self alloc] initWithNothing];
}

- (id)initWithType:(NSInteger)type
             brief:(NSString *)brief
            detail:(NSString *)detail
             cause:(NSObject *)cause {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    userInfo[@"XKProblemType"] = [NSNumber numberWithInteger:type];
    if (cause) {
        userInfo[@"XKProblemCause"] = cause;
    } // else NOP;
    
    return [self initWithName:brief reason:detail userInfo:userInfo];
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

- (NSInteger)type {
    NSInteger type = kXKProblemUndefinedType;
    
    NSNumber *typeObject = self.userInfo[@"XKProblemType"];
    if (typeObject) {
        type = [typeObject integerValue];
    } // else NOP
    
    return type;
}

- (NSString *)brief {
    return self.name;
}

- (NSString *)detail {
    return self.reason;
}

- (NSObject *)cause {
    return self.userInfo[@"XKProblemCause"];
}

@end
