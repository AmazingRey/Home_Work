//
//  XKRWIntelligentListCell.m
//  XKRW
//
//  Created by Shoushou on 16/1/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWIntelligentListCell.h"
#import "UIImageView+WebCache.h"

@implementation XKRWIntelligentListCell
{
    IBOutlet UILabel *ranking;
    IBOutlet UIImageView *iconImageView;
    IBOutlet UIImageView *levelImageView;
    IBOutlet UILabel *nickName;
    IBOutlet UILabel *likeNum;
}

- (void)awakeFromNib {
    // Initialization code
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)setContentWithEntity:(XKRWIntelligentListEntity *)entity rankNum:(NSInteger)rankNum {
    
    if (rankNum == 0) {
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"ranking_1gold"] forState:UIControlStateNormal];
    } else if (rankNum == 1) {
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"ranking_2silver"] forState:UIControlStateNormal];
    } else if (rankNum == 2) {
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"ranking_3copper"] forState:UIControlStateNormal];
    } else {
        [_bgButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
    
    ranking.text = [NSString stringWithFormat:@"%d",(int)rankNum + 1];
    [iconImageView setImageWithURL:[NSURL URLWithString:entity.iconUrl] placeholderImage:[UIImage imageNamed:@"lead_nor"]options:SDWebImageRetryFailed];
    [levelImageView setImageWithURL:[NSURL URLWithString:entity.levelUrl]];
    nickName.text = entity.nickName;
    likeNum.text = [NSString stringWithFormat:@"%ld",(long)entity.beLikedNum];
}
- (IBAction)bgButtonClicked:(id)sender {
    if (self.cellClickBlock && [self respondsToSelector:@selector(cellClickBlock)]) {
        self.cellClickBlock(nickName.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
