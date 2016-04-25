//
//  XKRWConstValue.m
//  XKRW
//
//  Created by Jiang Rui on 13-12-17.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import "XKRWConstValue.h"

NSString *const kDefaultBackgroundColor = @"#ECECEC";

NSString *const kDefaultFont = @"Heiti SC";


NSString * const kScoreReminder = @"kScoreReminder";
//登陆step
//登陆未填写个人资料
NSString *const kStepUnCompleteInfo = @"STEP_UNCOMPLETEINFO";
NSString *const kXKUserAccount = @"UserAccount";
//通过登录页面
NSString *const kStepLogin = @"STEP_LOGIN";
//设置未完成
NSString *const kStepUnCompletePlan = @"STEP_UNCOMPLETEPLAN";
//已经完成流程进入主页
NSString *const kStepComplete = @"STEP_ALL_COMPLETE";
//是初次打开APP
NSString* const isForTheFirstOpen=@"isForTheFirstOpen";
//不是初次打开APP
NSString* const notForTheFirstOpen=@"notForTheFirstOpen";

//闹钟关键字定义
NSString * const kAlarmNotification        = @"AlarmMessages";
NSString * const kAlarmNotificationSecheme = @"AlarmMessagesSecheme";
NSString * const kAlarmNotificationHome    = @"AlarmMessagesHome";
NSString * const kAlarmNotificationRecord  = @"AlarmMessagesRecord";

/* 闹钟更新时间 */
NSString * const kAlarmUpDateTimeRecord = @"AlarmUpDateTimeRecord";


NSString *const kBreakfast       = @"breakfast";
NSString *const kLunch           = @"lunch";
NSString *const kSnack           = @"snack";
NSString *const kDinner          = @"dinner";
NSString *const kCacheKeyOfSport = @"sport_cache";
NSString *const kCacheKeyOfFood  = @"food_cache";
NSString *const kAlarmMsgFile    = @"newAlertMsgFor4_0";
NSString *const kWeightHint      = @"weightHint";
NSString *const kFirstOpenToday  = @"fristOpenToday";
NSString *const kUpdateFromV2    = @"kUpdateFromV2";
NSString *const kFirstOpenApp     = @"firstOpenApp";

NSString *const kUserName = @"XKRWUser";

NSString *const kPassword = @"450a91a2d08bcbb7d9ce6b21af2f73e5";

NSString *const kAlarms = @"/otherapi/saveAlert/";

NSString *const kGetAlarms = @"/otherapi/alerts/";

NSString *const kAddNewAlarm = @"/v2/otherapi/save_alert/";
NSString *const kSaveAlarm = @"/alert/set/";//@"/v2/otherapi/update_alert";
NSString *const kDeleteAlarm = @"/alert/del/";//@"/v2/otherapi/delete_alert";
NSString *const kGetAllAlarm = @"/alert/get/";    //@"/v2/otherapi/listAllAlert";
NSString *const kCloseOrStartAlarm = @"/alert/all/";

NSString *const kSignIn =  @"/calendar/daily/"; ///v2/userapi/signInUserDay
NSString *const kLoginURL = @"/userapi/login/";

//NSString *const kHomeAd = @"/otherapi/getIndexpic";
NSString *const kHomeAd = @"/index/pic/";

NSString *const kRegisterURL = @"/userapi/regist/";

NSString *const kGetUserInfo = @"/userapi/getUserinfo/";

NSString *const kGetUserAllInfo = @"/v2/userapi/getUserinfoPlanQa/";

NSString *const kUploadUserInfo = @"/userapi/saveUserinfo/";

NSString *const kUploadUserHeader = @"/userapi/uploadAvatar/";

NSString *const kGetUserPlan = @"/v2/userapi/getUserPlan/";

NSString *const kUploadUserPlan = @"/v2/userapi/saveUserPlan/";

NSString *const kUploadUser = @"/v2/userapi/saveUserinfoPlanQa/";

//NSString *const kGetUserWeightRecord = @"/weightapi/weights";
//NSString *const kUploadUserWeightRecord = @"/weightapi/saveWeight";

NSString *const kGetUserWeightRecord = @"/weightapi/monthWeights/";

NSString *const kUploadUserWeightRecord = @"/weightapi/saveWeight/";


NSString *const kDeleteUserWeightRecord = @"/weightapi/delWeight/";

NSString *const kGetUserWeightCurve = @"/otherapi/weightCurve/";

NSString *const kUploadQuestioinAnswer = @"/userapi/saveUserQA/";

NSString *const kGetQuestionAnswer = @"/userapi/getQA/";

NSString *const kGetRecommendApps = @"/messageapi/getNewCooperation/";

NSString *const kIncreaseAppDowloadTimes = @"/otherapi/increaseAppDowloadTimes/";

NSString *const kManagementInfoURL = @"/v2/otherapi/yunying/";

NSString *const kManagementArticleURL = @"/article/index/";  //获取当天运营文章

NSString *const kManagementMoreArticleURL = @"/article/more/";  //获取更多文章

NSString *const kGetTogetherPKDetailURL = @"/article/node/";  //获取PK详情

NSString *const kGetPKVoteURL = @"pk/node/";//获取用户正反方投票

NSString *const KManagementAdInfo =@"/index/adver/";

NSString *const kAdInfo_5_2 = @"/index/commerce/"; //5.2 焦点图、公告

NSString *const KManagementContact = @"/index/about/";

NSString *const KResetUserData  = @"v2/otherapi/reset/";

NSString *const kUploadNicknameAndAvatar = @"/userapi/setAvatarNickname/";

NSString *const kGetUserStarNum = @"/star/get/"; //@"/otherapi/selectStar";

NSString *const kUploadCompleteTask = @"star/set/"; //@"/otherapi/saveStars";//

NSString *const kGetManagementHistory = @"/otherapi/yunyingMore/";

NSString *const kGetManagementInfoByNid = @"/otherapi/getYunying/";

NSString *const kPKVote = @"/pk/node/";

NSString *const kPVStatistics = @"/otherapi/statistics/";

NSString *const kSaveUserManifesto = @"otherapi/SaveUserManifesto/";

NSString *const kLocation = @"/userapi/savaAddress/";

NSString *const kGetLocation = @"";

NSString *const kGetIntitle = @"/userapi/getsignInList/";

NSString *const kImportantNotice = @"/index/notification/";

#pragma mark - 5.0 new interface

NSString *const kGetMealScheme = @"/foods/get/";
NSString *const kGetBanFoods = @"/foods/banfoods/";
NSString *const kGetSportScheme = @"/scheme/sport/";
NSString *const kGetMealSchemeByIds = @"/foods/cookbook/";
//历程分享
NSString *const kGetShareCourse = @"/article/slogan/";
NSString *const kSearchURL = @"/content/mixSearch/";

#pragma mark -

#if DEBUG

//NSString *const kNewServer = @"http://115.29.175.210:8009/"; //测试服务器地址

//NSString *const kNewServer = @"http://112.124.53.222/";
NSString *const kNewServer = @"http://115.29.205.235/";

#else

NSString *const kNewServer = @"http://115.29.205.235/";
#endif

NSString *const kNoticeServer = @"http://203.195.248.43/";
/**
 *  5.2
 */
NSString *const kGetBlogRank = @"blog/rank/";

/**
 *  5.1
 */
NSString *const kGetBlogRecommendArticle = @"blog/recommend/";
NSString *const kGetBlogMoreArticle = @"blog/more/";
NSString *const kDelComment = @"comment/del/";
NSString *const kAddComment = @"comment/add/";
NSString *const kGetComment = @"comment/gets/";
NSString *const kGetNotice = @"app/message";

#pragma --mark 5.2 Discover 新接口
NSString *const kGetUserJoinTeam = @"/group/usergroups/";

NSString *const kGetDiscoverOperationState = @"/user-article/index";
NSString *const kGetOperationTypeData = @"/user-article/more";

/*
 *  4.1 new interface
 */
NSString *const kGetProductList = @"/index/product/";
NSString *const kGetOrderInfo = @"/pay/service/";

NSString *const kUploadExchangeCode = @"/exchange/doexchange/";
NSString *const kGetExchangeWays = @"/exchange/introduction/";
NSString *const kExchange = @"/exchange/achieveV5/";
NSString *const kGetInsistDays = @"/exchange/getDaysV5/";
NSString *const kJoinFreeExchange = @"/exchange/startCdKeyAct/";

NSString *const kiSlimChances = @"/evaluate/getTimes/";
NSString *const kUploadAnswers = @"/evaluate/report/";
NSString *const kGetReport = @"/evaluate/getReport/";

NSString *const kISlimAdds = @"/index/service/";

/*
 *  4.2 new Collection
 */
NSString *const kSaveUserCollection = @"favorite/set/";
NSString *const kGetUserCollection = @"favorite/get/";
NSString *const kCollectionUpdateTime = @"";

#pragma mark - 5.0版本URL

/**************************************************************/
NSString *const v5_registerUrl = @"/auth/SDKSMSRegist1/";
NSString *const v5_getAllUserInfoUrl = @"/user/get/";
NSString *const v5_setAllUserInfoUrl = @"/user/set/";

NSString *const v5_setUserAvatar = @"/user/avatarhd/";

NSString *const v5_changPWD = @"/user/password/";
NSString *const v5_KResetUserData =@"/calendar/newReset/";

/*************************************************************
 */
/*HUD 提示*/
NSString *const kLoading = @"数据加载中...";
NSString *const kSearching = @"正在搜索中...";
NSString *const kSearchFaild = @"搜索失败，请稍后再试";

NSString *const kSearchNoData = @"无搜索结果";
NSString *const kSaving = @"保存中...";
NSString *const kSaveFaild = @"保存失败，请重试";
NSString *const kNetWorkDisable = @"没有网络，请检查网络设置";

/*DIY食谱的同步时间戳*/
NSString *const kDIYDietUpdateTime = @"diyDietUpdateTime";
/*记录的同步时间戳*/
NSString *const kRecordUpdateTime = @"recordUpdateTime";

/*预测的同步时间戳*/
NSString *const kForecastUpdateTime = @"forecastUpdateTime";

NSString *const kIsScaleSync = @"kIsScaleSync";
float  const  requestTimeOut = 15.f;
/*男性腰臀比*/
float const kWHROfMale = 0.9;
/*女性腰臀比*/
float const kWHROfFemale = 0.8;

/*科大讯飞*/
NSString *const kIFlyAppId = @"512435af";
NSString *const kIFlyEngineUrl = @"http://dev.voicecloud.cn/index.htm" ;
/*友盟*/
NSString *const kYMAppKey = @"5109fd2552701553b3000029";

/**
 *  营养key值
 */
NSString *const kCaloric = @"热量(大卡)";
NSString *const kCarbohydrate = @"碳水化合物(克)";
NSString *const kFat = @"脂肪(克)";
NSString *const kProtein = @"蛋白质(克)";
NSString *const kCellulose = @"纤维素(克)";

NSString *const kVitaminA = @"维生素A(微克)";
NSString *const kVitaminC = @"维生素C(毫克)";
NSString *const kVitaminE = @"维生素E(毫克)";
NSString *const kCarotene = @"胡萝卜素(微克)";
NSString *const kThiamine = @"硫胺素(毫克)";

NSString *const kRiboflavin = @"核黄素(毫克)";
NSString *const kNiacin = @"烟酸(毫克)";
NSString *const kCholesterol = @"胆固醇(毫克)";
NSString *const kMa = @"镁(毫克)";
NSString *const kCa = @"钙(毫克)";

NSString *const kFe = @"铁(毫克)";
NSString *const kZn = @"锌(毫克)";
NSString *const kCu = @"铜(毫克)";
NSString *const kMn = @"锰(毫克)";
NSString *const kKalium = @"钾(毫克)";

NSString *const kP = @"磷(毫克)";
NSString *const kNa = @"钠(毫克)";
NSString *const kSe = @"硒(微克)";

NSString *const kSchemeUpdate = @"scheme_update";
NSString *const kMealScale = @"mealScale";


/**
 *  小组
 */
NSString *const XKRWAllGroup = @"/group/list/";         ///<   小组列表

NSString *const XKRWAllCGroup = @"/group/clist/";        ///<   小组列表 分权重

NSString *const XKRWGroupAdd = @"/group/add/";          ///<   加入小组
NSString *const XKRWGroupAddMulti = @"/group/multi/";   ///<   批量加入小组
NSString *const XKRWGroupRemove = @"/group/remove/";    ///<   退出小组

NSString *const XKRWPostlist = @"/post/list/";          ///<   帖子列表
NSString *const XKRWPostMy = @"/post/my/";              ///<   查看自己或他人的帖子
NSString *const XKRWReplyMy = @"/post/cmtpostlist/";    ///<   查看自己回复的贴子

NSString *const XKRWUserGroups = @"/group/usergroups/"; ///<   用户小组列表
NSString *const XKRWActivitiesGroups = @"/group/activities/"; ///<   活跃小组列表
NSString *const XKRWGroupDetail = @"/group/detail/";    ///<   小组详情
NSString *const XKRWGroupIdentify = @"/group/identify/";///<   小组权限检验
NSString *const XKRWGroupHasRecord=@"/group/hasrecord/";///<   检验用户是否已经加入小组





