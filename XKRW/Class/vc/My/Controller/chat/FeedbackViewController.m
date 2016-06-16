//
//  FeedbackViewController.m
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "FeedbackViewController.h"
#import "XKRWUserDefaultService.h"
#import <QuartzCore/QuartzCore.h>
#import "L_FeedbackTableViewCell.h"
#import "R_FeedbackTableViewCell.h"
#import "XKRWCui.h"
#import "XKCuiUtil.h"
#import "XKHudHelper.h"
#import "XKRWUserService.h"
#import "Masonry.h"
#import "View+MASShorthandAdditions.h"
#import "XKRWUserService.h"

@implementation FeedbackViewController

@synthesize mTextField = _mTextField, mTableView = _mTableView, mToolBar = _mToolBar, mFeedbackDatas = _mFeedbackDatas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    [self addNaviBarBackButton];
    
    if (IPHONE4S_DEVICE) {
        self.mTableView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight-44);
    }else
    {
        self.mTableView.frame = CGRectMake(0, 0, XKAppWidth, XKAppHeight-64-44-27);
    }
    
    [_mTableView setBackgroundColor:[UIColor whiteColor]];
    self.mToolBar.frame = CGRectMake(0, XKAppHeight-64-44, XKAppWidth, 44);
    
    feedbackClient = [UMFeedback sharedInstance];
    feedbackClient.delegate = self ;
    [feedbackClient get];

    _mFeedbackDatas = [[NSArray alloc] init];
    
    //    从缓存取topicAndReplies
    self.mFeedbackDatas = feedbackClient.topicAndReplies;
    [self updateTableView:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _resignKeyboardTap = [[UITapGestureRecognizer alloc] init];
    [_mTableView addGestureRecognizer:self.resignKeyboardTap];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *) notification {
    
    // 键盘升起tableView点击添加键盘落下事件
    [self.resignKeyboardTap addTarget:self action:@selector(textFieldResignFirstRespond)];
    
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect bottomBarFrame = self.mToolBar.frame;
    {
        [UIView beginAnimations:@"bottomBarUp" context:nil];
        [UIView setAnimationDuration: animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        __block CGFloat mToolBarY = self.view.bounds.size.height - 44 - height;
        
        [self.mToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).with.offset(mToolBarY);
        
        }];
        
        self.mToolBar.frame = bottomBarFrame;
        [self.mTextField becomeFirstResponder];
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *) notification {
    
    // 键盘落下移除tableView点击事件
    [self.resignKeyboardTap removeTarget:self action:@selector(textFieldResignFirstRespond)];
    
        __block CGFloat mToolBarY = self.view.bounds.size.height - 44;
        
        [self.mToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).with.offset(mToolBarY);
            
        }];
    


}

- (void)popView {
    if ([self.mTextField isFirstResponder]) {
        [self.mTextField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mFeedbackDatas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *contentText;
    if ([[[self.mFeedbackDatas objectAtIndex:indexPath.row] objectForKey:@"content"] rangeOfString:@"反馈内容:"].location != NSNotFound) {
        NSString *content  = [[self.mFeedbackDatas objectAtIndex:indexPath.row] objectForKey:@"content"];
        
        NSRange range = [content rangeOfString:@"反馈内容:"]; //现获取要截取的字符串位置
        NSString * result = [content substringFromIndex:range.location+5]; //截取字符串
        contentText = result;
    }else
    {
        contentText = [[self.mFeedbackDatas objectAtIndex:indexPath.row] objectForKey:@"content"];
    }
    CGSize labelSize = [contentText sizeWithFont:[UIFont systemFontOfSize:14.0f]
                           constrainedToSize:CGSizeMake(250.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *L_CellIdentifier = @"L_UMFBTableViewCell";
    static NSString *R_CellIdentifier = @"R_UMFBTableViewCell";
    
    NSDictionary *data = [self.mFeedbackDatas objectAtIndex:indexPath.row];
    
    if ([[data valueForKey:@"type"] isEqualToString:@"dev_reply"]) {
        L_FeedbackTableViewCell *cell = (L_FeedbackTableViewCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil) {
            cell = [[L_FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        
        if ([[data valueForKey:@"content"] rangeOfString:@"反馈内容:"].location != NSNotFound) {
            NSString *content  = [data valueForKey:@"content"];
         
            NSRange range = [content rangeOfString:@"反馈内容:"]; //现获取要截取的字符串位置
            NSString * result = [content substringFromIndex:range.location+5]; //截取字符串
            cell.textLabel.text = result;
        }else
        {
            cell.textLabel.text = [data valueForKey:@"content"];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else {
        
        R_FeedbackTableViewCell *cell = (R_FeedbackTableViewCell *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
        if (cell == nil) {
            cell = [[R_FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
        }
        
        
        if ([[data valueForKey:@"content"] rangeOfString:@"反馈内容:"].location != NSNotFound) {
            NSString *content  = [data valueForKey:@"content"];
            
            NSRange range = [content rangeOfString:@"反馈内容:"]; //现获取要截取的字符串位置
            NSString * result = [content substringFromIndex:range.location+5]; //截取字符串
            cell.textLabel.text = result;
        }else
        {
            cell.textLabel.text = [data valueForKey:@"content"];
        }

        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }
}

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error
{
    if ([self.mFeedbackDatas count])
    {
        [self.mTableView reloadData];
        NSInteger lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [XKRWUserDefaultService setShowMoreRedDot:NO];
        
    }
    else
    {
        
    }
}

- (void)updateTextField:(NSError *)error
{
    self.mTextField.text = @"";
    [feedbackClient get];
}

- (void)getFinishedWithError:(NSError *)error
{
    if (!error)
    {
        XKLog(@"%@", feedbackClient.topicAndReplies);
        [self updateTableView:error];
    }
    else
    {
        XKLog(@"%@",error);
    }
}


- (void)postFinishedWithError:(NSError *)error
{
    [XKRWCui hideProgressHud];
    [self.mTextField resignFirstResponder];
    if (!error) {
      
    } else{
       
        [[XKHudHelper  instance]showInformationHudWithText:@"发送失败"];
    }
    
    [self updateTextField:error];
}

- (void)textFieldResignFirstRespond {
    [self.mTextField resignFirstResponder];
}
#pragma mark scrollow delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.mTextField resignFirstResponder];
}


- (IBAction)sendFeedback:(id)sender {
    if ([self.mTextField.text length])
    {
        [XKRWCui showProgressHudInView:self.view];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
   
        NSString *content = self.mTextField.text;
        [dictionary setObject:content forKey:@"content"];
        
        //  添加用户反馈 的用户信息
        NSString * userAccount =  [[XKRWUserService sharedService] getUserAccountName];
        NSDictionary *userInfo = @{@"用户账号":userAccount,
                                   @"用户token:":[[XKRWUserService sharedService] getToken]
                                   };
    
        [feedbackClient updateUserInfo:@{@"contact":userInfo}];
        [feedbackClient post:dictionary];
    }
}
@end
