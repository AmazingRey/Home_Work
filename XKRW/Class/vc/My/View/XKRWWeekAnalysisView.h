//
//  XKRWWeekAnalysisView.h
//  XKRW
//
//  Created by ss on 16/5/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWStatiscHeadView.h"
#import "XKRWStatisticDetailView.h"

@interface XKRWWeekAnalysisView : UIView

@property (strong, nonatomic) XKRWStatiscHeadView *headView;
@property (strong, nonatomic) XKRWStatisticDetailView *eatDecreaseView;
@property (strong, nonatomic) XKRWStatisticDetailView *sportDecreaseView;

@end
