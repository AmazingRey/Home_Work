//
//  NSString+XKUtil.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-4.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XKUtil)

// YES: 非空
- (BOOL)isNotEmpty;
// YES: 非空且非空格且非Tab且非换行
- (BOOL)isNotBlank;
//判断空字符串 fanzhanao add
- (BOOL) isBlank;

- (BOOL) isContainString:(NSString *)str;

@end
