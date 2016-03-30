//
//  XKRWShareCourseService.m
//  XKRW
//
//  Created by Jack on 15/7/6.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWShareCourseService.h"
#import "XKRWUserService.h"
static XKRWShareCourseService *shareInstance;
@implementation XKRWShareCourseService
//单例
+(id)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWShareCourseService alloc]init];
    });
    return shareInstance;
}

-(NSDictionary *)getDataFromServer{
    NSURL *shareCourseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kGetShareCourse]];
    NSDictionary *shareCourseDic = [self syncBatchDataWith:shareCourseUrl andPostForm:[NSDictionary dictionary]];
    return shareCourseDic[@"data"];
    
}

-(NSArray *)getFamous{
    NSArray *temp = [self getDataFromServer][@"famous"];
    return temp;
}

-(NSArray *)getImageUrl{
    NSArray *temp = [self getDataFromServer][@"imageurl"];
    return temp;
}

- (void)setShareCourseHaveSlide
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"Slider_%ld",(long)[[XKRWUserService sharedService ]getUserId]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)shareCourseVCNeedSlide
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"Slider_%ld",(long)[[XKRWUserService sharedService ]getUserId]]]) {
        return  YES;
    }else{
        return NO;
    }
}

@end
