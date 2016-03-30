//
//  XKError.h
//  calorie
//
//  Created by Rick Liao on 13-1-30.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKProblem.h"

@interface XKError : NSError <XKProblem>

+ (id)errorWithType:(NSInteger)type
              brief:(NSString *)brief
             detail:(NSString *)detail
              cause:(NSObject *)cause;
+ (id)errorWithBrief:(NSString *)brief
              detail:(NSString *)detail
               cause:(NSObject *)cause;
+ (id)errorWithType:(NSInteger)type
             detail:(NSString *)detail
              cause:(NSObject *)cause;
+ (id)errorWithType:(NSInteger)type
              brief:(NSString *)brief
             detail:(NSString *)detail;
+ (id)errorWithDetail:(NSString *)detail
                cause:(NSObject *)cause;
+ (id)errorWithType:(NSInteger)type
             detail:(NSString *)detail;
+ (id)errorWithDetail:(NSString *)detail;
+ (id)error;

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
