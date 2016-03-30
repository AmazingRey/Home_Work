//
//  XKRWCommentEtity.m
//  XKRW
//
//  Created by Shoushou on 15/9/29.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWCommentEtity.h"
#import "XKRWReplyView.h"

@implementation XKRWCommentEtity


- (void)calculateCommentStrHeight
{
    if (!self.commentStr) {
        _commentHeight = 0;
        return;
    }
    NSMutableAttributedString *commentStr = [XKRWUtil createAttributeStringWithString:self.commentStr font:XKDefaultFontWithSize(14) color:colorSecondary_666666 lineSpacing:3.5 alignment:NSTextAlignmentLeft];
    CGSize commetLabelSize = [commentStr boundingRectWithSize:CGSizeMake(XKAppWidth-70-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    XKRWReplyView *view = [[XKRWReplyView alloc] initWithDataArray:self.sub_Array];
    _mainCommentHeight = commetLabelSize.height;
    _commentHeight = _mainCommentHeight + view.height;
}

- (void)calculateTimeShowStr
{

    _timeShowStr = [XKRWUtil calculateTimeShowStr:self.time];
    
}

@end
