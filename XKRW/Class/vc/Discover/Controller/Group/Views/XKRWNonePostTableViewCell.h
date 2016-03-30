//
//  XKRWNonePostTableViewCell.h
//  XKRW
//
//  Created by Seth Chen on 16/1/27.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWNonePostTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isNoneData;
@property (nonatomic, copy) void(^handle)();
@end
