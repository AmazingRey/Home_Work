//
//  XKProblem.h
//  calorie
//
//  Created by Rick Liao on 13-1-30.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN  NSInteger const kXKProblemUndefinedType;

@protocol XKProblem <NSObject>

@required
- (NSInteger)type;

- (NSString *)brief;

- (NSString *)detail;

- (NSObject *)cause;

@end
