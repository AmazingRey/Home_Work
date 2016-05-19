//
//  XKRWWeightPopView.h
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "XKHeader.h"
#import "XKRW-Swift.h"
#import "XKTaskDispatcher.h"


@protocol XKRWWeightPopViewDelegate <NSObject>
@optional
-(void)pressPopViewSure:(NSDictionary *)dic;
-(void)pressPopViewCancle;
-(void)resetWeightPlan;

- (void)saveSurroundDegreeOrWeightDataToServer:(XKRWRecordType) recordType andEntity:(XKRWRecordEntity4_0 *)entity;

@end


@interface XKRWWeightPopView : UIView <UITextFieldDelegate,iCarouselDataSource,iCarouselDelegate,XKRWCalendarDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (assign, nonatomic) id<XKRWWeightPopViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIButton *btnBefore;
@property (weak, nonatomic) IBOutlet UIButton *btnLater;
- (IBAction)actBefore:(id)sender;
- (IBAction)actLater:(id)sender;

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labInput;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;

@property (strong,nonatomic) NSArray *arrLabels;
@property (strong, nonatomic) NSDate *selectedDate;
//@property (strong, nonatomic) NSDate *calendarDisplayDate;
//@property (strong ,nonatomic) XKRWCalendar *calendar;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong ,nonatomic) XKRWRecordSchemeEntity *schemeReocrds;
@property (strong ,nonatomic) XKRWRecordEntity4_0 *oldRecord;
@property (assign ,nonatomic) BOOL isCalendarShown;
@property (strong,nonatomic) NSMutableArray *recordDates;
@property (strong, nonatomic) NSMutableDictionary *dicAll;

@property (copy, nonatomic) NSString *selectDateStr;
@property (strong, nonatomic) NSNumber *currentIndex;
@property (assign, nonatomic) XKRWRecordType recordType;
@property (strong, nonatomic) NSMutableDictionary *dicIllegal;

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type withDate:(NSDate *)date;
- (IBAction)pressCancle:(id)sender;
- (IBAction)pressSure:(id)sender;

@end
