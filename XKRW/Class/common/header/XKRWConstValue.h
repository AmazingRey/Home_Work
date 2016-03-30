//
//  XKRWConstValue.h
//  XKRW
//
//  Created by Jiang Rui on 13-12-17.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDefaultBackgroundColor;
//默认字体
extern NSString *const kDefaultFont;

//评分提醒
extern NSString * const kScoreReminder;
//闹钟
extern NSString * const kAlarmNotification;
extern NSString * const kAlarmNotificationSecheme;
extern NSString * const kAlarmNotificationHome ;
extern NSString * const kAlarmNotificationRecord;
/* 闹钟更新时间 */
extern NSString * const kAlarmUpDateTimeRecord;


/*接口URL*/
extern NSString *const kUserName;
extern NSString *const kPassword;
//extern NSString *const kServer;
extern NSString *const kAlarms ;
extern NSString *const kSignIn ;
extern NSString *const kGetAlarms ;
extern NSString *const kLoginURL;
extern NSString *const kHomeAd;
extern NSString *const kRegisterURL;
extern NSString *const kGetUserInfo;
extern NSString *const kGetUserAllInfo;
extern NSString *const kUploadUserInfo;
extern NSString *const kUploadUserHeader;
extern NSString *const kGetUserPlan;
extern NSString *const kUploadUserPlan;
extern NSString *const kGetUserWeightRecord;
extern NSString *const kUploadUserWeightRecord;
extern NSString *const kDeleteUserWeightRecord;
extern NSString *const kGetUserWeightCurve;
extern NSString *const kUploadQuestioinAnswer;
extern NSString *const kGetQuestionAnswer;
extern NSString *const kGetRecommendApps;
extern NSString *const kIncreaseAppDowloadTimes;
extern NSString *const kManagementInfoURL;
extern NSString *const kManagementArticleURL; //5.0新增  当天文章
extern NSString *const kManagementMoreArticleURL; //5.0新增 更多文章
extern NSString *const kGetTogetherPKDetailURL;  //5.0新增 获取PK详情
extern NSString *const kGetPKVoteURL; //5.0新增 获取用户正反方投票
extern NSString *const kUploadNicknameAndAvatar;
extern NSString *const kGetUserStarNum;
extern NSString *const kUploadCompleteTask;
extern NSString *const kGetManagementHistory;
extern NSString *const kGetManagementInfoByNid;
extern NSString *const kPKVote;
extern NSString *const kPVStatistics;
extern NSString *const kUploadUser;
extern NSString *const kLocation;
extern NSString *const kGetLocation;
extern NSString *const kGetIntitle;
extern NSString *const kUpdateFromV2;
extern NSString *const kSaveUserManifesto;

extern NSString *const KManagementAdInfo; //广告
extern NSString *const KManagementContact;

extern NSString *const kImportantNotice;

extern NSString *const KResetUserData;
/**
 *  5.2 blog New
 */

extern NSString *const kGetBlogRank;

/**
 *  5.1 discover New
 */
extern NSString *const kGetFitnessShareAdver;
extern NSString *const kGetBlogRecommendArticle;
extern NSString *const kGetBlogMoreArticle;
extern NSString *const kDelComment;
extern NSString *const kAddComment;
extern NSString *const kGetComment;
extern NSString *const kGetNotice;

#pragma --mark 5.2 Discover 新接口
extern NSString *const kGetUserJoinTeam;
extern NSString *const kGetDiscoverOperationState ;
extern NSString *const kGetOperationTypeData ;
/*
 *  4.1 new
 */
extern NSString *const kGetProductList;
extern NSString *const kGetOrderInfo;
extern NSString *const kUploadExchangeCode;
extern NSString *const kGetExchangeWays;
extern NSString *const kExchange;
extern NSString *const kiSlimChances;

extern NSString *const kGetInsistDays;
extern NSString *const kJoinFreeExchange;

extern NSString *const kNewServer;
extern NSString *const kTestServer;

extern NSString *const kNoticeServer;

extern NSString *const kGetReport;
extern NSString *const kUploadAnswers;
extern NSString *const kISlimAdds;
/*
 *  4.2 new
 */
extern NSString *const kSaveUserCollection;
extern NSString *const kGetUserCollection;
/*收藏的同步时间戳*/
extern NSString *const kCollectionUpdateTime;


#pragma mark - 5.0 new

extern NSString *const kGetMealScheme;
extern NSString *const kGetMealSchemeByIds;
extern NSString *const kGetBanFoods;
extern NSString *const kGetSportScheme;

extern NSString *const kGetShareCourse;
extern NSString *const kSearchURL;

extern NSString *const v5_registerUrl ;
extern NSString *const v5_getAllUserInfoUrl;
extern NSString *const v5_setAllUserInfoUrl;
extern NSString *const v5_setUserAvatar;    //保存用户头像

extern NSString *const v5_changPWD ;//修改用户密码

extern NSString *const v5_KResetUserData;
extern  NSString *const kXKUserAccount;
#pragma mark -
/*用户注册进度*/
//未填写个人资料
extern NSString *const kStepUnCompleteInfo;
//通过登录页面
extern NSString *const kStepLogin;
//填写个人计划
extern NSString *const kStepUnCompletePlan;
//已经完成流程进入主页
extern NSString *const kStepComplete;

//是初次打开APP
extern  NSString* const isForTheFirstOpen;
//不是初次打开APP
extern  NSString* const notForTheFirstOpen;


/*更新时间的key*/
//DIY食谱更新时间key
extern NSString *const kDIYDietUpdateTime;
/*记录的同步时间戳*/
extern NSString *const kRecordUpdateTime ;
/*预测的同步时间戳*/
extern NSString *const kForecastUpdateTime;
/*餐次key*/
//早餐
extern NSString *const kBreakfast;
/*午餐*/
extern NSString *const kLunch;
/*加餐*/
extern NSString *const kSnack;
/*晚餐*/
extern NSString *const kDinner;

extern NSString *const kCacheKeyOfSport;
extern NSString *const kCacheKeyOfFood;
/*默认提醒初始化数据*/
extern NSString *const kAlarmMsgFile;
/*体重记录参考*/
extern NSString *const kWeightHint;
/*当天第一次打开应用的key*/
extern NSString *const kFirstOpenToday;
/*第一次打开应用*/
extern NSString *const kFirstOpenApp;

/*网络请求参数*/
extern float  const  requestTimeOut;
/*
  提示信息
 */
//加载中
extern NSString *const kLoading; //正在加载
extern NSString *const kSearching;//正在搜索
extern NSString *const kSearchFaild;//搜索失败
extern NSString *const kSearchNoData;//搜索无结果
extern NSString *const kSaving;//正在保存中
extern NSString *const kSaveFaild;//搜索失败
extern NSString *const kNetWorkDisable;

extern NSString *const kIsScaleSync;
/*腰臀比阀值*/
extern float const kWHROfMale;//男性腰臀比
extern float const kWHROfFemale;//女性腰臀比

/*科大讯飞相关*/
extern NSString *const kIFlyAppId;
extern NSString *const kIFlyEngineUrl;

/*友盟*/
extern NSString *const kYMAppKey;
//extern NSString *const k

/**
 *  提醒新接口
 */
extern NSString *const kAddNewAlarm;
extern NSString *const kSaveAlarm;
extern NSString *const kDeleteAlarm;
extern NSString *const kGetAllAlarm;
extern NSString *const kCloseOrStartAlarm;

/**
 *  营养值
 */
extern NSString *const kCaloric;
extern NSString *const kCarbohydrate;
extern NSString *const kFat;
extern NSString *const kProtein;
extern NSString *const kCellulose;

extern NSString *const kVitaminA;
extern NSString *const kVitaminC;
extern NSString *const kVitaminE;
extern NSString *const kCarotene;
extern NSString *const kThiamine;

extern NSString *const kRiboflavin;
extern NSString *const kNiacin;
extern NSString *const kCholesterol;
extern NSString *const kMa;
extern NSString *const kCa;

extern NSString *const kFe;
extern NSString *const kZn;
extern NSString *const kCu;
extern NSString *const kMn;
extern NSString *const kKalium;

extern NSString *const kP;
extern NSString *const kNa;
extern NSString *const kSe;

extern NSString *const kSchemeUpdate;
extern NSString *const kMealScale;







/**
 *  小组相关接口
 */
extern NSString *const XKRWAllGroup;        ///<   小组列表

extern NSString *const XKRWAllCGroup;       ///<   小组列表 分权重

extern NSString *const XKRWGroupAdd;        ///<   小组加入
extern NSString *const XKRWGroupAddMulti;   ///<   批量加入小组
extern NSString *const XKRWGroupRemove;     ///<   小组退出

extern NSString *const XKRWPostlist;        ///<   帖子列表
extern NSString *const XKRWPostMy;          ///<   查看自己或他人的帖子
extern NSString *const XKRWReplyMy;         ///<   查看自己回复的贴子

extern NSString *const XKRWUserGroups;      ///<   用户小组列表
extern NSString *const XKRWActivitiesGroups;///<   活跃小组列表
extern NSString *const XKRWGroupDetail;     ///<   小组详情
extern NSString *const XKRWGroupIdentify;   ///<   小组权限检验
extern NSString *const XKRWGroupHasRecord;  ///<   检验用户是否已经加入小组


