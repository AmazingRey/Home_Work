//
//  XKRWAppCommentUtil.h
//  XKRW
//
//  Created by 忘、 on 16/3/23.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWAppCommentUtil : NSObject<UIAlertViewDelegate>

+ (instancetype)shareAppComment;

- (void)showAlertViewInVC;

- (void)setEntryPageTimeWithPage:(NSString *)pageName;

@end
