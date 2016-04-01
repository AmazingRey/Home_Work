//
//  XKRWAppCommentUtil.m
//  XKRW
//
//  Created by 忘、 on 16/3/23.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWAppCommentUtil.h"
#import "XKRWUserService.h"
#import "XKRWVersionService.h"
static XKRWAppCommentUtil *shareInstance;

@implementation XKRWAppCommentUtil

+ (instancetype)shareAppComment{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWAppCommentUtil alloc]init];
    });
    return shareInstance;
}

- (void)showAlertViewInVC{
    NSString *schemeKey = [NSString stringWithFormat:@"%@_%ld",SCHEMEPAGE,(long)[[XKRWUserService sharedService] getUserId]];
    
    NSString * analyzeKey = [NSString stringWithFormat:@"%@_%ld",ANALYZEPAGE,(long)[[XKRWUserService sharedService] getUserId]];
    
    id schemeValue = [[NSUserDefaults standardUserDefaults] objectForKey:schemeKey];
    
    id analyzeValue = [[NSUserDefaults standardUserDefaults] objectForKey:analyzeKey];
    
     NSInteger count = 0;
    if(schemeValue != nil || analyzeValue != nil){
        
        XKLog(@"%ld ,%ld",(long)[schemeValue integerValue],(long)[analyzeValue integerValue]);
        
        count = [schemeValue integerValue] >= [analyzeValue integerValue] ? [schemeValue integerValue]: [analyzeValue integerValue];
    }
    
    if(count == 5){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"妈妈说喜欢我们就会瘦,\n不信你试试啊!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我要瘦，我要瘦！",@"呵呵，可以吐槽吗？",@"就不试，狗带吧！", nil];
        [alertView show];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:schemeKey];
        [[NSUserDefaults standardUserDefaults ] setObject:nil forKey:analyzeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 2){
        NSString *string = @"itms-apps://itunes.apple.com/app/id622478622" ;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *key = [NSString stringWithFormat:@"Ver_%@_%ld",version,[[XKRWUserService sharedService] getUserId]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setEntryPageTimeWithPage:(NSString *)pageName{
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *key = [NSString stringWithFormat:@"Ver_%@_%ld",version,[[XKRWUserService sharedService] getUserId]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        NSString *key = [NSString stringWithFormat:@"%@_%ld",pageName,[[XKRWUserService sharedService] getUserId]];
        id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        
        NSInteger count = 0;
        
        if(value != nil){
            count = [value integerValue];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count + 1] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

@end
