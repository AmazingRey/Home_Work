//
//  XKException.h
//  calorie
//
//  Created by Rick Liao on 13-1-30.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKProblem.h"

@interface XKException : NSException <XKProblem>

+ (id)exceptionWithType:(NSInteger)type
                  brief:(NSString *)brief
                 detail:(NSString *)detail
                  cause:(NSObject *)cause;
+ (id)exceptionWithBrief:(NSString *)brief
                  detail:(NSString *)detail
                   cause:(NSObject *)cause;
+ (id)exceptionWithType:(NSInteger)type
                 detail:(NSString *)detail
                  cause:(NSObject *)cause;
+ (id)exceptionWithType:(NSInteger)type
                  brief:(NSString *)brief
                 detail:(NSString *)detail;
+ (id)exceptionWithDetail:(NSString *)detail
                    cause:(NSObject *)cause;
+ (id)exceptionWithType:(NSInteger)type
                 detail:(NSString *)detail;
+ (id)exceptionWithDetail:(NSString *)detail;
+ (id)exception;

- (id)initWithType:(NSInteger)type
             brief:(NSString *)brief
            detail:(NSString *)detail
             cause:(NSObject *)cause;
- (id)initWithBrief:(NSString *)brief
             detail:(NSString *)detail
              cause:(NSObject *)cause;
- (id)initWithType:(NSInteger)type
            detail:(NSString *)detail
             cause:(NSObject *)cause;
- (id)initWithType:(NSInteger)type
             brief:(NSString *)brief
            detail:(NSString *)detail;
- (id)initWithDetail:(NSString *)detail
               cause:(NSObject *)cause;
- (id)initWithType:(NSInteger)type
            detail:(NSString *)detail;
- (id)initWithDetail:(NSString *)detail;
- (id)initWithNothing;

- (NSInteger)type;
- (NSString *)brief;
- (NSString *)detail;
- (NSObject *)cause;

@end
