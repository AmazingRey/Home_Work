//
//  XKRWRequestConstValue.m
//  XKRW
//
//  Created by zhanaofan on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRequestConstValue.h"

/*方案相关请求*/
NSString *const kSchemeUrl = @"schemeapi/getScheme";
NSString *const kschemeRoundFoodUrl = @"schemeapi/get_rand_foodfangan";
/*小贴士相关请求*/
NSString *const kGetTipUrl = @"otherapi/tips";
NSString *const kGetSportDetailUrl = @"sportapi/getSport";
/*远程保存DIY食谱*/
NSString *const kSaveSchemeUrl = @"schemeapi/diySaveScheme";
/*远程删除DIY食谱中的一项*/

NSString *const kDeleteDIYSchemeFoodUrl = @"schemeapi/diySchemedeleteitem";

/*远程修改DIY食谱*/
NSString *const kUpdateSchemeUrl = @"schemeapi/diyupdataScheme";
/*查询远程的DIY食谱*/
NSString *const kGetDIYDietUrl = @"schemeapi/diyQueryScheme";
/*远程删除DIY食谱*/
NSString *const kRemoveSchemeUrl = @"schemeapi/diydeleteScheme";
/*批量上传DIY食谱*/
NSString *const kBatchSaveSchemeUrl = @"schemeapi/diyInsertScheme";
/*记录饮食很运动的接口*/
NSString *const kSaveRecordUrl = @"recordapi/insertRecord";
NSString *const kRemoveRecordUrl = @"recordapi/deleteRecord";
NSString *const kQueryRecordUrl = @"recordapi/queryRecord";
NSString *const kBatchSaveRecordUrl = @"recordapi/insertRecord";
NSString *const kSaveForecastUrl = @"recordapi/saveForecast";
NSString *const kQueryForecastUrl = @"recordapi/selectForecast";
NSString *const kBatchSaveForcast = @"recordapi/insertForecast";
/*批量上传提醒的url*/
NSString *const kBatchUpAlarmUrl = @"otherapi/saveAlerts";
/*批量上传*/
NSString *const kSaveWeightsUrl = @"userapi/saveWeights";
//删除提醒
NSString *const kDeleteAlarmUrl = @"otherapi/deleteAlertExtend";
/*批量上传比例*/
NSString *const kSaveScaleToRemoteUrl = @"recordapi/saveScale";
NSString *const kGetScalFromRemoteUrl = @"recordapi/queryScale";
/*摇一摇 运动*/
NSString *const kShakeSportUrl = @"schemeapi/get_rand_sportfangan";
/*删除方案预测接口*/
NSString *const kRemoveForcastUrl = @"recordapi/deleteForecast";
/**
 *  4.0新记录页接口
 */
NSString *const kSaveUserRecord = @"v2/recordapi/saveUserRecordLog";
NSString *const kGetUserRecord = @"v2/recordapi/getUserRecordLog";
NSString *const kDeleteUserRecord = @"v2/recordapi/deleteRecord";
NSString *const kGetRecordDay = @"v2/recordapi/getRecordHistoryDay";

/**
 *  4.2新 收藏接口
 */
NSString *const kSetCollectionData = @"favorite/set";
NSString *const kGetCollectionData = @"favorite/get";
NSString *const kDeleteUserCollection = @"favorite/set";


#pragma mark - 5.0新记录接口

/**
 *  添加或删除用户记录接口
 */
NSString *const kSaveUserRecord_5_0 = @"/record/set/";
/**
 *  获取用户记录接口
 */
NSString *const kGetUserRecord_5_0 = @"/record/get/";


#pragma mark - 5.1新接口

NSString *const kGetTopicList = @"/blog/topic/";
NSString *const kGetBlogToken = @"/blog/token/";
NSString *const kUploadArticle = @"/blog/add1/";
NSString *const kGetArticleDetail = @"/blog/detail/";
NSString *const kAddArticleLike = @"/agree/add/";
NSString *const kDelArticleLike = @"/agree/del/";
NSString *const kGetReportReason = @"report/reasons/";

NSString *const kGetUserArticleList = @"blog/my/";
NSString *const kDeleteUserArticle = @"/blog/del/";
NSString *const kAddReport = @"report/add/";

NSString *const kAddExp = @"/honor/addexp/";

NSString *const kAppRecommend = @"/user/apps/";

#pragma --mark -5.2新接口

NSString *const kUpLoadPost = @"post/add/";
NSString *const kGetPostDetail = @"/post/detail/";
NSString *const kDeletePost = @"post/del/";
NSString *const kSetSchemeStartData = @"/calendar/mark";
NSString *const kPostLimit = @"/group/checklimit";


