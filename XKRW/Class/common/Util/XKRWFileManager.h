//
//  XKRWFileManager.h
//  XKRW
//
//  Created by zhanaofan on 14-2-26.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWFileManager : NSObject
+ (NSString*)getPathByDir:(NSSearchPathDirectory)dir
				   domain:(NSSearchPathDomainMask)domainMask
	     relativeFilePath:(NSString*)strRelativeFilePath;

+ (NSString *)privateDocsDirPath;

+ (NSString *)groupDocsDirPath:(NSString *)_groupName;

+ (NSString *)getFileFullPathWithName:(NSString *)_fileName inGroup:(NSString *)_groupName;

+ (NSString *)fileFullPathWithName:(NSString *)fileName;

+ (BOOL) copyFile:(NSString *)srcPath toPath:(NSString*)toPath error:(NSError*)error;

+ (BOOL)isFileExist:(NSString *)_filename inGroup:(NSString *)_groupName;

+ (BOOL)isFileExist:(NSString *)file;

+ (BOOL)deleteFile:(NSString *)_filename inGroup:(NSString *)_groupName;

+ (BOOL)deleteGroup:(NSString *)_groupName;

+ (void)deleteFile:(NSString*)strFilePath;

+ (NSString *)getFilePath:(NSString *)fileName;



@end
