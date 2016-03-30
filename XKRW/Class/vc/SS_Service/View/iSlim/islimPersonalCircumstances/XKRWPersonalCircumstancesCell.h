//
//  XKRWPersonalCircumstancesCell.h
//  XKRW
//
//  Created by 忘、 on 15-2-3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKRWPersonalCircumstancesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ageLabel; //年龄
@property (weak, nonatomic) IBOutlet UILabel *heightLabel; //身高

@property (weak, nonatomic) IBOutlet UILabel *weightLabel; //体重
@property (weak, nonatomic) IBOutlet UILabel *BMILabel;   //BMI值
@property (weak, nonatomic) IBOutlet UILabel *metabolicLabel;  //基础代谢
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel; //最低热量
@property (weak, nonatomic) IBOutlet UILabel *BMRLabel; // BMR值
@property (weak, nonatomic) IBOutlet UILabel *bestWeightLabel;  //最佳体重
//@property (weak, nonatomic) IBOutlet UIImageView *bodyTypeImageView; 
//@property (weak, nonatomic) IBOutlet UIImageView *statImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *resultLabel;  //
@end
