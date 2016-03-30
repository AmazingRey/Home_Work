//
//  XKRWShareCourseVC.h
//  XKRW
//
//  Created by Jack on 15/6/24.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWShareCourseVC : XKRWBaseVC

@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *predictLoseWeightLabel;

@property (nonatomic, assign) NSInteger registDays;
@property (nonatomic, strong) NSString *loseWeightString;

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@end
