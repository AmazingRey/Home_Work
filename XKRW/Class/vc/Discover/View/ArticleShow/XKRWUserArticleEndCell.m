//
//  XKRWUserArticleEndCell.m
//  XKRW
//
//  Created by Klein Mioke on 15/10/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWUserArticleEndCell.h"

@implementation XKRWUserArticleEndCell
{
    
    IBOutlet UIButton *_topicButton;
}

- (void)awakeFromNib {
    // Initialization code
    [_topicButton setBackgroundImage:[UIImage createImageWithColor:colorSecondary_000000_02] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickTopicAction:(id)sender {
 
    if (self.clickTopicAction) {
        self.clickTopicAction();
    }
}

@end
