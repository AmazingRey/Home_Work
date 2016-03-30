//
//  XKRWHelpCenterVC.m
//  XKRW
//
//  Created by y on 15-1-20.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWHelpCenterVC.h"
#import "XKRWOrderService.h"
#import "DatePickerView.h"
#import "XKRWOrderRecordEntity.h"

@interface XKRWHelpCenterVC ()<DatePickerViewDelegate>
{
    CGPoint contentOffSet;
}
@property (weak, nonatomic) IBOutlet UIButton *confimButton;
@end

@implementation XKRWHelpCenterVC
@synthesize orderLabel;



-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mainScrollView.contentSize = CGSizeMake(XKAppWidth, 1000);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [MobClick event:@"in_PayHelp"];
    [self addNaviBarBackButton];
    [self setTitle:@"帮助中心"];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, 0.5)];
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, 50.5, XKAppWidth, 0.5)];
    topline.backgroundColor = XKSepDefaultColor;
    bottomline.backgroundColor = XKSepDefaultColor;
    [self.confimButton addSubview:topline];
    [self.confimButton addSubview:bottomline];
    [self.confimButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
    [self.confimButton setBackgroundImage:[UIImage createImageWithColor:RGB(207, 207, 207, 1)] forState:UIControlStateHighlighted];

    readDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self readOrderData];
    
    NSLog(@"高度1111 %f",self.connectView.frame.size.height );
    
    self.mainScrollView.scrollEnabled = YES ; 
    self.mainScrollView.contentSize = CGSizeMake(XKAppWidth, 1000);
    contentOffSet = CGPointMake(0, 0);
    
    self.OrderID.userInteractionEnabled = YES;
    
    orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.OrderID.frame.size.width, self.OrderID.frame.size.height)];
    [self.OrderID addSubview:orderLabel];

    
    orderLabel.userInteractionEnabled = YES ;
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDataView)];
    tap.numberOfTapsRequired = 1 ;
    [orderLabel addGestureRecognizer:tap];
    
    self.userAddress.font = XKDefaultFontWithSize(14);
    self.userAddress.keyboardType = UIKeyboardTypeNumberPad;
    
    self.userAddress.delegate = self;
    self.userAddress.leftViewMode =  UITextFieldViewModeAlways;

    [self.userAddress isFirstResponder];
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    self.contentTextView.delegate  = self;
    self.contentTextView.font = XKDefaultFontWithSize(14);
   NSMutableAttributedString *saftAttributedStr= [XKRWUtil createAttributeStringWithString:@"移动支付会通过密钥、安全插件、手机短信验证码、风险控制等技术手段来效验使用者身份,保证您的资金安全." font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:7 alignment:NSTextAlignmentLeft];
    _safetyDescribeLabel.attributedText = saftAttributedStr;
    
    NSMutableAttributedString *failAttributedStr= [XKRWUtil createAttributeStringWithString:@"此问题是由于网络不稳定或者第三方支付不稳定导致，建议您更换一种支付方式进行尝试。您还可以点击“更多”-“意见反馈”向我们反馈您遇到的问题，会安排技术人员进行排查。" font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:7 alignment:NSTextAlignmentLeft];
    _failDescribeLabel.attributedText = failAttributedStr;
    
    
     NSMutableAttributedString *attributedStr= [XKRWUtil createAttributeStringWithString:@"2.支付过程中跳转失败或者提示系统繁忙、初始化失败等错误。" font:XKDefaultFontWithSize(16.f) color:XK_TITLE_COLOR lineSpacing:8 alignment:NSTextAlignmentLeft];
    _failLabel.attributedText = attributedStr;
    
     NSMutableAttributedString *describeAttributedStr= [XKRWUtil createAttributeStringWithString:@"付款遇到其他问题了？别着急，请留下您的问题，我们收到问题会在第一时间联系您。" font:XKDefaultFontWithSize(14.f) color:XK_TEXT_COLOR lineSpacing:7 alignment:NSTextAlignmentLeft];
    _describeLabel.attributedText = describeAttributedStr;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    
    
    [self.mainScrollView addGestureRecognizer:tapGesture];
    
    
}

-(void)popDataView
{
    
    [self tapAction];
    
    if (readDataArray.count == 0)
    {
        [XKRWCui showInformationHudWithText:@"暂时没发现您的订单，请先购买吧！"];
    }
    else
    {
        
        DatePickerView *picker = LOAD_VIEW_FROM_BUNDLE(@"DatePickerView");
        [picker initSubviewsWithStyle:DatePickerStyleSinglePicker
                        andDatasource:readDataArray
                               andObj:@"订单"];
        picker.delegate   = self;
        picker.identifier = @"订单";
        picker.tag = 1234;
        [picker addToWindow];

    }
}

- (void)tapAction
{
    if ([_userAddress isFirstResponder]) {
        [_userAddress resignFirstResponder];
    }
    
    if ([_OrderID isFirstResponder]) {
        [_OrderID resignFirstResponder];
    }
    
    if ([_contentTextView isFirstResponder]) {
        [_contentTextView resignFirstResponder];
    }
    
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark - DatePicker's Delegate

- (void)clickConfirmButton:(DatePickerView *)picker postSelected:(NSString *)string
{
  //  self.orderLabel.text = string ;
    _OrderID.text = string;
}

- (void)clickCancelButton:(DatePickerView *)picker {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    [self animateView:textField up:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


- (void) animateView: (UIView*) view up: (BOOL) up
{
    int movementDistance;

    if (view.tag == 1000) {
        
        if(self.view.height  > 480)
            movementDistance = 200;
        else
            movementDistance = 330;
        
    }else if (view.tag == 1001){
        if(self.view.height  > 480)
            movementDistance = 370;
        else
            movementDistance = 440;
    }
   
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    contentOffSet = CGPointMake(0, -movement);
    self.mainScrollView.contentOffset = contentOffSet;
    
    [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userAddress resignFirstResponder];
    
    [self.OrderID resignFirstResponder];
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _detailLabel.hidden = NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _detailLabel.hidden = YES;
    [self animateView:textView up:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.OrderID) {
        // 四位加一个空格
//        if ([string isEqualToString:@""]) { // 删除字符
//            if ((textField.text.length - 2) % 5 == 0) {
//                textField.text = [textField.text substringToIndex:textField.text.length - 1];
//            }
//            return YES;
//        } else {
//            if (textField.text.length % 5 == 0) {
//                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
//            }
//        }
//        return YES;
    }
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



- (IBAction)submit:(id)sender {
    
    if ([XKUtil isNetWorkAvailable]) {
        
        if (_OrderID.text.length == 0) {
            [XKRWCui showInformationHudWithText:@"请选择您的订单"];
            return;
        }
        
        if (self.userAddress.text .length == 0  )
        {
            [XKRWCui showInformationHudWithText:@"请填写您的手机号码"];
            return;
        }
        NSLog(@"coin你   %@",self.contentTextView.text);
        if (self.contentTextView.text.length == 0 )
        {
            [XKRWCui showInformationHudWithText:@"请填写您的描述建议等.."];
            return;
        }
        
        NSString *content = self.contentTextView.text;
        NSString *phone  = self.userAddress.text;
        
        NSString *trade_id  =  [self OrderNoByChoose:self.OrderID.text];
        
        NSDictionary *pagams =  @{@"content": content,
                                  @"phone":phone,
                                  @"trade_id":trade_id};
        
        [XKRWCui showInformationHudWithText:@"提交中"];
        XKDispatcherOutputTask block = ^(){
            return [[XKRWOrderService sharedService] getUserAdviceByDic:pagams];
        };
        
        [self downloadWithTaskID:@"userHelp" outputTask:block];
        
    }
}

//根据选择  找出订单id号
-(NSString *)OrderNoByChoose:(NSString*)choose
{
    NSString *str = @"";
    NSString *date = [choose substringToIndex:11];
    NSInteger uid = [[XKRWUserService sharedService]getUserId];
    NSMutableArray *array = [[XKRWOrderService sharedService]readUserOrderRecordByUid:uid];
    for (XKRWOrderRecordEntity *entity in array)
    {

        if (entity.orderDate.length > 0 && [entity.orderDate rangeOfString:date].length > 0   ) {
            
            return entity.orderNo;
            break;
        }
    }
    return str;
    
}

//读取数据 订单号
-(void)readOrderData
{
     NSInteger uid = [[XKRWUserService sharedService]getUserId];
     NSMutableArray *Array = [[XKRWOrderService sharedService]readUserOrderRecordByUid:uid];
    
    for (int i = 0 ; i < Array.count; i++)
    {
        
        XKRWOrderRecordEntity *entity = [Array objectAtIndex:i];
        NSRange range = {5,11};
        NSString  *time = [entity.orderDate substringWithRange:range];
        time = [NSString stringWithFormat:@"%@",time];
        NSString * str = [NSString stringWithFormat:@"%@ %@",time,entity.orderProductName];
        [readDataArray addObject:str];
        
    }
    
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
    
}

- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"userHelp"])
    {
        [XKRWCui  hideProgressHud];
        if ([[result objectForKey:@"success"]integerValue] == 1) {
            [self.navigationController  popViewControllerAnimated:YES];
        }else{
            [XKRWCui showInformationHudWithText:@"提交失败，请稍后再试！"];
        }
        
        
    }
}

-(void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    if ([taskID isEqualToString:@"userHelp"]) {
        [XKRWCui hideProgressHud];
        [XKRWCui showInformationHudWithText:@"提交失败，请稍后再试！"];
    }
}



@end
