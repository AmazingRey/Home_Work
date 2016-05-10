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
+ (void)enterHomepageDealDataAndUIWithHomepage:(UIViewController *)vc {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XKRWVersionService shareService]doSomeFixWithInfo:^BOOL(NSString *currentVersion, BOOL currentUserNeedExecute) {
            if (currentUserNeedExecute) {
                //设置默认闹钟  (不一定要设置吧)
                [[XKRWLocalNotificationService shareInstance] defaultAlarmSetting];
                
                //当前版本 为5.0以上 进行数据处理
                if ([currentVersion floatValue] >= 5.0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XKRWCui showProgressHud:@"正在为你转换新版数据中\n请稍等..."];
                    });
                    
                    BOOL success = [[XKRWRecordService4_0 sharedService] doFixV5_0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XKRWCui hideProgressHud];
//                        XKRWSurfaceView *surfaceView = [[XKRWSurfaceView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight) Destination:@"XKRWSchemeVC_5_0" andUserId:[XKRWUserDefaultService getCurrentUserId] completion:^{
                            if ([[XKRWUserService sharedService] isNeedNoticeTheChangeOfInsistDays]) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尊敬的瘦瘦老用户，自2015年9月1日起，瘦瘦的“坚持天数”将按照新规则计算。使用v5.0期间，若出现以下情况为正常：\n\n1.首次登录v5.0后，天数比以往增多；\n2.在v5.0重置减肥方案以后，天数比重置前增多；\n\n瘦瘦v5.0新版本以后，“坚持天数”将成为您在瘦瘦的重要数据，累积可用于特权、荣誉和优先体验资格，请加以保护您的帐号和数据。" delegate:vc cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                
                                [alertView show];
                            }
                            
                            if (![[XKRWUserService sharedService] getUserNickNameIsEnable]) {
                                XKRWModifyNickNameVC *nickVC = [[XKRWModifyNickNameVC alloc] init];
                                nickVC.hidesBottomBarWhenPushed = YES;
                                nickVC.notShowBackButton = YES;
                                [vc.navigationController pushViewController:nickVC animated:YES];
                            }
                            
//                        }];
                    });
                    return  success ;
                }
            }
            return NO;
        }];
        //这数据加载是否有问题
        //        [XKRWCommHelper syncRemoteData];
    });
}

@end
