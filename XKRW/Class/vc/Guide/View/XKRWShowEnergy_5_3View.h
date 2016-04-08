//
//  XKRWShowEnergy_5_3View.h
//  XKRW
//
//  Created by ss on 16/4/8.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWEnergyCircleView.h"

@interface XKRWShowEnergy_5_3View : UIView
@property (weak, nonatomic) IBOutlet XKRWEnergyCircleView *firstCircleView;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet XKRWEnergyCircleView *secondCircleView;
@property (weak, nonatomic) IBOutlet XKRWEnergyCircleView *thridCircleView;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;

@end
