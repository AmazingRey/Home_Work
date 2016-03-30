//
//  XKDidPerformTaskNotification.h
//  XKCommon
//
//  Created by Rick Liao on 13-3-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDefaultNotification.h"

typedef enum XKDataChangeNotificationTaskType {
    XKDidPerformTaskNotificationTaskTypeDownload = 0,
    XKDidPerformTaskNotificationTaskTypeUpload,
} XKDidPerformTaskNotificationTaskType;

@interface XKDidPerformTaskNotification : XKDefaultNotification

+ (id)notificationWithTaskID:(NSString *)taskID
                    taskType:(XKDidPerformTaskNotificationTaskType)taskType
                   isSuccess:(BOOL)isSuccess
                      output:(id)output;
+ (id)notificationWithSender:(id)sender
                      taskID:(NSString *)taskID
                    taskType:(XKDidPerformTaskNotificationTaskType)taskType
                   isSuccess:(BOOL)isSuccess
                      output:(id)output
               otherUserInfo:(NSDictionary *)otherUserInfo;

- (id)initWithTaskID:(NSString *)taskID
            taskType:(XKDidPerformTaskNotificationTaskType)taskType
           isSuccess:(BOOL)isSuccess
              output:(id)output;
- (id)initWithSender:(id)sender
              taskID:(NSString *)taskID
            taskType:(XKDidPerformTaskNotificationTaskType)taskType
           isSuccess:(BOOL)isSuccess
              output:(id)output
       otherUserInfo:(NSDictionary *)otherUserInfo;

+ (id)downloadOKNotificationWithTaskID:(NSString *)taskID;
+ (id)downloadOKNotificationWithTaskID:(NSString *)taskID
                                result:(id)result;

+ (id)downloadNGNotificationWithTaskID:(NSString *)taskID;
+ (id)downloadNGNotificationWithTaskID:(NSString *)taskID
                               problem:(id)problem;

+ (id)uploadOKNotificationWithTaskID:(NSString *)taskID;
+ (id)uploadOKNotificationWithTaskID:(NSString *)taskID
                              result:(id)result;

+ (id)uploadNGNotificationWithTaskID:(NSString *)taskID;
+ (id)uploadNGNotificationWithTaskID:(NSString *)taskID
                             problem:(id)problem;

- (id)taskID;
- (id)sender;
- (XKDidPerformTaskNotificationTaskType)chageType;
- (BOOL)isSuccess;
- (id)output;
- (NSDictionary *)otherUserInfo;

- (BOOL)isDownloadTask;
- (BOOL)isUploadTask;
- (id)result;
- (id)problem;

@end
