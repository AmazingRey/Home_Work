//
//  XKTimePicker.h
//  XKCommon
//
//  Created by JiangRui on 13-3-26.
//  Copyright (c) 2013年 xikang. All rights reserved.
//
#import <UIKit/UIKit.h>

@class XKTimePicker;
typedef void (^XKTimePickerBlock)(XKTimePicker *);

@protocol XKTimePickerProtocol <NSObject>

@optional
-(void)chooseTime:(NSDate *)date;

@end

@interface XKTimePicker : UIActionSheet

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,strong) NSDate *pickerDate;

@property (nonatomic) UIDatePickerMode datePickerMode;

@property (nonatomic,weak) id<XKTimePickerProtocol> pickerDelegate;
//创建XKTimePicker
+(XKTimePicker *)createTimePickerWithDatePickerMode:(UIDatePickerMode)mode
                                     andDefaultDate:(NSDate *)date;
//创建XKTimePicker 包含时间设置
+(XKTimePicker *)createTimePickerWithDatePickerMode:(UIDatePickerMode)mode
                                        defaultDate:(NSDate *)date
                                           fromDate:(NSDate *)fDate
                                       toLastestDay:(NSDate *)lDate;
//完成时执行block
-(void)showTimePickerInView:(UIView *)view andCompleteWithBlock:(XKTimePickerBlock)block;
@end