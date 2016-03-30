//
//  AssessmentProgressBar.h
//  XKRW
//
//  Created by XiKang on 15-1-23.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssessmentProgressBar : UIView
/**
 *  Initialization funtion, set number of stages and frame of self.
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStage:(NSInteger)stage;
/**
 *  Set every stages displayed color in subview, NSArray must includes [UIColor class]
 */
- (void)setStageColors:(NSArray *)colorArray;
/**
 *  Set to the count of stage, ** BEGIN FROM 1 **
 */
- (void)setToStage:(NSInteger)stage;

@end
