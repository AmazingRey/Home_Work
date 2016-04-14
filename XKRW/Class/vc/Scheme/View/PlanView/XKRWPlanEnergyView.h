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
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
- (void)setEatEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber;
- (void)setSportEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber;
- (void)setHabitEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber;
/**
 *  change current eat kcal with animation
 *
 *  @param currentNumber current kcal number
 */
- (void)runEatEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber;
/**
 *  change current sport expended kcal with animation
 *
 *  @param currentNumber current expended kcal number
 */
- (void)runSportEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber;
/**
 *  change current correct bad habits with animation
 *
 *  @param currentNumber current corrective habits number
 */
- (void)runHabitEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber;
@end
