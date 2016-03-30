//
//  DatePickerView.h
//  XKRW
//
//  Created by XiKang on 14-11-4.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWUserService.h"
/**
 *  DatePicker的类型样式
 */
typedef NS_ENUM(NSInteger, DatePickerStyle){
    /**
     *  起床时间
     */
    DatePickerStyleGetUpTimePicker,
    /**
     *  睡觉时间
     */
    DatePickerStyleSleepTimePicker,
    /**
     *  体重记录
     */
    DatePickerStyleWeightReocrd,
    /**
     *  围度
     */
    DatePickerStyleCircumferenceRecord,
    /**
     *  闹钟类型
     */
    DatePickerStyleAlertType,
    /**
     *  重复周期选择
     */
    DatePickerStyleWeekdayPicker,
    /**
     *  方案难度
     */
    DatePickerStyleSchemeDifficulty,
    /**
     *  单列选择
     */
    DatePickerStyleSinglePicker,
    
    
    //订单标号
    
    DatePickerstyleOrderPicker,
    
};

@class DatePickerView;

@protocol DatePickerViewDelegate <NSObject>

- (void)clickCancelButton:(DatePickerView *)picker;
- (void)clickConfirmButton:(DatePickerView *)picker postSelected:(NSString *)string;

@end

@interface DatePickerView : UIView

@property (weak, nonatomic) IBOutlet UIView       *contentView;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UILabel      *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) NSMutableString        *selectedDate;

@property (weak, nonatomic  ) id <DatePickerViewDelegate> delegate;
@property (nonatomic        ) DatePickerStyle        style;
@property (nonatomic, strong) NSString               *identifier;

- (IBAction)clickClearButton:(id)sender;
- (IBAction)clickConfirmButton:(id)sender;
/**
 *  Load .xib之后调用的初始化方法
 *
 *  @param style 类型
 *  @param obj   弹出时默认显示的项目
 */
- (void)initSubviewsWithStyle:(DatePickerStyle)style andObj:(id)obj;
/**
 *  Load .xib之后调用的初始化方法（第二种）
 *
 *  @param style      类型
 *  @param datasource 显示的内容数组
 *  @param obj        弹出时默认显示的项目
 */
- (void)initSubviewsWithStyle:(DatePickerStyle)style
                andDatasource:(NSArray *)datasource
                       andObj:(NSString *)obj;
/**
 *  设置标题
 *
 *  @param title 标题文字
 */
- (void)setTitle:(NSString *)title;
/**
 *  动画显示在当前屏幕上
 */
- (void)addToWindow;

@end
