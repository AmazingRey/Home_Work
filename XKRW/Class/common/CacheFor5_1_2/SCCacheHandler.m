//
//  SCCacheHandler.m
//  XKRW
//
//  Created by Seth Chen on 15/12/31.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "SCCacheHandler.h"

#define ALLOfTheCachePath  @"allOfTheCachePath"
#define FileManager [NSFileManager defaultManager]
@implementation SCCacheHandler

/**<cache with name*/
+ (BOOL)cache:(SCCache *)cache withkey:(NSString *)key
{
    if (![FileManager fileExistsAtPath:getALLfoTheCachePath() isDirectory:NULL]) {
        [FileManager createDirectoryAtPath:getALLfoTheCachePath() withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSKeyedArchiver archiveRootObject:cache toFile:pathForkey(key)];
}

/**<get cache with name*/
+ (SCCache *)getCacheDataFromKey:(NSString *)key
{
    SCCache *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:pathForkey(key)];
    return cache;
}

/**<get the completePath*/
NSString * getALLfoTheCachePath(void)
{
    NSArray * paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullpath = [paths[0] stringByAppendingPathComponent:ALLOfTheCachePath];
    return fullpath;
}

NSString * pathForkey(NSString *key)
{
    NSString *path = [getALLfoTheCachePath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%lx",(unsigned long)[key hash]]];
    return path;
}

BOOL removeCacheforKey(NSString *key)
{
    return [FileManager removeItemAtPath:pathForkey(key) error:nil];
}

BOOL removeAllCache(void)
{
    NSString *cachepath = nil;
    NSDirectoryEnumerator * enumerator = [FileManager enumeratorAtPath:getALLfoTheCachePath()];
    while (cachepath = [enumerator nextObject]) {
        [FileManager removeItemAtPath:pathForkey(cachepath) error:nil];
    }
    return true;
}

long int fileSize(NSString*fullpath)
{
    long int len = 0;
    FILE *fileHandle = fopen(fullpath.UTF8String,"r");
    
    if(fileHandle)
    {
        fseek(fileHandle, 0, SEEK_END);
        len = ftell(fileHandle);
        fclose(fileHandle);
    }
    return len;
}

+ (float)folderSizeAtPath:(NSString*)folderPath
{
    if (![FileManager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[FileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += fileSize(fileAbsolutePath);
    }
    return folderSize/(1024.0*1024.0);
}

float allCacheSize(void)
{
    if (![FileManager fileExistsAtPath:getALLfoTheCachePath()]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[FileManager subpathsAtPath:getALLfoTheCachePath()] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [getALLfoTheCachePath() stringByAppendingPathComponent:fileName];
        folderSize += fileSize(fileAbsolutePath);
    }
    return folderSize/(1024.0*1024.0);
}

@end
