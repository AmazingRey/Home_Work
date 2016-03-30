
//
//  XKRWFatReasonService.m
//  XKRW
//
//  Created by yaowq on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWFatReasonService.h"
#import "XKRWFatReasonEntity.h"
#import "XKRWUserService.h"
#import "XKRWHabbitEntity.h"

static XKRWFatReasonService *shareInstance;

@implementation XKRWFatReasonService
{
    BOOL _isFromRecord;
    id _obj;
}
//单例
+(id)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        shareInstance = [[XKRWFatReasonService alloc] init];
        shareInstance.array = [NSMutableArray array];
    });
    
    return shareInstance;
    
}

- (BOOL)uploadQuestionAswerToRemoteServerNeedLong:(BOOL)need
{
//    NSArray *array = [self getTemp];
//    NSInteger uid = [[XKRWUserService sharedService]getUserId];
//    NSArray *array = [self getUnuploadAnswerWithUid:(int32_t)uid];
//    NSString *resultStr = @"";
//    
//    for (int i = 0; i < array.count; i++)
//    {
//        XKRWFatReasonEntity *entity = [array objectAtIndex:i];
//        NSString *str = [NSString stringWithFormat:@"%i_%i_%i",entity.question,entity.answer,entity.type];
//        if (i == 0)
//        {
//            resultStr = str;
//        }
//        else
//        {
//            resultStr = [NSString stringWithFormat:@"%@;%@",resultStr,str];
//        }
//      
//    }
//    if ([resultStr isEqualToString:@""]) {
//        return YES;
//    }
//    
//
//    
//    
//    
//    NSURL *qaRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServer,kUploadQuestioinAnswer]];
//    
//    NSString *tokenStr = [[XKRWUserService sharedService]getToken];
//    if (tokenStr != nil && ![tokenStr isEqualToString:@""])
//    {
//        NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:tokenStr,@"token",resultStr,@"option", nil];
//        NSDictionary * dic = [self syncBatchDataWith:qaRequestURL andPostForm:args withLongTime:need];
//        
//        if ([[dic objectForKey:@"success"] integerValue]) {
//            [self updateCurrentFatReason];
//            return YES;
//        }
//
//    }
   
    return NO;
}

-(void)updateCurrentFatReason{
    NSString * update = [NSString stringWithFormat:@"UPDATE fat_reason SET sync = 1 where u_id = %ld",(long)[XKRWUserDefaultService getCurrentUserId]];
    [self executeSql:update];
}
//
- (void)downloadQuenstionAnswer
{
//     NSURL *qaRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServer,kGetQuestionAnswer]];
//    
//    NSString *tokenStr = [[XKRWUserService sharedService] getToken];
//     if (tokenStr != nil && ![tokenStr isEqualToString:@""])
//     {
//       NSDictionary *args = [[NSDictionary alloc] initWithObjectsAndKeys:tokenStr,@"token", nil];
//    
//       NSDictionary *dic =  [self syncBatchDataWith:qaRequestURL andPostForm:args];
//       NSString *data = [dic objectForKey:@"data"];
//    
//         if ([data isKindOfClass:[NSString class]] && data.length) {
//             NSArray *array = [data componentsSeparatedByString:@";"];
//             [self saveQuenstionAnswer:array andSync:YES andUID:-1];
//         }
//     }
}

- (int32_t)getReasonIDWIthQid:(int32_t)qID andAID:(int32_t)aID {
    if (qID == 1 && aID == 1) {
        return 1;
    }if (qID == 1 && aID == 2) {
        return 2;
    }if (qID == 1 && aID == 3) {
        return 4;
    }if (qID == 1 && aID == 4) {
        return 3;
    }if (qID == 3 && aID == 6) {
        return 4;
    }if (qID == 3 && aID == 7) {
        return 5;
    }if (qID == 3 && aID == 8) {
        return 6;
    }if (qID == 7 && aID == 9) {
        return 1;
    }if (qID == 7 && aID == 10) {
        return 7;
    }if (qID == 7 && aID == 11) {
        return 2;
    }if (qID == 7 && aID == 12) {
        return 8;
    }if (qID == 8 && aID == 14) {
        return 9;
    }if (qID == 8 && aID == 15) {
        return 10;
    }if (qID == 8 && aID == 16) {
        return 11;
    }if (qID == 8 && aID == 17) {
        return 12;
    }if (qID == 9 && aID == 19) {
        return 13;
    }if (qID == 9 && aID == 20) {
        return 14;
    }
    return 0;
}


- (void)saveQuenstionAnswer:(NSArray *)array WithUID:(NSInteger) u_ID{
//    [self saveQuenstionAnswer:array andSync:NO andUID:u_ID];
    [self saveFatReasonToDB:array andUserId:u_ID andSync:1];
}

//- (void)saveQuenstionAnswer:(NSArray *)array{
//    
//   [self saveFatReasonToDB:array andUserId:u_ID andSync:1];
//    
//}


//删除暂存
-(void)deleteTemp {
    
    [self.array removeAllObjects];
}
//将信息暂存在temp中
- (void) addToTemp:(NSArray *)array {
    [self.array addObject:array];
}

- (void)tempRemoveLastObject
{
    [self.array removeLastObject];
}

- (NSArray *)getTemp{
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (NSArray *subArray in self.array) {
        for (NSString * temp  in subArray) {
            
            XKRWFatReasonEntity *entity = [[XKRWFatReasonEntity alloc] init];
            NSArray *questionArray = [temp componentsSeparatedByString:@"_"];
            
            if (questionArray.count == 3) {
                entity.question = [[questionArray objectAtIndex:0] intValue];
                entity.answer = [[questionArray objectAtIndex:1] intValue];
                entity.type = [[questionArray objectAtIndex:2] intValue];
                
                [array addObject:entity];
            }
        }
    }
    return array;
}
//从缓存加入数据库
- (void) addTempToDB{
    
    [self saveQuenstionAnswer:self.array WithUID:[[XKRWUserService sharedService] getUserId]];
}

//导入数据时 更新本地表
-(void)updateTringUser{
    NSMutableArray * array = [NSMutableArray arrayWithArray:[self getQuestionAnswerWithUid:0]];
    NSMutableArray * temp = [NSMutableArray array];
    for (XKRWFatReasonEntity *entity in array) {
        entity.u_id = [XKRWUserDefaultService getCurrentUserId];
        
        [temp addObject:entity.description];
    }
    [self deleteQuestionAnswerFromDB:0];
    [self deleteQuestionAnswerFromDB:(int32_t)[XKRWUserDefaultService getCurrentUserId]];
    [self saveQuenstionAnswer:temp];

}

//- (void)saveQuenstionAnswer:(NSArray *)array andSync:(BOOL) sync andUID:(NSInteger)u_id;
//{
//    if (array && array.count) {
//        [self deleteQuestionAnswerFromDB:(int)u_id];
//        if ([array[0] isKindOfClass:[NSArray class]]) {
//            for (NSArray *subArray in array) {
//                for (NSString *str in subArray) {
//                    
//                    NSArray *questionArray = [str componentsSeparatedByString:@"_"];
//                    if (questionArray.count == 3) {
//                        
//                        [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *roolback){
//                            NSString *sss = [NSString stringWithFormat:@"REPLACE INTO fat_reason VALUES(%i,%i,%i,%ld,%i)",[[questionArray objectAtIndex:0] intValue],[[questionArray objectAtIndex:1] intValue],[[questionArray objectAtIndex:2] intValue],(long)((u_id == -1)?[[XKRWUserService sharedService] getUserId]:u_id),sync];
//                            
//                            [db executeUpdate:sss];
//                            
//                        }];
//                    }
//                }
//            }
//        } else if ([array[0] isKindOfClass:[NSString class]]) {
//            
//            for (NSString *str in array) {
//                
//                NSArray *questionArray = [str componentsSeparatedByString:@"_"];
//                if (questionArray.count == 3) {
//                    
//                    [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *roolback){
//                        NSString *sss = [NSString stringWithFormat:@"REPLACE INTO fat_reason VALUES(%i,%i,%i,%ld,%i)",[[questionArray objectAtIndex:0] intValue],[[questionArray objectAtIndex:1] intValue],[[questionArray objectAtIndex:2] intValue],(long)((u_id == -1)?[[XKRWUserService sharedService] getUserId]:u_id),sync];
//                        
//                        [db executeUpdate:sss];
//                        
//                    }];
//                }
//            }
//        }
//    }
//}



#pragma mark --读取未同步的  肥胖原因 ---
- (NSArray*)getUnuploadAnswerWithUid:(int32_t)uid
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM fat_reason where u_id = '%d'and sync = '0' ORDER BY question,answer",uid]];
        while ([result next])
        {
            XKRWFatReasonEntity *entity = [[XKRWFatReasonEntity alloc] init];
            [result  setResultToObject:entity];
            [array addObject:entity];
        }
    }];
    
    return array;

}












/*
 case 1:
 titleShow = @"饮食油腻";
 case 2:
 titleShow = @"零食";
 case 4:
 titleShow = @"白酒";
 case 5:
 titleShow = @"红酒";
 case 6:
 titleShow = @"啤酒";
 case 7:
 titleShow = @"饮料";
 case 8:
 titleShow = @"肥肉";
 case 9:
 titleShow = @"坚果";
 case 10:
 titleShow = @"宵夜";
 case 11:
 titleShow = @"晚饭吃的晚";
 case 12:
 titleShow = @"吃饭快";
 case 13:
 titleShow = @"饮食不规律";

 */
//获取文案index 范围 0 ~ 10
//获取文案index 范围 0 ~ 10
- (int32_t) getAlarmDescriptionIndex{
    
    NSArray * arrTemp = [self getQuestionAnswer];

    NSMutableArray * badHabbits = [NSMutableArray array];
    
    int num = 0;
    
    
    for (XKRWFatReasonEntity *entity in arrTemp) {
        if (entity.question == 1 && entity.answer == 5)
        {
            num++;
        }
        else if (entity.question == 7 && entity.answer == 13)
        {
            num++;
        }
        else if (entity.question == 8 && entity.answer == 18)
        {
            num++;
        }
        else if (entity.question == 9 && entity.answer == 21)
        {
            num++;
        }
        else
        {
            
            //饮料 和 酒类 及个数需要跳过 个数 和jiulei
            if (entity.question == 2 || entity.question == 4 || entity.question == 5 || entity.question == 6) {
                continue;
            }
            if (entity.question == 1 && entity.answer == 3) {
                continue;
            }
            
            [badHabbits addObject:entity];
        }
        
    }
   
    int32_t reason = 0;
    if (num != 4 && badHabbits.count) {
        int32_t index =  (int)(0 + (arc4random() % (badHabbits.count)));
        
        XKRWFatReasonEntity * _fatReasonEntity = [badHabbits objectAtIndex:index];
        reason = [[XKRWFatReasonService sharedService] getReasonIDWIthQid:_fatReasonEntity.question andAID:_fatReasonEntity.answer];
        
    }
    
    
    switch (reason)
    {
        case 1:
        {
            return 0;

        }
        case 2:
        {
            return 1;
           
            
        }
            break;
        case 4:
        {

            return 2;
            
        }
            break;
        case 5:
        {

            return 3;
  
            
        }
            break;
        case 6:
        {

            return 4;
          
            
        }
            break;
            
        case 7:
        {

           return 5;
    
            
        }
        case 8:
        {
            return 6;
 
        }
        case 9:
        {
            return 7;
      
        }
            
        case 10:{
            return 8;
   
            
        }
        case 11:{
            return 9;
            
        }
            break;
        case 12:{
            
            return 10;
        }
        case 13:{
            return 9;
            
            
        }
        case 14:
        case 15:
        default:
            break;
    }
    
    return  (int)(0 + (arc4random() % (10 - 0 + 1)));
}


-(NSArray *)getDetailReasonSet{
    NSArray *array = [[XKRWFatReasonService sharedService] getQuestionAnswer];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    int num = 0;
    
    for (int i = 0; i < array.count; i++)
    {
        XKRWFatReasonEntity *entity = [array objectAtIndex:i];
        if (entity.question == 1 && entity.answer == 5)
        {
            num++;
        }
        else if (entity.question == 7 && entity.answer == 5)
        {
            num++;
        }
        else if (entity.question == 8 && entity.answer == 5)
        {
            num++;
        }
        else if (entity.question == 9 && entity.answer == 3)
        {
            num++;
        }
        else
        {
            [list addObject:entity];
        }
        
    }
    return list;
}
-(void)deleteQuestionAnswerFromDB:(NSInteger)uid{
    @try {

        [self executeSql:[NSString stringWithFormat:@"DELETE FROM fat_reason where u_id = %ld",(long)uid]];
    }
    @catch (NSException *exception) {
        XKLog(@"肥胖原因删除失败 %@",exception);
    }
}
- (void)deleteQuestionAnswerFromDB
{
    [self deleteQuestionAnswerFromDB:[XKRWUserDefaultService getCurrentUserId]];
}

- (id)isFromRecord
{
    if (_isFromRecord) {
        return _obj;
    }
    return nil;
}

- (void)setFromRecord:(id)obj
{
    if (obj) {
        _isFromRecord = YES;
        _obj = obj;
    } else {
        obj = nil;
        _isFromRecord = NO;
    }
}

#pragma --mark  5.0版本


//将肥胖原因保存到数据库   通过sync判断是否要同步
- (void) saveFatReasonToDB:(NSArray *)array  andUserId:(NSInteger)userID andSync:(NSInteger) sync{
    
    [self deleteQuestionAnswerFromDB:userID];
    
    for (int i =0 ;i <array.count ;i++){
        NSString *fatReason = [array objectAtIndex:i];
        NSArray *questionArray =  [fatReason componentsSeparatedByString:@"_"];
        if (questionArray.count == 3) {
            [self writeDefaultDBWithTask:^(FMDatabase *db,BOOL *roolback){
                NSString *sql = [NSString stringWithFormat:@"REPLACE INTO fat_reason VALUES(%d,%d,%d,%ld,%ld)",[[questionArray objectAtIndex:0] intValue],[[questionArray objectAtIndex:1] intValue],[[questionArray objectAtIndex:2] intValue],(long)userID,(long)sync];
                [db executeUpdate:sql];
            }];
        }
    }
}




- (NSArray *)getQuestionAnswerWithUid:(NSInteger)uid {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM fat_reason where u_id = '%ld' ORDER BY question,answer",(long)uid]];
        
        while ([result next]) {
            XKRWFatReasonEntity *entity = [[XKRWFatReasonEntity alloc] init];
            [result  setResultToObject:entity];
            [array addObject:entity];
        }
    }];
    return array;
}


/**
 *  获得肥胖原因分析页中具体用户数值计算时用到的ID，因getReasonIDWIthQid:andAid:不能兼容新版本需求所增
 */
- (int32_t)getReasonDescriptionWithID:(int32_t)qID andAID:(int32_t)aID {
    
    if (qID == 1 && aID == 1) {
        return 1;
    }if (qID == 1 && aID == 2) {
        return 2;
    }if (qID == 1 && aID == 3) {
        return 0;    //本来应该为4  但是因为会导致饮酒在饮料前边  所以改为0  因为啤酒会返回一个4
    }if (qID == 1 && aID == 4) {
        return 3;
    }if (qID == 2) {
        return 3;
    }if (qID == 4) {
        return 4;
    }if (qID == 5) {
        return 5;
    }if (qID == 6) {
        return 6;
    }if (qID == 7 && aID == 9) {
        return 1;
    }if (qID == 7 && aID == 10) {
        return 7;
    }if (qID == 7 && aID == 11) {
        return 2;
    }if (qID == 7 && aID == 12) {
        return 8;
    }if (qID == 8 && aID == 14) {
        return 9;
    }if (qID == 8 && aID == 15) {
        return 10;
    }if (qID == 8 && aID == 16) {
        return 11;
    }if (qID == 8 && aID == 17) {
        return 12;
    }if (qID == 9 && aID == 19) {
        return 13;
    }if (qID == 9 && aID == 20) {
        return 14;
    }
    return 0;
}

- (NSArray *)getQuestionAnswer
{
    return [self getQuestionAnswerWithUid:[[XKRWUserService sharedService] getUserId]];
}


- (NSArray *)getQuestionAnswerByUid:(NSInteger) uid{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self readDefaultDBWithTask:^(FMDatabase *db){
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM fat_reason where u_id = '%ld' ORDER BY question,answer",(long)uid]];
        while ([result next])
        {
            XKRWFatReasonEntity *entity = [[XKRWFatReasonEntity alloc] init];
            [result  setResultToObject:entity];
            [array addObject:entity];
        }
    }];
    
    return array;
    
}

- (NSInteger) getBadHabitNum{
    
    NSArray * questionArray =  [XKRWFatReasonService.sharedService getQuestionAnswer];
    
    NSMutableArray *titleArray = [[NSMutableArray alloc]init];
    
    for (int  i = 0 ;i < questionArray.count ; i++) {
        XKRWFatReasonEntity * entity  = [questionArray objectAtIndex:i] ;
        int  reason =[ XKRWFatReasonService.sharedService getReasonDescriptionWithID:entity.question andAID:entity.answer];
        
        
        
        switch (reason){
        case 1:
            if(![titleArray containsObject:@"饮食油腻"]){
                [titleArray addObject:@"饮食油腻"];
            }
                break;
        case 2:
            if(![titleArray containsObject:@"吃零食"]){
                 [titleArray addObject:@"吃零食"];
            }
                break;
        case 3:
            if(![titleArray containsObject:@"喝饮料"]){
                [titleArray addObject:@"喝饮料"];
            }
                break;
            case 4:
            case 5:
            case 6:
            if(![titleArray containsObject:@"饮酒"]){
                [titleArray addObject:@"饮酒"];
            }
                break;
        case 7:
            if(![titleArray containsObject:@"吃肥肉"]){
                [titleArray addObject:@"吃肥肉"];
            }
                break;
        case 8:
            if(![titleArray containsObject:@"吃坚果"]){
                [titleArray addObject:@"吃坚果"];

            }
                break;
        case 9:
            if(![titleArray containsObject:@"吃宵夜"]){
                [titleArray  addObject: @"吃宵夜"];

            }
                break;
        case 10:
            if(![titleArray containsObject:@"吃饭晚"]){
               [titleArray  addObject: @"吃饭晚"];

            }
                break;
        case 11:
            if(![titleArray containsObject:@"吃饭快"]){
                [titleArray  addObject: @"吃饭快"];
            }
                break;
        case 12:
            if(![titleArray containsObject:@"饮食不规律"]){
                [titleArray  addObject: @"饮食不规律"];

            }
                break;
        case 13:
            if(![titleArray containsObject:@"活动量少"]){
               [titleArray  addObject: @"活动量少"];

            }
                break;
        case 14:
            if(![titleArray containsObject:@"缺乏锻炼"]){
                [titleArray  addObject: @"缺乏锻炼"];
            }
                break;
        default:
                XKLog(@"习惯很好，不需要改善");
        }
    }
     XKLog(@"%@",titleArray);
     return [titleArray count];
}



//从服务器获取肥胖原因 并组合成字符串形式  （未来适配以前的版本）

- (NSString *)getFatReason:(XKRWFatReasonEntity * )enity{
    
    return [NSString stringWithFormat:@"%d_%d_%d",enity.question,enity.answer,enity.type];
}

- (NSString *)getFatReasonFromDB{
    NSArray *questionArray =[XKRWFatReasonService.sharedService getQuestionAnswer];
    
    NSMutableString *questionString = [[NSMutableString alloc]init];
    
    if (questionArray.count != 0) {
        for (int i =0;i < questionArray.count; i++) {
            NSString *question = [self getFatReason:[questionArray objectAtIndex:i]];
            if (i == questionArray.count -1) {
                [questionString appendString:question];
            }else{
                [questionString appendFormat:@"%@;",question];
            }
        }
    }
    return questionString;
}


- (void)saveFatReasonToRemoteServer
{
    NSString *questionString = [self getFatReasonFromDB];
    [[XKRWUserService sharedService]changeUserInfo:questionString WithType:@"slim_qa"];
}


#pragma mark - 5.1

- (nonnull NSArray<XKRWHabbitEntity *> *)getHabitEntitiesWithString:(nonnull NSString *)qa_string {
    
    if (qa_string.length == 0) {
        return [[NSArray<XKRWHabbitEntity *> alloc] init];
    }
    NSArray *qaStrings = [qa_string componentsSeparatedByString:@";"];
    
    NSMutableArray<XKRWFatReasonEntity *> *fatReasons = [NSMutableArray new];
    
    for (NSString *qa in qaStrings) {
        NSArray *comp = [qa componentsSeparatedByString:@"_"];
        NSInteger q = [comp.firstObject integerValue];
        NSInteger a = [comp[1] integerValue];
        
        XKRWFatReasonEntity *entity = [[XKRWFatReasonEntity alloc] init];
        entity.question = (int)q;
        entity.answer = (int)a;
        [fatReasons addObject:entity];
    }
    return [self getHabitEntitiesWithFatReasonEntities:fatReasons];
}

- (nonnull NSArray<XKRWHabbitEntity *> *)getHabitEntitiesWithFatReasonEntities:(nonnull NSArray<XKRWFatReasonEntity *> *)fatReasons {
    
    NSMutableArray<XKRWHabbitEntity *> *habitArray = [[NSMutableArray alloc] init];
    int num = 0;
    
    for (int i = 0; i < fatReasons.count; i++)
    {
        XKRWFatReasonEntity *entity = [fatReasons objectAtIndex:i];
        
        if (entity.question == 1 && entity.answer == 5) {
            num++;
        } else if (entity.question == 7 && entity.answer == 13) {
            num++;
        } else if (entity.question == 8 && entity.answer == 18) {
            num++;
        } else if (entity.question == 9 && entity.answer == 21) {
            num++;
        } else {
            int32_t reason = [[XKRWFatReasonService sharedService] getReasonIDWIthQid:entity.question andAID:entity.answer];
            
            switch (reason) {
                case 1:
                {
                    BOOL flag = YES;
                    for (XKRWHabbitEntity *entity in habitArray) {
                        if ([entity.name isEqualToString:@"饮食油腻"]) {
                            flag = NO;
                            break;
                        }
                    }
                    if (flag) {
                        [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:1 andName:@"饮食油腻" andSituation:0]];
                    }
                }
                    break;
                case 2:
                {
                    BOOL flag = YES;
                    for (XKRWHabbitEntity *entity in habitArray) {
                        if ([entity.name isEqualToString:@"吃零食"]) {
                            flag = NO;
                            break;
                        }
                    }
                    if (flag) {
                        [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:2 andName:@"吃零食" andSituation:0]];
                    }
                }
                    break;
                case 3:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:3 andName:@"喝饮料" andSituation:0]];
                }
                    break;
                case 4:
                {
                    XKRWHabbitEntity *entity =[[XKRWHabbitEntity alloc] initWithHid:4 andName:@"饮酒" andSituation:0];
                    [habitArray addObject:entity];
                }
                    break;
                case 5:
                {
                    XKRWHabbitEntity *entity =[[XKRWHabbitEntity alloc] initWithHid:5 andName:@"饮酒" andSituation:0];
                    [habitArray addObject:entity];
                }
                    break;
                case 6:
                {
                    XKRWHabbitEntity *entity =[[XKRWHabbitEntity alloc] initWithHid:6 andName:@"饮酒" andSituation:0];
                    [habitArray addObject:entity];
                }
                    break;
                case 7:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:7 andName:@"吃肥肉" andSituation:0]];
                }
                    break;
                case 8:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:8 andName:@"吃坚果" andSituation:0]];
                }
                    break;
                case 9:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:9 andName:@"吃宵夜" andSituation:0]];
                }
                    break;
                case 10:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:10 andName:@"吃饭晚" andSituation:0]];
                }
                    break;
                case 11:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:11 andName:@"吃饭快" andSituation:0]];
                }
                    break;
                case 12:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:12 andName:@"饮食不规律" andSituation:0]];
                }
                    break;
                case 13:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:13 andName:@"活动量小" andSituation:0]];
                }
                    break;
                case 14:
                {
                    [habitArray addObject:[[XKRWHabbitEntity alloc] initWithHid:14 andName:@"缺乏锻炼" andSituation:0]];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
    // 5.0 版本升级后，饮酒可能会重复
    num = 0;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (XKRWHabbitEntity *habit in habitArray) {
        
        if ([habit.name isEqualToString:@"饮酒"]) {
            if (++num > 1) {
                [temp addObject:habit];
            }
        }
    }
    
    for (XKRWHabbitEntity *habit in temp) {
        [habitArray removeObject:habit];
    }
    return habitArray;
}

@end
