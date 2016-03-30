//
//  XKRWGroupItem.m
//  XKRW
//
//  Created by Seth Chen on 16/1/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWGroupItem.h"

@implementation XKRWGroupItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@", self.groupId,self.groupName,self.groupDescription,self.grouptype,self.groupCTime];
}

@end

@implementation XKRWGroupWithtServerTimeItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.groupItems = [NSMutableArray array];
    }
    return self;
}

@end