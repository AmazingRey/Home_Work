//
//  NSString+XKUtil.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-4.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "NSString+XKUtil.h"

@implementation NSString (XKUtil)

- (BOOL)isNotEmpty {
    return (self.length > 0);
}

- (BOOL)isNotBlank {
    return ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0);
}

- (BOOL) isBlank {
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (BOOL) isContainString:(NSString *)str{
    if([self rangeOfString:str].location != NSNotFound){
        return YES;
    }
    return NO;

}

@end
