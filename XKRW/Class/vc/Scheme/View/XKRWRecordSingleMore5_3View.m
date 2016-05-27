//
//  XKRWRecordSingleMore5_3View.m
//  XKRW
//
//  Created by ss on 16/4/21.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordSingleMore5_3View.h"

@implementation XKRWRecordSingleMore5_3View
{
    
    IBOutlet UIView *backgroundView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordSingleMore5_3View");
        self.frame = frame;
        backgroundView.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
        backgroundView.backgroundColor = [UIColor colorFromHexString:@"#e4e4e4"];
        [_btnSet setBackgroundImage:[UIImage createImageWithColor:colorSecondary_f0f0f0] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setType:(energyType)type {
    
    _type = type;
    _btnSet.tag = type;
    if (type == energyTypeSport) {
        [_btnSet setTitle:@"设置运动提醒" forState:UIControlStateNormal];
    } else if (type == energyTypeHabit){
        [_btnSet setTitle:@"设置习惯提醒" forState:UIControlStateNormal];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (IBAction)actSet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressSetSportNotifyWithType:)]) {
        [self.delegate pressSetSportNotifyWithType:[(UIButton *)sender tag]];
    }
}
@end
