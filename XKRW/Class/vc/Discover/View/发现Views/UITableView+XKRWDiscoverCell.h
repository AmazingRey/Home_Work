//
//  UITableView+XKRWDiscoverCell.h
//  XKRW
//
//  Created by Klein Mioke on 15/9/1.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWDiscoverCell.h"

@interface UITableView (XKRWDiscoverCell)

- (id)dequeueReusableCellWithDiscoverCellType:(XKRWDiscoverCellType)type;

@end
