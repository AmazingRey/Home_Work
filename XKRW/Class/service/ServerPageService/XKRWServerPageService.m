//
//  XKRWServerPageService.m
//  XKRW
//
//  Created by XiKang on 15-1-13.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

#import "XKRWServerPageService.h"
#import "ASIHTTPRequest.h"
#import "XKRWIslimModel.h"
#import "XKRWBodyModel.h"
#import "XKRWOtherFactorsModel.h"
#import "XKRWHabitModel.h"
#import "XKRWSchemeStepsModel.h"
#import "XKRWDescribeModel.h"
#import "XKRWStatusModel.h"
#import "XKRWDietModel.h"
#import "XKRWIslimSportModel.h"
#import "XKRWSportResultModel.h"
#import "XKRWsportRegulateModel.h"
#import "XKRWsportAdviseModel.h"
#import "XKRWSportIntroductionModel.h"
#import "XKRWFatReasonEntity.h"
#import "XKRWRecordEntity4_0.h"
#import "XKRWFatReasonService.h"
#import "XKRWCommentModel.h"
#import "XKRWFileManager.h"
#import "XKRWUserService.h"

#define TEST_TOKEN @"KKexYFyNAVpjZMd5bkDIAqFb81xjqeroBvKrWlOVH*iUhYHWZcymAYKQ6TltWSLb4YK5YqQxvonCsHYL"
#define SWITCH_KEY [NSString stringWithFormat:@"%@_show_purchase_entry", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]

static XKRWServerPageService *sharedInstance = nil;
static NSMutableArray *answerArray =  nil;
 
@implementation XKRWServerPageService

#pragma mark - 单例
+ (id)sharedService {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[XKRWServerPageService alloc] init];
    });
    return sharedInstance;
}
#pragma mark -
#pragma mark - 网络方法
#pragma mark -
#pragma mark - 是否显示购买入口
- (BOOL)isShowPurchaseEntry {
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:SWITCH_KEY];
    
    if (value && [value boolValue]) {
        return YES;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pay/status/", kNewServer]];
    
//    NSDictionary *param = @{@"token": NEW_TOKEN};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
    BOOL isShow = [result[@"data"] boolValue];
    if (isShow) {
        [[NSUserDefaults standardUserDefaults] setObject:@(isShow) forKey:SWITCH_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isShow;
}

- (BOOL)isShowPurchaseEntry_uploadVersion {
    
    if (![self needRequestStateOfSwitch]) {
        return YES;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pay/status2/", kNewServer]];
    
    NSString *version = [NSString stringWithFormat:@"i%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSDictionary *param = @{@"ver": version};
    
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:param];
    
    BOOL isShow = [result[@"data"] boolValue];
    if (isShow) {
        [[NSUserDefaults standardUserDefaults] setObject:@(isShow) forKey:SWITCH_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isShow;
}

- (BOOL)needRequestStateOfSwitch {
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:SWITCH_KEY];
    
    if (value && [value boolValue]) {
        return NO;
    }
    return YES;
}
#pragma mark - 获取用户购买状态和剩余评估次数
- (NSDictionary *)getUserPurchaseState
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kiSlimChances]];
    
//    NSDictionary *param = @{@"token": NEW_TOKEN};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
//    PurchaseState state;
//    
//    NSString *identifier = [NSString stringWithFormat:@"%ld.islim", (long)UID];
//    if ([self isUsed:identifier]) {
//        
//        state = PurchaseStateDone;
//    } else {
//        if ([result[@"data"] intValue]) {
//            state = PurchaseStatePurchased;
//        } else {
//            state = PurchaseStateNotYet;
//        }
//    }
    [self setNumberOfEvaluteChances:[result[@"data"] intValue]];
    
    return @{@"data": result[@"data"]};
}

#pragma mark - 获取免费兑换剩余天数
- (NSNumber *)getFreeExchangeRestDays {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kGetInsistDays]];
    
//    NSDictionary *param = @{@"token": NEW_TOKEN};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    NSInteger days = [result[@"data"] integerValue];
    if (days >= 0) {
        return @(((60 - days)>=0)?(60-days):0);
    } else {
        return @(days);
    }
}
#pragma mark - 上传兑换码
- (NSDictionary *)uploadExchangeCode:(NSString *)exchangeCode {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kUploadExchangeCode]];
    NSDictionary *param = @{@"cdkey": exchangeCode};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:param];
    
    return result[@"data"];
//    return @{@"flag": @1};
}
#pragma mark - 获取iSlim总评论数
- (NSDictionary *)getServerDataFromNetwork {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", kNewServer, @"/evaluate/getNums/"];
//    NSDictionary *param = @{@"token" : NEW_TOKEN};
    
    NSDictionary *result = [self syncBatchDataWith:[NSURL URLWithString:url] andPostForm:nil withLongTime:YES];
    return [result objectForKey:@"data"];
}
#pragma mark - 上传评估答案、获取评估结果
- (XKRWIslimModel *)uploadEvaluateAnswer {

    if (answerArray.count < 28) {
        
        //查找用户是否有喝饮料的坏习惯
        XKRWRecordEntity4_0 *recordEntity = [[XKRWRecordEntity4_0 alloc] init];
        [recordEntity reloadHabitArray];
        
        BOOL flag = NO;
        for (XKRWHabbitEntity *habit in recordEntity.habitArray) {
            if (habit.hid == 3) {
                flag = YES;
                break;
            }
        }
        [answerArray addObject:[NSNumber numberWithBool:flag]];
    }
    
    //发送数据
    NSString *url = [NSString stringWithFormat:@"%@/%@", kNewServer, kUploadAnswers];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:answerArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];

    NSDictionary *param = @{@"answers": jsonString};
    
    NSDictionary *result = [self syncBatchDataWith:[NSURL URLWithString:url] andPostForm:param withLongTime:YES];
    
    [self setNumberOfEvaluteChances:[self getEvaluateChances] - 1];

    NSString *fileName = [NSString stringWithFormat:@"%ld.islim",(long)UID];
    NSString *path =  [XKRWFileManager getFilePath:fileName];
    [result writeToFile:path atomically:YES];
    
    return [self getIslimModelFromResultDic:result];
}
#pragma mark - 从本地文件读取评估结果
/**
 *  从本地文件读取评估结果Model
 *
 *  @return 评估结果Model
 */
- (XKRWIslimModel *)getIslimModelFromLocalFile {
    
    NSString *fileName = [NSString stringWithFormat:@"%ld.islim",(long)UID];
    
    if (![XKRWFileManager isFileExist:fileName]) {
        XKLog(@"无本地评估结果文件");
        return nil;
    }
    NSString *path = [XKRWFileManager getFilePath:fileName];
    
    NSDictionary *resultDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    XKRWIslimModel *model = [self getIslimModelFromResultDic:resultDic];

    return model;
}
#pragma mark - 解析评估结果字典
/**
 *  从字典解析评估结果Model
 *
 *  @param result 服务器返回结果字典或本地文件
 *
 *  @return 评估结果Model
 */
- (XKRWIslimModel *)getIslimModelFromResultDic:(NSDictionary *)data {
    
    NSDictionary *result = data[@"data"];
    if (result[@"code"] && [result[@"code"] intValue] == 0) {
        return nil;
    }
    XKRWIslimModel *islimModel = [[XKRWIslimModel alloc]init];
    
    islimModel.dateString = result[@"create_time"];
    
    //解析到bodyModel里面
    NSDictionary *bodyDic = [[result objectForKey:@"report"] objectForKey:@"body"];
    XKRWBodyModel *bodyModel = [[XKRWBodyModel alloc] init];
    bodyModel.BMI = [bodyDic objectForKey:@"BMI"];
    bodyModel.BMIStatus = [bodyDic objectForKey:@"BMIStatus"];
    bodyModel.BMR = [[bodyDic objectForKey:@"BMR"] integerValue];
    bodyModel.bestWeight = [[bodyDic objectForKey:@"bestWeight"]floatValue];
    bodyModel.bodyFatPercentage = [bodyDic objectForKey:@"bodyFatPercentage"];
    bodyModel.fatPctStatus =[bodyDic objectForKey:@"fatPctStatus"];
    bodyModel.fatStandard =[bodyDic objectForKey:@"fatStandard"];
    bodyModel.lowestCalCtrl = [[bodyDic objectForKey:@"lowestCalCtrl"]integerValue];
    bodyModel.BMIsd =[[bodyDic objectForKey:@"stature"]objectForKey:@"BMIsd"];
    bodyModel.calf =[[bodyDic objectForKey:@"stature"]objectForKey:@"calf"];
    bodyModel.chest =[[bodyDic objectForKey:@"stature"]objectForKey:@"chest"];
    bodyModel.hipline =[[bodyDic objectForKey:@"stature"]objectForKey:@"hipline"];
    bodyModel.thigh =[[bodyDic objectForKey:@"stature"]objectForKey:@"thigh"];
    bodyModel.scale =[[bodyDic objectForKey:@"stature"]objectForKey:@"scale"];
    bodyModel.waist =[[bodyDic objectForKey:@"stature"]objectForKey:@"waist"];
    
    bodyModel.BMISdisc = [bodyDic objectForKey:@"BMISdisc"];
    bodyModel.fatPctdisc1 = [bodyDic objectForKey:@"fatPctdisc1"];
    bodyModel.fatPctdisc2 = [bodyDic objectForKey:@"fatPctdisc2"];
    bodyModel.fatSTFlag =[[bodyDic objectForKey:@"fatSTFlag"] integerValue];
    bodyModel.BMISflag = [[bodyDic objectForKey:@"BMISflag"] integerValue] ;
    bodyModel.fatPctFlag = [[bodyDic objectForKey:@"fatPctFlag"] integerValue] ;
    
    bodyModel.height = [NSString stringWithFormat:@"%ld",(long)[[bodyDic objectForKey:@"height"]integerValue]];
    bodyModel.weight = [NSString stringWithFormat:@"%.1f",[[bodyDic objectForKey:@"weight"]floatValue]];
    bodyModel.age = [NSString stringWithFormat:@"%ld",(long)[[bodyDic objectForKey:@"age"]integerValue]];
    bodyModel.gender = [NSString stringWithFormat:@"%ld",(long)[[bodyDic objectForKey:@"sex"]integerValue]];
    
    XKRWStatusModel *bodyStatusModel = [[XKRWStatusModel alloc]init];
    bodyStatusModel.desc = [[bodyDic objectForKey:@"status"] objectForKey:@"desc"];
    XKLog(@"---%@",[[bodyDic objectForKey:@"status"] objectForKey:@"flag"]);
    bodyStatusModel.flag = [[[bodyDic objectForKey:@"status"] objectForKey:@"flag"]integerValue];
    bodyStatusModel.name = [[bodyDic objectForKey:@"status"] objectForKey:@"name"];
    XKLog(@"---%@",[[bodyDic objectForKey:@"status"] objectForKey:@"score"]);
    bodyStatusModel.score = [[[bodyDic objectForKey:@"status"] objectForKey:@"score"]integerValue];
    bodyStatusModel.word = [[bodyDic objectForKey:@"status"] objectForKey:@"word"];
    bodyModel.model = bodyStatusModel;
    
    
    bodyModel.total = [bodyDic objectForKey:@"total"];
    
    //解析到OtherFactorsModel  里面
    NSDictionary *otherFactorsDic = [[result objectForKey:@"report"] objectForKey:@"comprehensive"];
    XKRWOtherFactorsModel *otherFactorsModel = [[XKRWOtherFactorsModel alloc ]init];
    
    NSDictionary *characterDic =  [otherFactorsDic objectForKey:@"character"];
    XKRWDescribeModel *characterModel = [[XKRWDescribeModel alloc]init];
    characterModel.advise = [characterDic objectForKey:@"advise"];
    characterModel.flag = [[characterDic objectForKey:@"flag"] integerValue];
    characterModel.result = [characterDic objectForKey:@"result"];
    otherFactorsModel.characterModel = characterModel;
    
    NSDictionary *mindDic = [otherFactorsDic objectForKey:@"mind"];
    NSMutableArray *mindMutableArray = [[NSMutableArray alloc]init];
    for (NSString *key in [mindDic allKeys]) {
        XKRWDescribeModel *mindModel = [[XKRWDescribeModel alloc]init];
        mindModel.advise = [mindDic[key] objectForKey:@"advise" ];
        mindModel.flag = [[mindDic[key] objectForKey:@"flag" ] integerValue];
        mindModel.result = [mindDic[key] objectForKey:@"result" ];
        [mindMutableArray addObject:mindModel];
    }
    otherFactorsModel.mindArray = mindMutableArray;
    
    NSDictionary *reasonDic = [otherFactorsDic objectForKey:@"reason"];
    NSMutableArray *reasonMutableArray = [[NSMutableArray alloc]init];
    for (NSString *key in [reasonDic allKeys]) {
        XKRWDescribeModel *reasonModel = [[XKRWDescribeModel alloc] init];
        reasonModel.advise = [reasonDic[key] objectForKey:@"advise" ];
        reasonModel.flag = [[reasonDic[key] objectForKey:@"flag" ] integerValue];
        
        reasonModel.result = [reasonDic[key] objectForKey:@"result" ];
        
        [reasonMutableArray addObject:reasonModel];
    }
    otherFactorsModel.reasonArray = reasonMutableArray;
    
    NSDictionary *otherFactorsStatusDic = [otherFactorsDic objectForKey:@"status"];
    
    XKRWStatusModel *otherFactorsStatusModel = [[XKRWStatusModel alloc]init];
    otherFactorsStatusModel.desc = [otherFactorsStatusDic  objectForKey:@"desc"];
    otherFactorsStatusModel.flag = [[otherFactorsStatusDic objectForKey:@"flag"]integerValue];
    otherFactorsStatusModel.name = [otherFactorsStatusDic objectForKey:@"name"];
    otherFactorsStatusModel.score = [[otherFactorsStatusDic objectForKey:@"score"]integerValue];
    otherFactorsStatusModel.word = [otherFactorsStatusDic objectForKey:@"word"];
    otherFactorsModel.model = otherFactorsStatusModel;
    
    //解析到 habitModel里面
    
    NSDictionary *habitDic = [[result objectForKey:@"report"] objectForKey:@"custom"];
    XKRWHabitModel *habitModel = [[XKRWHabitModel alloc]init];
    habitModel.total = [[habitDic objectForKey:@"total"]integerValue];
    
    NSDictionary *otherDic = [habitDic objectForKey:@"other"];
    
    if (otherDic != nil) {
        habitModel.otherDescribeModel.advise = [otherDic objectForKey:@"advise"];
        habitModel.otherDescribeModel.flag = [[otherDic objectForKey:@"flag"] integerValue];
        habitModel.otherDescribeModel.result = [otherDic objectForKey:@"result"];
    }
    
    
    NSDictionary *reduceCalDic = [habitDic objectForKey:@"reduce_cal"];
    if(reduceCalDic != nil)
    {
        NSMutableArray *reduceCalArray = [[NSMutableArray alloc ] init];
        for(int i =0;i < [[reduceCalDic allKeys] count];i++)
        {
            XKRWDescribeModel *describeModel = [[XKRWDescribeModel alloc]init];
            NSDictionary *dic=  [[reduceCalDic allValues]objectAtIndex:i];
            describeModel.advise = [dic objectForKey:@"advise"];
            describeModel.flag = [[dic objectForKey:@"flag"] integerValue];
            describeModel.result = [dic objectForKey:@"result"];
            [reduceCalArray addObject:describeModel];
        }
        habitModel.reduceCalArray = reduceCalArray;
    }
    NSDictionary *bodyConsumeDic = [habitDic objectForKey:@"body_consume"];
    NSMutableArray *bodyConsumeArray = [[NSMutableArray alloc ] init];
    if (bodyConsumeDic!= nil) {
        for(int i =0;i < [[bodyConsumeDic allKeys] count];i++)
        {
            XKRWDescribeModel *describeModel = [[XKRWDescribeModel alloc]init];
            NSDictionary *dic=  [[bodyConsumeDic allValues]objectAtIndex:i];
            describeModel.advise = [dic objectForKey:@"advise"];
            describeModel.flag = [[dic objectForKey:@"flag"] integerValue];
            describeModel.result = [dic objectForKey:@"result"];
            [bodyConsumeArray addObject:describeModel];
        }
        habitModel.bodyConsumeArray = bodyConsumeArray;
    }
    
    
    
    NSDictionary *secretionDic = [habitDic objectForKey:@"secretion"];
    NSMutableArray *secretionArray = [[NSMutableArray alloc ] init];
    if (secretionDic!= nil) {
        for(int i =0;i < [[secretionDic allKeys] count];i++)
        {
            XKRWDescribeModel *describeModel = [[XKRWDescribeModel alloc]init];
            NSDictionary *dic=  [[secretionDic allValues]objectAtIndex:i];
            describeModel.advise = [dic objectForKey:@"advise"];
            describeModel.flag = [[dic objectForKey:@"flag"] integerValue];
            describeModel.result = [dic objectForKey:@"result"];
            [secretionArray addObject:describeModel];
        }
        habitModel.secretionArray = secretionArray;
        
    }
    
    NSDictionary *habitStatusDic = [habitDic objectForKey:@"status"];
    XKRWStatusModel *habitStatusModel = [[XKRWStatusModel alloc] init];
    habitStatusModel.desc = [habitStatusDic objectForKey:@"desc"];
    habitStatusModel.flag = [[habitStatusDic objectForKey:@"flag"]integerValue];
    habitStatusModel.name = [habitStatusDic objectForKey:@"name"];
    habitStatusModel.score = [[habitStatusDic objectForKey:@"score"]integerValue];
    habitStatusModel.word = [habitStatusDic objectForKey:@"word"];
    habitModel.model = habitStatusModel;
    
    //解析到 DietModel里面
    NSDictionary *dietDic = [[result objectForKey:@"report"] objectForKey:@"dietary"];
    XKRWDietModel *dietModel = [[XKRWDietModel alloc]init];
    dietModel.total = [[dietDic objectForKey:@"total"] integerValue];
    
    NSDictionary *dietStatusDic = [dietDic objectForKey:@"status"];
    XKRWStatusModel *dietStatusModel = [[XKRWStatusModel alloc] init];
    dietStatusModel.desc = [dietStatusDic objectForKey:@"desc"];
    dietStatusModel.flag = [[dietStatusDic objectForKey:@"flag"]integerValue];
    dietStatusModel.name = [dietStatusDic objectForKey:@"name"];
    dietStatusModel.score = [[dietStatusDic objectForKey:@"score"] integerValue];
    dietStatusModel.word = [dietStatusDic objectForKey:@"word"];
    dietModel.model = dietStatusModel;
    
    NSDictionary *caloriesCtrlDic = [dietDic objectForKey:@"caloriesCtrl"];
    XKRWDescribeModel *caloriesCtrlModel = [[XKRWDescribeModel alloc]init];
    caloriesCtrlModel.Calories = [[caloriesCtrlDic objectForKey:@"Calories"]integerValue];
    caloriesCtrlModel.advise = [caloriesCtrlDic objectForKey:@"advise"];
    caloriesCtrlModel.flag = [[caloriesCtrlDic objectForKey:@"flag"]integerValue];
    caloriesCtrlModel.result = [caloriesCtrlDic objectForKey:@"result"];
    dietModel.caloriesCtrlModel = caloriesCtrlModel;
    
    NSArray *array = [[dietDic objectForKey:@"dietaryStatus"] allValues] ;
    NSMutableArray  *dietaryStatueArray = [NSMutableArray arrayWithCapacity:[array count]];
    for ( int i = 0 ; i <[array count]; i++) {
        NSDictionary *dietaryStatueDic = [array objectAtIndex:i];
        XKRWDescribeModel *dietaryStatueModel = [[XKRWDescribeModel alloc]init];
        dietaryStatueModel.Calories = [[dietaryStatueDic objectForKey:@"Calories"]integerValue];
        dietaryStatueModel.advise = [dietaryStatueDic objectForKey:@"advise"];
        dietaryStatueModel.flag = [[dietaryStatueDic objectForKey:@"flag"]integerValue];
        dietaryStatueModel.result = [dietaryStatueDic objectForKey:@"result"];
    
        [dietaryStatueArray addObject:dietaryStatueModel];
        
    }
    
    dietModel.dietaryStatueArray = dietaryStatueArray;
    
    NSDictionary *extraMealDic = [dietDic objectForKey:@"extraMeal"];
    XKRWDescribeModel *extraMealModel = [[XKRWDescribeModel alloc]init];
    extraMealModel.Calories = [[extraMealDic objectForKey:@"Calories"]integerValue];
    extraMealModel.advise = [extraMealDic objectForKey:@"advise"];
    extraMealModel.flag = [[extraMealDic objectForKey:@"flag"]integerValue];
    extraMealModel.result = [extraMealDic objectForKey:@"result"];
    dietModel.extraMealModel =extraMealModel;
    
    NSDictionary *repastPlanDic = [dietDic objectForKey:@"repastPlan"];
    XKRWDescribeModel *repastPlanModel = [[XKRWDescribeModel alloc]init];
    repastPlanModel.Calories = [[repastPlanDic objectForKey:@"Calories"]integerValue];
    repastPlanModel.advise = [repastPlanDic objectForKey:@"advise"];
    repastPlanModel.flag = [[repastPlanDic objectForKey:@"flag"]integerValue];
    repastPlanModel.result = [repastPlanDic objectForKey:@"result"];
    dietModel.repastPlanModel =repastPlanModel;
    
    //解析到 sportModel里面
    NSDictionary *sportDic = [[result objectForKey:@"report"] objectForKey:@"sport"];
    XKRWIslimSportModel *sportModel = [[XKRWIslimSportModel alloc]init];
    sportModel.total = [[sportDic objectForKey:@"total"]integerValue];
    sportModel.sportLevel = [sportDic objectForKey:@"sportLevel"];
    sportModel.flag = [[sportDic objectForKey:@"flag"]integerValue];
    
    NSDictionary *regulateDic = [sportDic objectForKey:@"sportRegulate"];
    XKRWsportRegulateModel  *regulateModel = [[XKRWsportRegulateModel alloc]init];
    regulateModel.period = [regulateDic objectForKey:@"period"];
    regulateModel.time = [regulateDic objectForKey:@"time"];
    regulateModel.level = [regulateDic objectForKey:@"level"];
    regulateModel.type = [regulateDic objectForKey:@"type"];
    sportModel.regulateModel = regulateModel;
    
    NSDictionary *adviseDic =  [sportDic objectForKey:@"advise"];
    XKRWsportAdviseModel *adviseModel = [[XKRWsportAdviseModel alloc]init];
    adviseModel.guide1 = [adviseDic objectForKey:@"guide1"];
    adviseModel.guide2 = [adviseDic objectForKey:@"guide2"];
    adviseModel.introduction = [adviseDic objectForKey:@"introduction"];
    adviseModel.aerobics = [adviseDic objectForKey:@"aerobics"];
    adviseModel.strength = [adviseDic objectForKey:@"strength"];
    sportModel.adviseModel = adviseModel;
    
    NSDictionary *resultDic =  [sportDic objectForKey:@"result"];
    XKRWSportResultModel *resultModel = [[XKRWSportResultModel alloc]init];
    resultModel.status = [resultDic objectForKey:@"status"];
    resultModel.heart_lung = [resultDic objectForKey:@"heart_lung"];
    resultModel.power = [resultDic objectForKey:@"power"];
    resultModel.fp = resultDic[@"fp"];
    
    resultModel.stDes = resultDic[@"stDes"];
    resultModel.hlDes = resultDic[@"hlDes"];
    resultModel.pDes = resultDic[@"pDes"];
    resultModel.fpDes = resultDic[@"fpDes"];
    
    resultModel.stFlag = [resultDic[@"stFlag"] intValue];
    resultModel.fpFlag = [resultDic[@"fpFlag"] intValue];
    resultModel.hlFlag = [resultDic[@"hlFlag"] intValue];
    resultModel.pFlag = [resultDic[@"pFlag"] intValue];
    
    sportModel.resultModel = resultModel;
    
    NSArray *introductionArray = [sportDic objectForKey:@"introduction"];
    
    NSMutableArray *introductionMutableArray = [NSMutableArray array];
    
    for (int i =0 ; i <[introductionArray count]; i++) {
        NSDictionary *dic = [introductionArray objectAtIndex:i];
        XKRWSportIntroductionModel *introductionModel = [[XKRWSportIntroductionModel alloc]init];
        introductionModel.name = [dic objectForKey:@"name"];
        introductionModel.catsArray = [dic objectForKey:@"cats"];
        [introductionMutableArray addObject:introductionModel];
    }
    
    sportModel.introductionArray = introductionMutableArray;
    sportModel.comment = [sportDic objectForKey:@"comment"];
    
    NSDictionary *sportStatusDic = [sportDic objectForKey:@"status"];
    XKRWStatusModel *sportStatusModel = [[XKRWStatusModel alloc] init];
    sportStatusModel.desc = [sportStatusDic objectForKey:@"desc"];
    sportStatusModel.flag = [[sportStatusDic objectForKey:@"flag"]integerValue];
    sportStatusModel.name = [sportStatusDic objectForKey:@"name"];
    sportStatusModel.score = [[sportStatusDic objectForKey:@"score"]integerValue];
    sportStatusModel.word = [sportStatusDic objectForKey:@"word"];
    sportModel.model = sportStatusModel;
    
    NSDictionary *stepsDic = [result objectForKey:@"report"];
    
    NSMutableArray  *stepsArray = [NSMutableArray arrayWithCapacity:[[stepsDic objectForKey:@"steps"] count]];
    for (NSDictionary *dic in [stepsDic objectForKey:@"steps"]) {
        XKRWSchemeStepsModel *stepsModel = [[XKRWSchemeStepsModel alloc]init];
        stepsModel.calory = [[dic objectForKey:@"calory"]integerValue];
        stepsModel.flag = [[dic objectForKey:@"flag"]integerValue];
        stepsModel.weight = [[dic objectForKey:@"weight"]integerValue];
        stepsModel.tag = [dic objectForKey:@"tag"];
        stepsModel.title =[dic objectForKey:@"title" ];
        stepsModel.step = [dic objectForKey:@"step" ];
        [stepsArray addObject:stepsModel];
    }
    
    islimModel.bodyModel = bodyModel;
    islimModel.habitModel = habitModel;
    islimModel.otherFactorsModel = otherFactorsModel;
    islimModel.sportmodel = sportModel;
    islimModel.dietModel = dietModel;
    islimModel.guideStepArray = stepsArray;
    islimModel.success = [[result objectForKey:@"success"] integerValue];
    return islimModel;
}
#pragma mark - 从服务器获取评估结果
- (XKRWIslimModel *)getiSlimReportFromRemote {
    
    XKRWIslimModel *localModel = [self getIslimModelFromLocalFile];
    NSString *dateString = nil;
    
    if (!localModel) {
        dateString = @"";
    } else {
        dateString = localModel.dateString;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kGetReport]];
    NSDictionary *param = @{@"latest": dateString};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:param];
    //解析字典
    XKRWIslimModel *model = [self getIslimModelFromResultDic:result];
    
    if (model) {
        //存储本地
        NSString *fileName = [NSString stringWithFormat:@"%ld.islim",(long)UID];
        NSString *path =  [XKRWFileManager getFilePath:fileName];
        [result writeToFile:path atomically:YES];
    }
    return model;
}
#pragma mark - 点击参加免费兑换
- (BOOL)participateFreeExchange {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kJoinFreeExchange]];
    
//    NSDictionary *param = @{@"token": NEW_TOKEN};
    [self syncBatchDataWith:url andPostForm:nil];
    return YES;
}
#pragma mark - 兑换iSlim
- (BOOL)exchangeiSlim {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kExchange]];
    
//    NSDictionary *param = @{@"token": NEW_TOKEN};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
    if ([result[@"success"] intValue]) {
        return YES;
    }
    return NO;
}
#pragma mark - 获取评论
- (XKRWIslimCommentModel *)getCommentDataFromNetworkWithCommentID:(NSString *)commentId
                                                      commentType:(NSString *)type {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", kNewServer, @"/evaluate/getCmts/"];
    NSDictionary *param ;
    if (commentId == nil) {
        param = nil; //@{@"token" : NEW_TOKEN};
        
    } else {
        param = @{@"date": commentId,
                  @"type":type};
    }
    NSDictionary *result = [self syncBatchDataWith:[NSURL URLWithString:url] andPostForm:param withLongTime:YES];
    
    XKRWIslimCommentModel *islimCommentModel = [[XKRWIslimCommentModel alloc]init];
    islimCommentModel.commentTotal = [[[result objectForKey:@"data"] objectForKey:@"total"] integerValue];
    NSArray *listArray = [[result objectForKey:@"data"] objectForKey:@"list"];
    NSMutableArray *commentArray = [NSMutableArray arrayWithCapacity:[listArray count]];
    
    for (int i = 0; i <[listArray count]; i++) {
        XKRWCommentModel *model = [[XKRWCommentModel alloc]init];
        model.account = [[listArray objectAtIndex:i]objectForKey:@"name"];
        model.commentContent = [[listArray objectAtIndex:i]objectForKey:@"content"];
        model.score = [[[listArray objectAtIndex:i]objectForKey:@"score"] integerValue];
        model.data = [[listArray objectAtIndex:i]objectForKey:@"time"];
        model.commentId = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:i]objectForKey:@"id"]];
        [commentArray addObject:model];
    }
     

    islimCommentModel.commentArray = commentArray ;

     
    return islimCommentModel;
}
#pragma mark - 获取兑换方式
- (NSArray *)getExchangeWaysWithIdentifer:(NSString *)identifer {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kGetExchangeWays]];
    
//    NSDictionary *param = @{@"token": NEW_TOKEN};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
    return result[@"data"];
}
#pragma mark -
#pragma mark - 本地方法
#pragma mark -
#pragma mark - 存储答案
- (void)saveAnswer:(id)answer step:(NSInteger)page {
    
    if (!answerArray) {
        answerArray = [[NSMutableArray alloc] init];
    }
    /*
     *  判断是否已经存过
     */
    if (answerArray.count > page) {
        [answerArray replaceObjectAtIndex:page withObject:answer];
    } else {
        [answerArray addObject:answer];
    }
}

- (void)deleteLastAnswer {
    [answerArray removeLastObject];
}

- (void)deleteAnswers {
    answerArray = nil;
}

- (NSArray *)getAnswers {
    
    return answerArray;
}

#pragma mark - 免费兑换

- (NSInteger)getExchangeRestDays {
    
    NSNumber *days = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"exchangeRestDays_%ld",(long)UID]];
    if (!days) {
        return -1;
    }
    return [days integerValue];
}

- (void)saveExchangeRestDays:(NSInteger)days {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(days)
                                              forKey:[NSString stringWithFormat:@"exchangeRestDays_%ld",(long)UID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteExchangeRestDays {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"exchangeRestDays_%ld",(long)UID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 评估
/**
 *  是否使用过
 *
 *  @important KEY: islim
 *
 *  @return 是否评估过
 */
- (BOOL)isUsed:(NSString *)identifer {
    
    return [XKRWFileManager isFileExist:identifer];
}

- (void)setNumberOfEvaluteChances:(NSInteger)num {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(num)
                                              forKey:[NSString stringWithFormat:@"evaluateChances_%ld",(long)UID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getEvaluateChances {
    
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"evaluateChances_%ld",(long)UID]];
    if (!num) {
        return 0;
    }
    return [num integerValue];
}

#pragma mark - 其他

- (BOOL)isShowSortRemindImageView
{
    id obj =  [[NSUserDefaults standardUserDefaults] objectForKey:@"REMIND"] ;
    if (obj == nil) {
        return YES;
    }
    return [obj boolValue];
}

- (void)setShowSortRemindImageView:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:flag]
                                             forKey:@"REMIND"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)isShowPullUpImageView
{
    id obj =  [[NSUserDefaults standardUserDefaults] objectForKey:@"PULL_UP_DOWN"] ;
    if (obj == nil) {
        return YES;
    }
    return [obj boolValue];
}

- (void)setShowPullUpImageView:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:flag]
                                             forKey:@"PULL_UP_DOWN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)requestIslimDataForAdd
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", kNewServer, kISlimAdds];
    
    NSString *version = [NSString stringWithFormat:@"a%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSDictionary *param = @{@"native": @1,
                            @"var":version};
    
    NSDictionary *result = [self syncBatchDataWith:[NSURL URLWithString:url] andPostForm:param withLongTime:YES];
    
    NSArray *listArray = [result objectForKey:@"data"];
    
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary * dic in listArray){
    
        if ([dic[@"type"]isEqualToString:@"url"]) {

            XKRWIslimAddModel *model = [[XKRWIslimAddModel alloc]init];
            model.name = dic[@"name"];
            model.image = dic[@"image"];
            model.day_on = dic[@"day_on"];
            model.day_off = dic[@"day_off"];
            model.type = dic[@"type"];
            model.addr = dic[@"addr"];
            model.detail1 = dic[@"detail1"];
            model.detail2 = dic[@"detail2"];
            model.nid = dic[@"nid"];
            
            NSRange range = [model.addr rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                model.addr = [model.addr stringByReplacingOccurrencesOfString:@"{token}" withString:[[XKRWUserService sharedService] getToken]];
            }
            
            if ([model.addr isEqualToString:@"ssbuy"]) {
                model.addr = [NSString stringWithFormat:@"%@%@",@"http://ssbuy.xikang.com/?third_party=xikang&third_token=",[[XKRWUserService sharedService] getToken]];
            }
            
            [mutArray addObject:model];
        }
    }
    return mutArray;
}

#pragma mark - 内测功能

#ifdef DEBUG

- (void)给我一千次iSlim次机会 {
    
    long interval = (long)[[NSDate date] timeIntervalSince1970];
    int time = ceil(interval/3600);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/Evaluate/addTimesForInternal", kNewServer];
    
    NSDictionary *param = @{@"ho": @(time)};
    
    NSDictionary *result = [self syncBatchDataWith:[NSURL URLWithString:urlString] andPostForm:param];
    if (result && result[@"data"]) {
        XKLog(@"呦西！！我又能再战1000回啦");
    } else {
        XKLog(@"纳尼！？！？");
    }
}

#endif


@end
