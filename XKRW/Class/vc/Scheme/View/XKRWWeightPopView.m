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
        _arrLabels = @[@"体重",@"胸围",@"臂围",@"腰围",@"臀围",@"大腿围",@"小腿围"];
        isInit = YES;
        
        _iCarouselView.type = 0;
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
        
//        _calendar = [[XKRWCalendar alloc] initWithOrigin:CGPointMake(-50, 44) recordDateArray:_recordDates headerType:XKRWCalendarHeaderTypeSimple andResizeBlock:^{
//            
//        }];
//        CGRect frame = _calendar.frame;
////        frame.size.width -= 100;
//        _calendar.frame = frame;
//        [_calendar addBackToTodayButtonInFooterView];
//        _calendar.delegate = self;
//        [_calendar reloadCalendar];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, XKAppHeight-200, XKAppWidth, 200)];
        
        _datePicker.backgroundColor = [UIColor whiteColor];
        
        _datePicker.calendar = [NSCalendar currentCalendar];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(calendarSelectedDate:) forControlEvents:UIControlEventValueChanged];
        _datePicker.minimumDate = [self getRegisterDate];
        _datePicker.maximumDate = [NSDate today];
        
        for (UIView *view in _datePicker.subviews) {
            if ([view isKindOfClass:[UIPickerView class]]) {
                UIPickerView *pickView = (UIPickerView *)view;
                pickView.transform =CGAffineTransformMakeScale(1.35, 1.2);
            }
        }
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdateLabel)];
        _dateLabel.userInteractionEnabled = YES;
        [_dateLabel addGestureRecognizer:tapgesture];
        
        _selectedDate = [NSDate date];
        _datePicker.date = _selectedDate;
        [[UIApplication sharedApplication].keyWindow addSubview:_datePicker];
        _datePicker.alpha = 0;
        
        _selectDateStr =[_selectedDate stringWithFormat:@"YYYY-MM-dd"];
        _dateLabel.text = [_selectedDate stringWithFormat:@"MM月dd日"];
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        _dicAll = tmpDic;
        
        _textField.delegate = self;
        [self reloadReocrdOfDay:_selectedDate];
        _currentIndex = [NSNumber numberWithInteger:_iCarouselView.currentItemIndex];
    }
    return self;
}

-(NSDate *)getRegisterDate{
    NSString *registerDateStr = [[XKRWUserService sharedService] getREGDate];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc ]init];
    formatter1.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    formatter1.dateFormat = @"yyyy-MM-dd";
    NSDate *registerDate  = [formatter1 dateFromString:registerDateStr];
    return registerDate;
}

-(void)setCurrentIndex:(NSNumber *)currentIndex{
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
    [self showCurrentText];
}

-(void)setSelectedDate:(NSDate *)selectedDate{
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        _selectDateStr =[selectedDate stringWithFormat:@"YYYY-MM-dd"];
        _dateLabel.text = [selectedDate stringWithFormat:@"MM月dd日"];
    }
}

-(void)setSchemeReocrds:(XKRWRecordSchemeEntity *)schemeReocrds{
    if (!_schemeReocrds) {
        _schemeReocrds = [[XKRWRecordSchemeEntity alloc] init];
    }
    if (_schemeReocrds != schemeReocrds) {
        _schemeReocrds = schemeReocrds;
    }
}

-(void)setOldRecord:(XKRWRecordEntity4_0 *)oldRecord{
    if (!_oldRecord) {
        _oldRecord = [[XKRWRecordEntity4_0 alloc] init];
    }
    if (_oldRecord != oldRecord) {
        _oldRecord = oldRecord;
    }
    [self makeEntityConvertToDicall];
    [self showCurrentText];
}

-(void)makeEntityConvertToDicall{
    NSMutableDictionary *dayDiction = [NSMutableDictionary dictionary];
    
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.weight ] forKey:_arrLabels[0]];
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.circumference.bust ] forKey:_arrLabels[1]];
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.circumference.arm ] forKey:_arrLabels[2]];
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.circumference.waistline ] forKey:_arrLabels[3]];
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.circumference.hipline ] forKey:_arrLabels[4]];
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.circumference.thigh ] forKey:_arrLabels[5]];
    [dayDiction setObject:[NSString stringWithFormat:@"%f", _oldRecord.circumference.shank ] forKey:_arrLabels[6]];

    [_dicAll setObject:dayDiction forKey:_selectDateStr];
}

#pragma -mark calender module & Delegate method
-(void)tapdateLabel{
    [self showCalendar:!_isCalendarShown];
}

-(void)hideCalendar:(UIButton *)sender{
    [self showCalendar:false];
    [sender removeFromSuperview];
}

- (void)calendarSelectedDate:(UIDatePicker *)datePicker{
    if ([self checkSelectedDate:datePicker.date]) {
        [self reloadReocrdOfDay:datePicker.date];
    }
//    [self showCalendar:NO];
}

-(void)showCalendar:(BOOL)isShowCalendar{
    _isCalendarShown = isShowCalendar;
    if (isShowCalendar) {
        [MobClick event:@"clk_calendar"];
         [_textField resignFirstResponder];
        [UIView animateWithDuration:.3 animations:^{
            _datePicker.alpha = 1;
        }];
    }else{
         [_textField becomeFirstResponder];
        [UIView animateWithDuration:.3 animations:^{
            _datePicker.alpha = 0;
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
        
//        [self.calendar outerSetSelectedDate:self.selectedDate andNeedReload:false];
         [_datePicker setDate:_selectedDate animated:YES];
        
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
            [_textField resignFirstResponder];
            [self reloadReocrdOfDay:dateBefore];
//            [_calendar outerSetSelectedDate:_selectedDate andNeedReload:true];
             [_datePicker setDate:_selectedDate animated:YES];
            [self showCurrentText];
        }
    }
}

- (IBAction)actLater:(id)sender {
    if (_selectedDate) {
        NSDate *dateAfter = [_selectedDate offsetDay:1];
        if ([self checkSelectedDate:dateAfter]) {
            [_textField resignFirstResponder];
            [self reloadReocrdOfDay:dateAfter];
//            [_calendar outerSetSelectedDate:_selectedDate andNeedReload:true];
            [_datePicker setDate:_selectedDate animated:YES];
            [self showCurrentText];
        }
    }
}

-(void)showCurrentText{
    dispatch_queue_t TextQueue = dispatch_queue_create("TextQueue", NULL);
    dispatch_async(TextQueue, ^{
        CGFloat str = [_dicAll[_selectDateStr][[self getCurrentType:_currentIndex]] floatValue];
        NSString *txt = str == 0 ? @"" : [NSString stringWithFormat:@"%.01f",str];
        dispatch_async(dispatch_get_main_queue(), ^{
            _textField.text = txt;
        });
    });
    dispatch_release(TextQueue);
}

-(NSString *)getCurrentType:(NSNumber *)indexNum{
    NSString *type = [NSString stringWithFormat:@"%@",[_arrLabels objectAtIndex:[indexNum integerValue]]];
    return type;
}

#pragma -mark carousel module & Delegate method
-(void)saveTheData{
    NSMutableDictionary *dic = [_dicAll objectForKey:_selectDateStr];
    NSMutableDictionary *dayDiction = [NSMutableDictionary dictionary];
    if (dic) {
        dayDiction = dic;
    }
    
    [dayDiction setObject:_textField.text forKey:[self getCurrentType:_currentIndex]];
    [_dicAll setObject:dayDiction forKey:_selectDateStr];
}
//EffectFoodAndSportCircle
-(void)saveRemote{
    _oldRecord.circumference.uid = (int)[XKRWUserDefaultService getCurrentUserId];
    NSDictionary *dic = [_dicAll objectForKey:_selectDateStr];
    
    _oldRecord.weight =[dic[_arrLabels[0]] floatValue];
    _oldRecord.circumference.bust = [dic[_arrLabels[1]] floatValue];
    _oldRecord.circumference.arm = [dic[_arrLabels[2]] floatValue];
    _oldRecord.circumference.waistline = [dic[_arrLabels[3]] floatValue];
    _oldRecord.circumference.hipline = [dic[_arrLabels[4]] floatValue];
    _oldRecord.circumference.thigh = [dic[_arrLabels[5]] floatValue];
    _oldRecord.circumference.shank = [dic[_arrLabels[6]]floatValue];
    
    _oldRecord.circumference.date = _selectedDate;
    _oldRecord.date = _selectedDate;
    
//    if ([self.delegate respondsToSelector:@selector(saveSurroundDegreeOrWeightDataToServer:andEntity:)]) {
//        [self.delegate saveSurroundDegreeOrWeightDataToServer:(XKRWRecordType) andEntity:_oldRecord];
//    }
    
    [[XKRWRecordService4_0 sharedService] saveRecord:_oldRecord ofType:XKRWRecordTypeCircumference];
    [[XKRWRecordService4_0 sharedService] saveRecord:_oldRecord ofType:XKRWRecordTypeWeight];
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    [self showCalendar:NO];
    if (carousel.currentItemIndex != [_currentIndex integerValue]) {
        [self saveTheData];
        _currentIndex = [NSNumber numberWithInteger:carousel.currentItemIndex];
        [self showCurrentText];
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    carousel.currentItemIndex = index;
    [carousel scrollToItemAtIndex:index animated:YES];
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
    [self saveTheData];
}


#pragma -mark sure btn & cancle btn
- (IBAction)pressCancle:(id)sender {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    if ([self.delegate respondsToSelector:@selector(pressPopViewCancle)]) {
        [self.delegate pressPopViewCancle];
    }
}

- (IBAction)pressSure:(id)sender {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    [_textField resignFirstResponder];
    
    [self saveRemote];
    
    if ([self.delegate respondsToSelector:@selector(pressPopViewSure:)]) {
        [self.delegate pressPopViewSure:_dicAll];
    }
}

@end