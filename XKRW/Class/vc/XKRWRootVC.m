//
//  XKRWRootVC.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-12.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWRootVC.h"
#import "XKRWAccountService.h"
#import "XKRWUserDefaultService.h"
#import "XKRWAlgolHelper.h"
#import "XKRWManagementService.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+Helper.h"
#import "XKRWUserService.h"
#import "XKSilentDispatcher.h"
#import "XKRWCui.h"
#import "XKRWCommHelper.h"
#import "XKConfigUtil.h"
#import "XKRWVersionService.h"
#import "XKRWDBControlService.h"
#import "XKRWFatReasonService.h"
#import "OpenUDID.h"
#import "UIImageView+WebCache.h"
#import "XKRWAdService.h"
#pragma --mark  5.0版本 
#import "XKRW-Swift.h"
#import "XKRWTabbarVC.h"

@interface XKRWRootVC ()<UIScrollViewDelegate>
{
    UIScrollView *guidanceScrollView ;
    UIPageControl *pageControl;
}
@property (nonatomic, strong) UIImageView *defaultImgView;
@property (nonatomic, strong) UILabel * VersionLab;
@property (nonatomic, assign) BOOL    adShowed;

@end

@implementation XKRWRootVC

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
    // 每次进入通过版本号等信息执行代码
    [[XKRWVersionService shareService] checkVersion:^BOOL(NSString *currentVersion, BOOL isNewUpdate, BOOL isNewSetUp) {
        // 是否是新安装或者新升级
        if (isNewSetUp || isNewUpdate) {
            [[XKRWDBControlService sharedService] updateDBTable];
            [[XKRWDBControlService sharedService] delete_V5_1_2DirtyData];
        }
        return YES;
    } needUpdateMark:NO];
    
    if (_fromWhich == Appdelegate) {
        [self initADView];
        [self downLoadAdInformation];
    }
}

- (void)downLoadAdInformation {
    [self downloadWithTaskID:@"downloadAD" task:^{
        [[XKRWAdService sharedService] downloadAdvertisementWithPosition:XKRWAdPostionMainPage];
    }];
}

- (BOOL)shouldRespondForDefaultNotificationForDetailName:(NSString *)detailName {
    return YES;
}

-(void) initADView{
    self.defaultImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.defaultImgView.height = XKAppHeight;
    [self.view addSubview:_defaultImgView];
    
    self.VersionLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, XKAppWidth, 20)];
    _VersionLab.text = [NSString stringWithFormat:@"IOS Ver %@", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]];
    _VersionLab.textAlignment = NSTextAlignmentCenter;
    _VersionLab.backgroundColor = [UIColor clearColor];
    _VersionLab.textColor = [UIColor colorFromHexString:@"#666666"];
    _VersionLab.font = [UIFont systemFontOfSize:10];
    _VersionLab.hidden  = YES;
    [self.view addSubview:_VersionLab];
    [self downLoadAdbPic];
}

//广告图下载
- (void) downLoadAdbPic
{
    [XKSilentDispatcher asynExecuteTask:^{
        //下载图片
        @try {
            NSString *pic_url  = [[XKRWAccountService shareService] getHomePagePic];
            if ([pic_url length] == 0 || [pic_url isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ADV_PIC_NAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                NSString *ext = [pic_url pathExtension];
                __block NSString *filename = [NSString stringWithFormat:@"%@.%@",[self stringFromMD5:pic_url],ext];
                __block NSString *localFile = [[NSUserDefaults standardUserDefaults] objectForKey:ADV_PIC_NAME];
                if (![self isFileExist:localFile] || ![localFile isEqualToString:filename]) {
                    //需要下载图片
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        UIImage *image = [UIImage imageWithContentsOfURL:[NSURL URLWithString:pic_url]];
                        if (image) {
                            BOOL isOK = NO;
                            if (!localFile) {
                                localFile = filename;
                            }
                            if ([[ext uppercaseString] isEqualToString:@"PNG"]) {
                                isOK = [UIImagePNGRepresentation(image) writeToFile:[self fileFullPathWithName:localFile] atomically:NO];
                            }else if ([[ext uppercaseString] isEqualToString:@"JPEG"] || [[ext uppercaseString] isEqualToString:@"JPG"]){
                                isOK = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[self fileFullPathWithName:localFile] atomically:NO];
                            }
                            if (isOK) {
                                [[NSUserDefaults standardUserDefaults] setObject:localFile forKey:ADV_PIC_NAME];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            }
                        }
                    });
                }
            }
        }
        @catch (NSException *exception) {
            //
            XKLog(@"获取图片错误");
            
        }
        @finally {
            
        }
    }];
}




-(void) normalFlow {
    _adShowed = YES;
    self.defaultImgView.hidden = YES;
    self.VersionLab.hidden = YES;
    //隐私密码
    /*******
     if(第一次打开){
     引导页，肥胖原因分析
     }else if(是否已经登录 &&  登录信息是否完整 ){
     直接进入主页
     
     }else{
     if(未登录){
     登陆页面
     }
     if(登陆信息不完整){
     重新填写登录信息,保存登陆信息
     }
     }
     *******/
    //如果已经打开过  并且slim.db数据库不存在  执行  进入一分钟减肥
    if ([XKRWCommHelper isFirstOpenThisApp]) {
        NSArray *imageArrays  = @[@"guide1@2x.jpg",@"guide2@2x.jpg",@"guide3@2x.jpg",@"guide4@2x.jpg"];

        // 添加引导页
        guidanceScrollView  = [[XKRWUIScrollViewBase alloc]initWithFrame:CGRectMake(0, 0, XKAppWidth, XKAppHeight)];
        guidanceScrollView.contentSize = CGSizeMake(XKAppWidth*imageArrays.count, XKAppHeight);
        guidanceScrollView.showsHorizontalScrollIndicator = NO;
        guidanceScrollView.showsVerticalScrollIndicator = NO;
        guidanceScrollView.pagingEnabled = YES;
        guidanceScrollView.delegate = self;
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, XKAppHeight-80, XKAppWidth, 30)];
        pageControl.numberOfPages  = imageArrays.count;
        pageControl.pageIndicatorTintColor = XK_ASSIST_LINE_COLOR;
        pageControl.currentPageIndicatorTintColor = XKMainToneColor_29ccb1;
        pageControl.enabled = NO;
        pageControl.frame = CGRectMake(0, XKAppHeight-50, XKAppWidth, 30);
        if (XKAppHeight == 480) {
           
            imageArrays  = @[@"guide1_4s@2x.jpg",@"guide2_4s@2x.jpg",@"guide3_4s@2x.jpg",@"guide4_4s@2x.jpg"];
        }else if(XKAppHeight == 667){
   
            imageArrays  = @[@"guide1@2x.jpg",@"guide2@2x.jpg",@"guide3@2x.jpg",@"guide4@2x.jpg"];
        }else if (XKAppHeight == 568){
  
             imageArrays  = @[@"guide1_5s@2x.jpg",@"guide2_5s@2x.jpg",@"guide3_5s@2x.jpg",@"guide4_5s@2x.jpg"];
        }else{
   
              imageArrays = @[@"guide1@3x.jpg",@"guide2@3x.jpg",@"guide3@3x.jpg",@"guide4@3x.jpg"];
        }
        
        for (int i =0 ; i <[imageArrays count]; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(XKAppWidth*i, 0, XKAppWidth, XKAppHeight)];
            if (i == imageArrays.count - 1) {
                imageView.userInteractionEnabled = YES;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake((XKAppWidth - 150)/2, XKAppHeight- 72, 150, 42);
                button.layer.borderColor =  XKMainToneColor_29ccb1.CGColor;
                button.layer.borderWidth = 1;
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 5;
                [button addTarget:self action:@selector(entryOneMinVC:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"开启瘦身之旅" forState:UIControlStateNormal];
                [button setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [button setBackgroundImage:[UIImage createImageWithColor:XKMainToneColor_29ccb1] forState:UIControlStateHighlighted];
                button.titleLabel.font = XKDefaultFontWithSize(16.f);
                [imageView addSubview:button];
            }
            imageView.image = [UIImage imageNamed:[imageArrays objectAtIndex:i]];
            [guidanceScrollView addSubview:imageView];
        }
        guidanceScrollView.delegate = self;
        [self.view addSubview:guidanceScrollView];
        [self.view addSubview:pageControl];
        return;
    }
    else if([XKRWUserDefaultService isLogin]) {
        if ([[XKRWUserService sharedService] checkUserInfoIsComplete]) {
            
            if (![[XKRWUserService sharedService] getUserNickNameIsEnable]) {
                XKRWModifyNickNameVC *nickVC = [[XKRWModifyNickNameVC alloc] init];
                nickVC.notShowBackButton = YES;
                [self.navigationController pushViewController:nickVC animated:YES];
              
            }else{
                XKRWAppDelegate *appdelegate = (XKRWAppDelegate *)[UIApplication sharedApplication].delegate;
                appdelegate.privacyPasswordVC.isVerified = true;
                XKRWTabbarVC *tabbarVC = [[XKRWTabbarVC alloc] init];
                if (IOS_8_OR_LATER) {
                    [self.navigationController pushViewController:tabbarVC animated:NO];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController pushViewController:tabbarVC animated:NO];
                    });
                }
            }
        }
        else {
            self.navigationController.navigationBarHidden =  NO;
            XKRWFoundFatReasonVC *fatReason = [[XKRWFoundFatReasonVC alloc] initWithNibName:@"XKRWFoundFatReasonVC" bundle:nil];
            fatReason.userfatReasonNoSet = YES;
            if (IOS_8_OR_LATER) {
                [self.navigationController pushViewController:fatReason animated:NO];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:fatReason animated:NO];
                    
                });
            }
        }
        return;
    }
    else if (![XKRWUserDefaultService isLogin])
    {
        self.navigationController.navigationBarHidden =  NO;
        XKRWLoginVC *loginVC = [[XKRWLoginVC alloc]initWithNibName:@"XKRWLoginVC" bundle:nil];
        loginVC.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:loginVC animated:true];
    }
}

- (void) entryOneMinVC:(UIButton *)button
{
    if ([XKRWUserDefaultService isLogin]) {
        [self normalFlow];
    }else{
        guidanceScrollView.hidden = YES;
        [UIView animateWithDuration:1 animations:^(){
            XKRWOneMinUndLoseFat *oneMin = [[XKRWOneMinUndLoseFat alloc]initWithNibName:@"XKRWOneMinUndLoseFat" bundle:nil];
            [self.navigationController  pushViewController:oneMin animated:YES ];
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationItem.hidesBackButton = YES;

    _VersionLab.frame =CGRectMake(0, self.view.bounds.size.height - 35, XKAppWidth, 10);
    if (!_adShowed) {
        NSString *localFile = [[NSUserDefaults standardUserDefaults] objectForKey:ADV_PIC_NAME];
        if ([self isFileExist:localFile]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[self fileFullPathWithName:localFile]];
            [self.defaultImgView setImage:image];
            self.VersionLab.hidden = YES;
        } else {
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_fromWhich == Appdelegate) {
        [XKRWCui showAdImageOnWindow];
        [self performSelector:@selector(normalFlow) withObject:nil afterDelay:5];
        _fromWhich = 0;
    }else{
        [self normalFlow];
    }
}


- (NSString *) stringFromMD5:(NSString *)string{
    
    if(self == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString ;
}

-(BOOL)isFileExist:(NSString *)fileName
{
    if ([fileName length] == 0)
    {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:
            [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
             stringByAppendingPathComponent:fileName]];
}

- (NSString *)fileFullPathWithName:(NSString *)fileName
{
    if ([fileName length] == 0)
    {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (!path){
        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
    }
    
    return path;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/XKAppWidth;
    if ( scrollView.contentOffset.x/XKAppWidth >2 ) {
        pageControl.hidden = YES;
    }else{
        pageControl.hidden = NO;
    }
    pageControl.currentPage = currentPage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end