//
//  XKRWFileManager.m
//  XKRW
//
//  Created by zhanaofan on 14-2-26.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFileManager.h"

@implementation XKRWFileManager


#pragma mark -
#pragma mark FileSystem Handler
//获取指定路径
+ (NSString*)getPathByDir:(NSSearchPathDirectory)dir
				   domain:(NSSearchPathDomainMask)domainMask
	     relativeFilePath:(NSString*)strRelativeFilePath
{
	NSString		*strDir			= nil;
	NSArray			*arrDirPaths	= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	if (arrDirPaths == nil || arrDirPaths.count == 0) {
		return nil;
	}
	
	strDir = [arrDirPaths objectAtIndex:0];
	if (strRelativeFilePath != nil) {
		return [strDir stringByAppendingPathComponent:strRelativeFilePath];
	}
	
	return strDir;
}

#pragma mark
#pragma mark FileManage Method

//private document
+ (NSString *)privateDocsDirPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PrivateDocuments"];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    //    LOG(@"create error=%@", error);
    return documentsDirectory;
}

+ (NSString *)groupDocsDirPath:(NSString *)_groupName {
    
    NSString *documentsDirectory = [[self class] privateDocsDirPath];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:_groupName];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    //    LOG(@"create error=%@", error);
    return documentsDirectory;
}

+ (NSString *)getFileFullPathWithName:(NSString *)_fileName inGroup:(NSString *)_groupName{
    NSString *documentsDirectory = [[self class] groupDocsDirPath:_groupName];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:_fileName];

    return fullPath;
}

+ (NSString *)fileFullPathWithName:(NSString *)fileName
{
    if ([fileName length] == 0) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (!path) {
        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
    }
    return path;
}

+ (BOOL) copyFile:(NSString *)srcPath toPath:(NSString*)toPath error:(NSError*)error
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:srcPath]) {
        //        NSError *err = [[[NSError alloc] init] autorelease];
        if ([fm fileExistsAtPath:toPath]) {
            [fm removeItemAtPath:toPath error:nil];
        }
        BOOL isOK =  [fm copyItemAtPath:srcPath toPath:toPath error:&error];
        if (error != nil) {
            NSLog(@"error message is: %@", [error description]);
            NSLog(@"error desciption is: %@",[error userInfo]);
        }
        return isOK;
    }
    return NO;
}

+ (BOOL)isFileExist:(NSString *)_filename inGroup:(NSString *)_groupName
{
    NSString *strPath = [[self class] getFileFullPathWithName:_filename inGroup:_groupName];
    return [[NSFileManager defaultManager] fileExistsAtPath:strPath];
}

+ (BOOL)isFileExist:(NSString *)file
{
    if (!file) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:
            [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
             stringByAppendingPathComponent:file]];
}
+ (BOOL)deleteFile:(NSString *)_filename inGroup:(NSString *)_groupName
{
    NSString *strPath = [[self class] getFileFullPathWithName:_filename inGroup:_groupName];
    return [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
}

+ (BOOL)deleteGroup:(NSString *)_groupName
{
    NSString *strPath = [[self class] groupDocsDirPath:_groupName];
    return [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
}

//document 文件夹
+ (void)deleteFile:(NSString*)strFilePath
{
	if (strFilePath == nil) {
		NSLog(@"param error");
		return;
	}
	
	NSError			*error					= nil;
	BOOL			isDir					= FALSE;
	NSFileManager	*fileMgr				= [NSFileManager defaultManager];
	
	if ([fileMgr fileExistsAtPath:strFilePath
					  isDirectory:&isDir] &&
		!isDir)
	{
		if (FALSE == [fileMgr removeItemAtPath:strFilePath error:&error]) {
			if (error != nil) {
				NSLog(@"delete file failed: [%@]", [[error userInfo] objectForKey:NSLocalizedDescriptionKey]);
			}
		}
	}
}

//获取fileName的文件路径,如果文件不存在则创建文件
+ (NSString *)getFilePath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (!path) //如果文件不存在则创建文件
    {
        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
    }
    return path;
}

@end
