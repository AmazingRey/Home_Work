//
//  XKRWReplyLabel.m
//  XKRW
//
//  Created by Shoushou on 15/12/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWReplyLabel.h"
#import "define.h"

@implementation XKRWReplyLabel

- (void)setEntity:(XKRWReplyEntity *)entity {
    _entity = entity;
    self.origin = CGPointMake(10, 0);
    self.width = XKAppWidth - 70 - 15 - 15;
    self.backgroundColor = XKClearColor;
    self.linesSpacing = 0;
    self.characterSpacing = 0;
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",entity.nickName];
    NSMutableArray *strArray = [NSMutableArray array];
    
    TYLinkTextStorage *nickName = [[TYLinkTextStorage alloc] init];
    nickName.range = [str rangeOfString:entity.nickName];
    nickName.underLineStyle = kCTUnderlineStyleNone;
    nickName.font = XKDefaultFontWithSize(14);
    nickName.textColor = XKMainSchemeColor;
    nickName.linkData = entity.nickName;
    [strArray addObject:nickName];
    
    if (entity.receiver_Name) {
        [str appendString:@"回复"];
        [str appendString:entity.receiver_Name];
        
        TYLinkTextStorage *receiverName = [[TYLinkTextStorage alloc] init];
        receiverName.range = [str rangeOfString:entity.receiver_Name];
        receiverName.underLineStyle = kCTUnderlineStyleNone;
        receiverName.font = XKDefaultFontWithSize(14);
        receiverName.textColor = XKMainSchemeColor;
        receiverName.linkData = entity.receiver_Name;
        [strArray addObject:receiverName];
    }
    [str appendString:@":"];
    [str appendString:entity.replyContent];
    
    TYTextStorage *content = [[TYTextStorage alloc] init];
    content.font = XKDefaultFontWithSize(14);
    content.textColor = colorSecondary_333333;
    content.range = [str rangeOfString:entity.replyContent];
    [strArray addObject:content];
    
    self.text = str;
    
    [self addTextStorageArray:strArray];
//    self.frame = CGRectMake(10, 0, XKAppWidth - 70 - 15 - 15, 0);
    [self sizeToFit];
  
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
