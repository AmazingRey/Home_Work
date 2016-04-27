//
//  XKRWTipsManage.h
//  XKRW
//
//  Created by 忘、 on 16/4/19.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWTipsManage : NSObject

+(instancetype)shareInstance;
/**
 *  获取Tips 显示的内容
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)TipsInfoWithUseSituation;

@end
