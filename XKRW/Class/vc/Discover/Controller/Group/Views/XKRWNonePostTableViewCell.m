
//
//  XKRWNonePostTableViewCell.m
//  XKRW
//
//  Created by Seth Chen on 16/1/27.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWNonePostTableViewCell.h"

@interface XKRWNonePostTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end

@implementation XKRWNonePostTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setIsNoneData:(BOOL)isNoneData
{
    _isNoneData = isNoneData;
    [self refreshStatu];
}

- (void)refreshStatu
{
    if (_isNoneData) {
        self.contentLabel.text = @"噢，你来早了，暂时还没有内容";
        self.refreshButton.hidden = YES;
    }else{
        self.contentLabel.text = @"服务器开小差，内容消失啦！";
        self.refreshButton.hidden = NO;
    }
}

- (IBAction)refreshButtonClick:(id)sender {
    if (self.handle) {
        self.handle();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
