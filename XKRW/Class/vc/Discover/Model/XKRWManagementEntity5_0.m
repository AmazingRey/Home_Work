//
//  XKRWManagementEntity5_0.m
//  XKRW
//
//  Created by Jack on 15/6/3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWManagementEntity5_0.h"

@implementation XKRWManagementEntity5_0
- (NSDictionary *)dictionaryInRecordTable
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *contentDic = self.content;
    self.icon_selected = contentDic[@"icon_selected"];
    self.icon_unselected = contentDic[@"icon_unselected"];
    [dic setObject:contentDic[@"beishu"] forKey:@"beishu"];
    if(!self.icon_selected){
        self.icon_selected = @"";
    }
    [dic setObject:self.icon_selected forKey:@"icon_selected"];
    if(!self.icon_unselected){
        self.icon_unselected = @"";
    }
    [dic setObject:self.icon_unselected forKey:@"icon_unselected"];
    [dic setObject:contentDic[@"module_name"] forKey:@"module_name"];
    [dic setObject:contentDic[@"nid"] forKey:@"nid"];
    [dic setObject:contentDic[@"pv"] forKey:@"pv"];
    if(!self.read){
        self.read = 0;
    }
    [dic setObject:[NSNumber numberWithInteger:self.read] forKey:@"read"];
    [dic setObject:contentDic[@"title"] forKey:@"title"];
    [dic setObject:contentDic[@"update_time"] forKey:@"update_time"];
    [dic setObject:contentDic[@"url"] forKey:@"url"];
    
    return dic;
}

@end
