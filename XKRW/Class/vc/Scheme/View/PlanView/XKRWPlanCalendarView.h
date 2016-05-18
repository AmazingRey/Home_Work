//
//  XKRWPlanCalendarView.h
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^lookPlanBlock)();
@interface XKRWPlanCalendarView : UIView
@property (copy, nonatomic) lookPlanBlock lookPlanBlock;
@property (weak, nonatomic) IBOutlet UILabel *weightDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *planFinishLabel;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@end
