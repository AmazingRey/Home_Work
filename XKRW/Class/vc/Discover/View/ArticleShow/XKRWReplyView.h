//
//  XKRWReplyView.h
//  XKRW
//
//  Created by Shoushou on 15/12/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKRWReplyView;
@protocol XKRWReplyViewDelegate <NSObject>

@optional
- (void)replyView:(XKRWReplyView *)replyView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)replyView:(XKRWReplyView *)replyView didLongPressedAtIndexPath:(NSIndexPath *)indexPath;
@end

typedef void(^nickNameBK)(NSString *nickName);
typedef void(^replyBK)(NSString *nickName);
@interface XKRWReplyView : UIView
@property (nonatomic, copy) nickNameBK nickNameBlock1;
@property (nonatomic, copy) replyBK replyBlock0;
@property (nonatomic, weak) id<XKRWReplyViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithDataArray:(NSArray *)dataArray;
@end
