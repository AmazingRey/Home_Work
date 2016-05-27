
//  XKRWUserService.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-27.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWUserService.h"
#import "JSONKit.h"
#import "XKRWFatReasonService.h"
#import "XKRWAlgolHelper.h"
#import "XKRWWeightService.h"
#import "XKRWCityControlService.h"
#import "XKRWCommHelper.h"
#import "XKCuiUtil.h"
#import "XKRWFoodService.h"
#import "XKRWRecordService4_0.h"
#import "XKRWFatReasonService.h"


#import "XKRWCollectionService.h"

#import "XKRW-Swift.h"

static XKRWUserService *shareInstance;
static XKDifficultyKindCount planCount  = eVeryHardCount;
static BOOL canUpdatePlan = YES;
@interface XKRWUserService ()



@end

@implementation XKRWUserService

-(NSString*)getSlimPartsString
{
    return nil;
}

//单例
+(instancetype)sharedService {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[XKRWUserService alloc] init];
        shareInstance.currentUser = [[XKRWUserInfoEntity alloc] init];
        [shareInstance getUserInfoByUserId:[XKRWUserDefaultService getCurrentUserId]];
        shareInstance.currentGroups = [NSMutableArray array];
    });
    return shareInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentUser = [[XKRWUserInfoEntity alloc]init];
    }
    return self;
}


-(void) setUserCity:(NSString *)city{
    _currentUser.address = city;
}

-(NSString * ) getUserProvince{
    NSArray *temp = [[self getCityAreaString] componentsSeparatedByString:@","];
    return [[XKRWCityControlService shareService] getNameWithID:[[temp objectAtIndex:0] integerValue]];
}
-(NSString * ) getUserCity{
    NSArray *temp = [[self getCityAreaString] componentsSeparatedByString:@","];
    return [[XKRWCityControlService shareService] getNameWithID:[[temp objectAtIndex:1] integerValue]];
    
}
-(NSString * ) getUserDistrict{
    NSArray *temp = [[self getCityAreaString] componentsSeparatedByString:@","];
    return [[XKRWCityControlService shareService] getNameWithID:[[temp objectAtIndex:2] integerValue]];
}
-(NSString *)getCityAreaString{
    NSString * str = @"0,0,0";
    if (_currentUser.address && _currentUser.address.length) {
        str = _currentUser.address;
    }
    return str;
}


-(void)getSignInDays{

    if([XKRWUtil isNetWorkAvailable]){
        NSDate * todayRecord = [NSDate date];
        NSMutableString * day = [NSMutableString stringWithString: [todayRecord stringWithFormat:@"yyyy-MM-dd"]];
        NSArray * arr =  [self query:[NSString stringWithFormat:@"select day from registerRecord where uid = %ld",(long)[self getUserId]]];
        
        
        if (arr && arr.count) {
            for (NSDictionary * dicTemp in arr) {
                day = (NSMutableString *)[day stringByAppendingString:[NSString stringWithFormat:@",%@",[dicTemp objectForKey:@"day"]]];
            }
        }
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer, kSignIn]];
        
        @try {
            
            NSDictionary * response = [self syncBatchDataWith:url andPostForm:[NSDictionary dictionaryWithObjectsAndKeys:day,@"date", nil]];
            NSString * str =  [response objectForKey:@"data"];
            [self executeSql:[NSString stringWithFormat:@"delete from registerRecord where uid = %ld",(long)[XKRWUserDefaultService getCurrentUserId]]];
            [self setInsisted:[str integerValue]];
        }
        @catch (NSException *exception) {
            XKLog(@"签到获取出错， ");
            [self addRecord];
        }
        
    }else{
        
        if ([self isfirstOpen]) {
            [self addRecord];
        }
    }
}

- (BOOL) isfirstOpen{
    
    NSString * openKey = [NSString stringWithFormat:@"sign_in_%ld",(long)[self getUserId]];
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSString *today = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate dateFormatString]];
    NSString *day = [defaults objectForKey:openKey];
    if (!day || ![day isEqualToString:today]) {
        [defaults setObject:today forKey:openKey];
        [defaults synchronize];
        return YES;
    }
    return NO;
    
}

-(void) addRecord{
    NSDate * todayRecord = [NSDate date];
    NSString * day = [todayRecord stringWithFormat:@"yyyy-MM-dd"];
    NSString * sql = [NSString stringWithFormat:@"REPLACE INTO registerRecord VALUES('%@',%ld)",day,(long)[self getUserId]];
    if ([self executeSql:sql]){
        
    }
}

-(void) setInsisted:(NSInteger)days{
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:[NSString stringWithFormat:@"userInsisted_%ld",(long)[self getUserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) getInsisted{
    NSInteger insisted = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"userInsisted_%ld",(long)[self getUserId]]];
    NSDictionary * dic =  [self fetchRow:[NSString stringWithFormat:@"select count (*) as num from registerRecord where uid = %ld",(long)[self getUserId]]];
    NSInteger local =[[dic objectForKey:@"num"] integerValue];
    NSInteger  result = insisted + local ;
    if (result == - 1) {
        result = 0 ;
    }
    return result;
}

//获取签到日志
//-(void)getIntitleLogsFromRemote{
//    
//    if (![self getToken]) {
//        return;
//    }
//    
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kServer,kGetIntitle]];
//    
//    @try {
//        
//        NSDictionary * response = [self syncBatchDataWith:url andPostForm:nil];
//        NSDictionary *temp =  [response objectForKey:@"data"];
//        
//        NSString * create = [temp objectForKey:@"userCreateDate"];
//        [self setREG:create];
//        NSString * planDate =[temp objectForKey:@"userPlanDate"];
//        [self setPlanDate:planDate];
//        
//        NSString * logs = [temp objectForKey:@"userLogDate"];
//        NSArray * array = [logs componentsSeparatedByString:@","];
//        /*
//         date   TEXT        DEFAULT NULL,
//         year   TEXT        DEFAULT NULL,
//         month  TEXT        DEFAULT NULL,
//         day    TEXT        DEFAULT NULL,
//         uid    integer     DEFAULT NULL
//         */
//        for (int index = 0; index < array.count;  index ++) {
//            
//            [self addLogs:  [array objectAtIndex:index]];
//        }
//    }
//    @catch (NSException *exception) {
//        
//        XKLog(@"签到日志获取出错，%@ ",exception);
//    }
//    
//}

//注册日期的 时间
-(void)setREG:(NSString *)date{
    [[NSUserDefaults standardUserDefaults] setValue:date forKeyPath:[NSString stringWithFormat:@"userCreateDate%ld",(long)[self getUserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)getREGDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"userCreateDate%ld",(long)[self getUserId]]];
}



//- (void )setREG


//新增 4.0  用户重置方案 时间
- (void)setResetTime:(NSNumber*)timestamp
{
    [[NSUserDefaults standardUserDefaults] setValue:timestamp forKeyPath:[NSString stringWithFormat:@"userResetDate%ld",(long)[self getUserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber*)getResetTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"userResetDate%ld",(long)[self getUserId]]];
}

-(void) setPlanDate:(NSString *)date{
    [[NSUserDefaults standardUserDefaults] setValue:date forKeyPath:[NSString stringWithFormat:@"userPlanDate%ld",(long)[self getUserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getPlanDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"userPlanDate%ld",(long)[self getUserId]]];
}


- (void) addLogs:(NSString *)date {
    NSString * year  = [date substringToIndex:4];
    NSString * month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString * day   = [date substringFromIndex:8];
    
    NSString * sqlInsert = [NSString stringWithFormat:@"REPLACE INTO registerLogs VALUES('%@','%@','%@','%@',%ld)",date,year,month,day,(long)[self getUserId]];
    @try {
        [self executeSql:sqlInsert];
    }
    @catch (NSException *exception) {
        XKLog(@"添加签到出错%@",exception);
    }
    @finally {
        
    }
    
}
-(NSArray *)getIntitleLocal{
    NSArray * array = nil;
    NSString * searchAll = [NSString stringWithFormat:@"select * from registerLogs where uid = %ld",(long)[self getUserId]];
    array = [self query:searchAll];
    return array;
}
-(XKDifficultyKindCount)getDiffCount{
    return  planCount;
}
/*
 eEasyCount = 1,         //容易
 eNormalCount,           //一般
 eHardCount,             //困难
 eVeryHardCount,         //艰巨
 */
-(void) updatePlanCount{
    
    if (!canUpdatePlan) {
        return;
    }
    
    float comment = [XKRWAlgolHelper dailyIntakEnergy];
    XKDifficulty diff =[self getUserPlanDifficulty];
    
    if ([self getSex] == eSexMale) {
        
        if (comment < 1950) {
            planCount = eEasyCount;
        }
        else if ((1950 <= comment) && (comment < 2280)){
            planCount = eNormalCount;
        }
        else if ((2280 <= comment) && (comment < 2500)){
            planCount = eHardCount;
        }
        else if (comment >= 2500 ){
            planCount = eVeryHardCount;
        }
        
    }else{
        if (comment < 1750) {
            planCount = eEasyCount;
        }
        else if ((1750 <= comment) && (comment < 2080)){
            
            planCount = eNormalCount;
        }
        else if ((2080 <= comment) && (comment < 2300)){
            planCount = eHardCount;
        }
        else if (comment >= 2300 ){
            planCount = eVeryHardCount;
        }
        
    }
    
    if (diff > planCount) {
        [self setUserPlanDifficulty:eEasy];
    }
    
}
-(NSInteger) getUserUpdateDate{
    return _currentUser.date;
}

//设置token
-(void)setToken:(NSString *)token {
    _currentUser.token = token;
}
//获取token
-(NSString *)getToken {
    return _currentUser.token;
}
//设置userid
-(void)setUserId:(NSInteger)userid {
    _currentUser.userid = userid;
}
//获取UserId
-(NSInteger)getUserId {
    
//    NSString *sql = [NSString stringWithFormat:@"select slimID from account where accountName='%@'",self.getUserAccountName];
//    
//    NSMutableArray *sqlRequest = [self query:sql];
//    
//    _currentUser.userid = [[[sqlRequest objectAtIndex:0] objectForKey:@"slimID"]integerValue];
    
    return _currentUser.userid;
}
//设置用户accountName
-(void)setUserAccountName:(NSString *)account {
    _currentUser.accountName = account;
}
//获取用户accountName
-(NSString *)getUserAccountName {
    return _currentUser.accountName;
}
//设置用户昵称
-(void)setUserNickName:(NSString *)nickname {
    _currentUser.nickName = nickname;
}
//获取用户昵称
-(NSString *)getUserNickName {
    return _currentUser.nickName;
}


- (void)setUserNickNameIsEnable:(NSInteger ) enable
{
    if(enable){
        _currentUser.userNickNameEnable = YES;
    }else{
        _currentUser.userNickNameEnable = NO;
    }
}

- (BOOL)getUserNickNameIsEnable
{
    return _currentUser.userNickNameEnable;
}



//设置用户瘦瘦号
-(void)setUserSlimId:(NSInteger)slimid {
    _currentUser.slimID = slimid;
}
//获取用户瘦瘦号
-(NSInteger)getUserSlimId {
    return _currentUser.slimID;
}
//设置性别
-(void)setSex:(XKSex)sex {
    XKLog(@"%d",sex);
    _currentUser.sex = sex;
    [self checkDestiWeight];
    if (!sex) {
        if ([self getUserGroup] == eGroupPuerperium) {
            [self setUserGroup:eGroupOther];
        }
    }    
}
//读取当前用户性别
-(XKSex)getSex {
    return _currentUser.sex;
}
//设置用户身高
-(void)setUserHeight:(NSInteger)height {
    _currentUser.height = height;
    [self checkDestiWeight];
}
//获取用户身高
-(NSInteger)getUserHeight {
    return _currentUser.height;
}

//设置出生日期(时间戳)
-(void)setBirthday:(NSInteger)birthday {
    _currentUser.birthDay = birthday;
    [self checkDestiWeight];
}
//获得当前用户出生日期(时间戳)
-(NSInteger)getBirthday {
    return _currentUser.birthDay;
}

//设置年龄
-(void)setAge {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyy"];
    NSTimeInterval birthday = [self getBirthday];
    int32_t userage = [formatter stringFromDate:[NSDate date]].intValue - [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:birthday]].intValue ;
    _currentUser.age = userage;

}

//获得当前用户年龄
-(NSInteger)getAge {
    return _currentUser.age;
}

//设置当前用户身高
-(void)setStature:(NSInteger)stature {
    _currentUser.height = stature;
    //    [self updatePlanCount];
}
//获得当前用户身高
-(NSInteger)getStature {
    return _currentUser.height;
}
//设置当前用户体重(g)

-(void)setCurrentWeight:(NSInteger)weight {
    _currentUser.weight = weight;
}

//获得当前用户体重
-(NSInteger)getCurrentWeight {
    if (_currentUser.weight > 200.9*1000) {
        _currentUser.weight = _currentUser.weight/1000;
        [self saveUserInfo];
    }
    return _currentUser.weight;
}

//设置用户类别
-(void)setUserGroup:(XKGroup)group {
    _currentUser.crowd = group;
}
//获得用户类别
-(XKGroup)getUserGroup {
    return _currentUser.crowd;
}

////设置用户类别
//-(void)setUserGroup:(XKGroup)group {
//    _currentUser.group = group;
//}
////获得用户类别
//-(XKGroup)getUserGroup {
//    return _currentUser.group;
//}

//设置用户腰围
-(void)setUserWaistline:(NSInteger)waistline {
    _currentUser.waistline = waistline;
}
//获得用户腰围
-(NSInteger)getUserWaistline {
    return _currentUser.waistline;
}
//设置用户臀围
-(void)setUserHipline:(NSInteger)hipline {
    _currentUser.hipline = hipline;
}
//获取用户臀围
-(NSInteger)getUserHipline {
    return _currentUser.hipline;
}
//设置用户头像
-(void)setUserAvatar:(UIImage *)avator {
    [self upLoadUserAvator:avator];
}

- (void)setUserBackgroundImageView:(UIImage *)image
{
    NSData *imageData = nil;
    UIImage * temp = [self makeImageWithImage:image scaledToSize:CGSizeMake(1080, 608)];
    
    imageData =UIImageJPEGRepresentation(temp, 0.5);
    //    XKLog(@"%d",imageData.length);
    NSString  *userAvatorURL = [NSString stringWithFormat:@"%@%@",kNewServer,@"/user/cover/"];
    
    @try {
        
        NSDictionary * result = [self syncHeaderDataWithUrl:userAvatorURL andPostData:imageData];
        _currentUser.userBackgroundImageUrl = result[@"data"];
        [self saveUserInfo];
    }
    @catch (NSException *exception) {
        XKLog(@"DEBUG 头像上传出错%@",exception);
    }

}

- (void)setUserBackgroundImageViewWithUrl:(NSString *)url
{
    _currentUser.userBackgroundImageUrl = url;
}

- (void)setIsAddGroup:(BOOL)abool
{
   _currentUser.isAddGroup = abool;
}

- (NSString *)getUserBackgroundImage
{
    return _currentUser.userBackgroundImageUrl;
}

//设置用户头像url
-(void)setUserAvatarURL:(NSString *)url {
    _currentUser.avatar = url;
}
//获取用户头像
-(NSString *)getUserAvatar {
    return _currentUser.avatar;
}
//设置用户日常体力活动类型
-(void)setUserLabor:(XKPhysicalLabor)labor {
    _currentUser.labor = labor;
    [self updatePlanCount];
    
}
//获取用户日常体力活动类型
-(XKPhysicalLabor)getUserLabor {
    return _currentUser.labor;
}

#pragma mark 所需信息的文字描述 √
-(NSString *)getSexDescription{
    NSString * decription = nil;
    if ([self getSex]) {
        decription = @"女";
    }else{
        decription = @"男";
    }
    return decription;
}

-(NSString *)getUserPlanDifficultyDescription{
    
    /*
     typedef enum {
     eEasy = 1,         //容易
     eNormal,           //一般
     eHard,             //困难
     eVeryHard,         //艰巨
     }XKDifficulty;
     */
    switch ([self getUserPlanDifficulty]) {
        case eEasy:
            return @"容易";
        case eNormal:
            return @"一般";
        case eHard:
            return @"困难";
        case eVeryHard:
            return @"艰巨";
        default:
            break;
    }
    return @"";
}
//用户类型描述
-(NSString *) getUserGroupDescription{
    
    switch ([self getUserGroup]) {
        case eGroupUnsel:
            return @"其他";
        case eGroupStudent:
            return @"学生";
        case eGroupDay:
            return @"白班族";
        case eGroupNight:
            return @"夜班族";
        case eGroupFreelance:
            return @"自由职业";
        case eGroupPuerperium:
            return @"产后女性";
        default:
            return @"其他";
    }
    
    return @"其他";
}
//体力活动描述
-(NSString * )getUserLaborDescription{
    
    NSString * decription = nil;
    
    switch ([self getUserLabor]) {
        case eLight:
            decription = @"轻体力";
            break;
        case eMiddle:
            decription = @"中体力";
            break;
        case eHeavy:
            decription = @"重体力";
            break;
            
        default:
            break;
    }
    return decription;
}

//体重描述
-(NSString*)getWeightDescription{
    NSString * decription = nil;
    
    XKSex sex = [[XKRWUserService sharedService] getSex];
    NSInteger stature = [[XKRWUserService sharedService] getStature];
    NSInteger age = [[XKRWUserService sharedService] getAge];
    XKRWBMIEntity *entity = [XKRWAlgolHelper calcBMIInfoWithSex:sex age:age andHeight:stature];
    float BMI = [XKRWAlgolHelper BMI];
    
    if ([XKRWAlgolHelper BMI] < entity.healthyBMI) {
        decription=@"偏瘦";
    }
    else if (BMI >= entity.healthyBMI && BMI < entity.overweightBMI) {
        decription = @"健康";
    }
    else {
        decription = @"肥胖";
    }
    
    return decription;
}

//腰臀比描述
-(NSString *)getWHRDescription{
    NSString * decription = @"   ";
    float ratioTemp = 0;
    if ([self getUserHipline]) {
        ratioTemp = (1.0 * [self getUserWaistline])/[self getUserHipline];
    }
    if (!ratioTemp) {
        return decription;
    }
    
    if ([self getSex]) {
        //女性
        decription = (ratioTemp > kWHROfFemale)? @"不正常":@"正常";
    }
    else{
        decription = (ratioTemp > kWHROfMale)? @"不正常":@"正常";
    }
    
    return decription;
}
//获取体重变化
-(float) getWeightChange{
    
    float weightOri =[[[XKRWWeightService shareService] getStartingValueWeight] floatValue];
    if (weightOri< .001) {
        if (weightOri > 1000) {
            weightOri =  [self getUserOrigWeight] / 1000;
        }
        else
        {
            weightOri =  [self getUserOrigWeight];  //改动 12、 15
        }
    }
    
    float weightCur = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]];
    
    return (weightOri - weightCur);
}
//疾病史描述
-(NSString *)getUserDiseaseDecription{
    if ([self getUserDisease].count) {
        return @"有";
    }
    return @"无";
}

//设置用户疾病情况
- (void)setUserDisease:(NSArray *)array {
    _currentUser.disease = [array mutableCopy];
}
//获取用户疾病情况
- (NSArray *)getUserDisease {
    return _currentUser.disease;
}


- (void)setUserSlimParts:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        
        _currentUser.slimParts = string;
    }
}

- (NSString *)getUserSlimParts {
    
    if ([_currentUser.slimParts isKindOfClass:[NSArray class]]) {
        [self setUserSlimPartsWithStringArray:(NSArray *)_currentUser.slimParts];
    }
    return _currentUser.slimParts;
}

- (void)setUserSlimPartsWithStringArray:(NSArray *)array
{
    NSMutableString *slimPartsStr = nil;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"(),[]{}"];
    
    for (NSString *str in array) {
        if ([str rangeOfCharacterFromSet:set].location != NSNotFound) {
            continue;
        }
        if (!slimPartsStr) {
            slimPartsStr = [NSMutableString stringWithString:str];
        } else {
            [slimPartsStr appendFormat:@",%@", str];
        }
    }
    _currentUser.slimParts = slimPartsStr;
}

- (NSArray *)getUserSlimPartsArray
{
    if ([_currentUser.slimParts isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)_currentUser.slimParts;
        [self setUserSlimPartsWithStringArray:array];
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"(),[]{}"];
    
    if (_currentUser.slimParts && _currentUser.slimParts.length > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[_currentUser.slimParts componentsSeparatedByString:@","]];
        for (NSString *str in array) {
            if ([str isEqualToString:@""] || [str rangeOfCharacterFromSet:set].location != NSNotFound) {
                [array removeObject:str];
            }
        }
        return array;
    }
    return nil;
}


-(NSString *)getDiseaseString {
    XKLog(@"12331  %@",[self getUserDisease]);
    NSString *disease = [[self getUserDisease] componentsJoinedByString:@","];
    
    return disease;
}

//获取用户减肥部位的拼接字符串（3.2new）
//-(NSString*)getUserSlimPartsString{
//
//    return [[self getUserSlimParts]componentsJoinedByString:@","];
//}

/*用户plan*/
//设置用户目标体重
-(void)setUserDestiWeight:(NSInteger)weight {
    _currentUser.destWeight = weight;
    if ([self getCurrentWeight] <= weight) {
        canUpdatePlan = NO;
    }else{
        canUpdatePlan = YES;
    }
    
    [self updatePlanCount];
}
-(BOOL) destiWightLower{
    return !canUpdatePlan;
}

//获取用户目标体重
-(NSInteger) getUserDestiWeight {
    [self checkDestiWeight];
    return _currentUser.destWeight;
}

- (void) checkDestiWeight{
    return;
    XKSex sex = [[XKRWUserService sharedService] getSex];
    int32_t stature = [[XKRWUserService sharedService] getStature];
    int32_t age = [[XKRWUserService sharedService] getAge];
    if (!stature) {
        return;
    }
    XKRWBMIEntity *entity = [XKRWAlgolHelper calcBMIInfoWithSex:sex age:age andHeight:stature];
    
    if ( entity.healthyWeight && (_currentUser.destWeight < entity.healthyWeight)) {
        
        [self setUserDestiWeight:entity.healthyWeight];
        
    }
}

//设置用户初始体重
-(void)setUserOrigWeight:(NSInteger)weight {
    _currentUser.origWeight = weight;
    //    [self updatePlanCount];
    
}
//获取用户初始体重
-(NSInteger)getUserOrigWeight {
    return _currentUser.origWeight;
}

//设置用户减肥时间
-(void)setUserPlanDuration:(NSInteger)duration {
    _currentUser.duration = duration;
}
//获取用户减肥时间
-(NSInteger)getUserPlanDuration {
    
    //    距达成目标还有？天 =【（当前体重 - 目标体重）*7700】/ 所选难度每日饮食控制值
    
    return _currentUser.duration;
}

//设置用户方案难度
-(void)setUserPlanDifficulty:(XKDifficulty)difficulty {
    _currentUser.reduceDiffculty = difficulty;

    
}
//获取用户方案难度
-(XKDifficulty)getUserPlanDifficulty {
    return _currentUser.reduceDiffculty;
}

//设置用户减肥目的
-(void)setUserReducePart:(XKReducePart)reducePart {
    _currentUser.reducePart = reducePart;
}
//获取用户减肥目的
-(XKReducePart)getUserReducePart {
    return _currentUser.reducePart;
}

//设置用户减肥位置
-(void)setUserReducePosition:(XKReducePosition)position {
    _currentUser.reducePosition = position;
}
//获取用户减肥位置
-(XKReducePosition)getUserReducePosition {
    return _currentUser.reducePosition;
}

//设置用户星星数量
-(void)setUserStarNum:(NSInteger)num {
    _currentUser.starNum = num;
}
//获取用户星星数量
-(NSInteger)getUserStarNum {
    return _currentUser.starNum;
}



//设置体重曲线四个值
- (void)setUserWeightCurve:(NSDictionary *)dic
{
    _currentUser.weightCurveDic = dic;
}
//获取体重曲线四个值
- (NSDictionary *)getUserWeightCurve
{
    return _currentUser.weightCurveDic;
}

////保存体重曲线四个值
- (void)saveUserWeightCurveData
{
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[self getUserId]];
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        NSDictionary *dic = [self getUserWeightCurve];
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@-%@",[dic objectForKey:@"oldWeight"],[dic objectForKey:@"maxWeight"],[dic objectForKey:@"minWeight"],[dic objectForKey:@"youngWeight"]];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE account SET weightcurve = '%@' WHERE userid = '%@'",str,userId]];
    }];
    
}

//获取体重曲线四个值
- (void)getUserWeightCurveData
{
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[self getUserId]];
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT weightcurve FROM account WHERE userid = ?",userId];
        while ([result next]) {
            NSDictionary *dict = [result resultDictionary];
            NSString *str = [dict objectForKey:@"weightcurve"];
            if (str && ![str isMemberOfClass:[NSNull class]] && ![str isEqualToString:@""] )
            {
                NSArray *array = [str componentsSeparatedByString:@"-"];
                NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[array objectAtIndex:0],@"oldWeight",[array objectAtIndex:1],@"maxWeight",[array objectAtIndex:2],@"minWeight",[array objectAtIndex:3],@"youngWeight",nil];
                [self setUserWeightCurve:dictionary];
            }
        }
    }];
    
}


//保存当前用户信息      slimParts
-(void)saveUserInfo {
    [self writeDefaultDBWithTask:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"REPLACE INTO account (accountname,nickname,birthday,starnum,height,sex,crowd,token,hipline,waistline,labor_level,avatar,disease,userid,origWeight,destWeight,part,position,diffculty,duration,currentweight,address,date,manifesto,slimParts,userBackgroundImageUrl,userNickNameEnable,isAddGroup) VALUES(:accountName,:nickName,:birthDay,:starNum,:height,:sex,:crowd,:token,:hipline,:waistline,:labor,:avatar,:disease,:userid,:origWeight,:destWeight,:reducePart,:reducePosition,:reduceDiffculty,:duration,:weight,:address,:date,:manifesto,:slimParts,:userBackgroundImageUrl,:userNickNameEnable,:isAddGroup)" withParameterObject:_currentUser];
    }];
    
    [self getUserId];
}

//获取当前用户信息
-(void)getUserInfoByUserId:(NSInteger)userid {
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT slimID,accountname AS accountName,nickname AS nickName,birthday AS birthDay,starnum AS starNum,height,sex,crowd,token,hipline,waistline,labor_level AS labor,avatar,disease,userid,origweight AS origWeight,destweight AS destWeight,part AS reducePart,position AS reducePosition,diffculty AS reduceDiffculty,duration,currentweight AS weight,address AS address,date AS date,manifesto AS manifesto,slimParts AS slimParts,userBackgroundImageUrl AS userBackgroundImageUrl,isAddGroup AS isAddGroup,userNickNameEnable AS userNickNameEnable FROM account WHERE userid = ?",[NSNumber numberWithInteger:userid]];
        while ([result next]) {
            [result setResultIgnoreAbsentPropertiesToObject:_currentUser];
        }
    }];
}


- (void) getUserInfoByUserAccount:(NSString *)userAccount{
    [self readDefaultDBWithTask:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT slimID,accountname AS accountName,nickname AS nickName,birthday AS birthDay,starnum AS starNum,height,sex,crowd,token,hipline,waistline,labor_level AS labor,avatar,disease,userid,origweight AS origWeight,destweight AS destWeight,part AS reducePart,position AS reducePosition,diffculty AS reduceDiffculty,duration,currentweight AS weight,address AS address,date AS date,manifesto AS manifesto,slimParts AS slimParts ,userBackgroundImageUrl AS userBackgroundImageUrl,userNickNameEnable AS userNickNameEnable FROM account WHERE accountname = ?",userAccount];
        while ([result next]) {
            [result setResultIgnoreAbsentPropertiesToObject:_currentUser];
        }
    }];
}



//重置方案4.0
-(NSDictionary*)resetUserAllDataByToken
{   
    // network
    NSURL *restUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,v5_KResetUserData]];
    NSDictionary *pargams = @{@"token": [self getToken]};
    NSDictionary *restDic;
    @try {
       restDic = [self syncBatchDataWith:restUrl andPostForm:pargams];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return restDic;
    
    
}

//新加的
-(NSString*)getResetToken
{
    NSString* token=[[NSUserDefaults standardUserDefaults]objectForKey:@"resetToken"];
    if (!token.length) {
        return token;
    }
    return nil;
}
//新加的

-(void)setUserResrtToken:(NSString*)token;
{
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"resetToken"];
}



/*获取用户全部资料包括userinfo，plan，QA*/
#pragma --mark  获取所有的用户资料
-(void)getUserAllInfoFromRemoteServerByToken:(NSString *)token {
    //获取用户信息
    NSURL *userAllInfoRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,v5_getAllUserInfoUrl]];
    NSDictionary *userAllInfoParaDic = @{@"token": token};
    NSDictionary *userAllInfoDic = [self syncBatchDataWith:userAllInfoRequestURL andPostForm:userAllInfoParaDic];
    //存储userInfo
    NSMutableDictionary *userInfo = [userAllInfoDic objectForKey:@"data"];
    
    //设置token
    [userInfo setObject:token forKey:@"token"];
    [self updateCurrentUserInfo:userInfo];
    
    //设置重置时间
    if ([userInfo objectForKey:@"date_reset"]&& ![userInfo[@"date_reset"] isKindOfClass:[NSNull class]]) {
        NSString * time = [userInfo objectForKey:@"date_reset"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc ]init];
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date  = [formatter dateFromString:time];
        [[XKRWUserService sharedService] setResetTime:[NSNumber numberWithLong:[date timeIntervalSince1970]]];
    }
    
    //设置创建时间
    
    if ([userInfo objectForKey:@"date_add"] && ![userInfo[@"date_add"] isKindOfClass:[NSNull class]]) {
        NSString * time = [userInfo objectForKey:@"date_add"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc ]init];
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date  = [formatter dateFromString:time];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc ]init];
        formatter1.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        formatter1.dateFormat = @"yyyy-MM-dd";
        XKLog(@"%@",[formatter1 stringFromDate:date]);
        [self setREG:[formatter1 stringFromDate:date]];
        
        XKLog(@"%@",[self getREGDate]);
    }
    
    
    
    //设置更新时间
    if ([userInfo objectForKey:@"date_upd"]) {
        NSString * time = [userInfo objectForKey:@"date_upd"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc ]init];
        formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date  = [formatter dateFromString:time];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:[date timeIntervalSince1970]] forKey:[NSString stringWithFormat:@"XKUSerUpDateTime%ld",(long)_currentUser.userid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
 

    //设置初始体重
    [self setUserOrigWeight:((NSString *)userInfo[@"weight"]).floatValue * 1000];
    
    //存储userPlan
    
      if(![[userInfo objectForKey:@"slim_plan"] isKindOfClass:[NSString class]])
      {
          NSDictionary *userPlanDic = userAllInfoDic[@"data"][@"slim_plan"];
          if (![self isNull:userPlanDic] && [userPlanDic.allKeys count] > 0) {
              [self setUserDestiWeight:((NSString *)userPlanDic[@"target_weight"]).floatValue * 1000];
              if (userPlanDic[@"degree"]) {
                  int32_t degree = ((NSString *)userPlanDic[@"degree"]).intValue;
                  [self setUserPlanDifficulty:degree];
                }
              
              //保存三餐比例到本地
              [[NSUserDefaults standardUserDefaults] setObject:[userPlanDic objectForKey:@"meal_ratio"] forKey:[NSString stringWithFormat:@"meal_ratio_%ld",(long)[self getUserId]]];
              [[NSUserDefaults standardUserDefaults] synchronize];
            }
      }
    
    [self saveUserInfo];
    
    //存储userQA
    NSString *userQaStr = userInfo[@"slim_qa"];
    if (userQaStr && ![userQaStr isMemberOfClass:[NSNull class]])
    {
        NSArray *array = [userQaStr componentsSeparatedByString:@";"];
        [[XKRWFatReasonService sharedService] saveQuenstionAnswer:array WithUID:[self getUserId]];
    }
    
    NSTimeInterval timeInterval = [[[userInfo objectForKey:@"slim_bak1"] objectForKey:@"plan_time"] integerValue];
    if(timeInterval != 0){
        [XKRWAlgolHelper setExpectDayOfAchieveTarget:[self getUserOrigWeight] andStartTime:[[userInfo objectForKey:@"slim_bak1"] objectForKey:@"plan_time"]];
        
    }
}

//更新CurrentUser的用户信息
-(void)updateCurrentUserInfo:(NSDictionary *)dic {
    
    [self setToken:dic[@"token"]];
    
    [self setUserAccountName:dic[@"xk_account"]];
    
    NSString *account = self.getUserAccountName;
    
    const char *accountName = [account cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSInteger userid = 0 ;
    XKLog(@"%d",atoi(accountName));
    
    for (int i = 0; i < strlen(accountName); i++) {
        userid += accountName[i];
    }
    
    [self setUserId:userid*strlen(accountName)];
    
    [XKRWUserDefaultService setCurrentUserId:[[XKRWUserService sharedService] getUserId]];
    
    [self setUserHeight:[[dic objectForKey:@"height"] integerValue]];
    [self setSex:[[dic objectForKey:@"gender"] intValue]];
    //设置生日
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthday = [formatter dateFromString:dic[@"birthday"]];
    [self setBirthday:[birthday timeIntervalSince1970]];
    [self setAge];
    
    //设置体力活动水平
    [self setUserLabor:[[dic objectForKey:@"labor_level"] intValue]];

    //设置昵称
    [self setUserNickName:dic[@"nickname"]];
    
    //设置昵称是否可用
    NSInteger nickNameEnable = [[dic objectForKey:@"nickname_enabled"] integerValue];
    [self setUserNickNameIsEnable:nickNameEnable];
    
    //设置头像
    [self setUserAvatarURL:dic[@"avatar"]];
    
    [self setUserBackgroundImageViewWithUrl:[[dic objectForKey:@"slim_bak1"] objectForKey:@"cover"] ];
    
    
    //设置是否加入过小组
    NSInteger isAddGroup = [[[dic objectForKey:@"slim_bak0"] objectForKey:@"add_group"] integerValue];
    [self setIsAddGroup:isAddGroup== 0?NO:YES];
    
    //设置人群
    [self setUserGroup:[[dic objectForKey:@"crowd_type"]intValue]];
    [self setUserCity:dic[@"address"]];
    [self setManifesto:dic[@"manifesto"]];
    
    //设置疾病
    NSString *disease = dic[@"disease_type"];
    NSMutableArray *array = [[disease componentsSeparatedByString:@","] mutableCopy];
    if ([[array lastObject] isEqualToString:@""]) {
        [array removeLastObject];
    }
    [self setUserDisease:array];
    //设置减肥的部位
    
    if(![[dic objectForKey:@"slim_plan"] isKindOfClass:[NSString class]])
    {
        if ([[[dic objectForKey: @"slim_plan"]objectForKey:@"part"] isKindOfClass:[NSString class]]) {
            [self setUserSlimParts:[[dic objectForKey: @"slim_plan"]objectForKey:@"part"]];
        } else if ([[[dic objectForKey: @"slim_plan"]objectForKey:@"part"] isKindOfClass:[NSArray class]]) {
            [self setUserSlimPartsWithStringArray:[[dic objectForKey: @"slim_plan"]objectForKey:@"part"]];
        }
    }
    

}

///*提交本地用户资料到远程服务器*/
//-(void)uploadUserInfoToRemoteServerByToken:(NSString *)token {
//    [self uploadUserInfoToRemoteServerNeedLong:NO ByToken:token];
//}


- (UIImage *)makeImageWithImage:(UIImage *)imageOld scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [imageOld drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void) setManifesto:(NSString * )manifesto{
    
    if ([manifesto isKindOfClass:[NSNull class]]) {
        manifesto = @"";
    }
    _currentUser.manifesto = manifesto;
}
- (NSString *) getUserManifesto{
    
    return _currentUser.manifesto;
}

-(BOOL)checkComplete{
    BOOL com = NO;
    
    NSString * brithDay = [self getBirthdayString];
    BOOL birCom =(brithDay && brithDay.length);
    BOOL heiCom = ([self getUserHeight] > 0.0001);

    BOOL weiCom = ([self getUserDestiWeight] > 0.0001);
    if (birCom && heiCom && weiCom) {
        com = YES;
    }
    
    return com;
}
//获取生日字符串
-(NSString *)getBirthdayString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_currentUser.birthDay]];
}

//打印当前用户信息
-(void)printCurrentUserInfo {
    XKLog(@"%@",_currentUser);
}

-(void)logout{
    self.currentUser = [[XKRWUserInfoEntity alloc]init];
    [XKRWUserDefaultService setCurrentUserId:0];
    [XKRWUserDefaultService setLogin:NO];
    [XKRWUserDefaultService setStepForNewUser:nil];
    [[XKRWUserService sharedService] setUserId:0];
    [[XKRWLocalNotificationService shareInstance] cancelAllAlarm];
}

/*
 * 检查是否需要同步数据
 * return {"sync_item":[@"weight",@"diy_recipe",@"record",@"forecast"],"count":4}
 */

- (BOOL)checkSyncData
{
    if (![XKRWUserDefaultService isLogin]) {
        return NO;
    }
    
    /*
     * 检查体重记录√
     
     *检查DIY食谱√
     
     *检查记录√
     
     *检查预测√
     
     *检查提醒√
     
     *检查比例
     
     *肥胖原因√
     */
//    NSInteger uid = [self getUserId];
//    NSInteger count = 0;
    
    /*检查是否需要上传体重记录*/
//    NSDictionary *weight_rst = [self fetchRow: [NSString stringWithFormat: @"SELECT COUNT(*) AS num FROM weightrecord WHERE sync = 0   AND userid = %li",(long)uid]];
//    NSInteger weight_num = [[weight_rst objectForKey:@"num"] unsignedIntValue];
//    if (weight_num > 0) {
//        
//        XKLog(@"体重未上传");
//        return YES;
//        //        ++count;
//        //        [marr addObject:@"weight"];
//    }
    
    
    /*检查是否需要上传DIY食谱*/
//    NSDictionary *recipe_rst = [self fetchRow:[NSString stringWithFormat:@"SELECT COUNT(*) AS num FROM scheme_diy WHERE remoteId = 0  AND uid = %li",(long)uid]];
//    uint32_t recipe_num = [[recipe_rst objectForKey:@"num"] unsignedIntValue];
//    if (recipe_num > 0) {
//        XKLog(@"diy未上传");
//        return YES;
//        ++count;
//        //        [marr addObject:@"diy_recipe"];
//    }
    
    BOOL isRecordNeedUpload = [[XKRWRecordService4_0 sharedService] checkNeedSyncData];
    if (isRecordNeedUpload) {
        XKLog(@"离线记录需要上传");
        return YES;
    }
    
    /*检查是否需要上传肥胖原因*/
//    NSDictionary *fat_rst = [self fetchRow:[NSString stringWithFormat:@"SELECT COUNT(*) AS num FROM fat_reason WHERE sync = 0 AND u_id = %li ",(long)uid]];
//    uint32_t fat_num = [[fat_rst objectForKey:@"num"] unsignedIntValue];
//    if (fat_num > 0) {
//        XKLog(@"肥胖原因未上传");
//        return YES;
//        ++count;
//        //        [marr addObject:@"forecast"];
//    }
    
    //    NSDictionary *rst = [NSDictionary dictionaryWithObjectsAndKeys:marr,@"sync_item",[NSNumber numberWithInt:count],@"count", nil];
    return NO;
}

//获取用户的每周减重的kg数（3.2new）
-(CGFloat)getweeklyReduceWeight
{
    CGFloat daily_Normal_Intake=[XKRWAlgolHelper dailyIntakEnergy];
    CGFloat  daily_Recommand_Intake=[XKRWAlgolHelper dailyIntakeRecomEnergy];
    CGFloat  daily_Exercise_Run_Out= [XKRWAlgolHelper dailyConsumeSportEnergy];
    return (daily_Normal_Intake - daily_Recommand_Intake + daily_Exercise_Run_Out)*7/7700;
}

//删除用户数据  更新accout表数据 值保留账号信息等 其他个人数据默认
-(void)deleteDBDataByUser
{
    
    NSInteger  uid = [self getUserId];
    _currentUser.sex = 1 ;
    _currentUser.birthDay = 0;
    _currentUser.weight = 0 ;
    _currentUser.height = 0 ;
    _currentUser.destWeight = 0 ;
    _currentUser.address = @"0_0_0";
    _currentUser.slimParts = @"";
    _currentUser.slimPartsString = @"";
    _currentUser.labor = eLight;
    [self saveUserInfo];
    
    NSArray * fatReason = @[@"1_5_1",@"7_13_1",@"8_18_1",@"9_21_1"];
    [[XKRWFatReasonService sharedService] saveFatReasonToDB:fatReason andUserId:uid andSync:1];
}


- (void)saveNewToken:(NSString *)new_token {
    [[NSUserDefaults standardUserDefaults] setObject:new_token forKey:@"NEW_TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getNewToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"NEW_TOKEN"];
}

- (BOOL)checkUserInfoIsComplete{
    [self setAge];
    NSInteger age = [self getAge];
    NSInteger height = [self getUserHeight];
    NSInteger labor =   [self getUserLabor];
    NSInteger currentWeight =    [self getUserOrigWeight];
    NSInteger targetWeight = [self getUserDestiWeight];
    if (age&&height&&labor&&currentWeight&&targetWeight){
        return YES;
    }
    return NO;
}


//默认设置方案难度
-(void) defaultSetPlanCount{
    float comment = [XKRWAlgolHelper dailyIntakEnergy];
    XKDifficulty difficulty;
    
    if ([self getSex] == eSexMale) {
        
        if (comment < 1950) {
            difficulty = eEasy;
        }
        else if ((1950 <= comment) && (comment < 2280)){
            difficulty = eNormal;
        }
        else if ((2280 <= comment) && (comment < 2500)){
            difficulty = eHard;
        }
        else {
            difficulty = eVeryHard;
        }
        
    }else{
        if (comment < 1750) {
            difficulty = eEasy;
        }
        else if ((1750 <= comment) && (comment < 2080)){
            
            difficulty = eNormal;
        }
        else if ((2080 <= comment) && (comment < 2300)){
            difficulty = eHard;
        }
        else {
            difficulty = eVeryHard;
        }
        
    }
    [self setUserPlanDifficulty:difficulty];
}

//保存用户信息到远程服务器
- (NSDictionary *) saveUserInfoToRemoteServer:(NSDictionary *)userInfo{
    NSURL *restUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,v5_setAllUserInfoUrl]];

    NSDictionary *restDic;
    @try {
        restDic = [self syncBatchDataWith:restUrl andPostForm:userInfo withLongTime:YES];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return restDic;

}

//改变用户信息
- (NSDictionary *)changeUserInfo:(id)info WithType:(NSString *)InfoType
{
    NSURL *changeInfoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,v5_setAllUserInfoUrl]];
    NSDictionary *dic = @{InfoType:info};
    NSData *infoData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString  *dataStr = [[NSString alloc]initWithData:infoData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"data":dataStr};
    NSDictionary *result =    [self syncBatchDataWith:changeInfoUrl andPostForm:params withLongTime:YES];
    return result;
}


/*更改密码*/
-(void)uploadUserPWDWithOldP:(NSString *)old andNP:(NSString *) newP{
    NSURL *userChangePwdRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,v5_changPWD]];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    [userDic setObject:old forKey:@"old"];
    [userDic setObject:newP forKey:@"new"];
    [self syncBatchDataWith:userChangePwdRequestURL andPostForm:userDic];
}

/*上传用户头像*/
- (void)upLoadUserAvator:(UIImage *)header{
    NSData *imageData = nil;
    UIImage * temp = [self makeImageWithImage:header scaledToSize:CGSizeMake(720, 720)];
    imageData =UIImageJPEGRepresentation(temp, 0.5);
    NSString  *userAvatorURL = [NSString stringWithFormat:@"%@%@",kNewServer,v5_setUserAvatar];
    @try {
        NSDictionary * result = [self syncHeaderDataWithUrl:userAvatorURL andPostData:imageData];
        _currentUser.avatar = result[@"data"];
    }
    @catch (NSException *exception) {
        XKLog(@"DEBUG 头像上传出错%@",exception);
    }
    
}

- (void)setThirdPartyLogin{
    NSInteger usid =  [self getUserId];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"THIRDPARTYLOGIN_%ld",(long)usid]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL) getThirdPartyLogin
{
    NSInteger usid =  [self getUserId];
    
    BOOL result =  [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"THIRDPARTYLOGIN_%ld",(long)usid]];
    
    if (result == YES) {
        return  YES;
    }else{
        return NO;
    }
}


- (CGFloat) getBMIFromAge:(NSInteger)age andSex:(XKSex)sex andBMItype:(BMIType)type
{
    CGFloat BMI;
    if(sex == eSexMale){
        switch (age){
            case 7:
                if(type == eLowest){
                    BMI = 14;
                }else if(type == eStandard){
                    BMI = 15;
                }else{
                    BMI = 17.4;
                }
                break;
                case 8:
                if(type == eLowest){
                    BMI = 14.1;
                }else if(type == eStandard){
                    BMI = 15.1;
                }else{
                    BMI = 18.1;
                }
                break;
                case 9:
                if(type == eLowest){
                    BMI = 14.3;
                }else if(type == eStandard){
                    BMI = 15.3;
                }else{
                    BMI = 18.9;
                }
                break;
                case 10:
                if(type == eLowest){
                    BMI = 14.5;
                }else if(type == eStandard){
                    BMI = 15.5;
                }else{
                    BMI = 19.6;
                }
                break;
                case 11:
                if(type == eLowest){
                    BMI = 14.8;
                }else if(type == eStandard){
                    BMI = 15.8;
                }else{
                    BMI = 20.3;
                }
                break;
                case 12:
                if(type == eLowest){
                    BMI = 15.2;
                }else if(type == eStandard){
                    BMI = 16.2;
                }else{
                    BMI = 21;
                }
                break;
                case 13:
                if(type == eLowest){
                    BMI = 15.7;
                }else if(type == eStandard){
                    BMI = 16.7;
                }else{
                    BMI = 21.9;
                }
                break;
                case 14:
                if(type == eLowest){
                    BMI = 16.2;
                }else if(type == eStandard){
                    BMI = 17.2;
                }else{
                    BMI = 22.6;
                }
                break;
                case 15:
                if(type == eLowest){
                    BMI = 16.8;
                }else if(type == eStandard){
                    BMI = 17.8;
                }else{
                    BMI = 23.1;
                }
                break;
                case 16:
                if(type == eLowest){
                    BMI = 17.4;
                }else if(type == eStandard){
                    BMI = 18.4;
                }else{
                    BMI = 23.5;
                }
                break;
                case 17:
                if(type == eLowest){
                    BMI = 18;
                }else if(type == eStandard){
                    BMI = 19;
                }else{
                    BMI = 23.8;
                }
                break;
                default:
                if(type == eLowest){
                    BMI = 18.5;
                }else if(type == eStandard){
                    BMI = 21;
                }else{
                    BMI = 24;
                }
                break;
                }
    } else {
        switch (age){
        case 7:
            if(type == eLowest){
                BMI = 13.9;
            }else if(type == eStandard){
                BMI = 14.9;
            }else{
                BMI = 17.2;
            }
            break;
        case 8:
            if(type == eLowest){
                BMI = 14.1;
            }else if(type == eStandard){
                BMI = 15.1;
            }else{
                BMI = 18.1;
            }
            break;
        case 9:
            if(type == eLowest){
                BMI = 14.3;
            }else if(type == eStandard){
                BMI = 15.3;
            }else{
                BMI = 19.0;
            }
            break;
        case 10:
            if(type == eLowest){
                BMI = 14.6;
            }else if(type == eStandard){
                BMI = 15.6;
            }else{
                BMI = 20.0;
            }
            break;
        case 11:
            if(type == eLowest){
                BMI = 15.0;
            }else if(type == eStandard){
                BMI = 16.0;
            }else{
                BMI = 21.1;
            }
            break;
        case 12:
            if(type == eLowest){
                BMI = 15.5;
            }else if(type == eStandard){
                BMI = 16.5;
            }else{
                BMI = 21.9;
            }
            break;
        case 13:
            if(type == eLowest){
                BMI = 16.1;
            }else if(type == eStandard){
                BMI = 17.1;
            }else{
                BMI = 22.6;
            }
            break;
        case 14:
            if(type == eLowest){
                BMI = 16.7;
            }else if(type == eStandard){
                BMI = 17.7;
            }else{
                BMI = 23.0;
            }
            break;
        case 15:
            if(type == eLowest){
                BMI = 17.3;
            }else if(type == eStandard){
                BMI = 18.3;
            }else{
                BMI = 23.4;
            }
            break;
        case 16:
            if(type == eLowest){
                BMI = 17.8;
            }else if(type == eStandard){
                BMI = 18.8;
            }else{
                BMI = 23.7;
            }
            break;
        case 17:
            if(type == eLowest){
                BMI = 18.2;
            }else if(type == eStandard){
                BMI = 19.2;
            }else{
                BMI = 23.8;
            }
            break;
        default:
            if(type == eLowest){
                BMI = 18.5;
            }else if(type == eStandard){
                BMI = 21;
            }else{
                BMI = 24;
            }
            break;
        }
        
        
    }
    return BMI;
    
}

#pragma mark - 5.0 new

- (BOOL)getUserFlagWithType:(UserFlag)flag {
    
    @try {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, @"/user/flag/"]];
        NSDictionary *rst = [self syncBatchDataWith:url andPostForm:nil];
        
        NSString *key = @"";
        switch (flag) {
            case UserFlagTransferSchemeData:
                key = @"import_scheme";
                break;
            default:
                break;
        }
        return [rst[@"data"][key] boolValue];
    }
    @catch (NSException *exception) {
        
        return NO;
    }
    return YES;
}

- (BOOL)isNeedChangeScheme:(float)originalDailyIntake AndNowDailyIntake:(float)nowDailyIntake
{
    if ((originalDailyIntake <= 1400 && nowDailyIntake <= 1400)||((originalDailyIntake > 1400 && originalDailyIntake <1800) && (nowDailyIntake > 1400 && nowDailyIntake <1800))||(originalDailyIntake >= 1800 && nowDailyIntake >= 1800)) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isNeedNoticeTheChangeOfInsistDays {
    
    BOOL flag = NO;
    
    NSInteger uid = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"%ld_notice_insist_days", (long)uid];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        NSTimeInterval regDate = [[NSDate dateFromString:[self getREGDate] withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
        NSTimeInterval compare = [[NSDate dateFromString:@"2014-6-25" withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
        NSTimeInterval restTime = [[self getResetTime] doubleValue];
        
        if (regDate < compare && restTime > compare) {
            flag = YES;
        }
        [[NSUserDefaults standardUserDefaults] setObject:@(flag) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return flag;
}

#pragma mark - 5.0.1 new

- (BOOL)shouldShowTipsInVC:(UIViewController *)vc withFlag:(int)flag {
    
    BOOL shouldShow = YES;
    
    NSInteger uid = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"TIP_IN_%@_%d_%ld", NSStringFromClass([vc class]), flag, (long)uid];
    
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (value) {
        shouldShow = [value boolValue];
    }
    return shouldShow;
}

- (void)setShouldShowTips:(BOOL)yesOrNo inVC:(UIViewController *)vc withFlag:(int)flag {
    
    NSInteger uid = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"TIP_IN_%@_%d_%ld", NSStringFromClass([vc class]), flag, (long)uid];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(yesOrNo) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 5.1.0

- (void)setUserHavaCheckNickname{
    NSInteger uid = [self getUserId];
    NSString  *key = [NSString stringWithFormat:@"HAVE_CHECK_%ld",(long)uid];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getUserHaveCheckNickname{
    NSInteger uid = [self getUserId];
    NSString  *key = [NSString stringWithFormat:@"HAVE_CHECK_%ld",(long)uid];
    BOOL  haveCheck = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (haveCheck) {
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)checkUserNickNameIsQualified
{
    if(![self getUserHaveCheckNickname])
    {
        
    }
    
    return YES;
}

- (NSDictionary *)getUserThumpUpAndBeParisedInfomation{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, @"/honor/good/"]];
    NSDictionary *rst = [self syncBatchDataWith:url andPostForm:nil];

    return rst;
}


- (NSDictionary *)getUserHonorData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/honor/get/"]];
    
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
    return result;
}

- (NSDictionary *)getHonorSystemInfo
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/honor/introduction/"]];
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    return result;
}

- (NSDictionary *)getBePraisedInfoAndpageTime:(NSInteger)time andSize:(NSInteger)size
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/agree/recvs/"]];
    NSDictionary *params =@{@"pagetime":  [NSNumber numberWithInteger:time],@"size":  [NSNumber numberWithInteger:size]};;
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:params];
    return result;
}

- (NSDictionary *)getUserShareOrLikeInfoFrom:(NSString *)nickName andInfoType:(XKRWArticleType )type andpageTime:(NSInteger)time andSize:(NSInteger)size  andPage:(NSInteger)page
{
    NSURL *url;
    NSDictionary *params;
    if(type  == ShareArticle){
        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/blog/my/"]];
    }else{
        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/agree/sends/"]];
    }
    if(nickName == nil){
        if (type != postLikeArticle) {
             params = @{@"pagetime":  [NSNumber numberWithInteger:time],@"size":  [NSNumber numberWithInteger:size]};
        } else {
            params = @{@"type":@"post",@"pagetime":  [NSNumber numberWithInteger:time],@"pagesize":  [NSNumber numberWithInteger:size]};
        }
       
    }else{
        if(type == ShareArticle){
             params = @{@"nickname":nickName,@"page":  [NSNumber numberWithInteger:page],@"pagesize":  [NSNumber numberWithInteger:size]};
        } else if (type == postLikeArticle) {
            params = @{@"nickname":nickName,@"type":@"post",@"pagetime":  [NSNumber numberWithInteger:time],@"pagesize":  [NSNumber numberWithInteger:size]};
        }else{
            params = @{@"nickname":nickName,@"pagetime":  [NSNumber numberWithInteger:time],@"size":  [NSNumber numberWithInteger:size]};
        }
    }
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:params];
    return result;
}

- (XKRWUserInfoShowEntity *)getOtherUserInfoFromUserNickname:(NSString *)nickname
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,@"/user/index/"]];
    NSDictionary *params = @{@"nickname":nickname};
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:params] ;
    
    NSDictionary *userInfoDic = [[result objectForKey:@"data"] objectForKey:@"user/get"];
    NSDictionary *recordDic = [[result objectForKey:@"data"] objectForKey:@"record/today"];
    NSDictionary *blogDic = [[result objectForKey:@"data"] objectForKey:@"honor/num"];
    XKRWUserInfoShowEntity *entity =  [[XKRWUserInfoShowEntity alloc]init] ;
    entity.age = [[userInfoDic objectForKey:@"age"] integerValue] ;
 
    entity.avatar = [userInfoDic objectForKey:@"avatar"];
    entity.birthday = [userInfoDic objectForKey:@"birthday"];
    entity.daily = [userInfoDic[@"daily"] integerValue];
    entity.sex  =  (XKSex)[userInfoDic[@"gender"] integerValue];

    entity.weight = [recordDic[@"weight"] floatValue];
    entity.slim_qa = userInfoDic[@"slim_qa"];
    entity.disease_type = userInfoDic[@"disease_type"];
    
    entity.height = [[userInfoDic objectForKey:@"height"] integerValue];
    entity.labor_level = (XKPhysicalLabor)[[userInfoDic objectForKey:@"labor_level"] integerValue];
    entity.manifesto = [userInfoDic objectForKey:@"manifesto"];
    entity.nickname = [userInfoDic objectForKey:@"nickname"];
    entity.blognum = [[blogDic objectForKey:@"blog_num"] integerValue] ;
    entity.post_num = [[blogDic objectForKey:@"post_num"] integerValue];
    entity.level = [blogDic objectForKey:@"level"];
    entity.thumpUpNum = [[blogDic objectForKey:@"send"] integerValue] ;
    entity.post_send = [[blogDic objectForKey:@"post_send"] integerValue];
    entity.bePraisedNum = [[blogDic objectForKey:@"recv"] integerValue];

    entity.backgroundUrl = [[userInfoDic objectForKey:@"slim_bak1" ]objectForKey:@"cover"];
    entity.starNum = [[[result objectForKey:@"data"] objectForKey:@"star/get"] integerValue] ;
    entity.avatar_hd = [[userInfoDic objectForKey:@"slim_bak1" ]objectForKey:@"avatar_hd"];
    
    NSArray *schemeArray = [recordDic objectForKey:@"scheme"];
    
    NSArray *recordArray = [recordDic objectForKey:@"record"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < schemeArray.count; i++) {
        XKRWRecordSchemeEntity *schemeEntity =  [[XKRWRecordSchemeEntity alloc] init];
        NSDictionary *dic = [schemeArray objectAtIndex:i];
        schemeEntity.calorie = [[dic objectForKey:@"calorie"] integerValue] ;
        schemeEntity.create_time = [[dic objectForKey:@"create_time"] integerValue];
        schemeEntity.sid = [[dic objectForKey:@"sid"] integerValue];
        schemeEntity.type = [[dic objectForKey:@"type"] integerValue];
        schemeEntity.record_value = [[dic objectForKey:@"value"] integerValue];
        schemeEntity.uid = 1000;
        schemeEntity.sync = 1;
        schemeEntity.rid = 1;
        schemeEntity.date = [NSDate date];
        [array addObject:schemeEntity];
    }
    
    entity.schemeReocrds = array;

    XKRWRecordEntity4_0 *oldRecordEntity = [[XKRWRecordEntity4_0 alloc] init];
    oldRecordEntity.date = [NSDate date];
    
    
    if(![recordDic[@"habit"] isKindOfClass:[NSNull class]] && [recordDic[@"habit"] isKindOfClass:[NSDictionary class]]) {
        
        NSString *habitString = recordDic[@"habit"][@"value"];
        
        if (habitString.length > 0) {
            [oldRecordEntity splitHabitStringIntoArray:habitString];
        } else {
            oldRecordEntity.habitArray = [NSMutableArray arrayWithArray:[[XKRWFatReasonService sharedService] getHabitEntitiesWithString:entity.slim_qa]];
        }
    } else {
        oldRecordEntity.habitArray = [NSMutableArray arrayWithArray:[[XKRWFatReasonService sharedService] getHabitEntitiesWithString:entity.slim_qa]];
    }
    entity.oldRecordEntity = oldRecordEntity;
    
    float BM = [XKRWAlgolHelper BM_with_weight:entity.weight height:entity.height age:entity.age sex:entity.sex];
    float PAL = [XKRWAlgolHelper PAL_with_sex:entity.sex physicalLabor:entity.labor_level];
//    //每日正常饮食摄入量
    float dailyIntakEnergy =  [XKRWAlgolHelper dailyIntakEnergyWithBM:BM PAL:PAL];
    //每日正常推荐摄入量
//    float schemeIntakEnergy = [XKRWAlgolHelper dailyIntakeRecommendEnergyWithBM:BM PAL:PAL sex:entity.sex age:entity.age];
    //真实饮食摄入
    float realIntakEnergy = 0;
    //真实运动消耗
    float realSportEnergy = 0;
    
    
     BOOL isrecord;
    
    //记录用户的运动情况
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (XKRWRecordSchemeEntity *schemeEntity  in array) {
        if(schemeEntity.type == RecordTypeBreakfirst || schemeEntity.type == RecordTypeLanch || schemeEntity.type == RecordTypeLanch ||schemeEntity.type == RecordTypeSnack || schemeEntity.type == 6){
            realIntakEnergy += schemeEntity.calorie;
        }
        
        if (schemeEntity.type == RecordTypeSport || schemeEntity.type  == 5) {
            realSportEnergy += schemeEntity.calorie;
            if (schemeEntity.type == RecordTypeSport) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:@"完美执行" forKey:@"text"];
                [dic setObject:[NSNumber numberWithFloat:schemeEntity.calorie] forKey:@"calorie"];
                [mutableArray addObject:dic];
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:@"完美执行45分钟" forKey:@"text"];
                [dic setObject:[NSNumber numberWithFloat:schemeEntity.calorie] forKey:@"calorie"];
                [mutableArray addObject:dic];
            }
        }
    }
    
   
    for (NSDictionary *recordDic in recordArray) {
        if ([[recordDic objectForKey:@"type"] integerValue] == 0) {
            realSportEnergy += [[recordDic objectForKey:@"calorie"] floatValue];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%@%ld分钟",[recordDic objectForKey:@"itemName"],[[recordDic objectForKey:@"number"] integerValue]] forKey:@"text"];
            [dic setObject:[NSNumber numberWithFloat:[[recordDic objectForKey:@"calorie"] floatValue]] forKey:@"calorie"];
            [mutableArray addObject:dic];
            
        }else{
            realIntakEnergy += [[recordDic objectForKey:@"calorie"] floatValue];
        }
        
        isrecord = YES;
    }
    
    
    
    
//    for (XKRWRecordFoodEntity *foodEntity in oldRecordEntity.FoodArray) {
//        realIntakEnergy += foodEntity.calorie;
//        isrecord = YES;
//    }
//    
//    for (XKRWRecordSportEntity *sportEntity in oldRecordEntity.SportArray) {
//        realSportEnergy += sportEntity.calorie;
//         isrecord = YES;
//    }
    entity.lossWeight = (dailyIntakEnergy -  realIntakEnergy + realSportEnergy) /7.7;
    entity.lessEatCalories = dailyIntakEnergy -  realIntakEnergy;
    entity.sportCalories = realSportEnergy;
    
//    for (XKRWRecordSportEntity *sportEntity in oldRecordEntity.SportArray) {
//       
//    }
    entity.sportArray = mutableArray;
    
    if ( realIntakEnergy + realSportEnergy > 0) {
        entity.isRecord = YES;
    }
    
    if (realIntakEnergy > 0) {
        entity.isRecordFood = YES;
    }
    
    if (realSportEnergy > 0) {
        entity.isRecordSport = YES;
    }
    
    return entity;
}

- (NSDictionary *)addExpWithType:(XKRWExpType)type {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNewServer, kAddExp]];
    
    NSString *typeString;
    if (type == XKRWExpTypeProgress) {
        typeString = @"processShare";
    }
    return [self syncBatchDataWith:url andPostForm:@{@"type": typeString}];
}

- (NSArray *)getAppRecommendInfo{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kAppRecommend]];

    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];
    
    NSArray *array = [result objectForKey:@"data"];
    NSMutableArray *appArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSInteger i = 0 ;i < array.count ;i++){
        NSDictionary *dic = [array objectAtIndex:i];
        XKRWAppRecommendModel *model = [[XKRWAppRecommendModel alloc] init];
        model.appId = [dic objectForKey:@"id"];
        model.name = [dic objectForKey:@"name"];
        model.appDescription = [dic objectForKey:@"description"];
        model.ios_download_url = [dic objectForKey:@"ios_download_url"];
        model.img_path = [dic objectForKey:@"img_path"];
    
        [appArray addObject:model];
    }
    return appArray;
}

- (NSDictionary *)setSchemeStartData{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewServer,kSetSchemeStartData]];
    
    NSDictionary *result = [self syncBatchDataWith:url andPostForm:nil];

    return result;
}

- (NSDictionary *)getMealRatio {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"meal_ratio_%ld",(long)[self getUserId]]];
}

- (BOOL) saveMealRatioWithBreakfast:(NSInteger)breakfast andLunch:(NSInteger)lunch andSnack:(NSInteger)snack andSupper:(NSInteger) supper{
    
    NSInteger destiWeight =   [XKRWUserService sharedService].getUserDestiWeight;
    CGFloat  targetWeight = destiWeight/1000.0f;
    
    NSDictionary *meal_ratio = @{@"breakfast":[NSNumber numberWithInteger:breakfast],@"lunch":[NSNumber numberWithInteger:lunch],@"supper":[NSNumber numberWithInteger:supper],@"snack":[NSNumber numberWithInteger:snack]};
    
    XKDifficulty degree = [[XKRWUserService sharedService ]getUserPlanDifficulty];
    NSDictionary *slim_Plan = @{@"meal_ratio":meal_ratio,
                                @"target_weight":[NSNumber numberWithFloat:targetWeight],
                                @"part":@"1,2,3,4,5,6",
                                @"degree":[NSNumber numberWithInt:degree]
                                };
    
   NSDictionary *dic =  [[XKRWUserService sharedService] changeUserInfo:slim_Plan WithType:@"slim_plan"];
    
    if([[dic objectForKey:@"success"] integerValue] ==1){
        [[NSUserDefaults standardUserDefaults] setObject:meal_ratio forKey:[NSString stringWithFormat:@"meal_ratio_%ld",(long)[self getUserId]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    return NO;

}


@end