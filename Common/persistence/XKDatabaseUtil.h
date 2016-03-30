//
//  XKDatabaseUtil.h
//  XKCommon
//
//  Created by Jiang Rui on 12-11-1.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface XKDatabaseUtil : NSObject

+ (FMDatabaseQueue *)defaultDB;
+ (FMDatabaseQueue *)defaultReadonlyDB;
+ (void)rebuildDefaultDB;

+ (NSString *)defaultDBFileName;
+ (NSString *)defaultReadonlyDBFileName;
+ (NSString *)defaultReadonlyDBAttachedName;

@end
