//
//  XKRWTitleHeadImgCell.m
//  XKRW
//
//  Created by Jack on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWTitleHeadImgCell.h"
#import "UIImageView+WebCache.h"

@implementation XKRWTitleHeadImgCell

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.font = XKDefaultFontWithSize(17);
    _titleLabel.textColor = XK_TITLE_COLOR;
    
    _timeLabel.font = XKDefaultFontWithSize(12);
    _timeLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _readNumLabel.font = XKDefaultFontWithSize(12);
    _readNumLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _moduleLabel.font = XKDefaultFontWithSize(12);
    _moduleLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    _moreLabel.font = XKDefaultFontWithSize(12);
    _moreLabel.textColor = XK_ASSIST_TEXT_COLOR;
    
    UIView *bottomLineImg = [[UIView alloc] initWithFrame:CGRectMake(0, _moreArticleBtn.bottom-0.5, XKAppWidth, 0.5)];
    bottomLineImg.backgroundColor = XK_ASSIST_LINE_COLOR;
    [_moreArticleBtn addSubview:bottomLineImg];
    
}

- (void)setContentWithArticleEntity:(XKRWManagementEntity5_0 *)entity {
    _articleEntity = entity;
    
    self.timeLabel.text = self.articleEntity.content[@"date"];
    
    //根据标题长短来变动
    NSAttributedString *text;
    if (self.articleEntity.content[@"title"]) {
        text =
        [XKRWUtil createAttributeStringWithString:self.articleEntity.content[@"title"]
                                             font:XKDefaultFontWithSize(17)
                                            color:XK_TITLE_COLOR
                                      lineSpacing:8.5 alignment:NSTextAlignmentLeft];
    } else {
        text = [[NSAttributedString alloc] initWithString:@" "];
    }
    
    self.titleLabel.attributedText = text;
    self.titleLabel.numberOfLines = 0;
    
    //阅读过 字体变灰
    if(self.articleEntity.read){
        self.titleLabel.textColor = XK_ASSIST_TEXT_COLOR;
    }
    if (self.articleEntity.category != eOperationEncourage && self.articleEntity.category != eOperationSport && self.articleEntity.category != eOperationKnowledge) {
        [self.starImg setHidden:YES];
    } else {
        [self.starImg setHidden:NO];
    }
    
    if(self.articleEntity.complete){
        self.starImg.image = [UIImage imageNamed:@"discover_star"];
    } else {
        self.starImg.image = [UIImage imageNamed:@"discover_star_hightlighted"];
    }
    
    if(!self.articleEntity.readNum){
        self.readNumLabel.text = @"0";
    }else{
        
        NSInteger readNum = [self.articleEntity.readNum integerValue];
        if (readNum >= 10000) {
            self.readNumLabel.text = [NSString stringWithFormat:@"%ld万+",(long)readNum/10000];
        }else
        {
            self.readNumLabel.text = entity.readNum;
        }
        
    }
    [self.moreArticleBtn setBackgroundImage:[XKRWUtil createImageWithColor:XK_ASSIST_LINE_COLOR] forState:UIControlStateHighlighted];
    [self.headImg setImageWithURL:[NSURL URLWithString:entity.smallImage] placeholderImage:nil options:SDWebImageRetryFailed];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
