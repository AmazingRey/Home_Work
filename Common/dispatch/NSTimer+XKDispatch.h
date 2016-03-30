//
//  NSTimer+XKDispatch.h
//  calorie
//
//  Created by Rick Liao on 13-1-23.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (XKDispatch)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                    repeats:(BOOL)repeats
                                       task:(void (^)())task;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                           repeats:(BOOL)repeats
                              task:(void (^)())task;

- (id)initWithFireDate:(NSDate *)date
              interval:(NSTimeInterval)seconds
              userInfo:(id)userInfo
               repeats:(BOOL)repeats
                  task:(void (^)())task;

@end
