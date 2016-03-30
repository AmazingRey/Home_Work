//
//  UIViewController+XKVc.h
//  calorie
//
//  Created by JiangRui on 13-2-4.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKDispatcher.h"
#import <UIKit/UIKit.h>

@class XKDefaultNotification;

@interface UIViewController (XKVc)

+ (id)transferData;
+ (void)setTransferData:(id)data;
+ (void)clearTransferData;

- (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task;
- (void)downloadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task;
- (void)uploadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task;

- (void)downloadWithTask:(XKDispatcherTask)task;
- (void)uploadWithTask:(XKDispatcherTask)task;
- (void)downloadWithOutputTask:(XKDispatcherOutputTask)task;
- (void)uploadWithOutputTask:(XKDispatcherOutputTask)task;

- (NSString *)defaultTaskID;
- (NSString *)taskIDForClassWithSubName:(NSString *)subName;

- (void)registerDefaultNotification;
- (void)unregisterDefaultNotification;

// 子类可覆盖实现：用于决定是否响应指定的通知（即是否对该通知执行下面的respondForDefaultNotification:）
//              返回YES代表响应，NO代表不响应
// 缺省实现为：返回调用下面的shouldRespondForDefaultNoticationForDetailName:方法得到的返回值
- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication;
// 子类可覆盖实现：用于对满足shouldRespondForNotication条件的指定通知进行相应的处理
// 缺省实现为：
//           1.当通知为下载成功通知时，同步（在主线程）调用下面的didDownloadWithResult: taskID:方法
//           2.当通知为下载失败通知时，同步（在主线程）调用下面的handleDownloadProblem: withTaskID:方法
//           3.当通知为上传成功通知时，同步（在主线程）调用下面的didUploadWithResult: taskID:方法
//           4.当通知为上传失败通知时，同步（在主线程）调用下面的handleUploadProblem: withTaskID:方法
- (void)respondForDefaultNotification:(XKDefaultNotification *)notification;
// 子类可覆盖实现：用以决定是否对指定detailName的通知进行响应
//              返回YES代表响应，NO代表不响应
// 缺省实现为：如果detailName和上面的defaultTaskID方法的返回值一致，则返回YES，否则返回NO
- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName;

// 用以子类覆盖实现：收到满足shouldRespondForNotication条件的下载成功的通知后会被调用，缺省实现为无处理
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID;
// 用以子类覆盖实现：收到满足shouldRespondForNotication条件的下载失败的通知后会被调用，缺省实现为原样抛出(@throw)该问题
- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID;
// 用以子类覆盖实现：收到满足shouldRespondForNotication条件的上传成功的通知后会被调用，缺省实现为无处理
- (void)didUploadWithResult:(id)result taskID:(NSString *)taskID;
// 用以子类覆盖实现：收到满足shouldRespondForNotication条件的上传失败的通知后会被调用，缺省实现为原样抛出(@throw)该问题
- (void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID;

// 本画面是否是navigation views的root view
- (BOOL)isNaviRootVC;

//进入本画面
-(void)beginLogPageViewPV;
//离开本画面
-(void)endLogPageViewPV;

@end
