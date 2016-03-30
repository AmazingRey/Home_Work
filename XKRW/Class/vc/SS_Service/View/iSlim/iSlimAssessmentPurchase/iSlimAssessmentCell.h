//
//  iSlimAssessmentCell.h
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iSlimAssessmentCell : UIView

@property (nonatomic, strong) NSArray *userNameArray;
@property (nonatomic, strong) NSArray *userCommentArray;

@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel;

- (void)initSubviewsWithObject;

- (IBAction)clickExchangeForFree:(id)sender;
- (IBAction)clickDataAndOrganization:(id)sender;
- (IBAction)clickUserComment:(id)sender;
- (IBAction)clickSuccessStories:(id)sender;

- (void)setClickExchangeButton:(void (^)(void))exchangeAction
     clickViewTeamDetailButton:(void (^)(void))detailAction
            clickCommentButton:(void (^)(void))commentAction
     clickSuccessStoriesButton:(void (^)(void))storiesAction;

- (void)setUserCommentWithUserNameArray:(NSArray *)userArray commentNameArray:(NSArray *)array totalComment:(NSInteger )total;

@end
