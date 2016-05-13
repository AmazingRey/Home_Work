//
//  XKRWFoodCell.h
//  XKRW
//
//  Created by zhanaofan on 14-2-14.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWCollectionEntity.h"

@interface XKRWFoodCell : UITableViewCell


- (void) setCellValue:(NSDictionary *)value;
- (void) setCollectCellValue:(XKRWCollectionEntity *)foodEntity;
@end
