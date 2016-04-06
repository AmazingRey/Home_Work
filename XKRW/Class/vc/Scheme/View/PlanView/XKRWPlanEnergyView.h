//
//  XKRWPlanEnergyView.h
//  XKRW
//
//  Created by Shoushou on 16/4/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKRWPlanEnergyView;
@protocol XKRWPlanEnergyViewDelegate <NSObject>

@optional
- (void)energyCircleView:(XKRWPlanEnergyView *)energyCircleView clickedAtIndex:(NSInteger)index;
@end
@interface XKRWPlanEnergyView : UIView
@property (nonatomic, weak) id<XKRWPlanEnergyViewDelegate> delegate;

- (void)setEatEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber isBehaveCurrect:(BOOL)isBehaveCurrect;
- (void)setSportEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber isBehaveCurrect:(BOOL)isBehaveCurrect;
- (void)setHabitEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber isBehaveCurrect:(BOOL)isBehaveCurrect;
@end
