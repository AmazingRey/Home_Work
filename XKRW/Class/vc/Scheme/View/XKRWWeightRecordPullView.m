//
//  XKRWWeightRecordPullView.m
//  XKRW
//
//  Created by ss on 16/4/6.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWWeightRecordPullView.h"

@implementation XKRWWeightRecordPullView
@synthesize btnWeight,btnContain,btnGraph;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imgArrowWidth = 10 *frame.size.width/132;
        CGFloat imgArrowHeight = 5 *frame.size.height/132;
        CGFloat imgArrowX = 107 *frame.size.width/132;
        CGRect childFrame = CGRectMake(0, imgArrowHeight-1, frame.size.width, frame.size.height - imgArrowHeight);
        CGFloat btnHeight = (childFrame.size.height-2)/3;
        CGFloat labSpace = 15 *frame.size.width/132;
        
        _childrenView = [[UIView alloc] initWithFrame:childFrame];
        _childrenView.layer.borderWidth = 0.5;
        _childrenView.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
        _childrenView.layer.cornerRadius = 5;
        _childrenView.backgroundColor = [UIColor colorFromHexString:@"f0f0f0"];
        _childrenView.clipsToBounds = YES;
        
        [self addSubview:_childrenView];
        
        _imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(imgArrowX, 0, imgArrowWidth, imgArrowHeight)];
        _imgArrow.image = [UIImage imageNamed:@"triangle5_3"];
        _imgArrow.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgArrow];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, 0, childFrame.size.width, btnHeight)];
        [btn1 setTitle:@"记录体重" forState:UIControlStateNormal];
        [btn1 setTitleColor:colorSecondary_333333 forState:UIControlStateNormal];
        [btn1 setTitleColor:colorSecondary_333333 forState:UIControlStateHighlighted];
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1 setImage:[UIImage imageNamed:@"weight5_3"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"f0f0f0"]] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"#e4e4e4"]] forState:UIControlStateHighlighted];
        
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
        
        [btn1 addTarget:self action:@selector(actWeight:) forControlEvents:UIControlEventTouchUpInside];
        
        [_childrenView addSubview:btn1];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(labSpace, btnHeight, childFrame.size.width - 2*labSpace, .5)];
        lab1.backgroundColor = XKSepDefaultColor;
        [_childrenView addSubview:lab1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake(0, btnHeight+.5, childFrame.size.width, btnHeight)];
        [btn2 setTitle:@"记录围度" forState:UIControlStateNormal];
        [btn2 setTitleColor:colorSecondary_333333 forState:UIControlStateNormal];
        [btn2 setTitleColor:colorSecondary_333333 forState:UIControlStateHighlighted];
        
        [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn2 setImage:[UIImage imageNamed:@"girth5_3"] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"f0f0f0"]] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"#e4e4e4"]] forState:UIControlStateHighlighted];
        
        [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
        
        [btn2 addTarget:self action:@selector(actContain:) forControlEvents:UIControlEventTouchUpInside];
        
        [_childrenView addSubview:btn2];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(labSpace, btnHeight*2+.5, childFrame.size.width - 2*labSpace, .5)];
        lab2.backgroundColor = XKSepDefaultColor;
        [_childrenView addSubview:lab2];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setFrame:CGRectMake(0, btnHeight*2+1, childFrame.size.width, btnHeight+.5)];
        btn3.backgroundColor = [UIColor clearColor];
        [btn3 setTitle:@"查看曲线" forState:UIControlStateNormal];
        [btn3 setTitleColor:colorSecondary_333333 forState:UIControlStateNormal];
        [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
        btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn3 setImage:[UIImage imageNamed:@"curve5_3"] forState:UIControlStateNormal];
        [btn3 setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
        [btn3 setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"f0f0f0"]] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage createImageWithColor:[UIColor colorFromHexString:@"#e4e4e4"]] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(actGraph:) forControlEvents:UIControlEventTouchUpInside];
        
        [_childrenView addSubview:btn3];
        
    }
    return self;
}

- (IBAction)actWeight:(id)sender {
    [self pressBtnWithType:0];
}

- (IBAction)actContain:(id)sender {
    [self pressBtnWithType:1];
}

- (IBAction)actGraph:(id)sender {
    [self pressBtnWithType:2];
}

-(void)pressBtnWithType:(PullViewBtnType)type{
    if ([self.delegate respondsToSelector:@selector(pressPullViewButtonWithType:)]) {
        [self.delegate pressPullViewButtonWithType:type];
    }
}
@end
