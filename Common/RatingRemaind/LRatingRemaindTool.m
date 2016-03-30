//
//  LRatingRemaindTool.m
//  RulerPart
//
//  Created by Leng on 14-4-21.
//  Copyright (c) 2014年 Leng. All rights reserved.
//

#import "LRatingRemaindTool.h"
#import "XKUtil.h"
#define LRatingRemaindTimeRecord @"RatingRemaindTimeRecord"
#define LRatingRemaindFrequency @"RatingRemaindFrequency"

#define LRatingRemaindComplete @"LRatingRemaindComplete"

static LRatingRemaindTool *shareReMaindTool;

@implementation LRatingRemaindTool
//单例
+(id)shareTool {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareReMaindTool = [[LRatingRemaindTool alloc]init];
        [shareReMaindTool setRatingRemindType:RemindType_ForEFive];
    });
    return shareReMaindTool;
}



-(void)setRatingRemindType:(RemindType)type{
    
    int32_t temp = 1;

    switch (type) {
        case RemindType_NoLimit:
            
            break;
            case RemindType_ForEFive:
            temp = 5;
            break;
            case RemindType_ForETen:
            temp = 10;
            break;
        default:
            break;
    }

    [self setRatingRemindFrequency:temp];
}

-(void)setRatingRemindFrequency:(int32_t)frequency{

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:frequency] forKey:LRatingRemaindFrequency];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)checkIfNeedShow{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LRatingRemaindComplete] boolValue]) {
        return;
    }
    
    NSNumber * reminder = [[NSUserDefaults standardUserDefaults] objectForKey:LRatingRemaindTimeRecord];
    int temp = (int)[reminder integerValue];
    if (!temp) {
        temp = 1;
    }
    
    int frequency = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:LRatingRemaindFrequency] integerValue];
    
    if (!frequency) {
        frequency = 1;
        [self setRatingRemindFrequency:1];
    }
    
    if (temp) {
        if (!(temp %frequency)) {
            //提示评分
        
            if (_needPassOnce) {
                XKLog(@"需要手动调用");
            }else{
                [self showRating];
            }
            
        }
    }
    
    temp ++;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:temp] forKey:LRatingRemaindTimeRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) checkShowOnly{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LRatingRemaindComplete] boolValue]) {
        return;
    }
    
    NSNumber * reminder = [[NSUserDefaults standardUserDefaults] objectForKey:LRatingRemaindTimeRecord];
    int temp = (int)[reminder integerValue];
    if (!temp) {
        temp = 1;
    }
    
    int frequency = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:LRatingRemaindFrequency] integerValue];
    
    if (!frequency) {
        frequency = 1;
        [self setRatingRemindFrequency:1];
    }
    
    if (temp) {
        if (!(temp %frequency)) {
            //提示评分
            [self showRating];
        }
    }
    
}
-(void) showRating{
    XKLog(@"启动 评分vc");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Nil message:@"为瘦瘦投一票，评个分吧！" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"现在去评分", nil];
    
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    float verson = [[[UIDevice currentDevice] systemVersion] floatValue];

    
    
    if (buttonIndex != 0) {
        //6.0以下
        if (verson < 6.0) {
            //前去评分
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",LR_appID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            [self setRatingComplete];

            
        }else {
            BOOL toStore = NO;
            BOOL after = NO;
            if (!_delegate) {
                toStore = YES;
            }
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                toStore = YES;
                after = YES;
            }
            
            if (toStore) {
                NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",LR_appID];
                
                if (after) {
                     str =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",LR_appID];
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
                [self setRatingComplete];
                
                return;
            }
            
            SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];

            //设置代理请求为当前控制器本身
            storeProductViewContorller.delegate = self;
            //加载一个新的视图展示
            [storeProductViewContorller loadProductWithParameters:
             //appId唯一的
             @{SKStoreProductParameterITunesItemIdentifier : [NSString stringWithFormat:@"%d",LR_appID]} completionBlock:^(BOOL result, NSError *error) {
                 //block回调
                 if(error){
                     XKLog(@"error %@ with userInfo %@",error,[error userInfo]);
                 }else{
                     //模态弹出appstore
                     if (_delegate){
                         [_delegate presentViewController:storeProductViewContorller animated:YES completion:^{
                             [self setRatingComplete];
                         }
                          ];
                     }
                 }
             }];
        }
        
    }
    else{
        XKLog(@"取消点击");
    }
}
-(void) setRatingComplete{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:LRatingRemaindComplete];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [_delegate dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
