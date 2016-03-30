//
//  XKRWReplyEntity.h
//  XKRW
//
//  Created by Shoushou on 15/12/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWReplyEntity : NSObject

@property (nonatomic, assign) NSInteger mainId;
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, assign) NSInteger sid;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *receiver_Name;
@property (nonatomic, strong) NSString *replyContent;

@end
