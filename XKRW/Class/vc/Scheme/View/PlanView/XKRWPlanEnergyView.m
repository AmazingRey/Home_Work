//
//  XKRWPlanEnergyView.m
//  XKRW
//
//  Created by Shoushou on 16/4/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanEnergyView.h"
#import "XKRWEnergyCircleView.h"

@interface XKRWPlanEnergyView()
@property (nonatomic, strong) XKRWEnergyCircleView *eatEnergyCircle;
@property (nonatomic, strong) XKRWEnergyCircleView *sportEnergyCircle;
@property (nonatomic, strong) XKRWEnergyCircleView *habitEnergyCircle;

@end

@implementation XKRWPlanEnergyView
{
    XKRWEnergyCircleView *_exClickedCircle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CGFloat circleWidth = 95*(XKAppWidth/320.0);
    CGFloat separateWidth = (XKAppWidth - circleWidth * 3) / 4.0;
    if (self) {
        
        _eatEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(separateWidth, 0, circleWidth, circleWidth) Style:XKRWEnergyCircleStyleNotOpen];
        _eatEnergyCircle.tag = 1;
        [self addSubview:_eatEnergyCircle];
        
        
        _sportEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(_eatEnergyCircle.right + separateWidth, 0, circleWidth, circleWidth) Style:XKRWEnergyCircleStyleNotOpen];
        _sportEnergyCircle.tag = 2;
        [self addSubview:_sportEnergyCircle];
        
        
        _habitEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(_sportEnergyCircle.right + separateWidth, 0, circleWidth, circleWidth) Style:XKRWEnergyCircleStyleNotOpen];
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
        
        if ([weakSelf respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
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
        
        if ([weakSelf respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:1];
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
        
        if ([weakSelf respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:1];
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
