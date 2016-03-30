//
//  singleLineView.m
//  XKNewUserQuestionireResult
//
//  Created by 忘、 on 14-7-14.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

#import "singleLineView.h"

@implementation singleLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(UIView*)createLineViewWithRect:(CGRect)rect
{
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:rect];
    imageView.image=[UIImage imageNamed:@"space"];
    return imageView;
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
