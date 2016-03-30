//
//  FMDatabaseQueue+XKPersistence.h
//  XKCommon
//
//  Created by Rick Liao on 13-4-10.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "FMDatabaseQueue.h"

@interface FMDatabaseQueue (XKPersistence)

+ (id)memoryDatabaseQueueWithDiskPath:(NSString*)aPath;

- (id)initInMemoryWithDiskPath:(NSString*)aPath;

- (BOOL)attachDatabaseInMemoryWithDiskPath:(NSString *)path
                           forAttachedName:(NSString *)attachedName;
- (BOOL)attachInMemoryWithDatabase:(FMDatabase *)database
                   forAttachedName:(NSString *)attachedName;
- (BOOL)attachInMemoryWithDatabase:(FMDatabase *)database
                              name:(NSString *)name
                   forAttachedName:(NSString *)attachedName;

@end
