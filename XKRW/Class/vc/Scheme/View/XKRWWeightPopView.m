//
//  XKRWWeightPopView.m
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWWeightPopView.h"
@implementation XKRWWeightPopView{
    BOOL isInit;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void)awakeFromNib{
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWWeightPopView");
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _arrLabels = @[@"体重",@"胸围",@"腰围",@"臀围"];
        isInit = YES;
        
        _iCarouselView.type = 11;
//        _iCarouselView.bounceDistance = 150;
//        _iCarouselView.contentOffset = CGSizeMake(-110, 0);
        _iCarouselView.perspective = -0.008;
        _iCarouselView.delegate = self;
        _iCarouselView.dataSource = self;
        _iCarouselView.bounces = YES;
        _iCarouselView.clipsToBounds = YES;
        _iCarouselView.scrollEnabled = YES;
        _iCarouselView.centerItemWhenSelected = YES;
        _iCarouselView.scrollToItemBoundary = NO;
        _iCarouselView.decelerationRate = 0.7;
        _iCarouselView.scrollSpeed = .5;
        _iCarouselView.currentItemIndex = 0;
        
        _recordDates = [[XKRWRecordService4_0 sharedService] getUserRecordDateFromDB];
        
        _calendar = [[XKRWCalendar alloc] initWithOrigin:CGPointMake(-50, 44) recordDateArray:_recordDates headerType:XKRWCalendarHeaderTypeSimple andResizeBlock:^{
            
        }];
        CGRect frame = _calendar.frame;
//        frame.size.width -= 100;
        _calendar.frame = frame;
        [_calendar addBackToTodayButtonInFooterView];
        _calendar.delegate = self;
        [_calendar reloadCalendar];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdateLabel)];
        _dateLabel.userInteractionEnabled = YES;
        [_dateLabel addGestureRecognizer:tapgesture];
        
        _selectedDate = [NSDate date];
        _dateLabel.text = [_selectedDate stringWithFormat:@"MM月dd日"];
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        _dicAll = tmpDic;
        
        _textField.delegate = self;
    }
    return self;
}

-(void)setSelectedDate:(NSDate *)selectedDate{
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        _dateLabel.text = [selectedDate stringWithFormat:@"MM月dd日"];
    }
}

#pragma -mark calender module & Delegate method
-(void)tapdateLabel{
    [self showCalendar:!_isCalendarShown];
}

-(void)hideCalendar:(UIButton *)sender{
    [self showCalendar:false];
    [sender removeFromSuperview];
}

- (void)calendarSelectedDate:(NSDate *)date{
    if ([self checkSelectedDate:date]) {
        [self reloadReocrdOfDay:date];
    }
    [self showCalendar:NO];
}

-(void)showCalendar:(BOOL)isShowCalendar{
    _isCalendarShown = isShowCalendar;
   
    if (isShowCalendar) {
        [MobClick event:@"clk_calendar"];
         [_textField resignFirstResponder];
        _calendarDisplayDate = _selectedDate;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [btn addTarget:self action:@selector(hideCalendar:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 103268;
        [self addSubview:btn];
//        self.userInteractionEnabled = NO;
        
        _calendar.alpha = 0;
        [self addSubview:_calendar];
        [UIView animateWithDuration:.3 animations:^{
            self.calendar.alpha = 1;
        }];
    }else{
//        self.userInteractionEnabled = YES;
         [_textField becomeFirstResponder];
        UIButton *button = [self viewWithTag:103268];
        if (button) {
            [button removeFromSuperview];
        }
        [UIView animateWithDuration:.3 animations:^{
            self.calendar.alpha = 0;
        } completion:^(BOOL finished) {
            [self.calendar removeFromSuperview];
        }];
    }
}

-(BOOL)checkSelectedDate:(NSDate *)date{
    if ([date originTimeOfADay] > [[NSDate date] originTimeOfADay]) {
        [XKRWCui showInformationHudWithText:@"不能查看今天以后的日期哦~"];
        return false;
    }
    
    NSTimeInterval regDateInterval = [[NSDate dateFromString:[[XKRWUserService sharedService] getREGDate] withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    
    if ([date originTimeOfADay] < regDateInterval) {
        
        [self.calendar outerSetSelectedDate:self.selectedDate andNeedReload:false];
        
        [XKRWCui showInformationHudWithText:@"不能查看注册以前的日期哦~"];
        return false;
    }
    return true;
}

-(void)reloadReocrdOfDay:(NSDate *)date{
    self.selectedDate = date;
    [XKTaskDispatcher downloadWithTaskID:@"getAllRecord" task:^{
        self.schemeReocrds = (XKRWRecordSchemeEntity *)[[XKRWRecordService4_0 sharedService] getSchemeRecordWithDate:self.selectedDate];
        self.oldRecord = (XKRWRecordEntity4_0 *)[[XKRWRecordService4_0 sharedService] getAllRecordOfDay:self.selectedDate];
    }];
}
- (IBAction)actBefore:(id)sender {
    if (_selectedDate) {
        NSDate *dateBefore = [_selectedDate offsetDay:-1];
        if ([self checkSelectedDate:dateBefore]) {
            [self reloadReocrdOfDay:dateBefore];
            [_calendar outerSetSelectedDate:_selectedDate andNeedReload:true];
        }
    }
}

- (IBAction)actLater:(id)sender {
    if (_selectedDate) {
        NSDate *dateAfter = [_selectedDate offsetDay:1];
        if ([self checkSelectedDate:dateAfter]) {
            [self reloadReocrdOfDay:dateAfter];
            [_calendar outerSetSelectedDate:_selectedDate andNeedReload:true];
        }
    }
}

#pragma -mark carousel module & Delegate method

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
    carousel.currentItemIndex = index;
//    [carousel scrollToItemAtIndex:index duration:10.0f];
    [carousel scrollToItemAtIndex:index animated:YES];
    [_textField resignFirstResponder];
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    tmpDic = [_dicAll objectForKey:_selectedDate];
    NSString *str = [tmpDic objectForKey:_arrLabels[index]];
    if (str && ![str isEqualToString:@""]) {
        _textField.text = str;
    }
    NSLog(@"🐅%ld",(long)index);
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    for (UIView *item in carousel.visibleItemViews) {
        for (UILabel *lab in item.subviews) {
            lab.layer.borderWidth = 0;
            lab.layer.borderColor = [UIColor clearColor].CGColor;
            lab.textColor = [UIColor blackColor];
        }
    }
    
    for (UIView *view in carousel.currentItemView.subviews) {
        if ([view isKindOfClass:[UILabel class]] ) {
            UILabel *lab = (UILabel *)view;
            lab.textColor = XKMainToneColor_29ccb1;
            lab.layer.borderWidth = 1;
            lab.layer.cornerRadius = 5;
            lab.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
            NSString *str= [lab.text isEqualToString: _arrLabels[0]]?@"kg":@"cm";
            _labInput.text = str;
        }
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _arrLabels.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 55;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSUInteger)index
         reusingView:(UIImageView *)view
{
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
        view.contentMode = UIViewContentModeScaleToFill; //图片拉伸模式
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 26)];
       
        lab.text = [NSString stringWithFormat:@"%@",_arrLabels[index]];
        lab.textAlignment = NSTextAlignmentCenter;
        
        if (isInit && index == 0) {
            lab.textColor = XKMainToneColor_29ccb1;
            lab.layer.borderWidth = 1;
            lab.layer.cornerRadius = 5;
            lab.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
            isInit = NO;
        }
        [view addSubview:lab];
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.10f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 1.3f;
            }
            return value;
        }
        case iCarouselOptionFadeMin:
        {
            if (_carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return -1.3f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma -mark textfiled delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    
}

#pragma -mark sure btn & cancle btn
- (IBAction)pressCancle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressPopViewCancle)]) {
        [self.delegate pressPopViewCancle];
    }
}

- (IBAction)pressSure:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pressPopViewSure:)]) {
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        [self.delegate pressPopViewSure:[numFormatter numberFromString:[NSString stringWithFormat:@"%@",_textField.text]]];
    }
}

@end