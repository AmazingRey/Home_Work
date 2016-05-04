//
//  XKRWCustomPickerView.m
//  XKRW
//
//  Created by ss on 16/5/4.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWCustomPickerView.h"

@implementation XKRWCustomPickerView{
    UIToolbar *toolBar;
    UIPickerView *picker;
    NSString *currentStr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        currentStr = @"第一周";
        _leftBtnText = @"取消";
        _rightBtnText = @"确定";
        
        [self createToolBar];
    }
    return self;
}

- (void)createToolBar {
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 44)];
    
    if (_toolBarColor) {
        toolBar.backgroundColor = _toolBarColor;
    }else{
        toolBar.backgroundColor = [UIColor lightGrayColor];
    }
    
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *barButtonCancle = [[UIBarButtonItem alloc] initWithTitle:_leftBtnText
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(cancleClicked)];
    
    barButtonCancle.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *barTitle = [[UIBarButtonItem alloc] initWithTitle:currentStr
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:nil];
    barTitle.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:_rightBtnText
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(doneClicked)];
    
    barButtonDone.tintColor = [UIColor blackColor];
    
    toolBar.items = @[barButtonCancle, leftSpace, barTitle, rightSpace, barButtonDone];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.frame.size.height, XKAppWidth, 200)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    [self addSubview:picker];
    [self addSubview:toolBar];
}

- (void)doneClicked {
    if ([self.delegate respondsToSelector:@selector(pickerViewPressedDone:)]) {
        [self.delegate pickerViewPressedDone:currentStr];
    }
}

- (void)cancleClicked {
    if ([self.delegate respondsToSelector:@selector(pickerViewPressedCancle)]) {
        [self.delegate pickerViewPressedCancle];
    }
}

#pragma mark UIPickerView Method
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}
#pragma mark UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [NSString stringWithFormat:@"第%ld周",(long)row+1];
    myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    currentStr = [[_dicData objectForKey:[NSNumber numberWithInteger:component]] objectAtIndex:row];
    UILabel *lab = (UILabel *)[pickerView viewForRow:row forComponent:component];
    currentStr = lab.text;
}

@end
