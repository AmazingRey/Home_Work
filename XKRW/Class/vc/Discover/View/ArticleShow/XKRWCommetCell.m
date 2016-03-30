//
//  XKRWCommetCell.m
//  XKRW
//
//  Created by Shoushou on 15/9/28.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWCommetCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "XKRWReplyView.h"
#import "XKRWReplyEntity.h"

@interface XKRWCommetCell ()
// 等级图片
@property (nonatomic, strong) UIImageView *levelImageView;
// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
// 瘦身宣言
@property (nonatomic, strong) UILabel *declarationLabel;
// 评论再评论
@property (nonatomic, strong) XKRWReplyView *replyView;

@end

@implementation XKRWCommetCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.levelImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.declarationLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.articleReadingBtn];
        
        [self.contentView addSubview:self.line];
        self.contentView.clipsToBounds = YES;
    }
    
    return self;
}

- (UIButton *)iconBtn {
    
    if (_iconBtn == nil) {
     
    _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame = CGRectMake(15, 10, 40, 40);
    _iconBtn.layer.cornerRadius = 20;
    _iconBtn.clipsToBounds = YES;
    }
    return _iconBtn;
}

- (UIImageView *)levelImageView {
    
    if (_levelImageView == nil) {
        
    _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10+40-8, 40, 10)];
    }
    return _levelImageView;
}

- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = XKMainSchemeColor;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)declarationLabel {
    
    if (_declarationLabel == nil) {
        
    _declarationLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10+20, XKAppWidth-70-15, 20)];
    _declarationLabel.font = [UIFont systemFontOfSize:14];
    _declarationLabel.textColor = XK_ASSIST_TEXT_COLOR;
    _declarationLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _declarationLabel;
}

- (UILabel *)timeLabel {
    
    if (_timeLabel == nil) {
 
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(XKAppWidth-80, 10, 65, 20)];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)commentLabel {
    
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.declarationLabel.bottom + 12, XKAppWidth-70-15, 20)];
        _commentLabel.textColor = colorSecondary_333333;
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.numberOfLines = 0;
        _commentLabel.clipsToBounds = YES;
    }
    return _commentLabel;
}

- (UIButton *)articleReadingBtn {
    
    if (_articleReadingBtn == nil) {
     
    _articleReadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _articleReadingBtn.frame = CGRectMake(70, 101+60, 35, 20);
    [_articleReadingBtn setTitleColor:XK_ASSIST_TEXT_COLOR forState:UIControlStateNormal];
    _articleReadingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_articleReadingBtn addTarget:self action:@selector(readClick)  forControlEvents:UIControlEventTouchUpInside];
    }
    return _articleReadingBtn;
}

- (UIView *)line {
    
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(70, 0, XKAppWidth - 70 - 15, 0.5)];
        _line.backgroundColor = XK_ASSIST_LINE_COLOR;
    }
    return _line;
}

#pragma mark - 数据设置
- (void)setEntity:(XKRWCommentEtity *)entity {
    
    _entity = entity;
    
    [self.levelImageView setImageWithURL:[NSURL URLWithString:_entity.levelUrl]];
    [self.iconBtn setImageWithURL:[NSURL URLWithString:_entity.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lead_nor"]];
    self.timeLabel.text = _entity.timeShowStr;
    self.nameLabel.text = _entity.nameStr;
    self.declarationLabel.text = _entity.declaration;
    
    if (entity.commentStr == nil) {
        entity.commentStr = @"";
    } 
    self.commentLabel.attributedText = [XKRWUtil createAttributeStringWithString:entity.commentStr font:XKDefaultFontWithSize(14) color:colorSecondary_333333 lineSpacing:3.5 alignment:NSTextAlignmentLeft];
    self.commentLabel.frame = CGRectMake(70, 50 + 5, XKAppWidth-80, entity.mainCommentHeight);
    
    self.articleReadingBtn.frame = CGRectMake(70, entity.mainCommentHeight+60, 35, 20);
    if (self.entity.isShowBtn) {
        self.articleReadingBtn.hidden = NO;
        self.cellHeight = 50 + 15 + entity.currentHeight + 25;
    }else{
        self.articleReadingBtn.hidden = YES;
        self.cellHeight = 50 + 20 + entity.currentHeight;
    }
    
    if (entity.sub_Array.count && self.replyView.hidden == NO) {
        [self.contentView addSubview:self.replyView];
//        _cellHeight += _replyView.size.height;
    }
    self.line.frame = CGRectMake(70, _cellHeight- 0.5, XKAppWidth-70-15, 0.5);
    
    CGRect frame;
    if (_articleReadingBtn.hidden == NO) {
        
        frame = CGRectMake(70, _articleReadingBtn.bottom + 5, XKAppWidth - 70 - 15, _replyView.frame.size.height);
    } else {
        frame = CGRectMake(70, _commentLabel.bottom + 5, XKAppWidth - 70 - 15, _replyView.frame.size.height);
    }
    _replyView.frame = frame;
    if (self.entity.isOpen) {
        [self.articleReadingBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [self.articleReadingBtn setTitle:@"全文" forState:UIControlStateNormal];
    }
}

- (XKRWReplyView *)replyView {
    if (_replyView == nil) {
  
        _replyView = [[XKRWReplyView alloc] initWithDataArray:_entity.sub_Array];
        
        typeof(self) __weak weakSelf = self;
        _replyView.nickNameBlock1 = ^(NSString *nickName2){
            if (weakSelf.nickNameBlock3) {
                weakSelf.nickNameBlock3(nickName2);
            }
        };
        
        _replyView.replyBlock0 = ^(NSString *replyNickName0){
            if (weakSelf.replyBlock1) {
                weakSelf.replyBlock1(replyNickName0);
            }
        };
    }
    return _replyView;
}

#pragma mark - 点击事件
- (void)readClick
{
    self.entity.isOpen = !self.entity.isOpen;
   
    if (self.selectBlock) {
        self.selectBlock(self.selectIndexPath,self.entity.isOpen);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
