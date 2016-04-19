//
//  XKRWShowEnergy_5_3View.m
//  XKRW
//
//  Created by ss on 16/4/8.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWShowEnergy_5_3View.h"
#import "XKRWAlgolHelper.h"

@implementation XKRWShowEnergy_5_3View
{
    NSNumber *eatNum1;
    NSNumber *eatNum2;
    NSNumber *eatNum3;
    NSNumber *sportNum1;
    NSNumber *sportNum2;
    
    dispatch_source_t _timer;
    double secondsToFire;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWPlan_5_3View");
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect frame = self.frame;
        _dicAll = [NSMutableDictionary dictionary];
        
        _firstCircleView = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(frame.origin.x + frame.size.width/2 - 50, frame.origin.y - 100, 100, 100) Style:XKRWEnergyCircleStyleSelected];
     
        _firstCircleView.tag = 1;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        _label.text = @"达标";
        CGPoint p = CGPointMake(_firstCircleView.center.x, _firstCircleView.center.y+60);
        _label.center = p;
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_firstCircleView];
        [self addSubview:_label];
    }
    return self;
}

-(void)setType:(enum PlanType)type{
    if (_type != type) {
        _type = type;
    }
    [self initTimerData];
}

-(void)initTimerData{
    if (!_timer && _type == Food) {
        NSRange rangeEat = [XKRWAlgolHelper getDailyIntakeRange];
        eatNum1 = [NSNumber numberWithInteger:rangeEat.location - 1];
        eatNum2 = [NSNumber numberWithInteger:rangeEat.location+rangeEat.length - 1];
        eatNum3 = [NSNumber numberWithInteger:rangeEat.location+rangeEat.length + 1];
        
        [_dicAll setObject:@(NO) forKey:eatNum1];
        [_dicAll setObject:@(YES) forKey:eatNum2];
        [_dicAll setObject:@(NO) forKey:eatNum3];
        
        [self setEnergyCircleGoalNumber:rangeEat.location+rangeEat.length currentNumber:rangeEat.location+rangeEat.length];
    }
    if (!_timer && _type == Sport) {
        int sportNum =  [XKRWAlgolHelper dailyConsumeSportEnergy];
        sportNum1 = [NSNumber numberWithInt:sportNum - 1];
        sportNum2 = [NSNumber numberWithInt:sportNum + 1];
        [_dicAll setObject:@(NO) forKey:sportNum1];
        [_dicAll setObject:@(YES) forKey:sportNum2];
        
        [self setEnergyCircleGoalNumber:[XKRWAlgolHelper dailyIntakeRecomEnergy] currentNumber:sportNum];
    }
    [self runCircleView];
}

-(void)runCircleView{
    [self singleRunCircle];
    [self startTimer];
}

-(void)singleRunCircle{
    if (_type == Food) {
         secondsToFire = 15.000f;
        [_firstCircleView runToNextNumber:[eatNum1 integerValue] duration:2.0 resetIsBehaveCurrect:[[_dicAll objectForKey:eatNum1] boolValue]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_firstCircleView runToNextNumber:[eatNum2 integerValue] duration:1.0 resetIsBehaveCurrect:[[_dicAll objectForKey:eatNum2] boolValue]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_firstCircleView runToNextNumber:[eatNum3 integerValue] duration:.5 resetIsBehaveCurrect:[[_dicAll objectForKey:eatNum3] boolValue]];
            });
        });
    }else if (_type == Sport){
         secondsToFire = 10.000f;
        [_firstCircleView runToNextNumber:[sportNum1 integerValue] duration:2.0 resetIsBehaveCurrect:[[_dicAll objectForKey:sportNum1] boolValue]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_firstCircleView runToNextNumber:[sportNum2 integerValue] duration:1.0 resetIsBehaveCurrect:[[_dicAll objectForKey:sportNum2] boolValue]];
        });
    }
}

- (void)startTimer
{
    [self resetCirclesStyle];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        [self singleRunCircle];
    });
}

- (void)cancelTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (void)setEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    __weak typeof(self) weakSelf = self;
    
    BOOL isBehaveCurrect = NO;
    if (currentNumber <= goalNumber) {
        isBehaveCurrect = YES;
    } else {
        isBehaveCurrect = NO;
    }
    [_firstCircleView setOpenedViewTiltle:@"已摄入" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"kcal" isBehaveCurrect:isBehaveCurrect];
    _firstCircleView.energyCircleViewClickBlock = ^(){
        [weakSelf resetCirclesStyle];
        
        [weakSelf runEatEnergyCircleWithNewCurrentNumber:currentNumber];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
        }
    };
}

- (void)runEatEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    CGFloat percentage = (currentNumber / (CGFloat)_firstCircleView.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_firstCircleView.goalNumber);
    [_firstCircleView runProgressCircleWithColor:_firstCircleView.shadowColor percentage:percentage duration:1.5 * percentage];
    [_firstCircleView runToCurrentNum:currentNumber duration:1.5 * percentage];
}

- (void)resetCirclesStyle {
    if (_firstCircleView) {
        _firstCircleView.style = XKRWEnergyCircleStyleSelected;
    }
}
@end
