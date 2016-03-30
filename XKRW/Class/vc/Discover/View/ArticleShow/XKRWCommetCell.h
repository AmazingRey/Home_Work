//
//  XKRWCommetCell.h
//  XKRW
//
//  Created by Shoushou on 15/9/28.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XKRWCommentEtity.h"

typedef void(^SelectCallBack)(NSIndexPath *selectIndexPath, BOOL state);
typedef void(^nickNameBK)(NSString *nickName);
typedef void(^replyBK)(NSString *nickName);

@interface XKRWCommetCell : UITableViewCell

@property (nonatomic, assign) id delegate;

@property (nonatomic, copy) nickNameBK nickNameBlock3;
@property (nonatomic, copy) replyBK replyBlock1;

@property (nonatomic, copy) SelectCallBack selectBlock;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
// 头像
@property (nonatomic, strong) UIButton *iconBtn;
// 全文、收起
@property (nonatomic, strong) UIButton *articleReadingBtn;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 评论内容
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) XKRWCommentEtity *entity;
// cell分隔线
@property (nonatomic, strong) UIView *line;
// cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
