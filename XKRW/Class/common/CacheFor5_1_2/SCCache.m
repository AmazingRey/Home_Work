//
//  SCCache.m
//  XKRW
//
//  Created by Seth Chen on 15/12/31.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "SCCache.h"

@implementation SCCache

static NSString *const kDataKey = @"kDataKey";
static NSString *const kNameKey = @"kNameKey";
static NSString *const kDateKey = @"kDateKey";


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self name] forKey:kNameKey];
    [aCoder encodeObject:[self date] forKey:kDateKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setName:[aDecoder decodeObjectForKey:kNameKey]];
        [self setDate:[aDecoder decodeObjectForKey:kDateKey]];
    }
    return self;
}

@end
