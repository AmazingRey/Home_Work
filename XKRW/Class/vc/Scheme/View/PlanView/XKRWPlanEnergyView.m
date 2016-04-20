//
//  XKRWPlanEnergyView.m
//  XKRW
//
//  Created by Shoushou on 16/4/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanEnergyView.h"
#import "XKRWFlashingTextView.h"

@interface XKRWPlanEnergyView()

@property (nonatomic, strong) UIButton *titleClickButton;

@end

@implementation XKRWPlanEnergyView
{
    XKRWEnergyCircleView *_exClickedCircle;
    XKRWFlashingTextView *_remindTextView;
    UILabel *_checkTodayAnalyze;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CGFloat circleWidth = 95*(XKAppWidth/320.0);
    CGFloat separateWidth = (XKAppWidth - circleWidth * 3) / 4.0;
    if (self) {
        
        _remindTextView = [[XKRWFlashingTextView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 12)];
        _remindTextView.foreColor = [UIColor colorFromHexString:@"000000"];
        _remindTextView.backColor = [UIColor colorFromHexString:@"c7c7c7"];
        _remindTextView.font = XKDefaultFontWithSize(12);
        _remindTextView.alignment = NSTextAlignmentCenter;
        _remindTextView.center = CGPointMake(XKAppWidth/2.0, 34);
        [self addSubview:_remindTextView];
        [_remindTextView textFlashingWithDuration:1.5];
        
        _titleClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleClickButton.frame = _remindTextView.frame;
        [_titleClickButton setBackgroundImage:[UIImage createImageWithColor:colorSecondary_000000_02] forState:UIControlStateHighlighted];
        [_titleClickButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_titleClickButton aboveSubview:_remindTextView];
        
        _eatEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(separateWidth, 68, circleWidth, circleWidth) Style: XKRWEnergyCircleStyleNotOpen];
        _eatEnergyCircle.tag = 1;
        [self addSubview:_eatEnergyCircle];
        
        
        _sportEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(_eatEnergyCircle.right + separateWidth, _eatEnergyCircle.top, circleWidth, circleWidth) Style:XKRWEnergyCircleStyleNotOpen];
        _sportEnergyCircle.tag = 2;
        [self addSubview:_sportEnergyCircle];
        
        
        _habitEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(_sportEnergyCircle.right + separateWidth, _sportEnergyCircle.top, circleWidth, circleWidth) Style: XKRWEnergyCircleStyleNotOpen];
        _habitEnergyCircle.tag = 3;
        [self addSubview:_habitEnergyCircle];
        
        NSArray *titles = @[@"饮食",@"运动",@"习惯"];
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XK_ASSIST_TEXT_COLOR;
            label.font = XKDefaultFontWithSize(14);
            label.text = titles[i];
            [label sizeToFit];
            label.center = CGPointMake(separateWidth *(i + 1) + circleWidth*(i*2 + 1)/2.0, _eatEnergyCircle.bottom + 34);
            [self addSubview:label];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title isflashing:(BOOL)isflashing {
    _remindTextView.text = title;
    if (isflashing) {
        _remindTextView.backColor = [UIColor colorFromHexString:@"c7c7c7"];
        [_remindTextView startFlash];
        [_titleClickButton removeFromSuperview];
        
    } else {
        _remindTextView.backColor = XKMainSchemeColor;
        [_remindTextView endFlash];
        [self insertSubview:_titleClickButton aboveSubview:_remindTextView];
    }
}

- (void)titleButtonClicked {
    if (self.delegate && [_delegate respondsToSelector:@selector(energyCircleViewTitleClicked:)]) {
        [_delegate energyCircleViewTitleClicked:_remindTextView.text];
    }
}
#pragma mark -- reset meals、sports and habits' current number
- (void)runEatEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    CGFloat percentage = (currentNumber / (CGFloat)_eatEnergyCircle.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_eatEnergyCircle.goalNumber);
    [_eatEnergyCircle runProgressCircleWithColor:_eatEnergyCircle.shadowColor percentage:percentage duration:1.5 * percentage];
    [_eatEnergyCircle runToCurrentNum:currentNumber duration:1.5 * percentage];
}

- (void)runSportEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    CGFloat percentage = (currentNumber / (CGFloat)_sportEnergyCircle.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_sportEnergyCircle.goalNumber);
    [_sportEnergyCircle runProgressCircleWithColor:_sportEnergyCircle.shadowColor percentage:percentage duration:1.5 * percentage];
    [_sportEnergyCircle runToCurrentNum:currentNumber duration:1.5 * percentage];
}

- (void)runHabitEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    CGFloat percentage = (currentNumber / (CGFloat)_habitEnergyCircle.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_habitEnergyCircle.goalNumber);
    [_habitEnergyCircle runProgressCircleWithColor:_habitEnergyCircle.shadowColor percentage:percentage duration:1.5 * percentage];
    [_habitEnergyCircle runToCurrentNum:currentNumber duration:1.5 * percentage];
}

#pragma mark -- set meals、sports and habits' original state data
- (void)noneSelectedCircleStyle {
    [_exClickedCircle setStyle:XKRWEnergyCircleStyleOpened];
}
- (void)setEatEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    __weak typeof(self) weakSelf = self;
    
    BOOL isBehaveCurrect = NO;
    if (currentNumber <= goalNumber) {
        isBehaveCurrect = YES;
    } else {
        isBehaveCurrect = NO;
    }
    [_eatEnergyCircle setOpenedViewTiltle:@"已摄入" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"kcal" isBehaveCurrect:isBehaveCurrect];
    _eatEnergyCircle.energyCircleViewClickBlock = ^(){
        [weakSelf resetCirclesStyle];
        
        [weakSelf runEatEnergyCircleWithNewCurrentNumber:currentNumber];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.eatEnergyCircle runToNextNumber:1200 duration:1.5 resetIsBehaveCurrect:YES];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.eatEnergyCircle runToNextNumber:2000 duration:1.5 resetIsBehaveCurrect:NO];
        });
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {

            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:1];
        }
        _selectedIndex = 1;
        _exClickedCircle = _eatEnergyCircle;
    };
 
}

- (void)setSportEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    __weak typeof(self) weakSelf = self;
    
    BOOL isBehaveCurrect = NO;
    if (currentNumber >= goalNumber) {
        isBehaveCurrect = YES;
    } else {
        isBehaveCurrect = NO;
    }
    [_sportEnergyCircle setOpenedViewTiltle:@"已消耗" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"kcal" isBehaveCurrect:isBehaveCurrect];
    
    _sportEnergyCircle.energyCircleViewClickBlock = ^(){
        [weakSelf resetCirclesStyle];
        
        [weakSelf runSportEnergyCircleWithNewCurrentNumber:currentNumber];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {

            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:2];
        }
        _selectedIndex = 2;
        _exClickedCircle = _sportEnergyCircle;
    };
}

- (void)setHabitEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    __weak typeof(self) weakSelf = self;
    
    BOOL isBehaveCurrect = NO;
    if (currentNumber == goalNumber) {
        isBehaveCurrect = YES;
    } else {
        isBehaveCurrect = NO;
    }
    [_habitEnergyCircle setOpenedViewTiltle:@"已改正" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"个" isBehaveCurrect:isBehaveCurrect];

    _habitEnergyCircle.energyCircleViewClickBlock = ^(){
        [weakSelf resetCirclesStyle];
        
        [weakSelf runHabitEnergyCircleWithNewCurrentNumber:currentNumber];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {

            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:3];
        }
        _selectedIndex = 3;
        _exClickedCircle = _habitEnergyCircle;
    };
}
- (void)resetCirclesStyle {
    
    if (_exClickedCircle) {
        _exClickedCircle.style = XKRWEnergyCircleStyleOpened;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
