//
//  XKRWDetailBuyRecordVC.m
//  XKRW
//
//  Created by y on 15-1-14.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWDetailBuyRecordVC.h"
#import "XKRWStarView.h"
#import "XKRWOrderService.h"
#import "XKHudHelper.h"
@interface XKRWDetailBuyRecordVC ()<getStarCountDelegate>
{
    XKRWStarView  *star;
    __weak IBOutlet UIButton *confimButton;
}
@end

@implementation XKRWDetailBuyRecordVC
@synthesize orderRecordEntity;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNaviBarBackButton];
    [self setTitle:@"评分"];
    self.starNumLabel.textColor =  [UIColor redColor];
    
    self.evLabel.textColor = colorSecondary_666666;
    self.evLabel.font = XKDefaultFontWithSize(16);
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    line1.backgroundColor = RGB(227, 227, 227, 1);
    [self.contentView addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, XKAppWidth, 0.5)];
    line2.backgroundColor = RGB(227, 227, 227, 1);
    [self.contentView addSubview:line2];
    
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, XKAppWidth, 0.5)];
    line3.backgroundColor = RGB(227, 227, 227, 1);
    [self.contentView addSubview:line3];
    
    star = [[XKRWStarView alloc]initWithFrame:CGRectMake(60, 10, 160, 20) withColorCount:0 isEnable:YES isUserComment:NO];
    [star loadStarCount:[orderRecordEntity.evaluateScore integerValue]];

    [self.contentView addSubview:star];
    star.delegate = self ;
    
    self.contentTextView.delegate  =self ;
    
    [self.contentTextView setTextColor:XK_ASSIST_TEXT_COLOR];
    
    if ([orderRecordEntity.content  isEqualToString:@""]) {
         self.contentTextView.text = @"请留下你的评价";
    }
    else
    {
        self.contentTextView.text  =  orderRecordEntity.content;
    }
    
    if(orderRecordEntity.evaluateScore.length == 0 )
    {
        self.starNumLabel.text =@"0分";
    }
    else
    {
        self.starNumLabel.text = [NSString stringWithFormat:@"%@分",orderRecordEntity.evaluateScore];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.contentView addGestureRecognizer:tapGesture];
    
    
    UIView * topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    topline.backgroundColor = XKSepDefaultColor;
    UIView * bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, confimButton.height-.5, XKAppWidth, 0.5)];
    bottomline.backgroundColor = XKSepDefaultColor;
    [confimButton addSubview:topline];
    [confimButton addSubview:bottomline];
    [confimButton setBackgroundImage:[UIImage createImageWithColor:RGB(217, 217, 217, 1)] forState:UIControlStateHighlighted];
}

#pragma  --mark Action

-(void)getStarCount:(NSInteger)count
{
    self.starNumLabel.text = [NSString stringWithFormat:@"%ld分",(long)count];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if ([_contentTextView isFirstResponder]) {
        [_contentTextView resignFirstResponder];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
   
    if([textView.text isEqualToString:@"请留下你的评价"])
    {
        textView.text = @"";
    }
    [textView setTextColor:XK_TITLE_COLOR];

    return YES;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 120 && ![text isEqualToString:@""]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder]; return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)senderAppraise:(id)sender {
    
    if ([XKUtil isNetWorkAvailable]) {
        [MobClick event:@"clk_AddReview"];
        NSString *score =  [self.starNumLabel.text stringByReplacingOccurrencesOfString:@"分" withString:@""];
        NSString *comment  = self.contentTextView.text;
        if (self.contentTextView.text .length == 0 || [self.contentTextView.text isEqualToString:@"请留下你的评价"] )
        {
             [XKRWCui showInformationHudWithText:@"请填写评论"];
            return;
        }
        NSString *trade_id  = orderRecordEntity.orderNo;
        
        NSDictionary *pagams =  @{@"score": score,
                                  @"comment":comment,
                                  @"trade_id":trade_id};
        [XKRWCui showProgressHud:@"评分提交中..."];
        XKDispatcherOutputTask block = ^(){
            return [[XKRWOrderService sharedService] userAppraiseByDic:pagams];
        };
        
        [self downloadWithTaskID:@"appraise" outputTask:block];
        
    }
    
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
    
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID  isEqualToString:@"appraise"])
    {
        XKLog(@"当前 评论 回调 %@",result);
        if([result objectForKey:@"success"])
        {
            if ([[[result objectForKey:@"data"] objectForKey:@"code"] isEqualToString:@"0"]  )
            {
                XKLog(@"ok");
                //保存购买信息
                
                orderRecordEntity.content = self.contentTextView.text ;
                orderRecordEntity.evaluateScore  =  [self.starNumLabel.text stringByReplacingOccurrencesOfString:@"分" withString:@""];
                
                [[XKRWOrderService sharedService]saveTheRecord:orderRecordEntity];
                
                [XKRWCui hideProgressHud];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }

    }
    
}

-(void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    [[XKHudHelper instance]showInformationHudWithText:@"评分提交失败"];
}









@end
