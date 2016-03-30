//
//  XKRWStarView.m
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWStarView.h"

@implementation XKRWStarView
@synthesize starBtnArr;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame withColorCount:(NSInteger)count isEnable:(BOOL) enable isUserComment:(BOOL)allComment
{
    self = [super initWithFrame:frame];
    if (self)
    {
        starBtnArr = [[NSMutableArray alloc]init];
        for (int i= 0 ; i< 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (allComment) {
                [btn setBackgroundImage:[UIImage imageNamed:@"starS_02_"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"starS_01_"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"starS_01_"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(20*i, (20-14)/2, 14, 14);
        
            }else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"star_02_"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"star_01_"] forState:UIControlStateSelected];
                btn.frame = CGRectMake(30*i, 0, 20, 20);
            }
            if (i < count) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
            
            btn.tag = i+1 ;
            [starBtnArr addObject:btn];
            if (enable) {
                 [btn addTarget:self action:@selector(getStar:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)setCount:(NSInteger)count
{
    self.count = count ;
    
    for (int i = 0 ; i< count; i++) {
        UIButton *btn = [starBtnArr objectAtIndex:i];
        btn.selected = YES ;
    }

    
}

-(void)getStar:(UIButton*)btn
{
    
   // XKLog(@"%d",btn.tag);
    
    btn.selected =  !btn.selected ;
    
    NSInteger startCount = 0 ;
    if (btn.selected ) {
        
        [self resetStarState];
        for(int i = 0 ; i <= btn.tag - 1; i ++)
        {
            [starBtnArr[i] setSelected:YES];
        }
        startCount = btn.tag  ;
    }
    else
    {
        NSInteger currtTag  = btn.tag- 2  ;
        if (currtTag < 0) {
            currtTag = 0 ;
            startCount = currtTag ;
              [self resetStarState];
        }
        else
        {
            [self resetStarState];
            for(int i = 0 ; i <= currtTag; i ++)
            {
                [starBtnArr[i] setSelected:YES];
                
            }
            
            startCount = currtTag+1 ;
        }
        
    }
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(getStarCount:)]) {
        [_delegate getStarCount:startCount];
    }
    
}

-(void)resetStarState
{
    for (int i = 0 ; i < starBtnArr.count; i++)
    {
        [starBtnArr[i] setSelected:NO];
    }
}

-(void)loadStarCount:(NSInteger)count
{
    for (int i = 0 ; i< count; i++) {
        UIButton *btn = [starBtnArr objectAtIndex:i];
        btn.selected = YES ;
        [starBtnArr replaceObjectAtIndex:i withObject:btn];
    }

}

- (void)closeUserInterFaced
{
    self.userInteractionEnabled = NO ; 
}


@end
