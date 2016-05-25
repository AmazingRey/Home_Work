//
//  XKRWUserService.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-27.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWBaseService.h"
#import "XKRWUserInfoEntity.h"
#import "XKRWEnumDefine.h"

@class XKRWUserInfoShowEntity ;

typedef NS_ENUM(NSInteger, UserFlag) {
    
    UserFlagTransferSchemeData = 1
};

typedef NS_ENUM(NSInteger, XKRWExpType) {
    XKRWExpTypeProgress = 1
};


@interface XKRWUserService : XKRWBaseService

//单例

+(instancetype)sharedService;

@property (nonatomic, strong) NSMutableArray  * currentGroups; ///< 当前所有加入的小组

@property (nonatomic, strong) XKRWUserInfoEntity* currentUser;

@property (nonatomic, assign) BOOL addActivitiesGroupDefualt;

#pragma mark 网络任务

//远程服务器获得体重曲线四个值
//- (void) downloadWeightCurveData;

/*获取用户全部资料包括userinfo，plan，QA*/
-(void)getUserAllInfoFromRemoteServerByToken:(NSString *)token;

/*从服务器获取用户资料*/
//-(void)getUserInfoFromRemoteServerByToken:(NSString *)token;

/*提交本地用户资料到远程服务器*/
-(void)uploadUserInfoToRemoteServerByToken:(NSString *)token;
//-(void)uploadUserInfoToRemoteServerNeedLong:(BOOL)need ByToken:(NSString *)token;
/*更改密码*/
-(void)uploadUserPWDWithOldP:(NSString *)old andNP:(NSString *) newP;

/*修改用户的昵称和头像*/
//-(void)uploadUserNicknameByToken:(NSString *)token;

/*从远程服务器取得用户plan*/
//-(void)getUserPlanFromRemoteServerByToken:(NSString *)token;

///*提交本地用户资料到远程服务器*/
//-(void)uploadUserPlanToRemoteServerByToken:(NSString *)token;
//签名
//- (void) uploadUserManifestoToRemote:(NSString *) manifesto;
- (void) setManifesto:(NSString * )manifesto;
- (NSString *) getUserManifesto;

/*
 *  5.0 new
 */

- (BOOL)getUserFlagWithType:(UserFlag)flag;


#pragma mark 本地任务

/*
 *  4.1 new interface
 */
//- (void)saveNewToken:(NSString *)new_token;
//- (NSString *)getNewToken;

/****************************************/

-(void) setUserCity:(NSString *)city;
-(NSString * ) getUserProvince;
-(NSString * ) getUserCity;
-(NSString * ) getUserDistrict;
-(NSString *)getCityAreaString;


//已坚持天数
-(void) getSignInDays;
-(void) setInsisted:(NSInteger)days;
-(NSInteger) getInsisted;

//签到表远程获取
-(void) getIntitleLogsFromRemote;
//本地
- (NSArray  *) getIntitleLocal;
//用户注册时间
- (NSString *) getREGDate;
//签到上线时间
- (NSString *) getPlanDate;

//重置 方案时间
- (NSNumber*)getResetTime;
-(void)setResetTime:(NSNumber*)timestamp;



//更新难度可选项数量
-(void)updatePlanCount;
//检查 生日 身高 体重
-(BOOL)checkComplete;
//获得当前用户token
-(NSString *)getToken;
//设置当前用户token
-(void)setToken:(NSString *)token;
//设置userid
-(void)setUserId:(NSInteger)userid;
//获取UserId
-(NSInteger)getUserId;
//更新时间
-(NSInteger) getUserUpdateDate;
//设置用户瘦瘦号
-(void)setUserSlimId:(NSInteger)slimid;
//获取用户瘦瘦号
-(NSInteger)getUserSlimId;
//设置用户accountName
-(void)setUserAccountName:(NSString *)account;
//获取用户accountName
-(NSString *)getUserAccountName;
//设置用户昵称
-(void)setUserNickName:(NSString *)nickname;
//获取用户昵称
-(NSString *)getUserNickName;
//设置用户昵称是否可用
- (void)setUserNickNameIsEnable:(NSInteger ) enable;
//获取用户昵称是否可用
- (BOOL)getUserNickNameIsEnable;
//设置性别
-(void)setSex:(XKSex)sex;
//读取当前用户性别
-(XKSex)getSex;
//获取性别文字
-(NSString *)getSexDescription;
//设置用户身高
-(void)setUserHeight:(NSInteger)height;
//获取用户身高
-(NSInteger)getUserHeight;
//设置出生日期(时间戳)
-(void)setBirthday:(NSInteger)birthday;
//获得当前用户出生日期(时间戳)
-(NSInteger)getBirthday;
//获取生日文字
-(NSString *)getBirthdayString;

//获得当前用户年龄
-(NSInteger)getAge;
//设置当前用户身高(cm)
-(void)setStature:(NSInteger)stature;
//获得当前用户身高(cm)
-(NSInteger)getStature;
//设置当前用户体重(g)
-(void)setCurrentWeight:(NSInteger)weight;
//获得当前用户体重(g)
//-(NSInteger)getCurrentWeight;
//设置用户类别
-(void)setUserGroup:(XKGroup)group;
//获得用户类别
-(XKGroup)getUserGroup;
//用户类型描述
-(NSString *) getUserGroupDescription;

//设置用户腰围
-(void)setUserWaistline:(NSInteger)waistline;
//获得用户腰围
-(NSInteger)getUserWaistline;
//设置用户臀围
-(void)setUserHipline:(NSInteger)hipline;
//获取用户臀围
-(NSInteger)getUserHipline;
//设置用户头像
-(void)setUserAvatar:(UIImage *)avator;

//设置年龄
-(void)setAge;
/**
 *  设置用户背景图片
 *
 *  @param image <#image description#>
 */
- (void)setUserBackgroundImageView:(UIImage *)image;
/**
 * 设置用户背景图片 通过Url设置
 *
 *  @param getUserBackgroundImage <#getUserBackgroundImage description#>
 */
- (void)setUserBackgroundImageViewWithUrl:(NSString *)url;

/**
 *  获取用户背景图片
 *
 *  @return <#return value description#>
 */
- (NSString *)getUserBackgroundImage;
/**设置用户头像url*/
-(void)setUserAvatarURL:(NSString *)url;

/**获取用户头像*/
-(NSString *)getUserAvatar;

/**设置用户日常体力活动类型*/
-(void)setUserLabor:(XKPhysicalLabor)labor;

/**获取用户日常体力活动类型*/
-(XKPhysicalLabor)getUserLabor;

/**活动类型描述*/
-(NSString * )getUserLaborDescription;

/**设置用户疾病情况*/
-(void)setUserDisease:(NSArray *)array;

/**获取用户疾病情况*/
-(NSArray *)getUserDisease;

/**设置用户的瘦身部位(待定)*/
- (void)setUserSlimParts:(NSString *)array;

/**获取用户的瘦身部位（待定）*/
- (NSString *)getUserSlimParts;

- (void)setUserSlimPartsWithStringArray:(NSArray *)array;
/**
 *  获取用户减肥部位的数组，手臂=1、腰腹=2、臀部=3、大腿=4、小腿=5. 胸部=6
 */
- (NSArray *)getUserSlimPartsArray;

/**疾病史描述*/
-(NSString *)getUserDiseaseDecription;

/**打印当前用户信息*/
-(void)printCurrentUserInfo;

/**保存当前用户信息*/
-(void)saveUserInfo;

//获取当前用户信息
//-(void)getUserInfoByUserId:(NSInteger)userid;

- (void) getUserInfoByUserAccount:(NSString *)userAccount;

/**体重描述*/
-(NSString *)getWeightDescription;

/**腰臀比描述*/
-(NSString *)getWHRDescription;

/**获取体重变化*/
-(float) getWeightChange;

/*用户plan*/
-(XKDifficultyKindCount)getDiffCount;


/**设置用户目标体重*/
-(void)setUserDestiWeight:(NSInteger)weight;

/**获取用户目标体重*/
-(NSInteger)getUserDestiWeight;

-(BOOL) destiWightLower;

/**设置用户初始体重*/
-(void)setUserOrigWeight:(NSInteger)weight;

/**获取用户初始体重*/
-(NSInteger)getUserOrigWeight;

/**设置用户减肥时间*/
-(void)setUserPlanDuration:(NSInteger)duration;

/**获取用户减肥时间*/
-(NSInteger)getUserPlanDuration;

/**设置用户方案难度*/
-(void)setUserPlanDifficulty:(XKDifficulty)difficulty;

/**获取用户方案难度*/
-(XKDifficulty)getUserPlanDifficulty;

/**获取方案难度文字*/
-(NSString *)getUserPlanDifficultyDescription;

/**设置用户减肥目的*/
-(void)setUserReducePart:(XKReducePart)reducePart;

/**获取用户减肥目的*/
-(XKReducePart)getUserReducePart;

/**设置用户减肥位置*/
-(void)setUserReducePosition:(XKReducePosition)position;

/**获取用户减肥位置*/
-(XKReducePosition)getUserReducePosition;//XKReducePosition


/**设置用户星星数量*/
-(void)setUserStarNum:(NSInteger)num;

/**获取用户星星数量*/
-(NSInteger)getUserStarNum;

//设置体重曲线四个值
- (void)setUserWeightCurve:(NSDictionary *)dic;

/**获取体重曲线四个值*/
- (NSDictionary *)getUserWeightCurve;

/**保存体重曲线四个值*/
- (void)saveUserWeightCurveData;

/**获取体重曲线四个值*/
- (void)getUserWeightCurveData;


//退出登录
-(void) logout;

/*
 * 检查是否需要同步数据
 * return {"sync_item":[@"weight",@"diy_recipe",@"record",@"forecast"],"count":4}
 */
- (BOOL) checkSyncData;


//获取用户减肥飞部位的字符串；（待定）
-(NSString*)getSlimPartsString;
//清除掉用户所有的数据
//-(void)resetUserAllInfomationByToken;
-(NSString*)getResetToken;
-(void)setUserResrtToken:(NSString*)token;

//获取用户的每周减重的kg数
-(CGFloat)getweeklyReduceWeight;

//清掉用户所有数据  重置方案  只保留用户名 密码
-(NSDictionary*)resetUserAllDataByToken;

//清空数据 除了accout表  和几张固定的 表
-(void)deleteDBDataByUser;

#pragma --mark  5.0
/**
 *  检查用户信息的完整性
 *
 *  @return <#return value description#>
 */
- (BOOL)checkUserInfoIsComplete;


/**
 *  设置默认的方案难度
 */
- (void) defaultSetPlanCount;


/**
 *  保存用户信息到服务器
 *
 *  @param userInfo 用户信息
 *
 *  @return 返回保存结果
 */
- (NSDictionary *) saveUserInfoToRemoteServer:(NSDictionary *)userInfo;

/**
 *  修改用户信息
 *
 *  @param info     修改为...
 *  @param InfoType 所修改用户信息的字段
 *
 *  @return 返回修改结果
 */
- (NSDictionary *)changeUserInfo:(id)info WithType:(NSString *)InfoType;

/**获取疾病类型*/
-(NSString *)getDiseaseString;


/**设置是否是第三方登录*/
- (void) setThirdPartyLogin;

/**获取是否是第三方登录*/
- (BOOL) getThirdPartyLogin;

/**
 *  <#Description#>
 *
 *  @param age  年龄
 *  @param sex  性别
 *  @param type BMI类型
 *
 *  @return 获得用户BMI
 */
- (CGFloat) getBMIFromAge:(NSInteger)age andSex:(XKSex)sex andBMItype:(BMIType)type;

/**
 *  判断是否需要换方案，在体重、活动力水平等参数变化之后
 */
- (BOOL)isNeedChangeScheme:(float)originalDailyIntake AndNowDailyIntake:(float)nowDailyIntake;

/**
 *  因5.0版本后，2014年6月25日以前注册的用户的天数会多出很多，因此要给提示
 */
- (BOOL)isNeedNoticeTheChangeOfInsistDays;


#pragma mark - 5.0.1 new

- (void)setShouldShowTips:(BOOL)yesOrNo inVC:(UIViewController *)vc withFlag:(int)flag;
/**
 *  返回是否该在vc页显示tip，flag为一页内多提示时的区分
 *
 *  @param vc   要显示tips的vc
 *  @param flag 区分多个tips的标识
 *
 *  @return 是否显示
 */
- (BOOL)shouldShowTipsInVC:(UIViewController *)vc withFlag:(int)flag;

#pragma mark - 5.1.0

/**
 *  检查用户昵称是否合格
 *
 *  @return  yes/合格   no/不合格
 */
- (BOOL)checkUserNickNameIsQualified;

/**
 *  获取用户点赞与被赞信息
 *
 *  @return
 */
- (NSDictionary *)getUserThumpUpAndBeParisedInfomation;
/**
 *  获取用户荣誉数据
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)getUserHonorData;

/**
 *  获取所有的荣誉等级信息
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)getHonorSystemInfo;

/**
 *  获取被赞内容
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)getBePraisedInfoAndpageTime:(NSInteger)time andSize:(NSInteger)size;


/**
 *  获取其他人喜欢或者发表的文章列表
 *
 *  @param nickName 昵称
 *  @param type     喜欢/发表
 *
 *  @return <#return value description#>
 */

- (NSDictionary *)getUserShareOrLikeInfoFrom:(NSString *)nickName andInfoType:(XKRWArticleType )type andpageTime:(NSInteger)time andSize:(NSInteger)size  andPage:(NSInteger)page;


/**
 *  获取其他人的信息
 *
 *  @param nickname <#nickname description#>
 *
 *  @return <#return value description#>
 */
- (XKRWUserInfoShowEntity *)getOtherUserInfoFromUserNickname:(NSString *)nickname;
/**
 *  根据ExpType获取经验值
 *
 *  @param type 经验值类型
 *
 *  @return 服务器返回的字典
 */
- (NSDictionary *)addExpWithType:(XKRWExpType)type;

/**
 *  获取推荐APP信息
 *
 *  @return 返回推荐App信息
 */
- (NSArray *)getAppRecommendInfo;

- (NSDictionary *)setSchemeStartData;

/**
 *  获取餐次比例
 *
 *  @return 返回餐次比例详情
 */
- (NSDictionary *)getMealRatio;

/**
 *  保存餐次比例到服务器 保存成功返回YES  失败 NO
 *
 *  @param breakfast 早餐百分比
 *  @param lunch     午餐百分比
 *  @param snack     加餐百分比
 *  @param supper    晚餐百分比
 *
 *  @return 保存成功返回YES  失败 NO
 */
- (BOOL) saveMealRatioWithBreakfast:(NSInteger)breakfast andLunch:(NSInteger)lunch andSnack:(NSInteger)snack andSupper:(NSInteger) supper;


@end
