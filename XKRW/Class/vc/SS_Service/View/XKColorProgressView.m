//
//  XKColorProgressView.m
//  XKRW
//
//  Created by y on 15-1-28.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKColorProgressView.h"

@implementation XKColorProgressView

-(id)initWithFrame:(CGRect)frame initwithColorProgressWidth:(CGFloat)weight andColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGB(231, 231, 231, 1);
    
        self.layer.masksToBounds = YES ;
        self.layer.cornerRadius = 4 ;
        
        if (weight >= frame.size.width) {
            weight = frame.size.width;
        }
        _colorlayer = [CALayer layer];
        _colorlayer.frame = CGRectMake(0, 0, weight,self.frame.size.height);
        _colorlayer.cornerRadius = 4;
        _colorlayer.masksToBounds = YES ;
        
        _colorlayer.backgroundColor = [color CGColor];
        [self.layer addSublayer:_colorlayer];
        
        
       self.SpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 100,0 , 90, self.frame.size.height)];
        self.SpeedLabel.backgroundColor = [UIColor clearColor];
        self.SpeedLabel.textAlignment = NSTextAlignmentLeft;
        self.SpeedLabel.textColor = RGB(0, 204, 178, 1);
        self.SpeedLabel.font = XKDefaultFontWithSize(10);
        [self addSubview:self.SpeedLabel];
        
        
        self.SpeedLabel.hidden  = YES ;
    }
    
    
    return  self;
}

-(void)setSpeedlabelHide:(BOOL)yesOrNo
{
    self.SpeedLabel.hidden = yesOrNo;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
