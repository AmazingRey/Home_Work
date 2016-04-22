//
//  XKRWRecordMore5_3View.m
//  XKRW
//
//  Created by ss on 16/4/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordMore5_3View.h"

@implementation XKRWRecordMore5_3View
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordMore5_3View");
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void)setType:(energyType)type{
    if (_type != type) {
        _type = type;
    }
    switch (type) {
        case 1:
            _btnChange.titleLabel.text = @"调整四餐比例";
            _btnSet.titleLabel.text = @"设置饮食提醒";
            break;
        case 2:
            
            [_btnChange setTitle:@"" forState:UIControlStateNormal];
            [_btnSet setTitle:@"设置饮食提醒" forState:UIControlStateNormal];
            
            _btnChange.titleLabel.text = @"";
            _btnSet.titleLabel.text = @"设置饮食提醒";
            break;
        case 3:
            [_btnChange setTitle:@"重新测评习惯" forState:UIControlStateNormal];
            [_btnSet setTitle:@"设置习惯提醒" forState:UIControlStateNormal];
            _btnChange.titleLabel.text = @"重新测评习惯";
            _btnSet.titleLabel.text = @"设置习惯提醒";
            break;
        default:
            break;
    }
}

- (IBAction)actChange:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressChangeEatPercent)]) {
        [self.delegate pressChangeEatPercent];
    }
}

- (IBAction)actSet:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressSetEatNotify)]) {
        [self.delegate pressSetEatNotify];
    }
}
@end
