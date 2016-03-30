//
//  XKUnsupportedMethodException.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-16.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKRuntimeException.h"

#define XK_THROW_UNSUPPORTED_CLASS_METHOD_EXCEPTION @throw([XKUnsupportedMethodException exceptionWithClass:self method:_cmd])
#define XK_THROW_UNSUPPORTED_INSTANCE_METHOD_EXCEPTION @throw([XKUnsupportedMethodException exceptionWithClass:self.class method:_cmd])

#define XK_THROW_UNSUPPORTED_CLASS_METHOD_EXCEPTION_FOR(REASON) @throw([XKUnsupportedMethodException exceptionWithClass:self method:_cmd reason:REASON])
#define XK_THROW_UNSUPPORTED_INSTANCE_METHOD_EXCEPTION_FOR(REASON) @throw([XKUnsupportedMethodException exceptionWithClass:self.class method:_cmd reason:REASON])

#define XK_THROW_UNSUPPORTED_INSTANCE_METHOD_EXCEPTION_FOR_SINGLETON_PATTERN @throw([XKUnsupportedMethodException exceptionWithClass:self.class method:_cmd reason:@"the current class should be used as the singleton pattern"])

@interface XKUnsupportedMethodException : XKRuntimeException

+ (id)exceptionWithClass:(Class)clazz
                  method:(SEL)method;
+ (id)exceptionWithClass:(Class)clazz
                  method:(SEL)method
                  reason:(NSString *)reason;

- (id)initWithClass:(Class)clazz
             method:(SEL)method;
- (id)initWithClass:(Class)clazz
             method:(SEL)method
             reason:(NSString *)reason;

@end
