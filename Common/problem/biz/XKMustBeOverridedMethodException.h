//
//  XKMustBeOverridedMethodException.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-20.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#define XK_THROW_MUST_BE_OVERRIDED_CLASS_METHOD_EXCEPTION @throw([XKMustBeOverridedMethodException exceptionWithClass:self method:_cmd])
#define XK_THROW_MUST_BE_OVERRIDED_INSTANCE_METHOD_EXCEPTION @throw([XKMustBeOverridedMethodException exceptionWithClass:self.class method:_cmd])

#import "XKUnsupportedMethodException.h"

@interface XKMustBeOverridedMethodException : XKUnsupportedMethodException

+ (id)exceptionWithClass:(Class)clazz
                  method:(SEL)method;

- (id)initWithClass:(Class)clazz
             method:(SEL)method;

@end
