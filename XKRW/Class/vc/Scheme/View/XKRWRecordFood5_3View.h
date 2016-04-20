//
//  XKRWRecordFood5_3View.h
//  XKRW
//
//  Created by ss on 16/4/13.
//  Copyright © 2016年 XiKang. All rights reserved.
//
typedef NS_ENUM(NSInteger,energyType) {
    energyTypeEat = 1,
    energyTypeSport,
    energyTypeHabit
};

@protocol XKRWRecordFood5_3ViewDelegate <NSObject>
@optional
-(void)RecordFoodViewpressCancle;
-(void)addMoreView;
@end

#import <UIKit/UIKit.h>
#import "XKRWRecordSchemeEntity.h"

@interface XKRWRecordFood5_3View : UIView
@property (assign,nonatomic) id<XKRWRecordFood5_3ViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topArrowImgConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordWeight;
@property (weak, nonatomic) IBOutlet UILabel *labRecordWeight;
@property (weak, nonatomic) IBOutlet UILabel *labRecordWeightNum;
@property (weak, nonatomic) IBOutlet UIButton *btnPushMenu;
@property (weak, nonatomic) IBOutlet UILabel *labPushMenu;
@property (weak, nonatomic) IBOutlet UILabel *labPushMenuNum;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnAnalyze;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordSport;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordFood;
@property (weak, nonatomic) IBOutlet UILabel *labSeperate;
@property (weak, nonatomic) IBOutlet UIImageView *arrowLeft;
@property (weak, nonatomic) IBOutlet UIImageView *arrowMiddle;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRight;

- (IBAction)actCancle:(id)sender;

- (IBAction)actRecordWeight:(id)sender;

- (IBAction)actPushMenu:(id)sender;
- (IBAction)actMore:(id)sender;

- (IBAction)actAnalyze:(id)sender;
- (IBAction)actRecordSport:(id)sender;
- (IBAction)actRecordFood:(id)sender;


@property (strong ,nonatomic) UITableView *tableRecord;
@property (strong ,nonatomic) UITableView *tableMenu;
@property (strong ,nonatomic) UIScrollView *scrollView;
@property (assign ,nonatomic) NSInteger pageIndex;
@property (nonatomic) NSArray *arrRecord;
@property (strong ,nonatomic) NSArray *arrMenu;
@property (assign ,nonatomic) energyType type;

@end