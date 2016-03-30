//
//  XKUnsupportedMethodException.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-16.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKUnsupportedMethodException.h"

@implementation XKUnsupportedMethodException

+ (id)exceptionWithClass:(Class)clazz
                  method:(SEL)method {
    return [[self alloc] initWithClass:clazz method:method];
}

+ (id)exceptionWithClass:(Class)clazz
                  method:(SEL)method
                  reason:(NSString *)reason {
    return [[self alloc] initWithClass:clazz method:method reason:reason];
}

- (id)initWithClass:(Class)clazz
             method:(SEL)method {
    NSString *detail = [NSString stringWithFormat:@"Unsupported method has been accessed for class [%@] method [%@].", NSStringFromClass(clazz), NSStringFromSelector(method)];
    
    return [self initWithDetail:detail];
}

- (id)initWithClass:(Class)clazz
             method:(SEL)method
             reason:(NSString *)reason {
    NSString *detail = [NSString stringWithFormat:@"Unsupported method has been accessed for class [%@] method [%@], the reason is: [%@].", NSStringFromClass(clazz), NSStringFromSelector(method), reason];
    
    return [self initWithDetail:detail];
}

@end
