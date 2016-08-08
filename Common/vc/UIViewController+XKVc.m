//
//  UIViewController+XKVc.m
//  calorie
//
//  Created by JiangRui on 13-2-4.
//  Copyright (c) 2013年 neusoft. All rights reserved.
//

#import "XKTaskDispatcher.h"
#import "XKDidPerformTaskNotification.h"
#import "UIViewController+XKVc.h"
#import "MobClick.h"

static NSMutableDictionary *_transferData = nil;

@implementation UIViewController (XKVc)

+ (void)load {
    _transferData = [NSMutableDictionary dictionary];
}

+ (id)transferData {
    return _transferData[NSStringFromClass(self)];
}

+ (void)setTransferData:(id)data {
    [_transferData setValue:data forKey:NSStringFromClass(self)];
}

+ (void)clearTransferData {
    [_transferData removeObjectForKey:NSStringFromClass(self)];
}

- (void)downloadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
    [XKTaskDispatcher downloadWithTaskID:taskID task:task];
}

- (void)uploadWithTaskID:(NSString *)taskID task:(XKDispatcherTask)task {
    [XKTaskDispatcher uploadWithTaskID:taskID task:task];
}

- (void)downloadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task {
    [XKTaskDispatcher downloadWithTaskID:taskID outputTask:task];
}

- (void)uploadWithTaskID:(NSString *)taskID outputTask:(XKDispatcherOutputTask)task {
    [XKTaskDispatcher uploadWithTaskID:taskID outputTask:task];
}

- (void)downloadWithTask:(XKDispatcherTask)task {
    [XKTaskDispatcher downloadWithTaskID:[self defaultTaskID] task:task];
}

- (void)uploadWithTask:(XKDispatcherTask)task {
    [XKTaskDispatcher uploadWithTaskID:[self defaultTaskID] task:task];
}

- (void)downloadWithOutputTask:(XKDispatcherOutputTask)task {
    [XKTaskDispatcher downloadWithTaskID:[self defaultTaskID] outputTask:task];
}

- (void)uploadWithOutputTask:(XKDispatcherOutputTask)task {
    [XKTaskDispatcher uploadWithTaskID:[self defaultTaskID] outputTask:task];
}

- (NSString *)defaultTaskID {
    return NSStringFromClass([self class]);
}

- (NSString *)taskIDForClassWithSubName:(NSString *)subName {
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), subName];
}

- (void)registerDefaultNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDefaultNotification:)
                                                 name:[XKDefaultNotification notificationName]
                                               object:nil];
}

- (void)unregisterDefaultNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[XKDefaultNotification notificationName]
                                                  object:nil];
}

- (void)receiveDefaultNotification:(NSNotification *)notification {
    if ([self shouldRespondForDefaultNotification:((XKDefaultNotification *) notification)]) {
        [self respondForDefaultNotification:((XKDefaultNotification *) notification)];
    } // else NOP
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication {
    return [self shouldRespondForDefaultNotificationForDetailName:[notication detailName]];
}

- (void)respondForDefaultNotification:(XKDefaultNotification *)notification {
    if ([notification isKindOfClass:XKDidPerformTaskNotification.class]) {
        XKDidPerformTaskNotification *notice = (XKDidPerformTaskNotification *) notification;
        [XKDispatcher syncExecuteTask:^ {
            if ([notice isDownloadTask]) {
                if ([notice isSuccess]) {
                    NSLog(@"%@",[notification detailName]);
                    [self didDownloadWithResult:[notice result] taskID:[notification detailName]];
                } else {
                    [self handleDownloadProblem:[notice problem] withTaskID:[notification detailName]];
                }
            } else if ([notice isUploadTask]) {
                if ([notice isSuccess]) {
                    [self didUploadWithResult:[notice result] taskID:[notification detailName]];
                } else {
                    [self handleUploadProblem:[notice problem] withTaskID:[notification detailName]];
                }
            } // else NOP
        }];
    } // else NOP
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
      
    return [detailName isEqualToString:[self defaultTaskID]];
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID {
    // NOP
}

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID {

    @throw problem;
}

- (void)didUploadWithResult:(id)result taskID:(NSString *)taskID {
    // NOP
}

- (void)handleUploadProblem:(id)problem withTaskID:(NSString *)taskID {
    @throw problem;
}

- (BOOL)isNaviRootVC {
    NSArray *vcs = self.navigationController.viewControllers;
    return (vcs && vcs.count > 0 && vcs[0] == self);
}

-(void)beginLogPageViewPV
{
    [MobClick beginLogPageView:[self generateEventName]];
}


-(void)endLogPageViewPV
{
    [MobClick endLogPageView:[self generateEventName]];
}

-(NSString *)generateEventName
{
    return NSStringFromClass([self class]);
    
//    NSString *className = NSStringFromClass(self.class);
//    
//    NSString *suffix = @"ViewController";
//    
//    NSString *eventName = nil;
//    
//    if ([className length] >= [suffix length]) {
//        if ([className compare:suffix options:0 range:NSMakeRange([className length] - [suffix length], [suffix length])] == NSOrderedSame) {
//            eventName = [className substringToIndex:[className length] - [suffix length]];
//        }
//    }
//    else
//    {
//        eventName = className;
//    }
//    
//    return className;
}

@end
