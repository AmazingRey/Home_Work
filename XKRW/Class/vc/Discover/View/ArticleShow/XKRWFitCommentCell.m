//
//  XKRWFitCommentCell.m
//  XKRW
//
//  Created by Shoushou on 15/12/16.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWFitCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "XKRWTipView.h"
#import "XKRWUserService.h"

@interface XKRWFitCommentCell ()<XKRWReplyViewDelegate>

// 等级图片
@property (nonatomic, strong) UIImageView *levelImageView;
// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
// 瘦身宣言
@property (nonatomic, strong) UILabel *declarationLabel;

@property (nonatomic, strong) UIImage *replyImage;

@end

@implementation XKRWFitCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.frame = CGRectMake(15, 10, 40, 40);
        self.iconBtn.layer.cornerRadius = 20;
        self.iconBtn.clipsToBounds = YES;
        [self.contentView addSubview:self.iconBtn];
        
        self.levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10+40-8, 40, 10)];
        [self.contentView addSubview:self.levelImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconBtn.right + 15, 10, 180, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.textColor = XKMainSchemeColor;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.declarationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconBtn.right + 15, _nameLabel.bottom, XKAppWidth-70-15, 20)];
        self.declarationLabel.font = XKDefaultFontWithSize(14);
        self.declarationLabel.textColor = XK_ASSIST_TEXT_COLOR;
        self.declarationLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.declarationLabel];
        
        self.floorLabel = [[UILabel alloc] init];
        self.floorLabel.top = self.nameLabel.top;
        self.floorLabel.font = XKDefaultFontWithSize(14);
        self.floorLabel.textColor = XK_ASSIST_TEXT_COLOR;
        self.floorLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.floorLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconBtn.right + 15, self.declarationLabel.bottom + 12, XKAppWidth-70-15, 20)];
        self.commentLabel.textColor = colorSecondary_333333;
        self.commentLabel.font = XKDefaultFontWithSize(14);
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.clipsToBounds = YES;
        [self commentLabelAddLongPressGestureRecognizer];
        [self commentLabelAddTapGestureRecognizer];
        [self.contentView addSubview:self.commentLabel];
        
        self.replyImage = [UIImage imageNamed:@"article_comments_icon_"];
        self.replyImageView = [[UIImageView alloc] initWithImage:self.replyImage];
        self.replyImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editComment)];
        [self.replyImageView addGestureRecognizer:tap];
        [self.contentView addSubview:self.replyImageView];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth - 70 - 15, 0.5)];
        self.line.backgroundColor = XK_ASSIST_LINE_COLOR;
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)commentLabelAddLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedAction)];
    self.commentLabel.userInteractionEnabled = YES;
    [self.commentLabel addGestureRecognizer:longPressGes];
}
- (void)commentLabelAddTapGestureRecognizer {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.commentLabel addGestureRecognizer:tapGes];
}

- (void)editComment {
    
    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(fitCommentCell:didReplyComment:)]) {
        [_delegate fitCommentCell:weakSelf didReplyComment:_entity];
    }

}

- (void)longPressedAction {
    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(fitCommentCell:longPressedComment:)]) {
        [_delegate fitCommentCell:weakSelf longPressedComment:_entity];
    }
    
}

- (void)tapAction {
    typeof(self) __weak weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(fitCommentCell:clickedComment:)]) {
        [_delegate fitCommentCell:weakSelf clickedComment:_entity];
    }

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.commentLabel]) {
        self.commentLabel.backgroundColor = [UIColor colorFromHexString:@"#c7c7c7"];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.commentLabel]) {
        self.commentLabel.backgroundColor = XKClearColor;
    }
}
- (void)setEntity:(XKRWCommentEtity *)entity {

    if (entity) {
        _entity = entity;
     
        [self.levelImageView setImageWithURL:[NSURL URLWithString:entity.levelUrl]];
        [self.iconBtn setImageWithURL:[NSURL URLWithString:entity.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lead_nor"] options:SDWebImageRetryFailed];
        self.timeLabel.text = entity.timeShowStr;
        [self.timeLabel sizeToFit];
        
        self.nameLabel.text = entity.nameStr;
        self.declarationLabel.text = entity.declaration;
        self.commentLabel.numberOfLines = 0;
        
        [self.replyView removeFromSuperview];
        self.replyView = [[XKRWReplyView alloc] initWithDataArray:entity.sub_Array];
        self.replyView.delegate = self;
        typeof(self) __weak weakSelf = self;
        self.replyView.nickNameBlock1 = ^(NSString *nickName1){
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(fitSubComment:userNameDidClicked:)]) {
                [weakSelf.delegate fitSubComment:weakSelf.replyView userNameDidClicked:nickName1];
            }
        };
        [self.contentView addSubview:self.replyView];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3.5;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@",\n,\n,\n,\n,\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
        CGFloat sixFloorHeight = attributeStr.size.height;
        
        self.commentLabel.height = entity.mainCommentHeight;
        CGRect timeFrame;
        if (entity.isShowBtn) {
            self.articleReadingBtn.hidden = NO;
            if (!entity.isOpen) {
                style.lineBreakMode = NSLineBreakByTruncatingTail;
                self.commentLabel.height = sixFloorHeight;
            }
            
            if (!self.articleReadingBtn.hidden) {
                [self addCommentOpenBtn];
            }
            timeFrame = CGRectMake(_articleReadingBtn.left, _articleReadingBtn.bottom + 5, _timeLabel.size.width, _timeLabel.size.height);

        } else {
            self.articleReadingBtn.hidden = YES;
            timeFrame = CGRectMake(_commentLabel.left, _commentLabel.bottom + 5, _timeLabel.size.width, _timeLabel.size.height);
        }
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style};
        self.commentLabel.attributedText = [[NSAttributedString alloc] initWithString:entity.commentStr attributes:attribute];
        
        self.timeLabel.frame = timeFrame;
        self.replyImageView.frame = CGRectMake( XKAppWidth - _replyImage.size.width - 15, _timeLabel.top, _replyImage.size.width, _replyImage.size.height);
        
        CGRect replyViewFrame = CGRectMake(_timeLabel.left, _timeLabel.bottom + 5, _replyView.size.width, _replyView.size.height);
        self.replyView.frame = replyViewFrame;
        
        if (entity.sub_Array && _replyView.hidden == NO) {
            self.line.frame = CGRectMake(_commentLabel.left, _replyView.bottom + 10, XKAppWidth - 70 - 15, 0.5);
        } else if (self.replyImageView.hidden == YES) {
            self.line.frame = CGRectMake(_commentLabel.left, _commentLabel.bottom + 10, XKAppWidth - 70 - 15, 0.5);
        } else {
            self.line.frame = CGRectMake(_commentLabel.left, _timeLabel.bottom + 10, XKAppWidth - 70 - 15, 0.5);
        }
        self.cellHeight = _line.bottom + 1;
    }
    
}


- (void)addCommentOpenBtn {
    if (_articleReadingBtn == nil) {
        self.articleReadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_entity.isOpen) {
            [self.articleReadingBtn setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            [self.articleReadingBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
        [self.articleReadingBtn setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        self.articleReadingBtn.titleLabel.font = XKDefaultFontWithSize(15);
        [self.articleReadingBtn addTarget:self action:@selector(readClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.articleReadingBtn];
    }
   self.articleReadingBtn.frame = CGRectMake(_commentLabel.left, _commentLabel.bottom + 10, 35, 20);
}

- (void)setFloor:(NSInteger)floor {
    NSString *floorString;
    if (floor == 0) {
        floorString = @"沙发";
    } else if (floor == 1) {
        floorString = @"板凳";
    } else {
        floorString = [NSString stringWithFormat:@"%ld楼",(long)(floor + 1)];
    }
    self.floorLabel.text = floorString;
    [self.floorLabel sizeToFit];
    self.floorLabel.right = XKAppWidth - 15;
}

- (void)readClick {
    if (self.openBlock) {
        self.openBlock(self.selectIndexPath,self.entity.isOpen);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -XKRWReplyViewDelegate

-(void)replyView:(XKRWReplyView *)replyView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fitSubComment:didSelectAtIndexPath:subIndexPath:)]) {
        [_delegate fitSubComment:replyView didSelectAtIndexPath:_selectIndexPath subIndexPath:indexPath];
    }
}

- (void)replyView:(XKRWReplyView *)replyView didLongPressedAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fitSubComment:longPressedAtIndexPath:subIndexPath:)]) {
        [_delegate fitSubComment:replyView longPressedAtIndexPath:_selectIndexPath subIndexPath:indexPath];
    }
}

@end
