//
//  XKRWChangeMealPercentVC.h
//  XKRW
//
//  Created by 刘睿璞 on 16/4/24.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
//slideView size
#define SlideViewLeading 15
#define SlideViewWidth XKAppWidth - 2*SlideViewLeading
#define SlideViewHeight 90

//subviews size
#define ImageHeadWidth 30
#define ImageHeadHeight 30
#define LabTitleWidth 50
#define LabTitleHeight 30
#define LabPercentWidth 50
#define LabPercentHeight 20
#define LabNumWidth 100
#define LabNumHeight 30
#define ButtonLockWidth 30
#define ButtonLockHeight 30

#define SlideLeading 15
#define SlideWidth SlideViewWidth - 2*SlideLeading - ImageHeadWidth - LabTitleWidth - LabPercentWidth - ButtonLockHeight
#define SlideHeight 10

#define SlideTop 30

@interface XKRWChangeMealPercentVC : XKRWBaseVC

@property (strong, nonatomic) NSMutableDictionary *dicData;
@property (strong, nonatomic) NSMutableArray *arrMealRatio;
@end
