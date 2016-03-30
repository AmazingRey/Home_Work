//
//  XKRWRequestConstValue.h
//  XKRW
//
//  Created by zhanaofan on 14-3-24.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*方案相关请求*/
//获取方案
extern NSString *const kSchemeUrl;
//摇一摇请求
extern NSString *const kschemeRoundFoodUrl;
/*小贴士相关请求*/
extern NSString *const kGetTipUrl;

/*远程保存DIY食谱*/
extern NSString *const kSaveSchemeUrl;
/*远程修改DIY食谱*/
extern NSString *const kUpdateSchemeUrl;

extern NSString *const kDeleteDIYSchemeFoodUrl;

/*远程删除DIY食谱*/
extern NSString *const kRemoveSchemeUrl;
/*批量上传DIY食谱*/
extern NSString *const kBatchSaveSchemeUrl;
/*查询远程的DIY食谱*/
extern NSString *const kGetDIYDietUrl;
/*获取运动详情的接口地址*/
extern NSString *const kGetSportDetailUrl;
extern NSString *const kSaveWeightsUrl;
/*记录饮食和运动*/
extern NSString *const kSaveRecordUrl;
extern NSString *const kRemoveRecordUrl;
/*批量上传记录到服务器中*/
extern NSString *const kBatchSaveRecordUrl;
extern NSString *const kSaveScaleToRemoteUrl;
extern NSString *const kGetScalFromRemoteUrl;
extern NSString *const kDeleteAlarmUrl;
/*查询服务器上的记录*/
extern NSString *const kQueryRecordUrl;
/*方案预测上传*/
extern NSString *const kSaveForecastUrl;
/*批量下载预测值*/
extern NSString *const kQueryForecastUrl;
/*批量上传*/
extern NSString *const kBatchSaveForcast;
/*批量上传提醒的url*/
extern NSString *const kBatchUpAlarmUrl;
/*摇一摇 运动*/
extern NSString *const kShakeSportUrl;
/*删除方案预测接口*/
extern NSString *const kRemoveForcastUrl;

/**/
/**
 *  保存用户记录
 */
extern NSString *const kSaveUserRecord;
/**
 *  获取用户记录
 */
extern NSString *const kGetUserRecord;
/**
 *  删除用户记录
 */
extern NSString *const kDeleteUserRecord;
/**
 *  获取用户记录日期
 */
extern NSString *const kGetRecordDay;


/**
 *  4.2新 获取收藏信息
 */
extern NSString *const kSetCollectionData;
extern NSString *const kGetCollectionData;
extern NSString *const kDeleteUserCollection;

#pragma mark - 5.0新记录接口

/**
 *  添加或删除用户记录接口
 */
extern NSString *const kSaveUserRecord_5_0;
/**
 *  获取用户记录接口
 */
extern NSString *const kGetUserRecord_5_0;


#pragma mark - 5.1新接口
/**
 *  获取文章话题列表
 */
extern NSString *const kGetTopicList;
extern NSString *const kGetBlogToken;
extern NSString *const kUploadArticle;
extern NSString *const kGetArticleDetail;
extern NSString *const kAddArticleLike;
extern NSString *const kDelArticleLike;
extern NSString *const kGetReportReason;
extern NSString *const kGetUserArticleList;
extern NSString *const kDeleteUserArticle;
extern NSString *const kAddReport;
extern NSString *const kAddExp;
extern NSString *const kAppRecommend;

#pragma --mark 5.2 新接口
extern NSString *const kUpLoadPost;
extern NSString *const kGetPostDetail;
extern NSString *const kDeletePost;
extern NSString *const kSetSchemeStartData;
extern NSString *const kPostLimit;

