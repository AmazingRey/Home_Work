//
//  NSTimer+XKDispatch.m
//  calorie
//
//  Created by Rick Liao on 13-1-23.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "NSTimer+XKDispatch.h"

@implementation NSTimer (XKDispatch)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                    repeats:(BOOL)repeats
                                       task:(void (^)())task {
    return [NSTimer scheduledTimerWithTimeInterval:seconds
                                            target:self
                                          selector:@selector(executeTaskWithTimer:)
                                          userInfo:task
                                           repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                           repeats:(BOOL)repeats
                              task:(void (^)())task {
    return [NSTimer timerWithTimeInterval:seconds
                                   target:self
                                 selector:@selector(executeTaskWithTimer:)
                                 userInfo:task
                                  repeats:repeats];
}

- (id)initWithFireDate:(NSDate *)date
              interval:(NSTimeInterval)seconds
              userInfo:(id)userInfo
               repeats:(BOOL)repeats
                  task:(void (^)())task {
    return [self initWithFireDate:date
                         interval:seconds
                           target:self
                         selector:@selector(executeTaskWithTimer:)
                         userInfo:task
                          repeats:repeats];
}

+ (void)executeTaskWithTimer:(NSTimer *)timer {
    if([timer userInfo]) {
        void (^task)() = (void (^)())[timer userInfo];
        task();
    } // else NOP
}

@end
