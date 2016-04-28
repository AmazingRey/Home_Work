//
//  XKRWHabitListView.h
//  XKRW
//
//  Created by Shoushou on 16/4/25.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWRecordEntity4_0.h"

typedef void(^saveHabit)(NSArray *habitArray);
@interface XKRWHabitListView : UIView

@property (nonatomic, strong) XKRWRecordEntity4_0 *entity;
@property (nonatomic, copy) saveHabit saveBlock;
@end
