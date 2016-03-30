//
//  XKRWShareCourseService.h
//  XKRW
//
//  Created by Jack on 15/7/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"

@interface XKRWShareCourseService : XKRWBaseService
/**
 *  单例
 */
+(id)sharedService;

/**
 *  从服务器获取名人名言 以及图片信息
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)getDataFromServer;

/**
 *  获取名人名言信息
 *
 *  @return 返回名言的数组
 */
-(NSArray *)getFamous;

/**
 *  获取图片信息
 *
 *  @return 返回图片的数组
 */
-(NSArray *)getImageUrl;

/**
 *  设置当前用户已经划动过
 */
- (void)setShareCourseHaveSlide;

/**
 *  判断当前用户是否需要划动
 *
 *  @return 返回YES  需要划动   返回NO 不需要划动
 */
- (BOOL)shareCourseVCNeedSlide;

@end
