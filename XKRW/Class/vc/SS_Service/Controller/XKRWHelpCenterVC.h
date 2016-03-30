//
//  XKRWHelpCenterVC.h
//  XKRW
//
//  Created by y on 15-1-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"

@interface XKRWHelpCenterVC : XKRWBaseVC<UITextViewDelegate,UITextFieldDelegate>
{
    NSMutableArray  *readDataArray;
}
@property (weak, nonatomic) IBOutlet UILabel *safetyDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *failDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIView *connectView;

@property (weak, nonatomic) IBOutlet UITextField *OrderID;

@property (weak, nonatomic) IBOutlet UITextField *userAddress;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property(nonatomic,strong)UILabel  *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;



- (IBAction)submit:(id)sender;
- (IBAction)putInOrderNO:(id)sender;

@end
