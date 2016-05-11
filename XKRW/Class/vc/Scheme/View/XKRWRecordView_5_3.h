//
//  XKRWRecordFood5_3View.h
//  XKRW
//
//  Created by ss on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRWRecordSchemeEntity.h"
#import "XKRWRecordEntity4_0.h"

@protocol XKRWRecordFood5_3ViewDelegate <NSObject>
@optional
- (void)RecordFoodViewpressCancle;
- (void)addMoreView;
- (void)entryRecordVCWith:(SchemeType)schemeType;
- (void)saveSchemeRecord:(id )entity andType:( XKRWRecordType ) recordtype andEntryType:(energyType)entryRype;
- (void)deleteSchemeRecord:(id )entity andType:( XKRWRecordType ) recordtype andEntryType:(energyType)entryRype;
-(void)fixHabitAt:(NSInteger)index isCurrect:(BOOL)abool;
@end


@interface XKRWRecordView_5_3 : UIView
@property (assign,nonatomic) id<XKRWRecordFood5_3ViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *recommendedTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *habitLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTypeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labSeperate;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerbutton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeHeight;

// 点击的是记录饮食圆环  进入营养分析
- (IBAction)leftButtonAction:(UIButton *)sender;
// 记录推荐饮食  推荐运动  运动
- (IBAction)centerButtonAction:(UIButton *)sender;
//点击的是记录饮食圆环  进入记录食物
- (IBAction)rightButtonAction:(UIButton *)sender;

//关闭页面
- (IBAction)cancleAction:(UIButton *)sender;
//选中记录按钮 action
- (IBAction)recordSeclctAction:(UIButton *)sender;
//选中推荐按钮 action
- (IBAction)recommendedSelectAction:(UIButton *)sender;

-(void)initSubViews;

-(void)setsubViewUI;

@property (assign) NSInteger positionX;
@property (assign ,nonatomic) NSInteger pageIndex;
@property (strong ,nonatomic) NSArray *schemeArray;

@property (assign ,nonatomic) energyType type;
@property (strong ,nonatomic) NSMutableDictionary *dicCollection;
@property (strong ,nonatomic) UIImageView *shadowImageView;
@property (strong ,nonatomic) NSDate  *date;
@property (strong ,nonatomic) UIViewController *vc;
@property (assign,nonatomic) RevisionType revisionType;
@end