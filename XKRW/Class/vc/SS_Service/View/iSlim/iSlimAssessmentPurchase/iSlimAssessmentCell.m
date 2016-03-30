//
//  iSlimAssessmentCell.m
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "iSlimAssessmentCell.h"

@implementation iSlimAssessmentCell
{
    __weak IBOutlet UILabel *title;
    
    __weak IBOutlet UILabel *userName_1;
    __weak IBOutlet UILabel *comment_1;
    
    __weak IBOutlet UILabel *userName_2;
    __weak IBOutlet UILabel *comment_2;
    
    __weak IBOutlet UILabel *userName_3;
    __weak IBOutlet UILabel *comment_3;
    
    __weak IBOutlet UILabel *userName_4;
    __weak IBOutlet UILabel *comment_4;
    
    __weak IBOutlet UIView *attentionView;
    __weak IBOutlet UIView *loadingCommentView;
    
    void (^_clickExchange)(void);
    void (^_clickTeamDetail)(void);
    void (^_clickUserComment)(void);
    void (^_clickSuccessStories)(void);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initSubviewsWithObject {
    
    self.width = XKAppWidth;
    /******************************
     *  Fatal error
     */
    XKLog(@"%f", XKAppWidth);
    
    if (XKAppWidth == 375) {
        self.height += 100;
    } else if (XKAppWidth == 414) {
        self.height += 200;
    }
    //*****************************
    
    self.userCommentArray = [NSArray arrayWithObjects:comment_1, comment_2, comment_3, comment_4, nil];
    self.userNameArray = [NSArray arrayWithObjects:userName_1, userName_2, userName_3, userName_4, nil];
}

- (void)setUserCommentWithUserNameArray:(NSArray *)userArray commentNameArray:(NSArray *)array totalComment:(NSInteger )total {

    for (int i = 0; i < 4; i++) {
        UILabel *label = self.userNameArray[i];
        UILabel *commentLabel = self.userCommentArray[i];
        
        if (userArray.count && array.count) {
            
            label.text = [userArray objectAtIndex:i];
            commentLabel.text = [array objectAtIndex:i];
        }
    }
    
    title.text = [NSString stringWithFormat:@"用户评价（%ld）", (long)total];
    
    if (userArray.count) {
        
        [UIView animateWithDuration:0.15 animations:^{
            loadingCommentView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [loadingCommentView removeFromSuperview];
        }];
    }
}

- (void)setClickExchangeButton:(void (^)(void))exchangeAction
     clickViewTeamDetailButton:(void (^)(void))detailAction
            clickCommentButton:(void (^)(void))commentAction
     clickSuccessStoriesButton:(void (^)(void))storiesAction {
    
    _clickExchange = exchangeAction;
    _clickTeamDetail = detailAction;
    _clickUserComment = commentAction;
    _clickSuccessStories = storiesAction;
}

- (IBAction)clickExchangeForFree:(id)sender {
    if (_clickExchange) {
        _clickExchange();
    }
}

- (IBAction)clickDataAndOrganization:(id)sender {
    if (_clickTeamDetail) {
        _clickTeamDetail();
    }
}

- (IBAction)clickUserComment:(id)sender {
    if (_clickUserComment) {
        _clickUserComment();
    }
}

- (IBAction)clickSuccessStories:(id)sender {
    if (_clickSuccessStories) {
        _clickSuccessStories();
    }
}

@end
