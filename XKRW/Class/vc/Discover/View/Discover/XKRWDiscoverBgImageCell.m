//
//  XKRWDiscoverBgImageCell.m
//  XKRW
//
//  Created by Shoushou on 15/11/10.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "XKRWDiscoverBgImageCell.h"
#import "XKRWUtil.h"
#import "UIImageView+WebCache.h"

@implementation XKRWDiscoverBgImageCell
{
    IBOutlet UIImageView *_coverImageView;
    IBOutlet UILabel *_title;

    IBOutlet UILabel *_timeLabel;
    
    IBOutlet UILabel *_readNumLabel;
    IBOutlet UIImageView *_starImage;
    
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setContentWithDiscoverBgImageEntity:(XKRWManagementEntity5_0 *)discoverBgImageEntity {
    if (discoverBgImageEntity != nil) {
        _discoverBgImageEntity = discoverBgImageEntity;
        if (discoverBgImageEntity.content != nil && ![discoverBgImageEntity.content isKindOfClass:[NSNull class]]) {
            if (discoverBgImageEntity.content[@"title"] == nil) {
                [discoverBgImageEntity.content setValue:@"" forKey:@"title"];
            }
            _title.attributedText = [XKRWUtil createAttributeStringWithString:discoverBgImageEntity.content[@"title"] font:XKDefaultFontWithSize(17) color:[UIColor whiteColor] lineSpacing:8.5 alignment:NSTextAlignmentLeft];
            _timeLabel.text = discoverBgImageEntity.content[@"date"];
        }
       
        if (discoverBgImageEntity.category != eOperationEncourage && discoverBgImageEntity.category != eOperationSport && discoverBgImageEntity.category != eOperationKnowledge) {
            _starImage.hidden = YES;
        } else {
            _starImage.hidden = NO;
        }
      
        if (discoverBgImageEntity.complete) {
            [_starImage setImage:[UIImage imageNamed:@"discover_star"]];
        } else {
            [_starImage setImage:[UIImage imageNamed:@"discover_star_hightlighted"]];
        }
        
        if (discoverBgImageEntity.readNum == nil) {
            _readNumLabel.text = @"0";
            
        } else if ([discoverBgImageEntity.readNum intValue] >= 10000) {
            _readNumLabel.text = [NSString stringWithFormat:@"%d 万+",[discoverBgImageEntity.readNum intValue]/10000];

        } else {
            _readNumLabel.text = discoverBgImageEntity.readNum;
        }
        
        [_coverImageView setImageWithURL:[NSURL URLWithString:discoverBgImageEntity.bigImage]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
