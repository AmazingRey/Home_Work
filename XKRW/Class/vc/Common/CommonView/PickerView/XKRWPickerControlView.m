//
//  XKRWPickerControlView.m
//  XKRW
//
//  Created by XiKang on 14-7-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWPickerControlView.h"
#import "XKPickerView.h"
/**
 *  外部统一入口
 *
 */
@interface XKRWPickerControlView ()<UIPickerViewDataSource,UIPickerViewDelegate,XKPickerViewDelegate>

@property (nonatomic, strong) XKPickerView *mPicker;
@end
@implementation XKRWPickerControlView
//基础入口
/**
 *  初始化
 */
-(void)initDate{
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.picker = [[UIPickerView alloc] init];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self addSubview:_picker];
    }
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDate];
        [self setFrame:frame];
    }

    return self;
}
/**
 *  对picker进行frame设置
 *
 *  @param frame <#frame description#>
 */
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (K_iOS_System_Version_Gt_7) {
        [self.picker  setFrame:frame];
    }else{
    }
}
/**
 *  默认选中
 *
 *  @param row   选中的行
 *  @param colum 选中的列
 */
-(void)controlSelectRow:(NSInteger)row andColum:(NSInteger)colum{
    
    if (K_iOS_System_Version_Gt_7) {
        [self.picker  selectRow:row inComponent:colum animated:NO];
    }else{
        [self.mPicker selectedRow:row InColumn:colum];
    }
}

/**
 *  设置代理对象
 *  同时 处理7.0版本已下模拟的7的界面
 *  @param delegate 实现 XKPickerControlDelegate 协议方法的执行对象
 */
-(void)setDelegate:(id<XKPickerControlDelegate>)delegate{
    _delegate = delegate;
    if (!K_iOS_System_Version_Gt_7) {
        if (!_mPicker) {
            self.mPicker =[[XKPickerView alloc] initWithFrame:self.bounds];
            [self addSubview:_mPicker];
        }
        self.mPicker.pickerViewDelegate = self;
        [self.mPicker addContent];
        _mPicker.lineV.frame = CGRectMake(0, (kPickerViewHeight-kCellHeight)/2+5, XKAppWidth, kCellHeight);
        _mPicker.lineV.hidden = YES;
        
        _mPicker.lineView1.frame = CGRectMake(0, (kPickerViewHeight-kCellHeight)/2+5-0.7, XKAppWidth, 0.5);
        _mPicker.lineView2.frame = CGRectMake(0,(kPickerViewHeight-kCellHeight)/2+5+kCellHeight+0.2, XKAppWidth, 0.5);
        
    }
}
/**
 *  刷新方法
 *
 *  @param colum 需要刷新的列
 */
-(void)reloadData:(NSInteger)colum{
    
    if (K_iOS_System_Version_Gt_7) {
        [_picker  reloadComponent:colum];
    }else{
        [self.mPicker reloadData:colum];
    }

}

/**
 *  自定义协议方法
 *
 *  @param NSInteger 返回列数
 *
 *  @return 返回代理方法执行的结果
 */
#pragma mark 自定义picker协议方法
-(NSInteger) numbersOfColumnInPickerView:(XKPickerView *)pickerView{
    NSInteger colums = [_delegate controlGetNumberOfColum];
    return colums;
}
-(NSInteger) pickerView:(XKPickerView *)pickerView numberOfRowsInColumn:(NSInteger)column{
    NSInteger rows = [_delegate controlGetRowsInColum:column];
    return rows;
}
- (NSString *) pickerView:(XKPickerView *)pickerView titleForRow:(NSInteger)row forColumn:(NSInteger)column{
    NSString * title = [_delegate controlGetTitleAtRow:row InColum:column];
    
    return title;
}
-(void)pickerView:(XKPickerView *)pickerView didSelectRow:(NSInteger)row inColumn:(NSInteger)column{
    [_delegate controlDidSelectedRow:row andColum:column];
}
#pragma mark 系统picker 协议方法
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [_delegate controlGetNumberOfColum];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_delegate controlGetRowsInColum:component];
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_delegate controlGetTitleAtRow:row InColum:component];
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [_delegate controlDidSelectedRow:row andColum:component];
}
@end
