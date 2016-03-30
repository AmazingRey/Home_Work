//
//  SCBackToUpView.m
//  XKRW
//
//  Created by Seth Chen on 15/12/10.
//  Copyright © 2015年 xikang. All rights reserved.
//

#import "SCBackToUpView.h"

#define SCREEN_WIDTH_ [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT_ [UIScreen mainScreen].bounds.size.height
#define MARGIN (1)*SCREEN_HEIGHT_ //设定阀值为1.5个屏幕高

@interface SCBackToUpView ()<UIScrollViewDelegate>
{
    UIImage   *_buttonImage;
}

@end

@implementation SCBackToUpView

- (instancetype)initShowInSomeViewSize:(CGSize)rect
                               minitor:(UIScrollView *)minitor
                             withImage:(NSString *)optionImage
{
    
    _buttonImage = [UIImage imageNamed:optionImage];
    CGRect frame = (CGRect){(rect.width - _buttonImage.size.width - 15),(rect.height - _buttonImage.size.width - 64 -15),_buttonImage.size.width,_buttonImage.size.height};
    self = [super initWithFrame:frame];
    if (self) {
        self.backOffsettY = MARGIN;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backToupButton];
        [self setEvent];
        self.minitorScrollView = minitor;
        self.hidden = YES;
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat py = scrollView.contentOffset.y;
    if (py >= _backOffsettY) {
        if(self.hidden)
            self.hidden = NO;
    }else
    {
        if(!self.hidden)
            self.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat py = scrollView.contentOffset.y;
    if (py >= _backOffsettY) {
        if(self.hidden)
            self.hidden = NO;
    }else
    {
        if(!self.hidden)
            self.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat py = scrollView.contentOffset.y;
    if (py >= _backOffsettY) {
        if(self.hidden)
            self.hidden = NO;
    }else
    {
        if(!self.hidden)
            self.hidden = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat py = scrollView.contentOffset.y;
    if (py >= _backOffsettY) {
        if(self.hidden)
            self.hidden = NO;
    }else
    {
        if(!self.hidden)
            self.hidden = YES;
    }
}

/**<event*/
- (void)setEvent
{
    [self.backToupButton addTarget:self
                            action:@selector(backToUp:)
                  forControlEvents:UIControlEventTouchUpInside];
}

/**<response*/
- (void)backToUp:(UIButton *)sender
{
    if (self.minitorScrollView) {
        [self.minitorScrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH_, SCREEN_HEIGHT_)
                                           animated:YES];
    }
}

/**<getter*/
- (UIButton *)backToupButton
{
    if (!_backToupButton) {
        _backToupButton = [[UIButton alloc]initWithFrame:self.bounds];
        [_backToupButton setImage:_buttonImage forState:UIControlStateNormal];
        _backToupButton.showsTouchWhenHighlighted = YES;
    }
    return _backToupButton;
}

- (void)setBackOffsettY:(CGFloat)backOffsettY
{
    _backOffsettY = backOffsettY;
}

@end
