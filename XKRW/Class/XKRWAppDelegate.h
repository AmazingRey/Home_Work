//
//  XKRWAppDelegate.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-9.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XKAppDelegate.h"
#import "UMFeedback.h"
#import "WXApi.h"
#import "XKRWPrivacyPassWordVC.h"

@interface XKRWAppDelegate : XKAppDelegate <UIApplicationDelegate, UMFeedbackDataDelegate, WXApiDelegate,XKRWPrivacyPassWordVCDelegate>
{
    UMFeedback *feedbackClient;
    NSDictionary *dicInfo;
    
}

/// 打开app的时间，每次从后台进入前台会更新此date
@property (nonatomic, strong) NSDate *openDate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSDateFormatter *timeFormatterOne;
@property (strong, nonatomic) NSDateFormatter *timeFormatterTwo;
@property (strong, nonatomic) XKRWPrivacyPassWordVC *privacyPasswordVC;
@end
