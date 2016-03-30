//
//  XKRWArticleDetailEntity.h
//  XKRW
//
//  Created by Jack on 15/6/8.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWArticleDetailEntity : NSObject

@property (nonatomic) XKOperation category;

@property (nonatomic,strong) NSDictionary *content;

@property (nonatomic,strong)NSString *beishu;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *nid;

@property (nonatomic,strong) NSString *readNum;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *url;

@property (nonatomic)NSInteger read;
//正方票数
@property (nonatomic,strong) NSString *zfps;
//反方票数
@property (nonatomic,strong) NSString *ffps;

//是否为最新记录
@property (nonatomic,assign) BOOL leastrecord;

@end
