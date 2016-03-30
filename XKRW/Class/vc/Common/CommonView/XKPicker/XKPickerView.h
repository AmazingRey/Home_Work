//
//  XKPickerView.h
//  MyPicker
//
//  Created by yaowq on 14-3-3.
//  Copyright (c) 2014年 yaowq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPickerViewWidth 160
#define kPickerViewHeight 210
#define kCellHeight 30
#define kEmptyRows (kPickerViewHeight-kCellHeight)/2/kCellHeight
//kEmptyRows决定tableview起始和结尾的无内容cell的个数，这么做为了让tableview中所有有内容的cell能够滚动到中间部位。


@protocol XKPickerViewDelegate;

@interface XKPickerView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger columnNumbers;
    
}

@property (nonatomic, assign)id<XKPickerViewDelegate> pickerViewDelegate;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) int width;

- (void)addContent;//添加滚轮

- (void)reloadData;//刷新所有滚轮
- (void)reloadDataTwo;//刷新两个滚轮
- (void)reloadData:(NSInteger)tag;//刷新单个滚轮

- (void)selectedRow:(NSInteger)row  InColumn:(NSInteger)column;//每个滚轮选中的行

- (void) resetLayoutWithFontSize:(int) fontSize;

///选择单个滑轮  提醒周期选择
-(void)selectedRow:(int)row;
@end



@protocol XKPickerViewDelegate <NSObject>

//滚轮列数
- (NSInteger)numbersOfColumnInPickerView:(XKPickerView *)pickerView;

//每个滚轮的行数
- (NSInteger)pickerView:(XKPickerView *)pickerView numberOfRowsInColumn:(NSInteger)column;

//滚轮中每行的内容
- (NSString *)pickerView:(XKPickerView *)pickerView titleForRow:(NSInteger)row forColumn:(NSInteger)column;

//选中的行
- (void)pickerView:(XKPickerView *)pickerView didSelectRow:(NSInteger)row inColumn:(NSInteger)column;


@end