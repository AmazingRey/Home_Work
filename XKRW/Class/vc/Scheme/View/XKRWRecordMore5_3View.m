//
//  XKRWRecordMore5_3View.m
//  XKRW
//
//  Created by ss on 16/4/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWRecordMore5_3View.h"

@implementation XKRWRecordMore5_3View
{
    
    IBOutlet UIView *backgroundView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWRecordMore5_3View");
        backgroundView.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
        [_btnChange setBackgroundImage:[UIImage createImageWithColor:colorSecondary_f0f0f0] forState:UIControlStateHighlighted];
        [_btnSet setBackgroundImage:[UIImage createImageWithColor:colorSecondary_f0f0f0] forState:UIControlStateHighlighted];
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

//按钮一
- (IBAction)actChange:(id)sender {
    //调整四餐比例
    if ([self.delegate respondsToSelector:@selector(pressTip_1WithIndex:)]) {
        [self.delegate pressTip_1WithIndex:_type];
    }
}

//按钮二
- (IBAction)actSet:(id)sender {
    //设置饮食提醒
    if ([self.delegate respondsToSelector:@selector(pressSetNotifyWithIndex:)]) {
        [self.delegate pressSetNotifyWithIndex:_type];
    }
}
@end
