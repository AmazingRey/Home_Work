//
//  XKProblemUtil.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-19.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKProblemUtil : NSObject

+ (void)installDefaultUnexpectedProblemHandler;
+ (void)installDefaultUnexpectedProblemHandlerWithFinalTask:(void (^)(void))finalTask;

@end
