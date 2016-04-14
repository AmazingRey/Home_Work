//
//  XKRWThinBodyDayManage.h
//  XKRW
//
//  Created by 忘、 on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRWBaseVC.h"
@interface XKRWThinBodyDayManage : NSObject <UIAlertViewDelegate>

+(instancetype)shareInstance;


- (void)viewWillApperShowFlower:(XKRWBaseVC *) vc;

- (NSString *)PlanDayText ;

@end
