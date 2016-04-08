//
//  XKRWIntelligentListEnterCell.m
//  XKRW
//
//  Created by Shoushou on 16/1/12.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWIntelligentListEnterCell.h"
#import "UIImageView+WebCache.h"

@implementation XKRWIntelligentListEnterCell
{
    IBOutlet UIImageView *_icon1;
    IBOutlet UIImageView *_icon2;
    IBOutlet UIImageView *_icon3;
    IBOutlet UIImageView *_newImageView;
    NSString *_key;
    NSUserDefaults *_userDefault;
}

- (void)setContentWithArray:(NSArray <XKRWIntelligentListEntity *> *)array {
    NSArray *iconArray = @[_icon1,_icon2,_icon3];
    int count = iconArray.count >= array.count ? (int)array.count : 3;
    for (int i = 0; i < count; i++) {
        [iconArray[i] setImageWithURL:[NSURL URLWithString:[array[i] iconUrl]] placeholderImage:[UIImage imageNamed:@"lead_nor"] options:SDWebImageRetryFailed];
    }
    
    _icon1.layer.borderColor = [UIColor whiteColor].CGColor;
    _icon2.layer.borderColor = [UIColor whiteColor].CGColor;
    _icon3.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)IntelligentListIsNew:(NSString *)week_start {
    _userDefault = [NSUserDefaults standardUserDefaults];
    _key = [NSString stringWithFormat:@"XKRWIntelligentListEnter_%li_%@",(long)[XKRWUserDefaultService getCurrentUserId],week_start];
    if ([_userDefault boolForKey:_key]) {
        _newImageView.hidden = YES;
    } else {
        _newImageView.hidden = NO;
    }
}

- (void)XKRWIntelligentListEnterCellClicked {
    [_userDefault setBool:YES forKey:_key];
    [_userDefault synchronize];
}

- (void)awakeFromNib {
    // Initialization code
    _newImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
