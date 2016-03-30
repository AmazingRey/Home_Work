//
//  XKTimePicker.m
//  XKCommon
//
//  Created by JiangRui on 13-3-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//

#import "XKTimePicker.h"

//XKFCTimePicker 时间选择器
//继承自UIActionSheet
@interface XKTimePicker()

@property (nonatomic,strong) XKTimePickerBlock block;

@end

@implementation XKTimePicker

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
+(XKTimePicker *)createTimePickerWithDatePickerMode:(UIDatePickerMode)mode andDefaultDate:(NSDate *)date
{
    return [XKTimePicker createTimePickerWithDatePickerMode:mode defaultDate:date fromDate:nil toLastestDay:nil];
}
+(XKTimePicker *)createTimePickerWithDatePickerMode:(UIDatePickerMode)mode
                                        defaultDate:(NSDate *)date
                                           fromDate:(NSDate *)fDate
                                       toLastestDay:(NSDate *)lDate
{
    XKTimePicker *timePicker = [[XKTimePicker alloc]initWithTitle:@" \n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:nil,nil];
    timePicker.datePickerMode = mode;
    if (date) {
        timePicker.datePicker.date = date;
    }
    if (fDate) {
        timePicker.datePicker.minimumDate = fDate;
    }
    if (lDate) {
        timePicker.datePicker.maximumDate = lDate;
    }
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
//    [timePicker.datePicker setLocale:locale];
    
    return timePicker;
}
-(void)setUp
{
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.frame = CGRectMake(0, 44, 320, 216);
    self.toolBar = [[UIToolbar alloc]init];
    self.toolBar.frame = CGRectMake(0, 0, XKAppWidth, 44);
    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancel)];
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(done)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:NULL];
    self.toolBar.items = @[okItem,flexItem,cancelItem];
    [self addSubview:self.datePicker];
    [self addSubview:self.toolBar];
}
-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    self.datePicker.datePickerMode = datePickerMode;
}
-(void)setPickerDate:(NSDate *)pickerDate
{
    _pickerDate = pickerDate;
    self.datePicker.date = pickerDate;
}
-(void)cancel
{
    self.block = nil;
    [self dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)done
{
    if (self.block) {
        self.block(self);
        self.block = nil;
    }
    else if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(chooseTime:)]) {
        [self.pickerDelegate chooseTime:self.datePicker.date];
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}
//完成时执行block
-(void)showTimePickerInView:(UIView *)view andCompleteWithBlock:(XKTimePickerBlock)block
{
    [self showInView:view];
    self.block = block;
}
@end

