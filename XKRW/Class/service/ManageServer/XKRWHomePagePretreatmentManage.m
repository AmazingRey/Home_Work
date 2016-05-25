//
//  XKRWHomePagePretreatmentManage.m
//  XKRW
//  进入首页预处理
//  Created by 忘、 on 16/4/27.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWHomePagePretreatmentManage.h"
#import "XKRWVersionService.h"
#import "XKRWLocalNotificationService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWSurfaceView.h"
#import "XKRWUserService.h"
#import "XKRWModifyNickNameVC.h"
#import "XKRW-Swift.h"

@implementation XKRWHomePagePretreatmentManage

//进入首页 UI 以及数据的预处理 vc  首页
+ (void)enterHomepageDealDataAndUIWithHomepage:(XKRWBaseVC *)vc {
    
    if (![[XKRWUserService sharedService] getUserNickNameIsEnable]) {
        XKRWModifyNickNameVC *nickVC = [[XKRWModifyNickNameVC alloc] init];
        nickVC.hidesBottomBarWhenPushed = YES;
        nickVC.notShowBackButton = YES;
        [vc.navigationController pushViewController:nickVC animated:YES];
    }
    
    if (![[XKRWLocalNotificationService shareInstance] isResetMetamorphosisTourAlarmsToday]) {
        [[XKRWLocalNotificationService shareInstance] registerMetamorphosisTourAlarms];
    }
    
    [vc downloadWithTaskID:@"syncRemoteData" task:^{
         [XKRWCommHelper syncRemoteData];
    }];
}

@end
