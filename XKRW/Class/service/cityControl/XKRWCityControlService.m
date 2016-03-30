//
//  XKRWCityControlService.m
//  XKRW
//
//  Created by Leng on 14-4-30.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCityControlService.h"
#import "PYMethod.h"
#import "XKRWUserService.h"


static XKRWCityControlService *shareCityInstance;

@implementation XKRWCityControlService


#define TableNameNotice @"notice";

//
//#define updateSql @"UPDATE notice  SET uid=?,noticeType=?,noticeTitle=?,noticeMsg=?,noticeFrequency=?,noticeTime=?,noticeShake=?,noticeRing=?,noticeStatus=? WHERE noticeId = %i "


//单例
+(id)shareService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareCityInstance = [[XKRWCityControlService alloc] init ];
    });
    return shareCityInstance;
}


- (void) updateLocationInfoWithCity:(int)cid andProvence:(int) pid andDes:(int) did{

    [self updateLocationInfoWithCity:cid andProvence:pid andDes:did andNeedLong:NO];
}
//静默时间选择
-(void)updateLocationInfoWithCity:(int)cid andProvence:(int)pid andDes:(int)did andNeedLong:(BOOL)needLong{
    
    NSDictionary *data = @{@"address":[NSString stringWithFormat:@"%d,%d,%d",pid,cid,did],
                           };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"data":jsonString};

    [[XKRWUserService sharedService] saveUserInfoToRemoteServer:params];
    
}


-(NSString *) getNameWithID:(NSInteger) nameID{

    NSString * sql = [NSString stringWithFormat:@"select * from area  where id = %ld",(long)nameID];
    NSArray * array = [self query:sql];
    if (array && array.count) {
        
        NSString * temp =  [[array lastObject] objectForKey:@"name"];
        if (temp) {
            return temp;
        }
    }
    return @"无";
}

-(NSString *) getPorvienceWithID:(NSInteger)index{
    NSString * pro = nil;
    NSString * select =[NSString stringWithFormat:@"select name from area where id = %ld",(long)index];
    pro =[[self fetchRow:select] objectForKey:@"name"];
    return pro;
}

-(NSArray *) getPorvience{
    NSMutableArray * array = [NSMutableArray array];
    NSString * select =[NSString stringWithFormat:@"select * from area where pid = 0 and name like '%%市' order by id ASC"];
    NSArray * tempzxs = [self query:select];
    
    NSString * others = [NSString stringWithFormat:@"select * from area where pid = 0 and name not like '%%市' order by idx_char ASC"];
    NSArray * tempOthers = [self query:others];
    
    [array addObjectsFromArray:tempzxs];
    [array addObjectsFromArray:tempOthers];
    
    return array;
}

-(NSArray *) getCityWithPrivence:(NSInteger)pid{

    NSString * select =[NSString stringWithFormat:@"select * from area where pid = %ld order by idx_char ASC",(long)pid];
    return [self query:select];
}


-(NSArray *)getCityList{

    NSString * sql = @"select * from area  where pid between 1 and 34 ";
    NSArray * array = [self query:sql];
    
    return array;
}
-(NSArray *)getCityListWithKey:(NSString *)key{
    
    NSString * select =[NSString stringWithFormat:@"select * from area where idx_char like '%@%%'  and pid between 1 and 34  order by idx_char ASC",key];
    return [self query:select];
    
}

-(NSArray *)getCityListWithCityName:(NSString *)key{
    
    NSString * select =[NSString stringWithFormat:@"select * from area where name like '%@%%' and pid between 1 and 34   order by idx_char ASC",key];
    return [self query:select];
    
}


@end
