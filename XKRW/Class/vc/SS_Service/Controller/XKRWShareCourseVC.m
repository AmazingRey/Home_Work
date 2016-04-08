//
//  XKRWShareCourseVC.m
//  XKRW
//
//  Created by Jack on 15/6/24.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWShareCourseVC.h"
#import "XKRWShareCourseService.h"
#import "XKRWUserService.h"
#import "NZLabel.h"
#import "XKRWUserService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsData.h"
#import "UMSocialAccountManager.h"
#import "XKRWShareActionSheet.h"
#import "UIImageView+WebCache.h"

#import "WXApi.h"
#import <YouMeng/umeng_ios_social_sdk_4.2.5_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApiInterface.h>

#import "XKRWUserService.h"


@interface XKRWShareCourseVC ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *bg;
    UIView *shareImg;
    UITextField *infoTextf;
    
    NSString *famousPerson;
    NSString *famousRemark;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImage;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avaterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewConstraint;

@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *remarkScrollView;

@property (nonatomic,strong)NSMutableArray *imageMutArray;//图片
@property (nonatomic,strong)NSMutableArray *remarkMutArray;//名言

@end

@implementation XKRWShareCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _leftArrowImage.hidden = YES;
    [XKRWCui showProgressHud:@"加载中..."];
    [self downloadWithTaskID:@"getShareData" outputTask:^id{
        return [[XKRWShareCourseService sharedService] getDataFromServer];
    }];
    [self initView];
}


-(void)initView{
    
    self.predictLoseWeightLabel.text = [self.loseWeightString substringWithRange:NSMakeRange(0, self.loseWeightString.length-1)];
    self.daysLabel.text = [NSString stringWithFormat:@"%ld", (long)self.registDays];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _nickLabel.textColor = XK_TEXT_COLOR;
    _nickLabel.font = XKDefaultFontWithSize(14);
    
    _headImg.layer.cornerRadius = 23.5;
    _headImg.layer.masksToBounds = YES;
    
    _imageScrollView.delegate = self;
    
    [_headImg setImageWithURL:[NSURL URLWithString:[[XKRWUserService sharedService]getUserAvatar ]] placeholderImage:[UIImage imageNamed:@"lead_nor"] options:SDWebImageRetryFailed];
    
    _nickLabel.text = [[XKRWUserService sharedService]getUserNickName].length==0?@"昵称":[[XKRWUserService sharedService]getUserNickName];
    
    XKLog(@"-----%f",XKAppHeight);
    
    if (XKAppHeight <= 480) {
        _imageScrollViewConstraint.constant = 10;
        _avaterConstraint.constant = 30;
    }else if(XKAppHeight == 568){
        _imageScrollViewConstraint.constant = 40;
        _avaterConstraint.constant = 40;
    }else if (XKAppHeight == 667){
        _imageScrollViewConstraint.constant = 50;
        _avaterConstraint.constant = 50;
    }
    else{
        _avaterConstraint.constant = 60;
        _imageScrollViewConstraint.constant = 60;
    }
    
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        self.wechatButton.hidden = YES;
        self.wechatGroupButton.hidden = YES;
    }
    if (![QQApiInterface isQQInstalled] || ![QQApiInterface isQQSupportApi]) {
        
        self.qqButton.hidden = YES;
    }
    
    NSMutableArray *imageNames = [[NSMutableArray alloc] init];
    
    if ([WXApi isWXAppInstalled]) {
        [imageNames addObject:@"weixin"];
        [imageNames addObject:@"weixinpengypou"];
    }
    if ([QQApiInterface isQQInstalled]) {
        
        [imageNames addObject: @"qqzone"];
    }
    [imageNames addObject:@"weibo"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *name in imageNames) {
        [images addObject:[UIImage imageNamed:name]];
    }

    
    
    XKRWShareActionSheet *actionSheetView = [[XKRWShareActionSheet alloc]initWithButtonImages:images clickButtonAtIndex:^(NSInteger index) {
         NSData *imageData = [self imageFromView:self.view atFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        NSString *name = imageNames[index];
        
        if ([name isEqualToString:@"weixin"]) {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage ;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    XKLog(@"分享成功!");
                    [self shareSuccess];
                }
                else
                {
                    XKLog(@"分享微信好友失败");
                }
            }];

        }else if ([name isEqualToString:@"weixinpengypou"]){
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage ;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    XKLog(@"分享成功！");
                    [self shareSuccess];
                }
                else
                {
                    XKLog(@"分享朋友圈失败");
                }
            }];
        }else if ([name isEqualToString:@"qqzone"]){
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [UMSocialData defaultData].extConfig.qzoneData.title = @"瘦瘦分享";
            [UMSocialData defaultData].extConfig.qzoneData.url = @"ss.xikang.com";
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"瘦瘦分享" image:imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    XKLog(@"分享成功！");
                    [self shareSuccess];
                }
            }];

        }else if ([name isEqualToString:@"weibo"]){
            [self initWeiboShare:[UIImage imageWithData:imageData]];
        }
    }];
    actionSheetView.frame = CGRectMake(0, XKAppHeight-64, XKAppWidth, 64);
    [self.view addSubview:actionSheetView];
}


#pragma --mark  网络处理
- (void)didDownloadWithResult:(id)result taskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    if ([taskID  isEqual: @"getShareData"]) {
        _imageMutArray = [result objectForKey:@"imageurl"];
        _remarkMutArray = [result objectForKey:@"famous"];
        
        _imageScrollView.contentSize = CGSizeMake(XKAppWidth*_imageMutArray.count, _imageScrollView.height);
        for (int i=0; i<_imageMutArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XKAppWidth*i, 0, XKAppWidth, _imageScrollView.height)];
            
            [imageView setImageWithURL:[NSURL URLWithString:[_imageMutArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"sportsdetails_normal"] options:SDWebImageRetryFailed];
            [_imageScrollView addSubview:imageView];
        }
        
        _remarkScrollView.contentSize = CGSizeMake(XKAppWidth*_remarkMutArray.count, _remarkScrollView.height);
        
        for (int i = 0 ; i < _remarkMutArray.count; i++) {
            NSDictionary *dic = [_remarkMutArray objectAtIndex:i];
  
            famousPerson = [dic objectForKey:@"author"];
            famousRemark = [dic objectForKey:@"content"];
            
            UILabel *famousRemarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+i*XKAppWidth, (_remarkScrollView.height-80)/2, XKAppWidth-60, 60)];
            famousRemarkLabel.numberOfLines = 0;
            NSMutableAttributedString *attributedString=  [XKRWUtil createAttributeStringWithString:famousRemark font:XKDefaultMINISongFontWithSize(18) color:[UIColor blackColor] lineSpacing:7 alignment:NSTextAlignmentCenter];
            famousRemarkLabel.textAlignment = NSTextAlignmentCenter;
            famousRemarkLabel.attributedText = attributedString;
            [_remarkScrollView addSubview:famousRemarkLabel];
            
            UILabel *famousPersonLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+i*XKAppWidth, famousRemarkLabel.bottom, XKAppWidth-60, 20)];
            famousPersonLabel.textAlignment = NSTextAlignmentRight;
            
            UIFont *font = XKDefaultMINISongFontWithSize(18);
            famousPersonLabel.font =font ;
            famousPersonLabel.text = [NSString stringWithFormat:@"--%@",famousPerson];
            [_remarkScrollView addSubview:famousPersonLabel];
        }
        
        if(_remarkMutArray.count >= 2 && [[XKRWShareCourseService sharedService]shareCourseVCNeedSlide])
        {
            [UIView animateWithDuration:0.5 animations:^{
                _remarkScrollView.contentOffset = CGPointMake(XKAppWidth / 2, 0);
            } completion:^(BOOL finished) {
                
                [UIView  animateWithDuration:0.5 delay:1 options:0 animations:^{
                    _remarkScrollView.contentOffset = CGPointMake(0, 0);
                } completion:nil];

                [[XKRWShareCourseService sharedService]setShareCourseHaveSlide];
            }];
        }
    }
}


- (void)handleDownloadProblem:(id)problem withTaskID:(NSString *)taskID
{
    [XKRWCui hideProgressHud];
    XKLog(@"获取信息失败");
}

- (BOOL)shouldRespondForDefaultNotification:(XKDefaultNotification *)notication
{
    return YES;
}

#pragma mark - 截图分享
- (NSData *)imageFromView:(UIView *)view   atFrame:(CGRect)rect
{
    [self.closeButton setHidden:YES];
    [self.leftArrowImage setHidden:YES];
    [self.rightArrowImage setHidden:YES];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(XKAppWidth , XKAppHeight-64),view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    
    [self.closeButton setHidden:NO];
    [self.leftArrowImage setHidden:NO];
    [self.rightArrowImage setHidden:NO];
    
    return dataImage;
}

- (void)shareWeibo:(UIButton*)btn
{
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:infoTextf.text image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            XKLog(@"分享成功！");
            
            [self performSelectorOnMainThread:@selector(shareSuccess) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [XKRWCui showInformationHudWithText:@"微博分享失败!"];
        }
    }];
    
}

-(void)cancelShare:(UIButton*)btn
{
    [bg removeFromSuperview];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


-(void)initWeiboShare:(UIImage*)img
{
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
    bg.backgroundColor = RGB(0, 0, 0, 0.5);
    [self.view addSubview:bg];
    
    UIView *whiteBg = [[UIView alloc]initWithFrame:CGRectMake(25, 50, XKAppWidth-50, XKAppHeight - 140)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.tag = 4;
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:whiteBg.bounds byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight cornerRadii:CGSizeMake(9, 9)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = whiteBg.bounds;
    maskLayer1.path = maskPath1.CGPath;
    whiteBg.layer.mask = maskLayer1;
    [bg addSubview:whiteBg];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(whiteBg.frame.size.width/2.0 - (img.size.width *0.8)/4.0 ,0 ,img.size.width *0.8*0.5 ,img.size.height*0.8 *0.5)];
    if (IPHONE4S_DEVICE)
    {
        imgView.frame = CGRectMake(whiteBg.frame.size.width/2.0 - (img.size.width *0.35)/2.0 ,15 ,img.size.width *0.35 ,img.size.height*0.35);
    }
    [whiteBg addSubview:imgView];
    
    imgView.image = img;
    shareImg = [img copy];
    
    infoTextf= [[UITextField alloc]initWithFrame:CGRectMake(imgView.left, imgView.bottom - 10, imgView.width, 30)];
    
    if (IPHONE4S_DEVICE)
    {
        infoTextf.frame = CGRectMake(imgView.left, imgView.bottom , imgView.width, 30);
    }
    infoTextf.delegate = self;
    infoTextf.keyboardType = UIKeyboardTypeDefault;
    infoTextf.placeholder = @"说点什么吧";
    
    infoTextf.textColor = colorSecondary_666666;
    infoTextf.font = XKDefaultFontWithSize(14);
    [whiteBg addSubview:infoTextf];
    
    infoTextf.borderStyle = UITextBorderStyleRoundedRect;
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.backgroundColor = [UIColor whiteColor];
    cBtn.frame = CGRectMake(whiteBg.left, whiteBg.bottom+ 0.5, (XKAppWidth-50)/2, 44) ;
    [cBtn setImage:[UIImage imageNamed:@"sharequxiaoN"] forState:UIControlStateNormal];
    [cBtn setImage:[UIImage imageNamed:@"sharequxiao"] forState:UIControlStateHighlighted];
    [cBtn addTarget:self action:@selector(cancelShare:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:cBtn];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.backgroundColor = [UIColor whiteColor];
    share.frame = CGRectMake(XKAppWidth/2.0  + 0.5, whiteBg.bottom+ 0.5, (XKAppWidth-50)/2, 44) ;
    [share setImage:[UIImage imageNamed:@"buttonShare"] forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"buttonShare_p"] forState:UIControlStateHighlighted];
    [share addTarget:self action:@selector(shareWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:share];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 110 - (self.view.frame.size.height - 216.0-30);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [infoTextf resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == bg  || view == [bg viewWithTag:4]) {
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        
        [infoTextf resignFirstResponder];
    }
}

#pragma mark - 触发事件

- (IBAction)closeThePage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareSuccess
{
    [[[UIAlertView alloc] initWithTitle:@"分享成功"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"知道了"
                      otherButtonTitles:nil] show];
    [bg removeFromSuperview];
    
    [self downloadWithTask:^{
        [[XKRWUserService sharedService] addExpWithType:XKRWExpTypeProgress];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x/XKAppWidth +1 == [_imageMutArray count]) {
        _rightArrowImage.hidden = YES;
        _leftArrowImage.hidden = NO;
    }else{
        _rightArrowImage.hidden = NO;
    }
    
    
    if (scrollView.contentOffset.x/XKAppWidth == 0) {
        _rightArrowImage.hidden = NO;
        _leftArrowImage.hidden = YES;
    }else{
         _leftArrowImage.hidden = NO;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
