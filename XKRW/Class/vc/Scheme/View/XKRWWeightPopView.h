//
//  XKRWWeightPopView.h
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

@protocol XKRWWeightPopViewDelegate <NSObject>
@optional
-(void)pressPopViewSure:(NSNumber *)inputNum;
-(void)pressPopViewCancle;
@end
#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "XKHeader.h"
#import "XKRW-Swift.h"
#import "XKTaskDispatcher.h"

@interface XKRWWeightPopView : UIView <UITextFieldDelegate,iCarouselDataSource,iCarouselDelegate,XKRWCalendarDelegate>
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
@property (strong, nonatomic) NSDate *calendarDisplayDate;
@property (strong ,nonatomic) XKRWCalendar *calendar;
@property (strong ,nonatomic) XKRWRecordSchemeEntity *schemeReocrds;
@property (strong ,nonatomic) XKRWRecordEntity4_0 *oldRecord;
@property (assign ,nonatomic) BOOL isCalendarShown;
@property (strong,nonatomic) NSMutableArray *recordDates;
@property (strong, nonatomic) NSMutableDictionary *dicAll;

- (IBAction)pressCancle:(id)sender;
- (IBAction)pressSure:(id)sender;

@end
