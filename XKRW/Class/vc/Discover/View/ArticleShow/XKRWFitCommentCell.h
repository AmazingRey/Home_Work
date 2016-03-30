//
//  XKRWFitCommentCell.h
//  XKRW
//
//  Created by Shoushou on 15/12/16.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWCommentEtity.h"
#import "XKRWReplyView.h"

@class XKRWFitCommentCell;
@protocol XKRWFitCommentCellDelegate <NSObject>

@optional
- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell didReplyComment:(XKRWCommentEtity *)comment;
- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell longPressedComment:(XKRWCommentEtity*)comment;
- (void)fitCommentCell:(XKRWFitCommentCell *)fitCommentCell clickedComment:(XKRWCommentEtity *)comment;
- (void)fitSubComment:(XKRWReplyView *)replyView userNameDidClicked:(NSString *)userName;
- (void)fitSubComment:(XKRWReplyView *)replyView didSelectAtIndexPath:(NSIndexPath *)selfIndexPath subIndexPath:(NSIndexPath *)subCellIndexPath;
- (void)fitSubComment:(XKRWReplyView *)replyView longPressedAtIndexPath:(NSIndexPath *)selfIndexPath subIndexPath:(NSIndexPath *)subCellIndexPath;;
@end

typedef void(^OpenCallBack)(NSIndexPath *selectIndexPath, BOOL state);
typedef void(^nickNameBK)(NSString *nickName);

@interface XKRWFitCommentCell : UITableViewCell

@property (nonatomic, assign) id<XKRWFitCommentCellDelegate> delegate;
@property (nonatomic, copy) nickNameBK nickNameBlock3;

@property (nonatomic, copy) OpenCallBack openBlock;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) UILabel *floorLabel;
// 头像
@property (nonatomic, strong) UIButton *iconBtn;
// 全文、收起
@property (nonatomic, strong) UIButton *articleReadingBtn;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 评论内容
@property (nonatomic, strong) UILabel *commentLabel;
// 评论再评论
@property (nonatomic, strong) XKRWReplyView *replyView;
@property (nonatomic, strong) XKRWCommentEtity *entity;
// cell分隔线
@property (nonatomic, strong) UIView *line;
// cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UIImageView *replyImageView;

- (void)setFloor:(NSInteger)floor;
@end
