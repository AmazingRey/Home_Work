//
//  XKRWCommentModel.h
//  XKRW
//
//  Created by 忘、 on 15-3-19.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWCommentModel : NSObject

@property (nonatomic,strong) NSString *account;  //账号

@property (nonatomic,strong) NSString *commentContent; //评论内容

@property (nonatomic,assign) NSInteger score ; //分数

@property (nonatomic,strong) NSString *data;  //日期

@property (nonatomic,strong) NSString *commentId;

@end
