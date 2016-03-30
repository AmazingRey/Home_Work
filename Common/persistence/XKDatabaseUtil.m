//
//  XKDatabaseUtil.m
//  XKCommon
//
//  Created by Jiang Rui on 12-11-1.
//  Copyright (c) 2012年 neusoft. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseQueue+XKPersistence.h"
#import "XKConfigUtil.h"
#import "XKDatabaseUtil.h"

@implementation XKDatabaseUtil

static FMDatabaseQueue *_defaultDB;
static FMDatabaseQueue *_defaultReadonlyDB;

+ (FMDatabaseQueue *)defaultDB {
    if (!_defaultDB) {
        NSString *dbFileName = [self defaultDBFileName];
        
        if (![self dbExistForFileName:dbFileName]) {
            // copy the db file to the document directory
            [self copyDBForFileName:dbFileName];
        }
        
        _defaultDB = [self dbForFileName:dbFileName];
        
        if (_defaultDB && [XKConfigUtil boolForKey:@"ShouldAttachDefaultReadonlyDBToDefaultDB"]) {
            FMDatabase *attachedDB = [self readonlyDBForFileName:[self defaultReadonlyDBFileName]];
            BOOL isOK = [attachedDB open];
            
            if (isOK) {
                isOK = [_defaultDB attachInMemoryWithDatabase:attachedDB
                                              forAttachedName:[self defaultReadonlyDBAttachedName]];
                [attachedDB close];
            }
            
            if (!isOK) {
                [NSException raise:@"XKDbLoadException" format:@"Fail to attach the default readonly database to the default database with the specified database file name [%@] and attached name [%@].", [self defaultReadonlyDBFileName], [self defaultReadonlyDBAttachedName]];
            }
        }
    }
    
    return _defaultDB;
}

+ (FMDatabaseQueue *)defaultReadonlyDB {
    if (!_defaultReadonlyDB) {
        if ([XKConfigUtil boolForKey:@"ShouldAccessDefaultReadonlyDBThroughDefaultDB"]) {
            if ([XKConfigUtil boolForKey:@"ShouldAttachDefaultReadonlyDBToDefaultDB"]) {
                _defaultReadonlyDB = [self defaultDB];
            } else {
                [NSException raise:@"XKDbLoadException" format:@"Fail to load the default readonly database for the illegal config setting: [ShouldAttachDefaultReadonlyDBToDefaultDB = NO] [ShouldAccessDefaultReadonlyDBThroughDefaultDB = YES]."];
            }
        } else {
            NSString *dbFileName = [self defaultReadonlyDBFileName];
            _defaultReadonlyDB = [self readonlyDBInMemoryForFileName:dbFileName];
        }
    }
    
    return _defaultReadonlyDB;
}

+ (FMDatabaseQueue *)createDBForFileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath]) {
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] has existed for the full path [%@].", fileName, dbPath];
    }
    
    FMDatabaseQueue *dbQueue = [[FMDatabaseQueue alloc]initWithPath:dbPath];
    return dbQueue;
}

+(void)rebuildDefaultDB {
    //jiangr todo
    NSString *fileName = [self defaultDBFileName];
    NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                             ofType:[fileName pathExtension]];
    if (!dbBundlePath) {
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] doesn't exist for the bundle path.", fileName];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirDBPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:fileName];
    
    // Copy to the documentDirectory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:documentDirDBPath]) {
        [fileManager removeItemAtPath:documentDirDBPath error:&error];
        [[self defaultDB] close];
        _defaultDB = nil;
    }//else NOP
}

+ (BOOL)dbExistForFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:dbPath];
}

+ (BOOL)copyDBForFileName:(NSString *)fileName {
    NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                             ofType:[fileName pathExtension]];
    if (!dbBundlePath) {
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] doesn't exist for the bundle path.", fileName];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirDBPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:fileName];
    
    // Copy to the documentDirectory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL ifDone = [fileManager copyItemAtPath:dbBundlePath toPath:documentDirDBPath error:&error];
    
    return ifDone;
}

+ (FMDatabaseQueue *)dbForFileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] doesn't exist for the full path [%@].", fileName, dbPath];
    }
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    return dbQueue;
}

+ (FMDatabaseQueue *)readonlyDBInMemoryForFileName:(NSString *)fileName {
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                       ofType:[fileName pathExtension]];
    if (!dbPath) {
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] doesn't exist for the bundle path.", fileName];
    }
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue memoryDatabaseQueueWithDiskPath:dbPath];
    
    return dbQueue;
}

+ (FMDatabase *)readonlyDBForFileName:(NSString *)fileName {
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension]
                                                       ofType:[fileName pathExtension]];
    if (!dbPath) {
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] doesn't exist for the bundle path.", fileName];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}

+ (NSString *)defaultDBFileName {
    NSString *dbFileName = [XKConfigUtil stringForKey:@"DefaultDBFileName"];
    
    if (!dbFileName) {
        dbFileName = @"DefaultData.db";
    }
    
    return dbFileName;
}

+ (NSString *)defaultReadonlyDBFileName {
    NSString *dbFileName = [XKConfigUtil stringForKey:@"DefaultReadonlyDBFileName"];
    
    if (!dbFileName) {
        dbFileName = @"DefaultRData.db";
    }
    
    return dbFileName;
}


+ (NSString *)defaultReadonlyDBAttachedName {
    NSString *attachedName = [XKConfigUtil stringForKey:@"DefaultReadonlyDBAttachedName"];
    
    if (!attachedName) {
        attachedName = @"drdb";
    }
    
    return attachedName;
}

@end
