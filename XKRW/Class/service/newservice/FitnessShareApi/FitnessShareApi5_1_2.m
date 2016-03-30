//
//  FitnessShareApi5_1_2.m
//  XKRW
//
//  Created by Seth Chen on 15/12/11.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "FitnessShareApi5_1_2.h"
#import <XKRW-Swift.h>

@implementation FitnessShareApi5_1_2


//从网络获取瘦身分享推荐内容
- (void )getFitnessRecommendFromServerWithPage:(NSNumber *)page
{
    NSString *fitnessShareUrl = [NSString stringWithFormat:@"%@%@",kNewServer,kGetBlogRecommendArticle];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",@"10",@"size", nil];
    [self startAsynchronizedPostMethodwithCompleteUrl:fitnessShareUrl andParamer:parm andResponseMethod:@selector(getFitnessRecommendRes:)];
}


- (NSMutableArray *)getFitnessRecommendRes:(NSDictionary *)blogRecommendDic
{
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSDictionary *temp in blogRecommendDic[@"data"]) {
        XKRWArticleListEntity *entity = [[XKRWArticleListEntity alloc] init];
        entity.headImageUrl = temp[@"avatar"];
        entity.blogId = temp[@"blogid"];
        
        NSData *data = [temp[@"cover_pic"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *coverPicDc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        entity.coverImageUrl = coverPicDc[@"url"];
        entity.coverEnabled = [coverPicDc[@"flag"] integerValue];
        entity.articleState = [temp[@"status"] intValue];
        entity.createTime = [temp[@"ctime"] intValue];
        entity.bePraisedNum = [temp[@"goods"] integerValue];
        entity.userDegreeImageUrl = temp[@"level"];
        entity.manifesto = temp[@"manifesto"];
        entity.userNickname = temp[@"nickname"];
        entity.title = temp[@"title"];
        entity.articleViewNums = [temp[@"views"] integerValue];
        entity.manifesto = temp[@"manifesto"];
        
        XKRWTopicEntity *topicEntity = [[XKRWTopicEntity alloc] initWithId:[temp[@"topic_key"] integerValue] name:temp[@"topic_name"] enabled:YES];
        entity.topic = topicEntity;
        [mutArray addObject:entity];
    }
    return mutArray;
}

@end
