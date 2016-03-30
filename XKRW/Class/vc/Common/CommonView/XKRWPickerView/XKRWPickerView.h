//
//  MyPickerView.h
//  HaoBao
//  QQ:297184181
//  Created by haobao on 13-11-26.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WheelView.h"           //滚轮
#import "MagnifierView.h"       //放大
@protocol XKRWPickerViewDataSource;
@protocol XKRWPickerViewDelegate;

@interface XKRWPickerView : UIView<WheelViewDelegate> {
    
    CGFloat centralRowOffset;
    
    MagnifierView *loop;

}

@property (nonatomic, assign) id<XKRWPickerViewDelegate> delegate;
@property (nonatomic, assign) id<XKRWPickerViewDataSource> dataSource;

@property (nonatomic, retain)UIColor *fontColor;

- (void)update;

- (void)reloadData;

- (void)reloadDataInComponent:(NSInteger)component;

@end

@protocol XKRWPickerViewDataSource <NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(XKRWPickerView *)pickerView;

- (NSInteger)pickerView:(XKRWPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@protocol XKRWPickerViewDelegate <NSObject>

@optional

- (CGFloat)pickerView:(XKRWPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (CGFloat)pickerView:(MyPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (NSString *)pickerView:(XKRWPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

//- (UIView *)pickerView:(MyPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)pickerView:(XKRWPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


@end


