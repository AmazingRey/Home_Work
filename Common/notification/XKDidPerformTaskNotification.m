//
//  XKDidPerformTaskNotification.m
//  XKCommon
//
//  Created by Rick Liao on 13-3-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKDefine.h"
#import "XKDidPerformTaskNotification.h"

@implementation XKDidPerformTaskNotification

+ (id)notificationWithTaskID:(NSString *)taskID
                    taskType:(XKDidPerformTaskNotificationTaskType)taskType
                   isSuccess:(BOOL)isSuccess
                      output:(id)output {
    return [[XKDidPerformTaskNotification alloc] initWithTaskID:taskID
                                                       taskType:taskType
                                                      isSuccess:isSuccess
                                                         output:output];
}

+ (id)notificationWithSender:(id)sender
                      taskID:(NSString *)taskID
                    taskType:(XKDidPerformTaskNotificationTaskType)taskType
                   isSuccess:(BOOL)isSuccess
                      output:(id)output
               otherUserInfo:(NSDictionary *)otherUserInfo {
    return [[XKDidPerformTaskNotification alloc] initWithSender:sender
                                                         taskID:taskID
                                                       taskType:taskType
                                                      isSuccess:isSuccess
                                                         output:output
                                                  otherUserInfo:otherUserInfo];
}

- (id)initWithTaskID:(NSString *)taskID
            taskType:(XKDidPerformTaskNotificationTaskType)taskType
           isSuccess:(BOOL)isSuccess
              output:(id)output {
    return [self initWithSender:nil
                         taskID:taskID
                       taskType:taskType
                      isSuccess:isSuccess
                         output:output
                  otherUserInfo:nil];
}

- (id)initWithSender:(id)sender
              taskID:(NSString *)taskID
            taskType:(XKDidPerformTaskNotificationTaskType)taskType
           isSuccess:(BOOL)isSuccess
              output:(id)output
       otherUserInfo:(NSDictionary *)otherUserInfo {
    NSMutableDictionary *userInfo = nil;
    if (otherUserInfo) {
        userInfo = [NSMutableDictionary dictionaryWithDictionary:otherUserInfo];
    } else {
        userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    
    userInfo[@"XKUserInfoTaskType"] = [NSNumber numberWithInt:taskType];
    userInfo[@"XKUserInfoIsSuccess"] = [NSNumber numberWithBool:isSuccess];
    if (output) {
        userInfo[@"XKUserInfoOutput"] = output;
    }
    
    return [self initWithDetailName:taskID object:sender otherUserInfo:userInfo];
}

+ (id)downloadOKNotificationWithTaskID:(NSString *)taskID {
    return [XKDidPerformTaskNotification downloadOKNotificationWithTaskID:taskID
                                                                   result:nil];
}

+ (id)downloadOKNotificationWithTaskID:(NSString *)taskID
                                result:(id)result {
    return [XKDidPerformTaskNotification notificationWithTaskID:taskID
                                                       taskType:XKDidPerformTaskNotificationTaskTypeDownload
                                                      isSuccess:YES
                                                         output:result];
}

+ (id)downloadNGNotificationWithTaskID:(NSString *)taskID {
    return [XKDidPerformTaskNotification downloadNGNotificationWithTaskID:taskID
                                                                  problem:nil];
}

+ (id)downloadNGNotificationWithTaskID:(NSString *)taskID
                               problem:(id)problem {
    return [XKDidPerformTaskNotification notificationWithTaskID:taskID
                                                       taskType:XKDidPerformTaskNotificationTaskTypeDownload
                                                      isSuccess:NO
                                                         output:problem];
}

+ (id)uploadOKNotificationWithTaskID:(NSString *)taskID {
    return [XKDidPerformTaskNotification uploadOKNotificationWithTaskID:taskID
                                                                 result:nil];
}

+ (id)uploadOKNotificationWithTaskID:(NSString *)taskID
                              result:(id)result {
    return [XKDidPerformTaskNotification notificationWithTaskID:taskID
                                                       taskType:XKDidPerformTaskNotificationTaskTypeUpload
                                                      isSuccess:YES
                                                         output:result];
}

+ (id)uploadNGNotificationWithTaskID:(NSString *)taskID {
    return [XKDidPerformTaskNotification uploadNGNotificationWithTaskID:taskID
                                                                problem:nil];
}

+ (id)uploadNGNotificationWithTaskID:(NSString *)taskID
                             problem:(id)problem {
    return [XKDidPerformTaskNotification notificationWithTaskID:taskID
                                                       taskType:XKDidPerformTaskNotificationTaskTypeUpload
                                                      isSuccess:NO
                                                         output:problem];
}

- (id)taskID {
    return [self detailName];
}

- (id)sender {
    return self.object;
}

- (XKDidPerformTaskNotificationTaskType)chageType {
    return [[self userInfoValueForKey:@"XKUserInfoTaskType"] intValue];
}

- (BOOL)isSuccess {
    return [[self userInfoValueForKey:@"XKUserInfoIsSuccess"] boolValue];
}

- (id)output {
    return [self userInfoValueForKey:@"XKUserInfoOutput"];
}

- (NSDictionary *)otherUserInfo {
    NSMutableDictionary *otherUserInfo = [NSMutableDictionary dictionaryWithDictionary:[super otherUserInfo]];
    
    [otherUserInfo removeObjectForKey:@"XKUserInfoTaskType"];
    [otherUserInfo removeObjectForKey:@"XKUserInfoIsSuccess"];
    [otherUserInfo removeObjectForKey:@"XKUserInfoOutput"];
    
    return otherUserInfo;
}

- (BOOL)isDownloadTask {
    return ([self chageType] == XKDidPerformTaskNotificationTaskTypeDownload);
}

- (BOOL)isUploadTask {
    return ([self chageType] == XKDidPerformTaskNotificationTaskTypeUpload);
}

- (id)result {
    return ([self isSuccess] ? [self output] : nil);
}

- (id)problem {
    return ([self isSuccess] ? nil : [self output]);
}

@end
