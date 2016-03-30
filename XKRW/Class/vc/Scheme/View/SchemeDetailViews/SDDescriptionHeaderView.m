//
//  SDDescriptionHeaderView.m
//  XKRW
//
//  Created by Klein Mioke on 15/8/13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "SDDescriptionHeaderView.h"
#import "XKRW-Swift.h"

@implementation SDDescriptionHeaderView
{
    __weak IBOutlet UIView *_contentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (SDDescriptionHeaderView *)instanceView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SDDescriptionHeaderView" owner:nil options:nil].firstObject;
}

- (void)setContentWithEntity:(XKRWSchemeEntity_5_0 *)entity {

    self.title.text = entity.schemeName;
    self.detail.text = entity.detail;
    
    _contentView.layer.shadowOffset = CGSizeMake(0, 2);
    _contentView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _contentView.layer.shadowOpacity = 0.2;
    _contentView.layer.shadowRadius = 2;
}

@end
