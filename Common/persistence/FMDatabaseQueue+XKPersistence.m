//
//  FMDatabaseQueue+XKPersistence.m
//  XKCommon
//
//  Created by Rick Liao on 13-4-10.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseQueue+XKPersistence.h"

@implementation FMDatabaseQueue (XKPersistence)

+ (id)memoryDatabaseQueueWithDiskPath:(NSString*)aPath {
    FMDatabaseQueue *q = [[self alloc] initInMemoryWithDiskPath:aPath];
    
    FMDBAutorelease(q);
    
    return q;
}

- (id)initInMemoryWithDiskPath:(NSString*)aPath {
    self = [super init];
    
    if (self != nil) {
        _db = [FMDatabase databaseWithPath:nil];
        FMDBRetain(_db);
        
        if (![_db open]) {
            XKLog(@"Could not create database queue for failing to create memory database for path %@", aPath);
            FMDBRelease(self);
            return 0x00;
        }
        
        _path = 0x00;
        
        FMDatabase *dbOnDisk = [FMDatabase databaseWithPath:aPath];
        if (![dbOnDisk open]) {
            XKLog(@"Could not create database queue for failing to open database on disk for path %@", aPath);
            FMDBRelease(self);
            return 0x00;
        }
        
        BOOL copyOK = [self copyDatabaseFromDatabase:dbOnDisk name:@"main" toDatabase:_db name:@"main"];
        [dbOnDisk close];
        
        if (!copyOK) {
            XKLog(@"Could not create database queue for failing to load data from disk to memory for path %@", aPath);
            FMDBRelease(self);
            return 0x00;
        }
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
    }
    
    return self;
}

- (BOOL)attachDatabaseInMemoryWithDiskPath:(NSString *)path
                           forAttachedName:(NSString *)attachedName {
    BOOL result = NO;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    result = [database open];
    
    if (result) {
        result = [self attachInMemoryWithDatabase:database forAttachedName:attachedName];
        [database close];
    }
    
    return result;
}

- (BOOL)attachInMemoryWithDatabase:(FMDatabase *)database
                   forAttachedName:(NSString *)attachedName {
    return [self attachInMemoryWithDatabase:database name:@"main" forAttachedName:attachedName];
}

- (BOOL)attachInMemoryWithDatabase:(FMDatabase *)database
                              name:(NSString *)name
                   forAttachedName:(NSString *)attachedName {
    __block BOOL result = NO;
    
    [self inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:[NSString stringWithFormat:@"ATTACH DATABASE ':memory:' AS %@", attachedName]];
    }];
    
    if (result) {
        result = [self copyDatabaseFromDatabase:database name:name toDatabase:_db name:attachedName];
    }
    
    return result;
}

- (BOOL)copyDatabaseFromDatabase:(FMDatabase *)fromDatabase
                            name:(NSString *)fromName
                      toDatabase:(FMDatabase *)toDatabase
                            name:(NSString *)toName {
    BOOL result = NO;
    
    sqlite3_backup *pBackup = sqlite3_backup_init([toDatabase sqliteHandle],
                                                  [toName UTF8String],
                                                  [fromDatabase sqliteHandle],
                                                  [fromName UTF8String]);
    if (pBackup){
        (void)sqlite3_backup_step(pBackup, -1);
        (void)sqlite3_backup_finish(pBackup);
        
        result = ([toDatabase lastErrorCode] == SQLITE_OK);
    }
    
    return result;
}

@end
