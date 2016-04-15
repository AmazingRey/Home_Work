//
//  XKRWPlanTipsCell.m
//  XKRW
//
//  Created by 忘、 on 16/4/15.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanTipsCell.h"
#import "Masonry.h"
@implementation XKRWPlanTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    
    return self;
}

- (void) initView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageName]];
    imageView.frame = CGRectMake(15 + 16/2, 10 + 32, 16, 16);
    [self.contentView addSubview:imageView];
    
    UIView *upLineView = [[UIView alloc] init];
    upLineView.backgroundColor = XK_ASSIST_LINE_COLOR;
    
    [upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
