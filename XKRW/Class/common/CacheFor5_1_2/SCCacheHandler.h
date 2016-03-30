//
//  SCCacheHandler.h
//  XKRW
//
//  Created by Seth Chen on 15/12/31.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCache.h"

@interface SCCacheHandler : NSObject
/*!
 *  Cache With Key    会替换原来的cache
 *
 *  @return
 */
+ (BOOL)cache:(SCCache *)cache withkey:(NSString *)key;

/*!
 *  get Cache With Key 
 *
 *  @return
 */
+ (SCCache *)getCacheDataFromKey:(NSString *)key;

/*!
 *  remove cache for key
 *
 *  @return
 */
extern BOOL removeCacheforKey(NSString *key);

/*!
 *  remove cache for key
 *
 *  @return
 */
extern BOOL removeAllCache(void);

/*!
 *  allCacheSize
 *
 *  @return  单位KB
 */
extern float allCacheSize(void);


@end
