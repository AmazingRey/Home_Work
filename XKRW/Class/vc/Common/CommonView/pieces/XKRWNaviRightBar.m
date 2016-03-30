//
//  XKRWNaviRightBar.m
//  XKRW
//
//  Created by zhanaofan on 14-2-16.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWNaviRightBar.h"

@implementation XKRWNaviRightBar

-(id) initWithFrameAndTitle:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self  setTitleColor:XKBtnSelectedColor forState:UIControlStateHighlighted];
        float version = XKSystemVersion;
        if (version >= 7.0f) {
            self.titleLabel.font = XKDefaultFontWithSize(14.f);
        }else{
            self.titleLabel.font =  [UIFont systemFontOfSize:14];
        }
        //[UIFont fontWithName:@"Heiti SC" size:14.f];// XKDefaultFontWithSize(14.f);
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
