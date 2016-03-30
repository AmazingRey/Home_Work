//
//  UITableView+XKRWDiscoverCell.m
//  XKRW
//
//  Created by Klein Mioke on 15/9/1.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "UITableView+XKRWDiscoverCell.h"

@implementation UITableView (XKRWDiscoverCell)

- (id)dequeueReusableCellWithDiscoverCellType:(XKRWDiscoverCellType)type {
    
    NSString *identifier = getDiscoverCellTypeDescription(type);
    return [self dequeueReusableCellWithIdentifier:identifier];
}
@end
