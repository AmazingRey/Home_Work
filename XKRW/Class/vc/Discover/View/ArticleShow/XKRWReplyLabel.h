//
//  XKRWReplyLabel.h
//  XKRW
//
//  Created by Shoushou on 15/12/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "TYAttributedLabel.h"
#import "XKRWReplyEntity.h"


@interface XKRWReplyLabel : TYAttributedLabel
@property (nonatomic, strong) XKRWReplyEntity *entity;

@end
