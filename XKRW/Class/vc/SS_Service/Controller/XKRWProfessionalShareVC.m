//
//  XKRWProfessionalShareVC.m
//  XKRW
//
//  Created by y on 15-1-26.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWProfessionalShareVC.h"
#import "XKColorProgressView.h"
#import "XKRWUserService.h"
#import "UIImageView+WebCache.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"

#import "UMSocialSnsData.h"

#import "UMSocialAccountManager.h"
#import "JYRadarChart.h"

@interface XKRWProfessionalShareVC ()
@property(nonatomic,strong)XKColorProgressView *progressView;
@end

@implementation XKRWProfessionalShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    self.nowDateLabel.text = [self getTodyDateStr:[NSDate date]];
    self.nowDateLabel.textColor =  [UIColor whiteColor];
    
    self.mainScorllView.contentSize = CGSizeMake(XKAppWidth, self.contentView.frame.size.height);
    [self.mainScorllView addSubview:self.contentView];
    
    XKLog(@"mainscrollView %f   %f",self.mainScorllView.frame.size.width,self.mainScorllView.frame.size.height);
    
     XKLog(@"conntentView %f   %f",self.contentView.frame.size.width,self.contentView.frame.size.height);
    self.contentView.backgroundColor   = RGB(244, 244, 246, 1);
    

    
    self.fanrenProView = [[XKColorProgressView alloc]initWithFrame:CGRectMake(59, 440, XKAppWidth-80, 8) initwithColorProgressWidth:160 andColor:RGB(0, 204, 178, 1)];
    [self.contentView addSubview:self.fanrenProView];
    
    self.shoushouProView = [[XKColorProgressView alloc]initWithFrame:CGRectMake(59, 466, XKAppWidth-80, 8) initwithColorProgressWidth:100 andColor:RGB(0, 204, 178, 1)];
    [self.contentView addSubview:self.shoushouProView];
    [self.shoushouProView setSpeedlabelHide:NO];
    self.shoushouProView.SpeedLabel.text = @"加速60天";
   
    self.islimProView = [[XKColorProgressView alloc]initWithFrame:CGRectMake(59, 499, XKAppWidth-80, 8) initwithColorProgressWidth:140 andColor:RGB(0, 204, 178, 1)];
    [self.contentView addSubview:self.islimProView];
    
    [self.islimProView setSpeedlabelHide:NO];
    self.islimProView.SpeedLabel.text = @"加速120天";

    self.userHeadView .layer.cornerRadius = self.userHeadView .width/2.0;
    self.userHeadView .layer.masksToBounds  = YES ;
    self.userHeadView .layer.borderColor = [[UIColor whiteColor]CGColor];
    self.userHeadView .layer.borderWidth = 2 ;
    
    [self.userHeadView  setImageWithURL:[NSURL URLWithString:[[XKRWUserService sharedService]getUserAvatar]] placeholderImage:[UIImage imageNamed:@"lead_nor"]];
    
    self.userNameLabel.text = [[XKRWUserService  sharedService]getUserNickName];
    self.houziImgView.image = [UIImage imageNamed:@"icon_301_2"];
    
    
}

#pragma mark ---显示雷达图 ----
//雷达图
- (void)showRadar:(NSArray *)scoreArray
{
    JYRadarChart * radar = [[JYRadarChart alloc] initWithFrame:CGRectMake(95, 50, 130, 130)];
    
    radar.dataSeries = @[scoreArray];
    radar.steps = 1;
    radar.showStepText = NO;
    
    radar.r = 57;
    //    radar.minValue = 20;
    //    radar.maxValue = 120;
    radar.fillArea = YES;
    radar.colorOpacity = 0.7;
    radar.backgroundFillColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0];
    //    radar.attributes = @[@"Attack", @"Defense", @"Speed", @"HP", @"MP", @"IQ"];
    radar.showLegend = YES;
    [radar setTitles:@[@"archer", @"footman"]];
    [radar setColors:@[RGB(189, 236, 225, 0.7), [UIColor purpleColor]]];
    [self.view addSubview:radar];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 50, 130, 130)];
    
    imageView.image = [UIImage imageNamed:@"radar_"];
    
    [self.view addSubview:imageView];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getTodyDateStr:(NSDate*)date
{
    NSString *str = @"";
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                       fromDate:date];
    //      NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    str =[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    
    return str;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeTheVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)wechatShare:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.tag = 100 ;
    [self fenxiang:btn];
    
}

- (IBAction)pengyouquanShare:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.tag = 101 ;
    [self fenxiang:btn];
    
}

- (IBAction)qqzoneShare:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.tag = 102 ;
    [self fenxiang:btn];
    
}

- (IBAction)weiboShare:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.tag = 103 ;
    [self fenxiang:btn];
}


-(void)fenxiang:(UIButton*)sender
{
    NSData *img = [self imageFromView:self.contentView atFrame:self.contentView.bounds];
    switch (sender.tag)
    {
        case 100: //weixin
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage ;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    XKLog(@"分享成功！");
                }
                else
                {
                    XKLog(@"分享微信好友失败");
                }
            }];
            
            break;
        case 101:  //pengyou
            
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage ;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    XKLog(@"分享成功！");
                }
                else
                {
                    XKLog(@"分享朋友圈失败");
                }
            }];
            
            
            break;
        case 102: //qqkongjian
            
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"瘦瘦分享" image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    XKLog(@"分享成功！");
                }
            }];
            
            break;
        case 103: //weibo
            XKLog(@"开始 分享图片导微博");
        {
            
            [self initWeiboShare:[UIImage imageWithData:img]];
        }
            
            break;
        default:
            break;
    }
    
    
}

- (NSData *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(theView.frame.size.width, theView.frame.size.height),theView.opaque, 0.0);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    return dataImage;
}


-(void)initWeiboShare:(UIImage*)img
{
    
    bg = [[UIView alloc]initWithFrame:self.view.bounds ];
    bg.backgroundColor = RGB(0, 0, 0, 0.5);
    [self.view addSubview:bg];
    
    UIView *whiteBg = [[UIView alloc]initWithFrame:CGRectMake(25, 50, 270, XKAppHeight - 170)];
    //    whiteBg.layer.cornerRadius = 6 ;
    //    whiteBg.layer.masksToBounds = YES;
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.tag = 4 ;
    
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:whiteBg.bounds byRoundingCorners:UIRectCornerTopLeft |UIRectCornerTopRight cornerRadii:CGSizeMake(9, 9)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = whiteBg.bounds;
    maskLayer1.path = maskPath1.CGPath;
    whiteBg.layer.mask = maskLayer1;
    [bg addSubview:whiteBg];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(whiteBg.frame.size.width/2.0 - (img.size.width *0.6)/4.0 ,15 ,img.size.width *0.6*0.5 ,img.size.height*0.6 *0.5)];
    if (IPHONE4S_DEVICE)
    {
        imgView.frame = CGRectMake(whiteBg.frame.size.width/2.0 - (img.size.width *0.48)/4.0 ,15 ,img.size.width *0.24 ,img.size.height*0.24);
    }
    [whiteBg addSubview:imgView];
    
    imgView.image = img;
    shareImg = [img copy];
    
    infoTextf= [[UITextField alloc]initWithFrame:CGRectMake(10, imgView.bottom+5, 238, 24)];
    infoTextf.delegate = self ;
    infoTextf.keyboardType = UIKeyboardTypeDefault;
    infoTextf.placeholder = @"说点什么吧";
    [whiteBg addSubview:infoTextf];
    infoTextf.textColor = colorSecondary_666666;
    infoTextf.font = XKDefaultFontWithSize(14);
    
    infoTextf.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"textinfo"]];
    infoTextf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(XKAppWidth/2.0 -135, whiteBg.bottom+ 0.5, 135, 44) ;
    [cBtn setBackgroundImage:[UIImage imageNamed:@"sharequxiaoN"] forState:UIControlStateNormal];
    [cBtn setBackgroundImage:[UIImage imageNamed:@"sharequxiao"] forState:UIControlStateHighlighted];
    [cBtn addTarget:self action:@selector(cancelShare:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:cBtn];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(XKAppWidth/2.0  + 0.5, whiteBg.bottom+ 0.5, 135, 44) ;
    [share setBackgroundImage:[UIImage imageNamed:@"buttonShare"] forState:UIControlStateNormal];
    [share setBackgroundImage:[UIImage imageNamed:@"buttonShare_p"] forState:UIControlStateHighlighted];
    [share addTarget:self action:@selector(shareWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:share];
    
    //    [self exChangeOut:bg dur:0.25];
    
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

- (void)shareSuccess
{
    [[[UIAlertView alloc] initWithTitle:@"分享成功"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"知道了"
                      otherButtonTitles:nil] show];
    [bg removeFromSuperview];
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


@end
