//
//  XKRWBlogEnterCell.m
//  XKRW
//
//  Created by Shoushou on 16/1/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWBlogEnterCell.h"
#import "XKRW-Swift.h"

@implementation XKRWBlogEnterCell
{
    __weak IBOutlet UIButton *_coverButton;
    IBOutlet UILabel *_tipLabel;
    
    IBOutlet UILabel *_titleLabel;
}
- (void)setContentWithEntity:(XKRWArticleListEntity *)entity {
    _titleLabel.text = entity.title;
    
    if (!entity.coverEnabled) {
  
        [_coverButton setBackgroundImage:[UIImage imageNamed:@"share_cover_verify"] forState:UIControlStateNormal];
        
    } else if (entity.coverImageUrl != nil && entity.coverImageUrl.length > 0) {
        
        if ([XKRWUtil pathIsNative:entity.coverImageUrl]) {
            [_coverButton setBackgroundImage:[UIImage imageWithContentsOfFile:entity.coverImageUrl]forState:UIControlStateNormal];
            
        } else {
            NSString *url = [NSString stringWithFormat:@"%@%@", entity.coverImageUrl, kCoverThumb];

            [_coverButton setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"share_cover_placeholder"]];
        }
    } else if (entity.coverImageUrl == nil || entity.coverImageUrl.length == 0) {
        [_coverButton setBackgroundImage:[UIImage imageNamed:@"share_cover_placeholder"] forState:UIControlStateNormal];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)coverButtonAction:(UIButton *)sender {
    _islimShareActionBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
