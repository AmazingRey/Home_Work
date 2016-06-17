//
//  ALBBFeedbackService.h
//  ALBBFeedback
//
//  Created by zhoulai on 15/10/19.
//  Copyright © 2015年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

@protocol ALBBFeedbackService

/**
 *  @brief 准登陆并创建反馈页面回调Block，反馈页面相关接口见YWFeedbackViewController.h
 *  @param viewController 反馈页面
 *  @param error 调用失败返回错误
 */
typedef void (^YWMakeFeedbackViewControllerCompletionBlock) (YWFeedbackViewController * viewController, NSError *error);

/// @brief 登陆并创建反馈页面
- (void)makeFeedbackViewControllerWithCompletionBlock:(YWMakeFeedbackViewControllerCompletionBlock)completionBlock;

/**
 *  @brief 反馈未读消息数回调Block
 *  @param unreadCount 未读消息数
 *  @param error 调用失败返回错误
 */
typedef void (^YWGetUnreadCountCompletionBlock) (NSNumber *unreadCount, NSError *error);

/// @brief 请求反馈未读消息数
- (void)getUnreadCountWithCompletionBlock:(YWGetUnreadCountCompletionBlock)completionBlock;

/// 自定义反馈页面配置，在创建反馈页面前设置
@property (nonatomic, strong, readwrite) NSDictionary *customUIPlist;

/// 业务方扩展反馈数据，在创建反馈页面前设置
@property (nonatomic, strong, readwrite) NSDictionary *extInfo;

/// 忽略绑定的客服账号，将直接反馈到先知系统。请在初始化调用其他接口前调用，默认不忽略。
@property (nonatomic, assign) BOOL ignoreCustomerServiceBinded;

/** 联系方式相关的属性，需要在创建反馈页面前设置 **/

/// 设置反馈用户联系方式，用于反馈界面展示。
@property (nonatomic, strong) NSString *contactInfo;

/// 隐藏联系方式提醒条，默认显示。联系方式必须输入时无法隐藏。
@property (nonatomic, assign) BOOL hideContactInfoView;

@end

