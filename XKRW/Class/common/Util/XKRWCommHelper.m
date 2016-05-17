//
//  XKRWCommHelper.m
//  XKRW
//
//  Created by zhanaofan on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWCommHelper.h"
#import "NSDate+Helper.h"
#import "SAMCache.h"
#import "XKRWAlgolHelper.h"
#import "XKRWFatReasonService.h"
#import "FMDatabaseQueue.h"
#import "XKConfigUtil.h"
#import "XKRWUserDefaultService.h"
#import "XKRWBaseService.h"
#import "XKRWUserService.h"
//#import "XKRWSettingService.h"
#import "NSDate+Helper.h"

#import "XKRWWeightService.h"
#import "XKRWAlgolHelper.h"
#import "XKRWRecordService4_0.h"

#import "XKRWNeedLoginAgain.h"
#import "XKRWCollectionService.h"
//#import "FMDatabaseQueue+XKPersistence.h"
@interface XKRWDietPartStruct : NSObject<NSCoding>

@property (nonatomic,assign) int      type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int      proportion;
@property (nonatomic,assign) int      totalNum;
@property (nonatomic,assign) float    energy;
@property (nonatomic,assign) int32_t  weight;

@end

@implementation XKRWDietPartStruct

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInt:self.proportion forKey:@"proportion"];
    [aCoder encodeInt:self.totalNum forKey:@"totalNum"];
    [aCoder encodeInt:self.weight forKey:@"weight"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.proportion = [aDecoder decodeIntForKey:@"proportion"];
        self.totalNum = [aDecoder decodeIntForKey:@"totalNum"];
        self.weight = [aDecoder decodeIntForKey:@"weight"];
    }
    return self;
    
}
@end

@implementation XKRWCommHelper

static FMDatabaseQueue *fmdbq;
static XKRWBaseService *service;

/**
 *  这个应用是否是第一次打开
 *
 *  @return 是第一次打开返回YES 否则为NO
 */
+ (BOOL) isFirstOpenThisApp {

    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];

    if ([[defaults objectForKey:kFirstOpenApp] isEqual:[NSString stringWithFormat:@"IOS Ver %@", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]]]) {
        return  NO;
    }
    else{
        
        [defaults setObject:[NSString stringWithFormat:@"IOS Ver %@", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]] forKey:kFirstOpenApp];
        [defaults synchronize];
        
        return YES;
    }
}


+ (BOOL) isFirstOpenThisAppWithUserId:(NSInteger ) userId {
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];

    if ([[defaults objectForKey:kFirstOpenAppWithUser] isEqual:[NSString stringWithFormat:@"IOS_Ver_%@_%ld", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"],(long)userId]]) {
        return  NO;
    }
    else{
        [defaults setObject:[NSString stringWithFormat:@"IOS_Ver_%@_%ld", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"],(long)userId] forKey:kFirstOpenAppWithUser];
        [defaults setObject:[NSDate today] forKey:@"EnterDate"];
        [defaults synchronize];
        
        return YES;
    }

}

/**
 *  今天第一次打开
 *
 *  @return
 */
+ (BOOL) isFirstOpenToday
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSString *today = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];
    NSString *day = [defaults objectForKey:kFirstOpenToday];
    if (!day || ![day isEqualToString:today]) {
        [defaults setObject:today forKey:kFirstOpenToday];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

+ (BOOL)isLoginOpenToday
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"isLoginOpenToday_%ld", (long)UID];
    
    NSString *today = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];
    NSString *day = [defaults objectForKey:key];
    if (!day || ![day isEqualToString:today]) {
        return YES;
    }
    return NO;
}

+ (void)setLoginOpenToday {
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"isLoginOpenToday_%ld", (long)UID];
    
    NSString *today = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];

    [defaults setObject:today forKey:key];
    [defaults synchronize];
}

+ (BOOL) isUpdateFromV2{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    BOOL exists = [defaults boolForKey:kUpdateFromV2];
    return !exists;
}
+ (void) setFirstOpenToday
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSString *today = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];
    [defaults setObject:today forKey:kFirstOpenToday];
    [defaults synchronize];
}

/*从2.0升级上来，同步三餐比例*/
//+ (void) updateDietScaleFromV2
//{
//    NSInteger uid = [XKRWUserDefaultService getCurrentUserId];
//    NSString *scalFile = [NSString stringWithFormat:@"ThreeDietPart_%li.plist",(long)uid];
//    NSString *filePath = [[self class] fileFullPath:scalFile];
//    if(filePath){
//        NSDictionary *dictionary = [[NSDictionary alloc]initWithContentsOfFile:filePath];
//        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[dictionary objectForKey:@"ThreeDietPart"]];
//        if ([array count] >=4) {
//            int32_t breakfast = ((XKRWDietPartStruct*) [array objectAtIndex:0]).proportion;
//            int32_t lunch = ((XKRWDietPartStruct*) [array objectAtIndex:1]).proportion;
//            int32_t snack = ((XKRWDietPartStruct*) [array objectAtIndex:2]).proportion;
//            int32_t dinner = ((XKRWDietPartStruct*) [array objectAtIndex:3]).proportion;
//            NSDictionary *scal = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:breakfast],kBreakfast,
//                                  [NSNumber numberWithInt:lunch],kLunch,
//                                  [NSNumber numberWithInt:snack],kSnack,
//                                  [NSNumber numberWithInt:dinner],kDinner
//                                  ,nil];
//            [[XKRWSettingService shareService] setMealScales:scal];
//        }
//    }
//    
//}
///*从旧版本同步数据到本地账号中*/
//+ (void) updateUserFromOldVersion
//{
//    NSString *user_sel_sql = @"SELECT slimnum AS slimID,\
//    name AS accountname,\
//    nickname ,\
//    birthday,\
//    stars AS starnum,\
//    height,\
//    sex,\
//    0 AS crowd,\
//    token,\
//    0 AS hipline,0 AS waistline,\
//    exercise AS labor_level,\
//    avatar,\
//    '' AS disease,\
//    uid AS userid,\
//    initialWeight AS origweight,\
//    targetWeight AS destweight,\
//    part,\
//    purpose AS position,\
//    degreeDifficult+1 AS diffculty,\
//    numberWeeks*7 AS duration,\
//    currentWeight AS currentweight,\
//    '' AS weightcurve,\
//    '' AS address FROM account";
//    NSString *add_user_sql = @"REPLACE INTO account (slimID,accountname,nickname,birthday,starnum,height,sex,crowd,token,hipline,waistline,labor_level,avatar,disease,userid,origweight,destweight,part,position,diffculty,duration,currentweight,weightcurve,address) VALUES(:slimID,:accountname,:nickname,:birthday,:starnum,:height,:sex,:crowd,:token,:hipline,:waistline,:labor_level,:avatar,:disease,:userid,:origweight,:destweight,:part,:position,:diffculty,:duration,:currentweight,:weightcurve,:address)";
//    /*是否登录*/
//    uint32_t cur_uid = 0;
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_OF_USER_TOKEN"];
//    if (token) {
//        cur_uid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_OF_USER_ID"] intValue] ;
//        if (cur_uid > 0) {
//            [XKRWUserDefaultService setCurrentUserId:cur_uid];
//            [[self class] updateDietScaleFromV2];
//        }
//        [XKRWUserDefaultService setStepForNewUser:kStepComplete];
//        
//    }
////    XKRWBaseService *service = [[XKRWBaseService alloc ] init];
//    
//    NSArray *rst = [[self class] executeQuery:user_sel_sql];
//    if ([rst count] > 0) {
//        NSMutableArray *uids = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in rst) {
//            BOOL __block isOK = NO;
//            [service writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
//                if (add_user_sql) {  
//                    NSMutableDictionary *user_dict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//                    NSString *birth_str = [dict objectForKey:@"birthday"];
//                    
//                    if (!birth_str  || [birth_str isKindOfClass:[NSNull class]]) {
//                        birth_str = @"1990-01-01";
//                    }
//                    
//                    NSRange range = [birth_str rangeOfString:@"-"];
//                    NSTimeInterval timestamp = 0;
//                    if (range.location !=NSNotFound) {
//                        NSArray *birth_arr = [birth_str componentsSeparatedByString:@"-"];
//                        if ([birth_arr count] == 3) {
//                            NSString *sy = [birth_arr objectAtIndex:0];
//                            NSString *sm = [birth_arr objectAtIndex:1];
//                            NSString *sd = [birth_arr objectAtIndex:2];
//                            int im = [sm intValue];
//                            if (im < 10) {
//                                sm = [NSString stringWithFormat:@"0%i",im ];
//                            }
//                            int idy = [sd intValue];
//                            if (idy < 9) {
//                                sd = [NSString stringWithFormat:@"0%i",idy ];
//                            }
//                            
//                            birth_str =[NSString stringWithFormat:@"%@-%@-%@",sy,sm,sd ];
//                            NSDate *_birthday = [NSDate dateFromString:birth_str withFormat:[NSDate dateFormatString]];
//                            timestamp = [_birthday timeIntervalSince1970];
//                            
//                        }
//                    }
//                    [user_dict setObject:[NSNumber numberWithInt:timestamp] forKey:@"birthday"];
//                    
//                    [uids addObject:[dict objectForKey:@"userid"]];
//                    isOK = [db executeUpdate:add_user_sql withParameterDictionary:user_dict];
//                }
//            }];        
//            
//        }
//        if ([uids count] > 0) {
//            for (NSString *u_id in uids) {
//                [[self class] getQAWithUID:[u_id intValue]];
//            }
//        }
//#pragma mark 当用户为试用用户时 也需要更新信息
////        if (cur_uid > 0) {
//            /*更新当前用户信息*/
////            [[XKRWUserService sharedService] getUserInfoByUserId:cur_uid];
////        }
//        
//    }
//}

/*从旧版本同步数据到本地账号中*/
+ (void) updateWeightLogFromOldVersion{
    NSString *sql = @"SELECT * FROM weight_record_log";
    NSArray *rst = [[self class] executeQuery:sql];
    if ([rst count] > 0) {
        for (NSDictionary *dict in rst) {
            BOOL __block isOK = NO;
            [service writeDefaultDBWithTask:^(FMDatabase *db,BOOL *rollback){
                NSMutableDictionary *mdict = [[NSMutableDictionary alloc] init];
                [mdict setObject:[dict objectForKey:@"uid"] forKey:@"userid"];
                NSArray *day = [[dict objectForKey:@"day"] componentsSeparatedByString:@"-"];
                uint32_t m=0,d=0;
                NSString *y_str,*m_str,*d_str;
                if ([day count] >=3 ) {
                    y_str =[day objectAtIndex:0];

                    m = [[day objectAtIndex:1] intValue];
                    if (m < 10) {
                        m_str = [NSString stringWithFormat:@"0%i",m ];
                    }else {
                        m_str = [day objectAtIndex:1];
                    }
                    d = [[day objectAtIndex:2] intValue];
                    if (d < 10) {
                        d_str = [NSString stringWithFormat:@"0%i",d ];
                    }else {
                        d_str = [day objectAtIndex:2];
                    }
                }
                [mdict setObject:[dict objectForKey:@"weight"] forKey:@"weight"];
                NSString *day_str = [[dict objectForKey:@"day"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [mdict setObject:day_str forKey:@"date"];
                [mdict setObject:y_str forKey:@"year"];
                [mdict setObject:m_str forKey:@"month"];
                [mdict setObject:d_str forKey:@"day"];
                [mdict setObject:[dict objectForKey:@"syn"] forKey:@"sync"];
                [mdict setObject:[dict objectForKey:@"add_time"] forKey:@"timestamp"];
                isOK = [db executeUpdate:@"REPLACE INTO weightrecord VALUES(:userid,:weight,:date,:year,:month,:day,:sync,:timestamp)" withParameterDictionary:mdict];
            }];
        }
    }
}

#define HABIT_FAT   @"habit_fat"
#define HABIT_SWEET @"habit_sweet"
#define HABIT_WINE  @"habit_wine"
#define HABIT_DRINK @"habit_drink"
#define HABIT_MEAT  @"habit_meat"
#define HABIT_NUT   @"habit_nut"
#define HABIT_NIGHT @"habit_night"
#define HABIT_EAT   @"habit_eat"
#define HABIT_SLOW  @"habit_slow"
#define HABIT_WALK  @"habit_walk"

+( void ) getQAWithUID:(NSInteger) u_id{
    NSArray * data = nil;
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PrivateDocuments"];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"ApplicationGroup"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"RWQustionResults_%li",(long)u_id]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        
        data = [NSMutableArray arrayWithContentsOfFile:strPath];
    }
    else {
        
        NSMutableArray *arr_1 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
        NSMutableDictionary *dic_1 = [NSMutableDictionary dictionaryWithObject:arr_1 forKey:@"100001"];
        
        NSString *str_2 = @"4";
        NSMutableDictionary *dic_2 = [NSMutableDictionary dictionaryWithObject:str_2 forKey:@"100002"];
        
        NSMutableArray *arr_3 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
        NSMutableDictionary *dic_3 = [NSMutableDictionary dictionaryWithObject:arr_3 forKey:@"100003"];
        
        NSString *str_4 = @"0";
        NSMutableDictionary *dic_4 = [NSMutableDictionary dictionaryWithObject:str_4 forKey:@"100004"];
        
        NSString *str_5 = @"2";
        NSMutableDictionary *dic_5 = [NSMutableDictionary dictionaryWithObject:str_5 forKey:@"100005"];
        
        NSString *str_6 = @"6";
        NSMutableDictionary *dic_6 = [NSMutableDictionary dictionaryWithObject:str_6 forKey:@"100006"];
        
        NSMutableArray *arr_7 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
        NSMutableDictionary *dic_7 = [NSMutableDictionary dictionaryWithObject:arr_7 forKey:@"100007"];
        
        NSMutableArray *arr_8 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
        NSMutableDictionary *dic_8 = [NSMutableDictionary dictionaryWithObject:arr_8 forKey:@"100008"];
        
        NSMutableArray *arr_9 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
        NSMutableDictionary *dic_9 = [NSMutableDictionary dictionaryWithObject:arr_9 forKey:@"100009"];
        
        /////////////////////////////////////////////////////////////////////////////////////////////////
        
        NSString *str_10 = @"1";
        NSMutableDictionary *dic_10 = [NSMutableDictionary dictionaryWithObject:str_10 forKey:@"200000"];
        
        NSString *str_11 = @"35-0-0";
        NSMutableDictionary *dic_11 = [NSMutableDictionary dictionaryWithObject:str_11 forKey:@"200001"];
        
        NSString *str_12 = @"1";
        NSMutableDictionary *dic_12 = [NSMutableDictionary dictionaryWithObject:str_12 forKey:@"200002"];
        
        NSString *str_13 = @"0";
        NSMutableDictionary *dic_13 = [NSMutableDictionary dictionaryWithObject:str_13 forKey:@"200003"];
        
        NSString *str_14 = @"25";
        NSMutableDictionary *dic_14 = [NSMutableDictionary dictionaryWithObject:str_14 forKey:@"200004"];
        
        NSString *str_15 = @"25";
        NSMutableDictionary *dic_15 = [NSMutableDictionary dictionaryWithObject:str_15 forKey:@"200005"];
        
        NSString *str_16 = @"25";
        NSMutableDictionary *dic_16 = [NSMutableDictionary dictionaryWithObject:str_16 forKey:@"200006"];
        
        NSString *str_17 = @"1";
        NSMutableDictionary *dic_17 = [NSMutableDictionary dictionaryWithObject:str_17 forKey:@"200007"];
        
        NSString *str_18 = @"1";
        NSMutableDictionary *dic_18 = [NSMutableDictionary dictionaryWithObject:str_18 forKey:@"200008"];
        
        NSString *str_19 = @"2";
        NSMutableDictionary *dic_19 = [NSMutableDictionary dictionaryWithObject:str_19 forKey:@"200009"];
        
        /////////////////////////////////////////////////////////////////////////////////////////////////
        
        NSMutableArray *arr_ = [NSMutableArray arrayWithObjects:dic_1,dic_2,dic_3,dic_4,dic_5,dic_6,dic_7,dic_8,dic_9,
                                dic_10,dic_11,dic_12,dic_13,dic_14,dic_15,dic_16,dic_17,dic_18,dic_19,nil];
        
        data = arr_;
        
    }
    
    
    NSDictionary *dic = nil;
    NSString *string = nil;
    NSArray *array = nil;
    NSString *str1_1 = nil;  //饮食油腻
    NSString *str1_2 = nil;  //零食
    NSString *str1_3 = nil;  //喝酒
    NSString *str3_1 = nil;  //喝白酒
    NSString *str3_2 = nil;  //喝红酒
    NSString *str3_3 = nil;  //喝啤酒
    NSString *str1_4 = nil;  //饮料
    
    NSString *str7_1 = nil;  //肥肉
    NSString *str7_2 = nil;  //坚果
    NSString *str7_3 = nil;  //巧克力
    NSString *str7_4 = nil;  //核桃
    
    NSString *str8_1 = nil;  //夜宵
    NSString *str8_2 = nil; //吃饭晚
    NSString *str8_3 = nil; //吃饭快
    NSString *str8_4 = nil; //饮食不规律
    
    NSString *str9_1 = nil; //活动量少
    NSString *str9_2 = nil; //没有体育锻炼
    
    NSString *a1E = nil; // 优
    NSString *a2E = nil;
    NSString *a3E = nil;
    NSString *a4E = nil;
    
    //第一题
    dic = [data objectAtIndex:0];
    array = [dic objectForKey:@"100001"];
    string = [array objectAtIndex:0];//1-A
    if ([string isEqualToString:@"1"]) {
        str1_1 = @"1_1_1";
    }
    string = [array objectAtIndex:1];//1-B
    if ([string isEqualToString:@"1"]) {
        str1_2 = @"1_2_1";
    }
    string = [array objectAtIndex:2];//1-C
    if ([string isEqualToString:@"1"]) {
        str1_3 = @"1_3_1";
    }
    string = [array objectAtIndex:3];//1-D
    if ([string isEqualToString:@"1"]) {
        str1_4 = @"1_4_1";
    }
    string = [array objectAtIndex:4];//1-E
    if ([string isEqualToString:@"1"]) {
        a1E = @"1_5_1";
    }
    /*
   喝什么
     */
    string = [array objectAtIndex:2];//1-C
    if ([string isEqualToString:@"1"]) {
        dic = [data objectAtIndex:2];
        array = [dic objectForKey:@"100003"];
        string = [array objectAtIndex:0];//3-A
        if ([string isEqualToString:@"1"]) {
            str3_1 = @"3_6_1";
        }
        string = [array objectAtIndex:1];//3-B
        if ([string isEqualToString:@"1"]) {
            str3_2 = @"3_7_1";
        }
        string = [array objectAtIndex:2];//3-C
        if ([string isEqualToString:@"1"]) {
            str3_2 = @"3_8_1";
        }
    }
    //吃什么
    dic = [data objectAtIndex:6];
    array = [dic objectForKey:@"100007"];
    string = [array objectAtIndex:0];//4-A
    if ([string isEqualToString:@"1"]) {
        str7_1 = @"7_9_1";
    }
    string = [array objectAtIndex:1];//4-B
    if ([string isEqualToString:@"1"]) {
        str7_2 = @"7_10_1";
    }
    string = [array objectAtIndex:2];//4-C
    if ([string isEqualToString:@"1"]) {
        str7_3 = @"7_11_1";
    }
    string = [array objectAtIndex:3];//4-D
    if ([string isEqualToString:@"1"]) {
        str7_4 = @"7_12_1";
    }
    string = [array objectAtIndex:4];//4-E
    if ([string isEqualToString:@"1"]) {
        a2E = @"7_13_1";
    }
    //吃饭规律
    dic = [data objectAtIndex:7];
    array = [dic objectForKey:@"100008"];
    string = [array objectAtIndex:0];//5-A
    if ([string isEqualToString:@"1"]) {
        str8_1 = @"8_14_1";
    }
    string = [array objectAtIndex:1];//5-B
    if ([string isEqualToString:@"1"]) {
        str8_2 = @"8_15_1";
    }
    string = [array objectAtIndex:2];//5-C
    if ([string isEqualToString:@"1"]) {
        str8_3 = @"8_16_1";
    }
    string = [array objectAtIndex:3];//5-D
    if ([string isEqualToString:@"1"]) {
        str8_4 = @"8_17_1";
    }
    string = [array objectAtIndex:4];//5-E
    if ([string isEqualToString:@"1"]) {
        a3E = @"8_18_1";
    }
    //运动
    dic = [data objectAtIndex:8];
    array = [dic objectForKey:@"100009"];
    string = [array objectAtIndex:0];//6-A
    if ([string isEqualToString:@"1"]) {
        str9_1 = @"9_19_1";
    }
    string = [array objectAtIndex:1];//6-B
    if ([string isEqualToString:@"1"]) {
        str9_2 = @"9_20_1";
    }
    string = [array objectAtIndex:2];//6-D
    if ([string isEqualToString:@"1"]) {
        a4E = @"9_21_1";
    }
    
    NSMutableArray * userFatReason = [NSMutableArray array];
    
    if (a1E) {
        [userFatReason addObject:a1E];
    }else{
        
        if (str1_1) {
            [userFatReason addObject:str1_1];
        }
        if (str1_2) {
            [userFatReason addObject:str1_2];
        }
        if (str1_3) {
            [userFatReason addObject:str1_3];
            
            if (str3_1) {
                [userFatReason addObject:str3_1];
            }else if (str3_2){
                [userFatReason addObject:str3_2];
            }else{
                [userFatReason addObject:str3_3];
            }
            
        }
        if (str1_4) {
            [userFatReason addObject:str1_4];
        }
    }
    
    if (a2E) {
        [userFatReason addObject:a2E];
    }
    else {
        if (str7_1) {
            [userFatReason addObject:str7_1];
        }
        if (str7_2) {
            [userFatReason addObject:str7_2];
        }
        
        if (str7_3) {
            [userFatReason addObject:str7_3];
        }
        if (str7_4) {
            [userFatReason addObject:str7_4];
        }
    }
    
    if (a3E) {
        [userFatReason addObject:a3E];
    }else{
        if (str8_1) {
            [userFatReason addObject:str8_1];
        }
        if (str8_2) {
            [userFatReason addObject:str8_2];
        }
        if (str8_3) {
            [userFatReason addObject:str8_3];
        }
        if (str8_4) {
            [userFatReason addObject:str8_4];
        }
    }
    
    if (a4E) {
        [userFatReason addObject:a4E];
    }else{
        if (str9_1) {
            [userFatReason addObject:str9_1];
        }
        if (str9_2) {
            [userFatReason addObject:str9_2];
        }
    }
    
    [[XKRWFatReasonService sharedService] saveQuenstionAnswer:userFatReason WithUID:u_id];
}

/*当天第一次打开app时，需要处理的任务*/
+ (void) firstOpenHandler
{
    //需要同步的数据
    [XKSilentDispatcher asynExecuteTask:^{
        [XKRWCommHelper syncRemoteData];
    }];

    //设置日期为今天
    [[self class] setFirstOpenToday];
}
#pragma mark  下载远程数据
//下载
+ (BOOL) syncRemoteData
{
    if (![XKRWUserDefaultService isLogin]) {
        return NO;
    }
    
    @try {
        //获取记录值
        NSNumber *result = [[XKRWRecordService4_0 sharedService] syncRecordData];
        if ([result boolValue]) {
            [XKRWRecordService4_0 setNeedUpdate:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"获记录出错了:%@",[exception description]);
        return NO;
    }

    //4.2收藏  新增
    @try {
        /*加载收藏*/
        [[XKRWCollectionService sharedService] getCollectionRemoteData];
    }
    @catch (NSException *exception) {
        NSLog(@"出错了，错误原因:%@",[exception reason]);
        return NO;
    }
    return YES;
}
+ (BOOL) syncTodayRemoteData
{
    if (![XKRWUserDefaultService isLogin]) {
        return NO;
    }
    
    @try {
        //获取记录值
        NSNumber *result = [[XKRWRecordService4_0 sharedService] syncTodayRecordData];
        if ([result boolValue]) {
            [XKRWRecordService4_0 setNeedUpdate:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"获记录出错了:%@",[exception description]);
        return NO;
    }
    
    //4.2收藏  新增
    @try {
        /*加载收藏*/
        [[XKRWCollectionService sharedService] getCollectionRemoteData];
    }
    @catch (NSException *exception) {
        NSLog(@"出错了，错误原因:%@",[exception reason]);
        return NO;
    }
    return YES;
}

//上传
+ (BOOL) syncDataToRemote
{
    if (![XKUtil isNetWorkAvailable]) {
        return NO;
    }
    if (![XKRWUserDefaultService isLogin]) {
        return NO;
    }
    /*
     *检查体重记录上传√
     
     *检查DIY食谱上传√
     
     *检查记录上传√
     
     *检查预测上传√
     
     *检查提醒上传√
     
     *检查比例上传
     
     *肥胖原因上传√
     */
    
    
//    @try {
//        /*批量上传未同步的食谱*/
//        [[XKRWSchemeService shareService] batchSaveDiySchemeToRemote];
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"出错了，错误原因:%@",[exception reason]);
//        
//        return NO;
//    }
    
    
//    @try {
//        //上传本地未同步的记录数据
//        [[XKRWRecordService shareService] syncSaveRecordToRemote];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"上传记录出错 ：%@",exception);
//        return NO;
//    }
    
    
//    @try {
//        //上传本地未同步的方案预测记录
//        [[XKRWRecordService shareService] syncSaveForecastToRemote];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"上传方案预测出错 ：%@",exception);
//        return NO;
//    }
    
//    
//    @try {
//        //上传本地的提醒数据
//        [[XKRWAlarmService shareService] batchSaveAlarmToRemote];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"上传提醒出错 ：%@",exception);
//        return NO;
//    }
    
    
//    @try {
//        //体重记录
//        [[XKRWWeightService shareService] batchUploadWeightToRemoteNeedLong:YES];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"上传体重记录出错 ：%@",exception);
//        return NO;
//    }
    
    
//    @try {
//        //肥胖原因
//        [[XKRWFatReasonService sharedService] uploadQuestionAswerToRemoteServerNeedLong:YES];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"上传肥胖原因出错 ：%@",exception);
//        return NO;
//    }
    
    @try {
        //记录页记录（饮食，运动，围度，体重等等）
        if (![[[XKRWRecordService4_0 sharedService] syncOfflineRecordToRemote] boolValue]) {
            NSLog(@"上传记录出错");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"上传记录出错 ：%@",exception);
        return NO;
    }
    
   
    
    return YES;
}

+ (void) initAlarmData:(uint32_t) uid
{
    if (uid > 0) {
        
    }
}

+ (NSDictionary *) getAlarmsData
{
    NSDictionary *data = [[SAMCache sharedCache] objectForKey:kAlarmMsgFile];
    if (!data) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:kAlarmMsgFile ofType:@"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            data = [NSDictionary dictionaryWithContentsOfFile:plistPath];
            if (data) {
                [[SAMCache sharedCache] setObject:data forKey:kAlarmMsgFile];
            }
        }
    }
    return data;
}

+ (NSString *)getAlarmTitleWithType:(AlarmType)alarmType
{
    NSString *k = nil;
    switch (alarmType) {
            //        case eAlarmWeight:
            //            k = @"alarmWeightMsg";
            //            break;
        case eAlarmBreakfast:
            k = @"早餐"; break;
        case eAlarmExercise:
            k = @"运动"; break;
        case eAlarmDinner:
            k = @"晚餐"; break;
        case eAlarmLunch:
            k = @"午餐"; break;
        case eAlarmWalk:
            k = @"饭后散步"; break;
        case eAlarmHabit:
            k = @"习惯改善"; break;
        case eAlarmRecord:
            k = @"查看每日分析"; break;
            //        case eAlarmSleep:
            //            k=@"alarmSleepMsg";break;
        case eAlarmDrinkWater:
            k=@"喝水";break;
        case eAlarmSnack:
            k = @"加餐"; break;
            //        case eAlarmAddFood:
            //            k=@"alarmAddFoodMsg";break;
        default:
            break;
    }
    return k;
}

//获取闹钟内容
+ (NSString *) getAlarmMsgWithType:(AlarmType)alrmType
{
    NSString *msg = nil;
    NSString *k;
    switch (alrmType) {
        case eAlarmBreakfast:
            k = @"alarmBreakfastMsg"; break;
        case eAlarmExercise:
            k = @"alarmExerciseMsg"; break;
        case eAlarmDinner:
            k = @"alarmSupperMsg"; break;
        case eAlarmLunch:
            k = @"alarmLunchMsg"; break;
        case eAlarmWalk:
            k = @"alarmWalkMsg"; break;
        case eAlarmHabit:
            k = @"alarmHabitMsg"; break;
        case eAlarmRecord:
            k = @"alarmRecordMsg"; break;
        case eAlarmDrinkWater:
            k=@"alarmDrinkWaterMsg";break;
        case eAlarmSnack:
            k = @"alarmSnackMsg"; break;
        default:
            break;
    }
    NSDictionary *alarmDict = [[self class] getAlarmsData];
    
    if ([k isEqualToString:@"alarmHabitMsg"]) {
        
        XKRWRecordEntity4_0 *recordEntity = [[XKRWRecordEntity4_0 alloc] init];
        recordEntity.habitArray = [NSMutableArray array];
        [recordEntity reloadHabitArray];
        NSArray *habitArray = recordEntity.habitArray;
        
        if (habitArray && habitArray.count) {
            int num = arc4random() % (habitArray.count);
            XKRWHabbitEntity *habitEntity = (XKRWHabbitEntity *)habitArray[num];
            msg = alarmDict[k][habitEntity.hid - 1];
        }
        
    } else {
        
        msg = alarmDict[k];
    }
//    NSArray *arr = [alarmDict objectForKey:k];
//    if ([arr count] > 0) {
//        uint32_t idx = 0;
//        if (alrmType == eAlarmHabit) {
//            idx = [[XKRWFatReasonService sharedService] getAlarmDescriptionIndex];
//        }else{
//            idx = [XKRWUtil getRandomNumber:0 to:[arr count]-1];
//        }
//        msg = [arr objectAtIndex:idx];
//        if (alrmType == eAlarmExercise) {
//            NSRange rang = [msg rangeOfString:@"%i"];
//            if (rang.length != NSNotFound) {
//                msg = [NSString stringWithFormat:msg,(uint32_t)[XKRWAlgolHelper dailyConsumeSportEnergy]];
//            }
//        }
//    }
    return msg;
}
+ (NSArray *) getWeightHints
{
    NSArray *data = [[SAMCache sharedCache] objectForKey:kWeightHint];
    if (!data) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:kWeightHint ofType:@"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            data = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"weightTitles"];
            if (data) {
                [[SAMCache sharedCache] setObject:data forKey:kWeightHint];
            }
        }
    }
    return data;
}


+ (NSMutableArray *) executeQuery:(NSString *)sql{
    [self initOldDbQueue];
    NSMutableArray *rest = [[NSMutableArray alloc] init];
    [fmdbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rstSet = [db executeQuery:sql];
        while ([rstSet next]) {
            NSDictionary *dict_value = [rstSet resultDictionary];
            [rest addObject:dict_value];
        }
    }];
    return rest;
}
+ (BOOL ) executeUpdate:(NSString *)sql param:(NSDictionary*)param  {
    [self initOldDbQueue];
    __block BOOL isOK = NO;
    [fmdbq inTransaction:^(FMDatabase *db, BOOL *rollback) {
        isOK = [db executeUpdate:sql withParameterDictionary:param];
    }];
    return isOK;
}

+ (BOOL) initOldDbQueue
{
    BOOL sucess = YES;
    
    if (!fmdbq) {
        NSString *dbFileName = [XKConfigUtil stringForKey:@"oldVersionDbName"];
        NSString *path = [[self class] fileFullPath:dbFileName];
        if (path) {
            fmdbq = [FMDatabaseQueue databaseQueueWithPath:path];
        }else{
            sucess = NO;
        }
    }
    
    if (!service) {
        service = [[XKRWBaseService alloc] init];
    }
    return sucess;
}

//同步1.0的体重记录
+ (void) synWeightLogFromVersion1
{
    //    [XKDispatcher asynExecuteTask:^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"weightHistory.plist"];

    if (![[self class ] fileExists:@"weightHistory.plist"]) {
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSMutableArray *weightLogList = [[self class] readArchFile:file];
        //如果有历史体重记录
        if ([weightLogList count] > 0) {
            for (NSArray *arr_item in weightLogList) {
                //存在体重记录
                if ([arr_item count] ==2) {
                    NSString *weight = [NSString stringWithFormat:@"%i",(int)[[arr_item objectAtIndex:1] floatValue] *1000 ];
                     NSDate *date = [NSDate dateFromString:[arr_item objectAtIndex:0] withFormat:@"yyyy.MM.dd mm:ss"];
                    [[XKRWWeightService shareService] saveWeightRecord:weight date:date sync:@"0" andTimeRecord:nil];
                }
            }
            
        }
    }
}

+ (BOOL) fileExists:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (NSString *)fileFullPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {

        return nil;
        [NSException raise:NSInvalidArgumentException format:@"The specified database file named as [%@] doesn't exist for the full path [%@].", fileName, filePath];
    }
    
    return filePath;
}

+ (NSMutableArray *)readArchFile:(NSString *)file{
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]){
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:file];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void) cleanCache
{
    NSString *sql = @" DELETE FROM caches WHERE id LIKE 'food%' OR id LIKE 'sport%' ";
    @try {
        [[XKRWUserService sharedService] executeSql:sql];
    }
    @catch (NSException *exception) {
#ifdef XK_DEV
        NSLog(@"清理失败:%@",[exception reason] );
#endif
    }
    
    
    NSString * recommentApp = @"delete from recommend_app";
    @try {
        [[XKRWUserService sharedService] executeSql:recommentApp];
    }
    @catch (NSException *exception) {
#ifdef XK_DEV
        NSLog(@"应用推荐:%@",[exception reason] );
#endif
    }
    
}

@end
