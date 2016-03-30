//
//  FeedbackViewController.h
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "UMFeedback.h"

@interface FeedbackViewController : XKRWBaseVC <UMFeedbackDataDelegate> {
    
    UMFeedback *feedbackClient;
}


@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) IBOutlet UIView *mToolBar;

@property (strong, nonatomic) IBOutlet UITextField *mTextField;

@property (nonatomic, retain)  NSArray *mFeedbackDatas;
@property (nonatomic, strong) UITapGestureRecognizer *resignKeyboardTap;

- (IBAction)sendFeedback:(id)sender;



@end
