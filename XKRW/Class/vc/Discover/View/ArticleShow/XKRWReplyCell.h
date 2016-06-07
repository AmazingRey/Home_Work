//
//  XKRWReplyCell.h
//  XKRW
//
//  Created by Shoushou on 15/12/15.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWReplyEntity.h"
#import "XKRWReplyLabel.h"

@class XKRWReplyCell;
@protocol XKRWReplyCellDelegate <NSObject>
@optional

- (void)replyCell:(XKRWReplyCell *)replyCell longPressedWithIndexPath:(NSIndexPath *)replyCellIndexPath;

@end

typedef void(^nickNameBK)(NSString *nickName);

@interface XKRWReplyCell : UITableViewCell<TYAttributedLabelDelegate>

@property (nonatomic, assign) id<XKRWReplyCellDelegate> delegate;

@property (nonatomic, copy) nickNameBK nickNameBlock;
@property (nonatomic, strong) XKRWReplyLabel *label;
@property (nonatomic, strong) XKRWReplyEntity *entity;
@property (nonatomic, strong) NSIndexPath *replyCellIndexPath;
@end
