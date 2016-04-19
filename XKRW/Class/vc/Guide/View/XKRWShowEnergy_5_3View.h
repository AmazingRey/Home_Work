//
//  XKRWShowEnergy_5_3View.h
//  XKRW
//
//  Created by ss on 16/4/8.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWEnergyCircleView.h"
#import "XKRWPlanEnergyView.h"

@interface XKRWShowEnergy_5_3View : UIView
@property (strong, nonatomic) IBOutlet XKRWEnergyCircleView *firstCircleView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, weak) id<XKRWPlanEnergyViewDelegate> delegate;
@property (assign, nonatomic) enum PlanType type;
@property (strong ,nonatomic) NSMutableDictionary *dicAll;
@end
