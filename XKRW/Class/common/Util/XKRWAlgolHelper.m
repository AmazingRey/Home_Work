//
//  XKRWGlobalHelper.m
//  XKRW
//
//  Created by zhanaofan on 14-3-11.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWAlgolHelper.h"
#import "XKRWUserService.h"
#import "XKRWUserDefaultService.h"
#import "XKDatabaseUtil.h"
#import "FMResultSet+XKPersistence.h"
#import "FMDatabase.h"
#import "XKRWWeightService.h"
#import "XKRWUserService.h"
//static XKRWUserService *userService;

@implementation XKRWAlgolHelper
/*获取用户的BM*/
+ (float)BM
{
    return [[self class] BM_of_date:[NSDate date]];
}

+ (float)BM_of_date:(NSDate *)date {
    
    //体重
    float weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:date];
    //身高
    float height = [[XKRWUserService sharedService] getUserHeight];
    NSInteger age = [[XKRWUserService sharedService] getAge];
    XKSex sex = [[XKRWUserService sharedService] getSex];
    
    return [[self class] BM_with_weight:weight height:height age:age sex:sex];
}

+ (float)BM_with_weight:(float)weight height:(float)height age:(NSInteger)age sex:(XKSex)sex {
    
    float bm = 0.f;;
    if (age >= 7 && age <=10) {
        bm = (sex == eSexMale ? 22.7*weight +495 : 22.5*weight+499);
    }else if (age >= 11 && age <= 17){
        bm = (sex == eSexMale ? 17.5*weight +651 : 12.2*weight+746);
    }else if (age > 60){
        bm = (sex == eSexMale ? (13.5*weight +487)*0.95 : (10.5*weight+596)*0.95);
    }else{
        bm = 13.88*weight + 4.16*height - 3.43*age - 112.40*sex+54.34;
    }
    return bm;
}
/*获取用户的PAL*/
+ (float)PAL
{
    XKSex sex = [[XKRWUserService sharedService] getSex];
    XKPhysicalLabor labor = [[XKRWUserService sharedService] getUserLabor];
   
    return [[self class] PAL_with_sex:sex physicalLabor:labor];
}

+ (float)PAL_with_sex:(XKSex)sex physicalLabor:(XKPhysicalLabor)labor {
    
    NSArray *physicalPal = XKFemalePhysicalLevelOfPal;
    if (sex == eSexMale) {
        physicalPal = XKMalePhysicalLevelOfPal;
    }
    if (labor<=0) {
        labor = eLight;
    }
    if (labor >eHeavy) {
        labor = eHeavy;
    }
    float pal  = [[physicalPal objectAtIndex:labor -1] floatValue];
    return pal;
}
/*BMI*/
+ (float)BMI{
    float height = [[XKRWUserService sharedService] getUserHeight] / 100.f;
    float weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]];
    return [[self class] BMI_with_height:height weight:weight];
}

+ (float)BMI_with_height:(float)height weight:(float)weight {
    return weight / (height * height);
}
/*每日正常饮食摄入量*/
+ (float) dailyIntakEnergy
{
    float dailyIntakEnergy = [[self class] dailyIntakEnergyWithBM:[[self class] BM] PAL:[[self class] PAL]];
    return  dailyIntakEnergy;
}

+ (float)dailyIntakEnergyWithBM:(float)BM PAL:(float)PAL {
    
    return BM * PAL;
}
/*每日摄入能量*/
+ (float)dailyIntakeRecomEnergy
{
    float dailyIntakeRecomEnergy = [[self class] dailyIntakeRecomEnergyOfDate:[NSDate date]];
    return  dailyIntakeRecomEnergy;
}
/**
 *  date 当天的方案建议值
 */
+ (float)dailyIntakeRecomEnergyOfDate:(NSDate *)date {
    
    XKSex sex = [[XKRWUserService sharedService] getSex];
    NSInteger age = [[XKRWUserService sharedService] getAge];
    
    return [[self class] dailyIntakeRecommendEnergyWithBM:[[self class] BM_of_date:date] PAL:[[self class] PAL] sex:sex age:age];
}

+ (float)dailyIntakeRecommendEnergyWithBM:(float)BM PAL:(float)PAL sex:(XKSex)sex age:(NSInteger)age {
    
    float bmpal = BM * PAL;
    float energy;
    
    if (sex == eSexFemale) {
        if (bmpal < 1750) {
            energy = bmpal-330;
        }else if (bmpal>=1750 && bmpal<2080)
        {
            energy = bmpal-550;
        }else if(bmpal>=2080 && bmpal<2300){
            energy = bmpal-880;
        }else{
            energy = bmpal-1100;
        }
    }else{
        if (bmpal < 1950) {
            energy = bmpal-330;
        }else if (bmpal>=1950 && bmpal<2280)
        {
            energy = bmpal-550;
        }else if(bmpal>=2280 && bmpal<2500){
            energy = bmpal-880;
        }else{
            energy = bmpal-1100;
        }
    }
    if (age > 17) { //成人
        if (sex == eSexFemale) {//女性，如果小于1200,则最少位1200
            if (energy < 1200.f) {
                energy = 1200.f;
            }
        }else if(sex == eSexMale){//男性 小于1400 ，则最少为1400
            if (energy < 1400.f) {
                energy = 1400.f;
            }
        }
    }
    else { //7-17周岁
        if  (bmpal*0.6 > energy){
            energy = bmpal*0.6;
        }
    }
    return energy;
}

//每日 三钟 营养  比例 计算

+(NSDictionary*)getAdviceThreeNutrition
{
    CGFloat advice = [self dailyIntakeRecomEnergy];
    CGFloat pro1 = advice *0.12/4.f;      //蛋白质
    CGFloat pro2 = advice *0.18/4.f;
    
    CGFloat fat1 = advice*0.2/9.f;   //脂肪
    CGFloat fat2 = advice*0.3/9.f;   //脂肪
    
    CGFloat carbohydrates1 = advice *0.5/ 4.f ;    //碳水化合物
    CGFloat carbohydrates2 = advice *0.6/ 4.f ;    //碳水化合物
    
    NSString *proStr = [NSString stringWithFormat:@"%d~%d",(int) pro1,(int)pro2];
    NSString *fatStr = [NSString stringWithFormat:@"%d~%d", (int)fat1,(int)fat2];
    NSString *carStr = [NSString stringWithFormat:@"%d~%d",(int) carbohydrates1,(int)carbohydrates2];
    
    //pro 蛋白质  car 碳水 化合物  fat 脂肪
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:proStr,@"pro",carStr,@"car",fatStr,@"fat", nil];
    
    return dic;
}

/**
 *  获取用户最低摄入热量值
 *
 *  @return 最低摄入热量
 */
+(float)atLeastEnergy
{
    XKSex sex = [[XKRWUserService sharedService] getSex];
    NSInteger age = [[XKRWUserService sharedService] getAge];
    return [[self class] atLeastEnergyWithBM:[[self class] BM] PAL:[[self class] PAL] sex:sex age:age];
}

+ (float)atLeastEnergyWithBM:(float)BM PAL:(float)PAL sex:(XKSex)sex age:(NSInteger)age {
    
    float bmpal = BM * PAL;
    float energy = 0.0;
    if (age >= 18) {
        if (sex == eSexMale) {
            energy = 1400;
        } else {
            energy = 1200;
        }
    } else {
        energy = bmpal * 0.6;
    }
    return energy;
}

+ (CGFloat)getSchemeRecomandDietScaleWithType:(RecordType)type {
    
    switch (type) {
        case RecordTypeBreakfirst:
            return 0.3;
            break;
        case RecordTypeLanch:
            return 0.5;
            break;
        case RecordTypeDinner:
            return 0.2;
            break;
        default:
            return 0;
            break;
    }
}

+ (NSInteger)getSchemeRecomandCalorieWithType:(RecordType)type date:(NSDate *)date {
    
    NSInteger calorie = 0;
    
    CGFloat scale = [[self class] getSchemeRecomandDietScaleWithType:type];
    NSInteger wholeDayColorie = [[self class] dailyIntakeRecomEnergyOfDate:date];
    
    calorie = wholeDayColorie * scale;
                                 
    return calorie;
}

/** 按餐次，获取需要摄入的能量*/
+ (float)intakeRecomWithMealType:(MealType)type
{
    float energy = 0.f;
    float recomEnergy = [[self class] dailyIntakeRecomEnergy];
    uint32_t scale = [XKRWUserDefaultService getDiectScaleWithType:type];
    energy = recomEnergy * scale /100.f;
    return energy;
}
+ (foodMetric) metricWithMealType:(MealType)type scale:(uint32_t)scale  unitEnergy:(uint32_t)unitEnergy
{
    foodMetric foodMetric = {0.f,0.f};
    //获取本餐次的能量
    float energy = [[self class] intakeRecomWithMealType:type];
    foodMetric.energy = energy * (scale/100.f);
    foodMetric.weight = foodMetric.energy *100 /unitEnergy;
    return foodMetric;
}
/** 每日运动消耗量*/
+ (float)dailyConsumeSportEnergy {
    
    XKPhysicalLabor physicalLevel = [[XKRWUserService sharedService] getUserLabor];
    XKSex sex = [[XKRWUserService sharedService] getSex];
    
    return [[self class] dailyConsumeSportEnergyWithPhysicalLabor:physicalLevel
                                                               BM:[[self class] BM_of_date:[NSDate date]]
                                                              PAL:[[self class] PAL]
                                                              sex:sex];
}

+ (float)dailyConsumeSportEnergyWithPhysicalLabor:(XKPhysicalLabor)labor BM:(float)BM PAL:(float)PAL sex:(XKSex)sex {
    if (labor == eHeavy) {
        return 0.f;
    }
    float bmpal = BM * PAL;
    NSArray *sportLimit = (labor == eMiddle) ? XKSportOfNormalLimitCalorie : XKSportOfLightLimitCalorie;
    
    if (sex == eSexFemale) {
        if (bmpal < 1750) {
            return [[sportLimit objectAtIndex:0] floatValue];
        }else if (bmpal>=1750 && bmpal<2080){
            return [[sportLimit objectAtIndex:1] floatValue];
        }else if(bmpal>=2080 && bmpal<2300){
            return [[sportLimit objectAtIndex:2] floatValue];
        }else{
            return [[sportLimit objectAtIndex:3] floatValue];
        }
    }else{
        if (bmpal < 1950) {
            return [[sportLimit objectAtIndex:0] floatValue];
        }else if (bmpal>=1950 && bmpal<2280) {
            return [[sportLimit objectAtIndex:1] floatValue];
        }else if(bmpal>=2280 && bmpal<2500){
            return [[sportLimit objectAtIndex:2] floatValue];
        }else{
            return [[sportLimit objectAtIndex:3] floatValue];
        }
    }
}

/** 达成目标需要的天数*/
+ (NSInteger) dayOfAchieveTarget
{
    float cur_weight = [[XKRWUserService sharedService] getUserOrigWeight];
    float target_weight = [[XKRWUserService sharedService] getUserDestiWeight];
    NSInteger limit = [[self class] limitOfEnergywithCurWeight:cur_weight andTargetWeight:target_weight];
    if (limit == 0) {
        return 0;
    }
    
    float reduce = 480;
    
    // 5.0 Modified: Normal intake - Scheme recomand + Sport scheme
    
    switch ([[self class] getDailyIntakeSizeNumber]) {
        case 1:
            reduce = [[self class] dailyIntakEnergy] - 2200 + [[self class] dailyConsumeSportEnergy];
            break;
        case 2:
            reduce = [[self class] dailyIntakEnergy] - 1800 + [[self class] dailyConsumeSportEnergy];
            break;
        case 3:
            reduce = [[self class] dailyIntakEnergy] - 1400 + [[self class] dailyConsumeSportEnergy];
            break;
        default:
            break;
    }
    int32_t days = ceil((cur_weight-target_weight) * 7.7 / reduce);
    XKLog(@"达成目标天数为%d,当前体重%f,目标体重%f",days,cur_weight,target_weight);
    return days > 0 ? days : 0;
}


+ (void) setExpectDayOfAchieveTarget:(NSInteger )weight andStartTime:(id)starttime{
    NSInteger cur_weight = weight;
    float target_weight = [[XKRWUserService sharedService] getUserDestiWeight];
    NSInteger limit = [[self class] limitOfEnergywithCurWeight:cur_weight andTargetWeight:target_weight];
    if (limit == 0) {
        XKLog(@"这里有没有执行呢");
        return ;
    }
    
    float reduce = 480;
    
    switch ([[self class] getDailyIntakeSizeNumber]) {
        case 1:
            reduce = [[self class] dailyIntakEnergy] - 2200 + [[self class] dailyConsumeSportEnergy];
            break;
        case 2:
            reduce = [[self class] dailyIntakEnergy] - 1800 + [[self class] dailyConsumeSportEnergy];
            break;
        case 3:
            reduce = [[self class] dailyIntakEnergy] - 1400 + [[self class] dailyConsumeSportEnergy];
            break;
        default:
            break;
    }
    int32_t days = ceil((cur_weight-target_weight) * 7.7 / reduce);
    XKLog(@"达成目标天数为%d,当前体重%ld,目标体重%f",days,(long)cur_weight,target_weight);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:days > 0 ? days : 0] forKey:[NSString stringWithFormat:@"ExpectDay_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    
    NSTimeInterval timeInterval = [starttime doubleValue];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:startDate];
    NSDate *date = [formatter dateFromString:stringDate];
    XKLog(@"设置开始时间为%@",date);
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:[NSString stringWithFormat:@"StartTime_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber *) expectDayOfAchieveTarget{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ExpectDay_%ld",(long)[[XKRWUserService sharedService] getUserId]]] ;
}


+ (NSInteger ) remainDayToAchieveTarget{
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"StartTime_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    NSDate *nowDate = [NSDate date];
    
    NSInteger passDay = (([nowDate timeIntervalSince1970] - [startDate timeIntervalSince1970]) / (24 * 60 * 60)) + 1 ;
    XKLog(@"预期天数是多少%ld天 ,已经过了%ld天,达成目标还需要%ld天",(long)[self expectDayOfAchieveTarget].integerValue,(long)passDay, [self expectDayOfAchieveTarget].integerValue - passDay >=  -1 ? ([self expectDayOfAchieveTarget].integerValue - passDay) : -1);
  
    
    return    [self expectDayOfAchieveTarget].integerValue - passDay >=  -1 ? ([self expectDayOfAchieveTarget].integerValue - passDay) : -1;
    
  
}

+ (NSInteger ) newSchemeStartDayToAchieveTarget{
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"StartTime_%ld",(long)[[XKRWUserService sharedService] getUserId]]];
    NSDate *nowDate = [NSDate date];
    
    NSInteger passDay = ([nowDate timeIntervalSince1970] - [startDate timeIntervalSince1970]) / (24 * 60 * 60) ;
    return passDay + 1;
}



/** 运动在指定时间消耗的卡路里数*/
+ (NSInteger) sportConsumeWithTime:(NSInteger)minutes mets:(float)mets
{
    //METs * 分钟数 * 3.5 / 200 *当前体重（公斤）
    float curWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]];
    
    return mets*minutes*3.5/200 *curWeight ;
}

+ (NSInteger)sportTimeWithCalorie:(float)calorie mets:(float)mets {
    
    float curWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]];
    
    return calorie * 200 / (curWeight * mets * 3.5);
}

+ (NSInteger) sucessProbability
{
    uint32_t stars = 20;//[XKRWUserService sharedService];
    uint32_t probalility = 0 , from, to ;
    if (stars <=30) {
        from = 10;to = 30;
    }else if (stars <= 100){
        from = 31;to = 50;
    }else if(stars <400){
        from = 51;to = 70;
    }else if(stars <800){
        from = 71;to = 80;
    }else {
        from = 81;to = 90;
    }
    probalility = [XKRWUtil getRandomNumber:from to:to];
    return probalility;
}

/*获取每日的限制摄入量值*/
+ (NSInteger) limitOfEnergywithCurWeight:(CGFloat )curWeight andTargetWeight:(CGFloat) targetWeight
{
//    NSInteger curWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]] * 1000;
//    NSInteger targetWeight = [[XKRWUserService sharedService] getUserDestiWeight];
    if (curWeight <= targetWeight) {
        return 0;
    }
    XKDifficulty difficult = [[XKRWUserService sharedService] getUserPlanDifficulty];
    NSArray *limit = XKDietLimitCalorie;
    float bmpal = [[self class] BM] * [[self class] PAL];
    if (difficult > [limit count] ) {
        difficult = (int)[limit count];
    }
    if (difficult < 1) {
        difficult = 1;
    }
    
    float energy = bmpal - [[limit objectAtIndex:difficult-1] unsignedIntegerValue];
    XKSex sex = [[XKRWUserService sharedService] getSex];
    NSInteger age = [[XKRWUserService sharedService] getAge] ;
    float limitEnergy = (float)[[limit objectAtIndex:difficult-1] unsignedIntegerValue];
    //未成年人，且摄入量低于60%
    if (age <= 17 && age >= 7) {
        if (bmpal*0.6 > energy) {
            limitEnergy = bmpal*0.4;
        }
    } else {
        //成年人，摄入量低于正常值
        if (sex == eSexMale && energy < 1400.0) {
            
            limitEnergy = bmpal - 1400.f;
            
        } else if (sex == eSexFemale && energy < 1200.0) {
            
            limitEnergy = bmpal - 1200.f;
        }
    }
    return limitEnergy;
}
/*成功减肥*/
+ (float) didReduceWeight
{
    float originWeight = 0.0;
    float currentWeight = [[XKRWUserService sharedService] getCurrentWeight];
    return originWeight - currentWeight;
}

/*将卡路里转换成脂肪*/
+ (NSInteger) fatWithCalorie:(NSInteger)calorie
{
    return (int)((calorie / 7.7) + 0.5f) ;
}
/*还能吃*/
//+ (NSInteger) intakeOfRemainEnergy:(NSString *)day
//{
//    float currentWeight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:[NSDate date]] * 1000;
//    float targetWeight = [[XKRWUserService sharedService] getUserDestiWeight];
//    
//    NSInteger intakeEnergy = [[self class] dailyIntakeRecomEnergy];
//    NSInteger energy = intakeEnergy;
//    NSInteger recordEnergy = [[XKRWRecordService shareService] totalEnergyWithType:eSchemeFood   day:day];
//    if (currentWeight <= targetWeight) {
//        return (int)[[self class] dailyIntakEnergy] - recordEnergy;
//    }
//    if (recordEnergy > 0) {
//        energy = intakeEnergy - recordEnergy;
//    }
//    return energy;
//}
///*还需要运动*/
//+ (NSInteger) sportOfRemain:(NSString *)day
//{
//    uint32_t intakeEnergy = [[self class] dailyConsumeSportEnergy];
//    int32_t energy = intakeEnergy;
//    NSInteger recordEnergy = [[XKRWRecordService shareService] totalEnergyWithType:eSchemeSport   day:day];
//    if (recordEnergy > 0) {
//        energy = intakeEnergy - recordEnergy;
//    }
//    return energy;
//}

/*根据身高和年龄求健康体重下限*/
+(NSInteger)calcHealthyWeightFloorWithHeight:(NSInteger)height sex:(XKSex)sex andAge:(NSInteger)age {
    int32_t weightFloor = 0;
    if(age <= 17) {
        __block NSDictionary *resultDic = nil;
        [[XKDatabaseUtil defaultDB] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM bmireference WHERE age = ? AND gender = ?",itoa((int)age),itoa(sex)];
            while ([result next]) {
                resultDic = [result resultDictionary];
            }
        }];
        float floor_bmi = ((NSNumber *)resultDic[@"healthyweight"]).floatValue;
        weightFloor = (int32_t)(floor_bmi * powf((height / 100.0), 2) * 10 + 0.5) * 100;
    }
    else {
        weightFloor = (int32_t)(18.5 * powf((height / 100.0), 2) * 10 + 0.5) * 100;
    }
    return weightFloor;
}
//根据性别，身高，年龄计算bmi和体重范围
+(XKRWBMIEntity *)calcBMIInfoWithSex:(XKSex)sex age:(NSInteger)age andHeight:(NSInteger)height {
    XKRWBMIEntity *entity = [[XKRWBMIEntity alloc]init];
    if(age <= 17) {
        __block NSDictionary *resultDic = nil;
        [[XKDatabaseUtil defaultDB] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM bmireference WHERE age = ? AND gender = ?",itoa((int)age),itoa(sex)];
            while ([result next]) {
                resultDic = [result resultDictionary];
            }
        }];      
        //健康体重BMI
        entity.healthyBMI = ((NSNumber *)resultDic[@"healthyweight"]).floatValue;
        //健康上限
        entity.overweightBMI = ((NSNumber *)resultDic[@"overweight"]).floatValue ;
        entity.fatBMI = ((NSNumber *)resultDic[@"fatweight"]).floatValue;
        
        entity.healthyWeight = (int32_t)(entity.healthyBMI * powf((height / 100.0), 2) * 10 ) * 100;
        entity.overWeight = (int32_t)(entity.overweightBMI * powf((height / 100.0), 2) * 10 ) * 100;
        entity.fatWeight = (int32_t)(entity.fatBMI * powf((height / 100.0), 2) * 10 ) * 100;
    }
    else {
        entity.healthyBMI = 18.5;
        entity.overweightBMI = 24;
        entity.fatBMI = 28.f;
        entity.healthyWeight = (int32_t)(entity.healthyBMI * powf((height / 100.0), 2) * 10) * 100;
        entity.overWeight = (int32_t)(entity.overweightBMI * powf((height / 100.0), 2) * 10 ) * 100;
        entity.fatWeight = (int32_t)(entity.fatBMI * powf((height / 100.0), 2) * 10 ) * 100;
    }
    return entity;
}

//根据难度计算减肥时间
+(NSInteger)calcReduceWeightDurationWithDiffiuclty:(XKDifficulty)difficulty origWeight:(NSInteger)orig andDestiWeight:(NSInteger)desti {
    NSInteger duration = 0;
    //初始值大于目标值返回天数
    if (orig > desti) {
        float total = 7700 * (orig - desti) / 1000.0;
        
       float program = ([[self class] dailyIntakEnergy] - [[self class] dailyIntakeRecomEnergy]);
        
        switch (difficulty) {
            case eEasy:
                duration = ceilf( total / 330.0);
                break;
            case eNormal:
                duration = ceilf(total / 550.0);
                break;
            case eHard:
                duration = ceilf(total / 880.0);
                break;
            case eVeryHard:
                duration = ceilf(total / 1100.0);
                break;
            default:
                duration = ceilf(total / program);
                break;
        }
    }
    //结果为负 显示0天
    if (duration < 0 ) {
        duration = 0;
    }
    //else NOP

    return  duration;
}
+(NSInteger) getReduceDaysWithDiffCulty:(XKDifficulty)diffculty{
    int days = 0;
    



    return days;
}

/*计算用户超过多少减肥比例*/
+(NSString *)calcUserPercentWithStarNum:(NSInteger)num {
    
    NSInteger percent = 0 ;
    if (num == 0 ) {
        percent = 0 ;
    }
    else
    {
      percent = (num - 1)/5 +1;
    }
    
    if (percent > 99) {
        percent = 99;
    }
    
//    int rate = 50;
//    if(num <= 30) {
//        rate = [self getRandomNumber:10 to:30];
//    } else if(num <= 100) {
//        rate = [self getRandomNumber:31 to:50];
//    } else if(num <= 400) {
//        rate = [self getRandomNumber:51 to:70];
//    } else if(num <= 800) {
//        rate = [self getRandomNumber:71 to:80];
//    } else {
//        rate = [self getRandomNumber:81 to:90];
//    }
    
    return [NSString stringWithFormat:@"%li%%",(long)percent];
}

/*取随机数*/
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}


+(NSInteger)calcCaloriesWithUnit:(MetricUnit)unit andValue:(NSInteger)value andEnergy:(NSInteger)energy{
    switch (unit) {
        case eUnitGram :
        {
//            _str_unit = @"克";
        return value * energy / 100;
            
        }
            break;
        case eUnitKilojoules :
        {
            //1千卡=4.186千焦
           return  (int)(value/4.186 + .5);
//            _str_unit = @"千焦";
        }
            break;
        case eUnitKiloCalories :
        {
            
            return value;
//            _str_unit = @"千卡";
        }
            break;
        case eUnitBox :
        {
            
//            _str_unit = @"盒";
        }
            break;
        case eUnitBlock :
        {
//            _str_unit = @"块";
        }
            break;
        case eUnitMilliliter :
        {
//            _str_unit = @"毫升";
        }
            break;
        case eUnitMinutes:{
//            _str_unit = @"分钟";
        }
        default:
            break;
    }
    return 0;
}
//
+(NSString *)getPercentWithDays:(NSInteger)days{

    if (days == 0) {
        return @"0%";
    }
   else if (days <=1) {
        return @"1%";
    }else if ((days > 1) && (days<=5) ){
        return @"5%";
    }
    else if ((days > 5) && (days <= 10)){
        return @"10%";
    }
    else if ((days > 10) && (days <= 20)){
        return @"20%";
    }
    else if ((days > 20) && (days <= 30)){
        return @"30%";
    }
    else if ((days > 30) && (days <= 60)){
        return @"40%";
    }
    else if ((days > 60) && (days <= 100)){
        return @"50%";
    }
    else if ((days > 100) && (days <= 200)){
        return @"60%";
    }
    else if ((days > 200) && (days <= 300)){
        return @"70%";
    }
    else if ((days > 300)){
        return @"80%";
    }
    
    
  return @"1%";

}


+(NSDate*)getYesterdayDate
{
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    return yesterday;
}

+ (NSString *)getDailyIntakeSize {
    
    CGFloat intake = [self dailyIntakeRecomEnergy];
    
    if (intake <= 1400) {
        return @"1200~1400kcal";
    } else if (intake > 1400 && intake <= 1800) {
        return @"1400~1800kcal";
    } else {
        return @"1800~2200kcal";
    }
}

+ (NSRange)getDailyIntakeRange{
    
    CGFloat intake = [self dailyIntakeRecomEnergy];
    
    if (intake <= 1400) {
        
        return NSMakeRange(1200, 200);
    } else if (intake > 1400 && intake <= 1800) {
        return NSMakeRange(1400, 400);
    } else {
        return NSMakeRange(1800, 400);
    }
}

+ (NSInteger)getDailyIntakeSizeNumber {
    
    CGFloat intake = [self dailyIntakeRecomEnergy];
    
    if (intake <= 1400) {
        return 3;
    } else if (intake > 1400 && intake <= 1800) {
        return 2;
    } else {
        return 1;
    }
}

+ (NSString *)getDailyIntakeTipsContent
{
    CGFloat  intake =   [self  dailyIntakeRecomEnergy];
    
    
    return [NSString stringWithFormat:@"热量摄入：%@\n三餐比例：3:5:2，早餐适量、午餐正常、晚餐少吃 \n食谱构成：接地气的家常菜，包含谷薯类、肉类及豆制品、果蔬类、奶制品 \n温馨提示：少盐少油、保证饮水、睡眠充足",[self getDailyIntakeSize]];
    
//    if (intake<=1400 ){
//        return  @"根据您的身体状况、饮食习惯量身定制。小份食谱热量在1200~1400kCal之间，早餐适量，午餐营养，晚餐清淡，以常见的新鲜果蔬和低热量高蛋白肉食为主，营养均衡，低卡健康。两周左右，养成长期的健康饮食习惯。";
//        
//    }else if(intake >1400 && intake <=1800){
//        return  @"根据您的身体状况、饮食习惯量身定制。中份食谱热量在1400~1800kCal之间，早餐适量，午餐营养，晚餐清淡，以常见的果蔬、烹饪菜肴和低热量高蛋白肉食为主，营养均衡，低卡健康。两周左右，养成长期的健康饮食习惯。";
//        
//    }else{
//        return  @"根据您的身体状况、饮食习惯量身定制。大份食谱热量在1800~2200kCal之间，早餐适量，午餐营养，晚餐清淡，以常见的果蔬、烹饪菜肴和高蛋白肉食为主，营养均衡健康，却不乏饱腹感。两周左右，养成长期的健康饮食习惯。";
//        
//    }

}

+ (NSString *)getSportTipsContent:(NSString *)sportCal
{
   XKPhysicalLabor labor =  [XKRWUserService sharedService].getUserLabor;
    
    if(labor == eLight){
        return [NSString stringWithFormat: @"热量消耗：%@ \n运动方案：有氧运动、力量训练、综合体能练习 \n温馨提示：注意运动前的热身和运动后的拉伸放松",sportCal];
    }else if (labor == eMiddle){
        return [NSString stringWithFormat:@"热量消耗：%@ \n运动方案：步行、骑车等生活中常见的低强度活动 \n温馨提示：减脂效果在运动后1~2天后开始产生，坚持锻炼有助于形成易瘦体质，促进新陈代谢",sportCal];
    }else{
        return   [NSString stringWithFormat: @"热量消耗：%@ \n运动方案：无需额外运动，保持目前的体力活动状态即可 \n温馨提示：保持生活好习惯，适度调节放松身心，注意劳逸结合哦",sportCal];
    }
}

+(NSString *)getLossWeek{
    CGFloat normal_cal =  self.dailyIntakEnergy;

    CGFloat sport_cal = self.dailyConsumeSportEnergy;
    CGFloat lossweight = [XKRWUserService.sharedService getUserOrigWeight] - [XKRWUserService.sharedService getUserDestiWeight];
    
    float maxIntake;
    CGFloat  intake =   [self  dailyIntakeRecomEnergy];
    if (intake<=1400 ){
        maxIntake = 1400;
    }else if(intake >1400 && intake <=1800){
        maxIntake = 1800;
    }else{
        maxIntake = 2400;
    }
    
    int week = (int)(7700*(lossweight/1000.f)/(normal_cal-intake+sport_cal)/7);
    return [NSString stringWithFormat:@"%d",week];
    
}

@end
