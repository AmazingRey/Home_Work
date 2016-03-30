//
//  XKRWChangeSchemeInfoVC.h
//  XKRW
//
//  Created by 忘、 on 15/7/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWPickerSheet.h"
#import "XKRWPickerViewVC.h"
#import "XKRWSlimPartView.h"
#import "XKRWBMIEntity.h"
#import "XKRWAlgolHelper.h"
@interface XKRWChangeSchemeInfoVC : XKRWBaseVC<XKRWPickerViewVCDelegate,XKRWSlimPartViewDelegate,PickerSheetViewDelegate>
{
    XKRWPickerSheet * myPicker;
    XKRWPickerViewVC *otherPicker;
    XKRWSlimPartView *initpicker;
}
@property (nonatomic, assign) int showType;
@property (nonatomic) NSInteger  currentYearIndex;
@property (nonatomic) NSInteger  currentMonthIndex;
@property (nonatomic) NSInteger  currentDayIndex;

@property (nonatomic, assign) NSInteger startYear;
@property (nonatomic, assign) NSInteger endYear;
@property (nonatomic, strong) NSDate *addOneDay;

@property (nonatomic, assign) NSInteger row1Temp;
@property (nonatomic, assign) NSInteger row2Temp;
@property (nonatomic, assign) NSInteger row3Temp;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) BOOL isLeapYear;

@property (nonatomic, assign) NSInteger tempWeight;

@property (nonatomic, copy) DidDoneCallback saveBack;
@end
