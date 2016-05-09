//
//  XKRWCustomPickerView.h
//  XKRW
//
//  Created by ss on 16/5/4.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@protocol XKRWCustomPickerViewDelegate <NSObject>
@optional
-(void)pickerViewPressedDone:(NSInteger)currentIndex;
-(void)pickerViewPressedCancle;
@end
#import <UIKit/UIKit.h>

@interface XKRWCustomPickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (assign, nonatomic) id<XKRWCustomPickerViewDelegate> delegate;
/**
 *  上方栏位左边按钮内容
 */
@property (strong, nonatomic) NSString *leftBtnText;

/**
 *  上方栏位中间按钮内容
 */
@property (strong, nonatomic) NSString *middleBtnText;

/**
 *  上方栏位右边按钮内容
 */
@property (strong, nonatomic) NSString *rightBtnText;

/**
 *  上方栏位背景色
 */
@property (strong, nonatomic) UIColor *toolBarColor;

/**
 *  所有compontent的内容，dicdata.count为compontent组数，
 *  key:组编号  value:组内容数组
 */
@property (strong, nonatomic) NSDictionary *dicData;

@property (copy, nonatomic)  NSString *currentStr;
@property (assign, nonatomic)  NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame withindex:(NSInteger)index withDicData:(NSDictionary *)dic;
@end
