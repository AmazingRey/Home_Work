//
//  XKMustBeOverridedMethodException.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-20.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <objc/runtime.h>
#import "XKMustBeOverridedMethodException.h"

@implementation XKMustBeOverridedMethodException

+ (id)exceptionWithClass:(Class)clazz
                  method:(SEL)method {
    return [[self alloc] initWithClass:clazz method:method];
}

- (id)initWithClass:(Class)clazz
             method:(SEL)method {
    NSString *reason = [NSString stringWithFormat:@"the current method which is inherited from the super class [%@] can't be called directly and must be overrided in the subclass [%@]", NSStringFromClass(class_getSuperclass(clazz)), NSStringFromClass(clazz)];
    
    return [super initWithClass:clazz
                         method:method
                         reason:reason];
}

@end
