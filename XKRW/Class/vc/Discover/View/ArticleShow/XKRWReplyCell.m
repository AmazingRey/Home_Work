//
//  XKRWReplyCell.m
//  XKRW
//
//  Created by Shoushou on 15/12/15.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWReplyCell.h"

@implementation XKRWReplyCell
{
    UILongPressGestureRecognizer *_longPressGuesture;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = XKClearColor;
        
        _label = [[XKRWReplyLabel alloc] init];
        _label.highlightedLinkBackgroundColor = colorSecondary_c7c7c7;
        _longPressGuesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed)];
        [self addGestureRecognizer:_longPressGuesture];
        _label.delegate = self;
        [self.contentView addSubview:_label];
    }
    
    return self;
}

- (void)setEntity:(XKRWReplyEntity *)entity {
    _entity = entity;
    _label.entity = entity;
    self.size = _label.size;
}

- (void)longPressed {
    typeof(self) __weak weakSelf = self;
    if (self.delegate) {
        [_delegate replyCell:weakSelf longPressedWithIndexPath:_replyCellIndexPath];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    self.backgroundColor = colorSecondary_c7c7c7;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    self.backgroundColor = XKClearColor;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = XKClearColor;
}

#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point {
    XKLog(@"replyView%@",((TYLinkTextStorage *)textStorage).linkData);
    if (self.nickNameBlock) {
        _nickNameBlock(((TYLinkTextStorage *)textStorage).linkData);
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
