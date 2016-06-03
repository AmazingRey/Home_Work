//
//  XKRWAllCommentVC.m
//  XKRW
//
//  Created by 忘、 on 15-3-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWAllCommentVC.h"
#import "XKRWServerPageService.h"
#import "XKRWIslimCommentModel.h"
#import "XKRWUserCommentCell.h"
#import "XKRWCommentModel.h"
#import "XKRWCui.h"
#import "XKHudHelper.h"
@interface XKRWAllCommentVC ()

@end

@implementation XKRWAllCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initView
{
    [MobClick event:@"in_iSlimReview"];
    self.title = @"所有评论";
    self.forbidAutoAddPopButton = YES;
    [self addNaviBarBackButton];
    
    commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    commentTableView.backgroundColor = XKBGDefaultColor;
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.userInteractionEnabled = YES;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    headerView = [[MJRefreshHeaderView alloc]init];
    headerView.scrollView = commentTableView;
    headerView.delegate = self;
    
    
    noNetworkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight-64)];
    noNetworkView.backgroundColor = RGB(241, 241, 241, 1);
    noNetworkView.hidden = YES;
    [self.view addSubview:noNetworkView];
    
    noNetworkImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noNetwork"]];
    noNetworkImageView.frame = CGRectMake((XKAppWidth-99)/2, (commentTableView.height-132)/2, 99, 132);

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDataFromNetwork)];
    [noNetworkView addGestureRecognizer:tap];
    
    [noNetworkView addSubview:noNetworkImageView];
    
    footerView = [[MJRefreshFooterView alloc]init];
    footerView.scrollView = commentTableView;
    footerView.delegate = self;
    
    [self.view addSubview:commentTableView];
    
}


- (void)initData
{
    [[XKHudHelper instance]showProgressHudAnimationInView:self.view];
    [self loadCommentDataFromnetWork:nil commentType:nil];
}

- (void)loadCommentDataFromnetWork:(NSString *)commentId commentType:(NSString *)type
{
    if (![XKRWUtil isNetWorkAvailable]) {
        [XKRWCui showInformationHudWithText:@"你的网络有点不给力哦, 请检查网络设置"];
        return;
    }
    [self downloadWithTaskID:@"getCommentData"
                  outputTask:^id{
                      return [[XKRWServerPageService sharedService] getCommentDataFromNetworkWithCommentID:commentId commentType:type];
                  }];

}

#pragma --mark Action
- (void) reloadDataFromNetwork{
    commentTableView.hidden = NO;
    [self initData];
}


#pragma mark - Networking

- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"getCommentData"]) {
        if (commentArray.count == 0) {
             [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
             noNetworkView.hidden = NO;
            commentTableView.hidden = YES;
        }
        return;
    }
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"getCommentData"]) {
        XKLog(@"%@",result);
        XKRWIslimCommentModel *islimCommentModel = (XKRWIslimCommentModel *)result;
        if (commentArray.count == 0) {
            commentArray = [NSMutableArray arrayWithArray:islimCommentModel.commentArray];
           [[XKHudHelper instance] hideProgressHudAnimationInView:self.view];
        }else{
            if (isHeadFlash) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:islimCommentModel.commentArray];
                [array addObjectsFromArray:commentArray];
                commentArray  = array;
                [headerView endRefreshing];
            }else{
                [commentArray addObjectsFromArray:islimCommentModel.commentArray];
                [footerView endRefreshing];
            }

        }
        [commentTableView reloadData];
    }
}



#pragma --mark  UItableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [commentArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"commentCell";
    XKRWUserCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (commentCell == nil) {
        commentCell = LOAD_VIEW_FROM_BUNDLE(@"XKRWUserCommentCell");
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    XKRWCommentModel *model = [commentArray objectAtIndex:indexPath.row];
    
    commentCell.userNameLabel.text = model.account;
    commentCell.scoreLabel.text = [NSString stringWithFormat:@"%ld分",(long)model.score];
    XKLog(@"%@",model.data);

    
   commentCell.timeLabel.text = [XKRWUtil dateFormatWithString:model.data format:@"yyyy-MM-dd"];
    
   NSMutableAttributedString *attributestr = [XKRWUtil createAttributeStringWithString:model.commentContent font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:3.5 alignment:NSTextAlignmentLeft];

    commentCell.contentLabel.attributedText = attributestr;

    commentCell.contentLabel.numberOfLines = 0;
    [commentCell.star loadStarCount:model.score];
    
    return commentCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKRWCommentModel *model = [commentArray objectAtIndex:indexPath.row];
    NSMutableAttributedString *attributestr = [XKRWUtil createAttributeStringWithString:model.commentContent font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:6 alignment:NSTextAlignmentLeft];
    
    CGRect rect   =[attributestr  boundingRectWithSize:CGSizeMake(XKAppWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];

    return  rect.size.height+40+44;
    

}

#pragma --mark
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        XKRWCommentModel *model = [commentArray objectAtIndex:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:model.data];
        
        [self loadCommentDataFromnetWork:[NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]] commentType:@"1"];
        isHeadFlash = YES;
    }else
    {
        XKRWCommentModel *model = [commentArray lastObject];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:model.data];
        [self loadCommentDataFromnetWork:[NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]] commentType:@"0"];
        isHeadFlash = NO;
    }


}

// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
   // [refreshView endRefreshing];
}
// 刷新状态变更就会调用
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{


}

- (void)dealloc
{
    [headerView free];
    [footerView free];
    headerView = nil;
    footerView = nil;
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];
  
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
