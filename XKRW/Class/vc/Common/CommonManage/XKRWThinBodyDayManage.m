//
//  XKRWThinBodyDayManage.m
//  XKRW
//
//  Created by 忘、 on 16/4/1.
//  Copyright © 2016年 XiKang. All rights reserved.
//  瘦身天数管理

#import "XKRWThinBodyDayManage.h"
#import "XKRWAlgolHelper.h"
#import "XKRWUserService.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "XKRW-Swift.h"

static XKRWThinBodyDayManage * shareInstance;


@implementation XKRWThinBodyDayManage
{
    XKRWBaseVC *viewController;
}

+(instancetype)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWThinBodyDayManage alloc]init];
    });
    return shareInstance;
}

- (void)viewWillApperShowFlower:(XKRWBaseVC *) vc{
    viewController = vc;
    if( [[NSUserDefaults  standardUserDefaults] boolForKey:@"ShowImageOnWindow"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((XKAppWidth - 210) / 2, (XKAppHeight - 210) / 2, 210, 210)];
        imageView.image = [UIImage imageNamed:@"pop_daily"];
        [imageView addSubview:[self setShowImageViewLabel]];
        if([XKRWAlgolHelper remainDayToAchieveTarget] > -1){
            [viewController popUpTheTipViewOnWindowAsUserFirstTimeEntryVC:[[UIApplication sharedApplication] delegate].window andImageView:imageView andShowTipViewTime:3 andTimeEndBlock:^(UIView *backgroundView, UIImageView *imageView) {
                [imageView removeFromSuperview];
                [backgroundView removeFromSuperview];
            }];
        }
        
        if ([XKRWAlgolHelper remainDayToAchieveTarget] == -1 &&[XKRWAlgolHelper expectDayOfAchieveTarget] != nil) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"lateToResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]]){
                [self ShowEndOfTheSchemeAlert:[XKRWAlgolHelper remainDayToAchieveTarget]];
            }
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowImageOnWindow"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"ShowWindowFlower_%ld",(long)[[XKRWUserService sharedService] getUserId]]]){
        [self showFlowerInWindow];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"ShowWindowFlower_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



- (UILabel *)setShowImageViewLabel {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,145,200,50)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attributed ;
    
    if ([XKRWAlgolHelper expectDayOfAchieveTarget] == nil){
        attributed = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"蜕变之路\n第%ld天",(long)[[XKRWUserService sharedService] getInsisted]] attributes:@{NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XKMainToneColor_29ccb1}];
    
    }else {
        if ([XKRWAlgolHelper remainDayToAchieveTarget] > 99){
            NSInteger day ;
            if ([XKRWAlgolHelper expectDayOfAchieveTarget] == nil) {
                day = [[XKRWUserService sharedService ]getInsisted ];
            }else{
                day = [XKRWAlgolHelper newSchemeStartDayToAchieveTarget];
            }
            attributed = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"蜕变之路\n第%ld天",(long)[[XKRWUserService sharedService] getInsisted]] attributes:@{NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XKMainToneColor_29ccb1}];
        }else if ([XKRWAlgolHelper remainDayToAchieveTarget] <= 99 && [XKRWAlgolHelper remainDayToAchieveTarget] != 0){
            attributed = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"将在%ld天后\n完成蜕变",(long)[XKRWAlgolHelper remainDayToAchieveTarget]] attributes:@{NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XKMainToneColor_29ccb1}];
        }else{
            attributed = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"将在明天\n完成蜕变"] attributes:@{NSFontAttributeName:XKDefaultFontWithSize(15),NSForegroundColorAttributeName:XKMainToneColor_29ccb1}];
        }
    
    }
    textLabel.attributedText = attributed;
    return textLabel;
}



- (void)endOfTheUserScheme {
    UIAlertView * alertView =  [[UIAlertView alloc ] initWithTitle:@"方案的预期天数已结束" message:@"是否达到目标体重？" delegate:self cancelButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"完成目标%.1f啦",[[XKRWUserService sharedService] getUserDestiWeight]/1000.f], @"没有完成，重新制定方案", nil];
    alertView.tag = 10001 ;
    [alertView show];
}

- (void)ShowEndOfTheSchemeAlert:(NSInteger )needDay{
    if (needDay <=0 ){
        [self endOfTheUserScheme];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001){
        if (buttonIndex == 0){
            [MobClick event:@"clk_finish"];
            [self showFlowerInWindow];
        }else if (buttonIndex == 1){
            [XKRWCui showProgressHud:@"重置用户减肥方案中..."];
            [MobClick event:@"clk_unfinished"];
            [[XKRWSchemeService_5_0 sharedService] resetUserScheme:viewController];
        }
        return ;
    }
    
    if (alertView.tag == 10002){
        if (buttonIndex == 0){
            [XKRWCui showProgressHud:@"重置用户减肥方案中..."];
            [[XKRWSchemeService_5_0 sharedService] resetUserScheme:viewController];
        }
    }
    
    if (alertView.tag == 10003){
        if (buttonIndex == 0){
            
        }else if (buttonIndex == 1){
            [MobClick event:@"clk_Rest1"];
            [XKRWCui showProgressHud:@"重置用户减肥方案中..."];
            [[XKRWSchemeService_5_0 sharedService] resetUserScheme:viewController];
        }
        
    }
}

- (void) showFlowerInWindow {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"needResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
   
    
    UIWindow *window=  [[UIApplication sharedApplication].delegate window];
    UIView * backgroundView = [[UIView alloc]initWithFrame:window.bounds];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [window addSubview:backgroundView];
 
    
    NSMutableParagraphStyle *paragraphStyle =  [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5 ;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"恭喜你达成目标体重\n继续开始新的征程吧" attributes:@{NSParagraphStyleAttributeName:paragraphStyle} ];
    
    [attributedString addAttributes:@{NSFontAttributeName:XKDefaultFontWithSize(16),NSForegroundColorAttributeName:XKMainToneColor_29ccb1} range:NSMakeRange(0, 9)];
    
    [attributedString addAttributes:@{NSFontAttributeName:XKDefaultFontWithSize(14),NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(9, 10)];
    
    UILabel * showLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0,100,XKAppWidth,60)];
    showLabel.attributedText = attributedString;
    showLabel.numberOfLines = 0;
    showLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:showLabel];
    
    FLAnimatedImageView *flowerImageView = [[FLAnimatedImageView alloc] init];
    FLAnimatedImage *flowerImg = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flower" ofType:@"gif"]]];
    flowerImageView.animatedImage = flowerImg;
    flowerImageView.frame = CGRectMake((XKAppWidth - 250) /2, (XKAppHeight - 250)/2, 250, 250);
    [backgroundView addSubview:flowerImageView];
    
    
    UIButton * resetSchemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetSchemeButton.frame = CGRectMake((XKAppWidth - 250)/2, flowerImageView.bottom + 30, 250, 40);
    resetSchemeButton.backgroundColor = XKMainToneColor_29ccb1;
    resetSchemeButton.layer.masksToBounds = YES;
    resetSchemeButton.layer.cornerRadius = 5;
    [resetSchemeButton setTitle:@"去定制新的方案" forState:UIControlStateNormal];
    resetSchemeButton.titleLabel.font = XKDefaultFontWithSize(16);
  
    [resetSchemeButton addTarget:self action:@selector(toResetScheme:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:resetSchemeButton];
    
    
    UIButton *lateResetSchemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lateResetSchemeButton.frame = CGRectMake((XKAppWidth - 250)/2, resetSchemeButton.bottom + 10, 250, 40);
    lateResetSchemeButton.backgroundColor = [UIColor clearColor];
    [lateResetSchemeButton setTitle:@"稍后定制" forState:UIControlStateNormal];
    lateResetSchemeButton.titleLabel.font = XKDefaultFontWithSize(14);
    [lateResetSchemeButton addTarget:self action:@selector(lateToResetScheme:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:lateResetSchemeButton];
    
}



- (void) toResetScheme:(UIButton *)button{
    [button.superview removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"needResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self showToResetScheme];
}

- (void) lateToResetScheme:(UIButton *)button{
    [button.superview removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"lateToResetScheme_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void) showToResetScheme {
    UIAlertView * alertView =  [[UIAlertView alloc] initWithTitle:@"确定要重置方案吗？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    alertView.tag = 10003;
    [alertView show];
}

- (NSString *)PlanDayText {
    if ([XKRWAlgolHelper expectDayOfAchieveTarget] == nil) {
        return [NSString stringWithFormat:@"已坚持%ld天",(long)[[XKRWUserService sharedService] getInsisted]];
    }else{
        if([XKRWAlgolHelper remainDayToAchieveTarget] > -1){
            return [NSString stringWithFormat:@"第%ld天-剩%ld天",(long)[XKRWAlgolHelper newSchemeStartDayToAchieveTarget],(long)[XKRWAlgolHelper remainDayToAchieveTarget]];
        }else if ([XKRWAlgolHelper remainDayToAchieveTarget] == -1){
            return @"当前计划已结束";
        }
    }
    
    return nil;
}




@end
