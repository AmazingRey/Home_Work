//
//  XKRWRecordService4_0.h
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWRecordEntity4_0.h"
#import "XKRWUserDefaultService.h"
#import "XKRWFoodService.h"
#import "XKRWSportService.h"
#import "XKRWWeightService.h"

#import "XKRWUniversalRecordEntity.h"
#import "XKRWRecordSchemeEntity.h"

#define SUCCESS @"success"
#define ERROR @"error"

typedef NS_ENUM(NSInteger, XKRWRecordType) {
    XKRWRecordTypeFood = 0,
    XKRWRecordTypeSport,
    XKRWRecordTypeCustom,
    XKRWRecordTypeWeight,
    XKRWRecordTypeCircumference,
    XKRWRecordTypeHabit,
    XKRWRecordTypeMenstruation,
    XKRWRecordTypeSleep,
    XKRWRecordTypeWater,
    XKRWRecordTypeMood,
    XKRWRecordTypeRemark,
    XKRWRecordTypeScheme = 100
};

@interface XKRWRecordService4_0 : XKRWBaseService

+ (id)sharedService;
#pragma mark - Web Service Operation 网络操作

/********************************************************
 网络保存数据接口
 *******************************************************/
#pragma mark - Download from remote
//  获取数据接口

//- (NSArray *)getUserRecordDate;

#pragma mark - Save to remote
//  保存数据接口:
/**
 *  批量上传接口
 */
- (BOOL)batchSaveRecordToRemoteWithEntities:(NSArray *)eneities type:(NSString *)type isImport:(BOOL)isImport;

/**
 *  保存食物记录到服务器
 */
- (BOOL)saveFoodRecordToRemote:(XKRWRecordFoodEntity *)entity;
/**
 *  保存运动到服务器
 */
- (BOOL)saveSportRecordToRemote:(XKRWRecordSportEntity *)entity;
/**
 *  保存自定义食物或运动到服务器
 */
- (BOOL)saveCustomFoodOrSportToRemote:(XKRWRecordCustomEntity *)entity;
/**
 *  保存体重记录到服务器
 */
- (BOOL)saveWeightToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存围度记录到服务器
 */
- (BOOL)saveCircumferenceToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存习惯记录到服务器
 */
- (BOOL)saveHabitRecordToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存大姨妈情况到服务器
 */
- (BOOL)saveMenstruationToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存睡眠时长到服务器
 */
- (BOOL)saveSleepingTimeToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存起床时间到服务器
 */
- (BOOL)saveGetUpToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存饮水记录到无服务器
 */
- (BOOL)saveWaterToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存心情记录到服务器
 */
- (BOOL)saveMoodToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存备注到服务器
 */
- (BOOL)saveRemarkToRemote:(XKRWRecordEntity4_0 *)entity;
/**
 *  保存记录（通用对象）到服务器
 *
 *  @param entity 记录通用实体对象
 *
 *  @return 是否成功呀
 */
- (BOOL)saveUniversalRecordToRemote:(XKRWUniversalRecordEntity *)entity;

#pragma mark - Delete from remote

- (BOOL)deleteFoodRecordFromRemote:(XKRWRecordFoodEntity *)entity;

- (BOOL)deleteSportRecordFromRemote:(XKRWRecordSportEntity *)entity;

- (BOOL)deleteCustomRecordFromRemote:(XKRWRecordCustomEntity *)entity;

#pragma mark - DB Operation 数据库操作
#pragma mark -
/**
 *  保存食物记录到数据库
 */
- (BOOL)recordFoodToDB:(XKRWRecordFoodEntity *)entity;
/**
 *  保存运动记录到数据库
 */
- (BOOL)recordSportToDB:(XKRWRecordSportEntity *)entity;
/**
 *  保存自定义食物记录到数据库
 */
- (BOOL)recordCustomFoodToDB:(XKRWRecordCustomEntity *)entity;
/**
 *  保存自定义运动记录到数据库
 */
- (BOOL)recordCustomSportToDB:(XKRWRecordCustomEntity *)entity;
/**
 *  保存其他基本信息到数据库
 */
- (BOOL)recordInfomationToDB:(XKRWRecordEntity4_0 *)entity;
/**
 *  从数据库（下同）删除食物记录
 */
- (BOOL)deleteFoodRecordInDB:(XKRWRecordFoodEntity *)entity;
/**
 *  删除运动记录
 */
- (BOOL)deleteSportRecordInDB:(XKRWRecordSportEntity *)entity;
/**
 *  删除自定义食物记录
 */
- (BOOL)deleteCustomFoodInDB:(XKRWRecordCustomEntity *)entity;
/**
 *  删除自定义运动记录
 */
- (BOOL)deleteCustomSportInDB:(XKRWRecordCustomEntity *)entity;
/**
 *  删除其他记录
 */
- (BOOL)deleteRecordInfoInDB:(XKRWRecordCustomEntity *)entity;

- (BOOL)recordSchemeToDB:(XKRWRecordSchemeEntity *)entity;
/**
 *  批量保存方案记录
 */
- (BOOL)batchSaveSchemeRecordsToDB:(NSArray *)array;

#pragma mark - Public Interface 公共接口
#pragma mark -

#pragma mark - 5.0.1 new 

- (void)saveMenstruation:(BOOL)comeOrNot;
/**
 *  获取大姨妈情况
 */
- (BOOL)getMenstruationSituation;

#pragma mark - 5.0 NEW

//  (因新接口结构调整，5.0以后版本尽量使用以下接口，结构转换和校验都在此步进行。)
/**
 *  Version 5.0 and later, use this new interface. Cause the changes of server data, the struct exchange and verify should be done in this case.
 *
 *  @param recordEntity The entity of record type
 *  @param type         The type of record
 *
 *  @return Is success
 */
- (BOOL)saveRecord:(id)recordEntity ofType:(XKRWRecordType)type;

- (BOOL)deleteRecord:(id)recordEntity;

/// 新升级后，当天记录的数据转换为方案记录时，sid=0，造成主页方案记录查询不到，再进行记录时，数据库和服务器方案会重复，所以需要查询sid=0的当天方案记录并清除
- (void)cleanWrongSchemeRecords;

/**
 *  根据scheme查找date当天的方案记录
 *
 *  @param schemes 方案实体对象数组
 *  @param date 时间
 *
 *  @return 方案记录实体对象数组
 */
- (NSArray *)getSchemeRecordWithSchemes:(NSArray *)schemes date:(NSDate *)date;
/**
 *  获取date当天的方案记录
 *
 *  @param date 时间
 *
 *  @return 方案记录实体对象数组
 */
- (NSArray *)getSchemeRecordWithDate:(NSDate *)date;
/**
 *  Get scheme record, use Scheme ids to search; If search result is null, will create a new scheme record for return
 *
 *  @param schemes     Scheme entities array
 *  @param date        Searching date
 *
 *  @return Scheme records
 */
- (XKRWRecordSchemeEntity *)getSchemeRecordWithDate:(NSDate *)date type:(RecordType)type;
/**
 *  获取num天数内的方案记录状态
 *
 *  @param num 查找的天数
 *
 *  @return 状态数组，0：未计，1：完美执行(green)，2：偷了个懒/暴饮暴食(red)，3：吃了别的/做了别的(yellow)
 */
- (NSArray *)getSchemeStateOfNumberOfDays:(NSInteger)num withType:(RecordType)type;

/**
 *  获取最近days天数的习惯统计数据
 *
 *  @param days 天数
 *
 *  @return 统计数据
 */
- (NSDictionary *)getHabitInfoWithDays:(NSInteger)days;

/// 吃了大餐按钮文案
- (NSString *)getEatALotText;

/// 从本地获取吃了大餐文案
- (NSString *)getEatALotTextFromLocal;

/// 重置方案时调用，用来调整用户记录数据。
- (void)resetUserRecords;

/// 重置方案后，设置当前体重（因重置方案不会删除其他数据）
- (void)resetCurrentUserWeight:(float)weight;

/// 因Swift 1.x 暂无异常处理，先帮忙SchemeService5.0做异常处理
- (BOOL)doFixV5_0;
/// 判断数据库中 是否有这一天的数据


#pragma mark -

/**
 *  获得当天饮食/运动总量（KCAL）type = 1为食物， type = 0为运动
 */
- (NSInteger)getTotalCalorieOfDay:(NSDate *)date type:(int)type __deprecated_msg("Deprecated after Version 5.0");
/**_
 *  获得所有记录的维度、体重、时间
 *
 *  @return 返回值为字典，字典通过“waistline”等键值可以拿到响应部位存储数据的字典，子字典对应关系如下（例）：(key = value) name = 胸围， max = 最大值， min = 最小值， content = 数组；content数组中存放单个记录字典，对应关系如下：date = 日期（string），value = 当日值；取围度、体重字典key值：weight
 *
 */

- (NSDictionary *)getAllCircumferenceAndWeightRecord;

/**
 *  判断记录表里边是否记录了某一天的围度数据
 */
- (BOOL) recordTableHavaDataWithDate:(NSString *)date AndType:(DataType ) dataType;

/**
 *  获取days天数的维度和体重
 */
- (NSDictionary *)getCircumferenceAndWeightRecordOfDays:(NSInteger)numOfDays;
/**
 *  获取当天所有记录
 */
- (XKRWRecordEntity4_0 *)getAllRecordOfDay:(NSDate *)date;
/**
 *  获取当天体重记录
 */
- (float)getWeightRecordOfDay:(NSDate *)date;
/**
 *  获取体重记录 (days  这些天的体重数据)
 */
- (NSArray *)getWeightRecordNumberOfDays:(NSInteger) days;

/**
 *  获取当天其他记录（除去饮食和运动记录）
 */
- (XKRWRecordEntity4_0 *)getOtherInfoOfDay:(NSDate *)date;
/**
 *  获取记录历史（无重复）
 */
- (NSArray *)getRecordHistoryWithType:(int)type;
/**
 *  从数据库中查询用户记录的日期
 */
- (NSMutableArray *)getUserRecordDateFromDB;
/**
 *  判断date当天有没有记录过（从record 4.0表中查是否有当天数据）
 */
- (BOOL)haveRecordOfDate:(NSDate *)date;
/**
 *  获取date当天用户记录饮食的营养和组成成分
 */
- (NSArray *)getDietNutriIngredientWithDate:(NSDate *)date;
/**
 *  获取当天饮食的脂肪、蛋白质、碳水化合物的比例，返回值字典中Key值为kFat, kProtein, kCarbohydrate
 */
- (NSDictionary *)getFatProteinCarbohydratePercentage:(NSDate *)date;
/**
 *  获取date当天饮食（吃了别的）中，三大营养元素的详细数值
 *
 *  @param date 日期
 */
- (NSDictionary *)getFatProteinCarbohydrate:(NSDate *)date;
/**
 *  获取参数日期所有记录的饮食的脂肪、蛋白质、碳水化合物详细数值，返回字典中Key值为kFat, kProtein, kCarbohydrate，
 *
 *  @param date 查询日期
 *
 *  @return 结果字典
 */
- (NSDictionary *)getFatProteinCarbohydrateOfRecord:(NSDate *)date;


#pragma mark - Synchronize Data 数据同步
#pragma mark -
/**
 *  检查是否有离线数据需要同步到服务器
 */
- (BOOL)checkNeedSyncData;
/**
 *  离线数据同步到服务器, 返回值为BOOL值存放在NSNumber对象中
 */
- (NSNumber *)syncOfflineRecordToRemote;
/**
 *  同步指定时间到现在的数据到本地
 */
- (NSDictionary *)syncServerRecordFromDate:(NSDate *)date;
/**
 *  同步本地离线数据到服务器，再拉取从date至今为止的所有数据
 */
- (NSNumber *)syncRecordData;

/// 下载所有记录，5.0方案数据处理用
- (BOOL)downloadAllRecords;
/**
 *  是否需要更新页面
 */
+ (BOOL)isNeedUpdate;
/**
 *  设置是否需要更新页面
 */
+ (void)setNeedUpdate:(BOOL)need;
/**
 *  获取今天以前的一条数据。如果昨天有数据，返回昨天的数据，如果昨天没有则返回离昨天最近的一条数据
 */
- (float)getReciprocalSec;
/**
 *  历程界面是否提示
 */
+ (BOOL)needShowTipsInHPVC;
/**
 *  设置历程界面是否提示
 */
+ (void)setNeedShowTipsInHPVC:(BOOL)need;
/**
 *  设置最后记录同步时间
 */
+ (void)setRecordSyncDate:(NSDate *)date;
/**
 *  获取最后记录同步时间
 */
+ (NSDate *)getRecordSyncDate;
/**
 *  同步试用用户信息(4.0版本及以下无此需求)
 */
- (BOOL)syncTrialUserData __deprecated_msg("4.0及以下版本暂无此需求");
/**
 *  删除使用用户记录信息
 */
- (BOOL)deleteTrialUserData;

///**
// *  判断是否显示数据中心小红点
// *
// *  @return 
// */
//- (BOOL)isShowDataCenterRedDot;
//
///**
// *  设置数据中心小红点
// */
//- (void)setDataCenterRedDot:(BOOL) flag;


#pragma mark - 其他处理
#pragma mark -

+ (void)showLoginVCWithTarget:(id)target
               needBackButton:(BOOL)needBackButton
                andIfNeedBack:(BOOL)back
            andSucessCallBack:(void (^)())success
              andFailCallBack:(void (^)(BOOL userCancel))fail __deprecated_msg("deprecated in version 5.0");

- (void)deleteHabitRecord:(XKRWRecordEntity4_0 *)entity;


@end
