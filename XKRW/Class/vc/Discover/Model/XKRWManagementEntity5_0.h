//
//  XKRWManagementEntity5_0.h
//  XKRW
//
//  Created by Jack on 15/6/3.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRWManagementEntity5_0 : NSObject
//模块类别
@property (nonatomic) XKOperation category;

//模块名称
@property (nonatomic,strong) NSString *module;

//模块内容
@property (nonatomic,strong) NSDictionary *content;

//排序
@property (nonatomic) NSInteger seq;

//id
@property (nonatomic) NSInteger nid;

//是否完成
@property (nonatomic) BOOL complete;

//判断是哪一天的运营内容
@property (nonatomic) NSInteger day;

//huoqu运营内容的日期
@property (nonatomic,strong) NSString *date;   //upDataTime


@property (nonatomic,strong) NSString *articleDate;  //显示的文章时间

//帖子阅读量 pv
@property(nonatomic,strong)NSString *readNum;

//非0 为已阅读
@property (nonatomic)NSInteger read;

//是否为最新记录
@property (nonatomic) BOOL leastrecord; 

//大图
@property (nonatomic,strong)NSString *bigImage;

//小图
@property (nonatomic,strong)NSString *smallImage;

//副标题
@property (nonatomic,strong)NSString *subtitle;
//展示类型
@property (nonatomic) NSInteger showType;

//lhyy 专门处理
@property (nonatomic)NSInteger beishu;
@property (nonatomic,strong)NSString *icon_selected;
@property (nonatomic,strong)NSString *icon_unselected;
@property (nonatomic,strong)NSString *module_name;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *update_time;
@property (nonatomic,strong)NSString *url;

- (NSDictionary *)dictionaryInRecordTable;

@end
