//
//  define.h
//  XKRW
//
//  Created by zhanaofan on 13-12-17.
//  Copyright (c) 2013年 XiKang. All rights reserved.
//

#ifndef XKRW_define_h
#define XKRW_define_h
/**
 *  debug 模式下log
 */
#ifdef DEBUG
#import <Foundation/Foundation.h>
#define XKLog(...) NSLog(__VA_ARGS__)
#else
#define XKLog(...)
#endif

#ifndef IS_IPHONE_5
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#import "UIViewExt.h"

/*
 广告
 */
#define ADV_PIC_NAME    @"ADV_PIC_NAME"
#define ADV_PIC_SIZE  [NSString stringWithFormat:@"%dx%d", (int)(XKAppWidth * XKScreenScale), (int)(XKAppHeight * XKScreenScale)]
//[NSString stringWithFormat:@"%@x%@", XKAppWidth, XKAppHeight] IS_IPHONE_5 ? @"640x1136": @"640x960"

//#define NEW_TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"NEW_TOKEN"]
//#define OLD_TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"OLD_TOKEN"]

/*
 *  支付相关
 */
#define kPaymentResultNotification @"paymentResultNotification"

/*
 *  Tips
 */

#define OpenPlanToday  @"OpenPlanToday"

//远程通知相关
#define RemoteImportantNotification     @"remoteImportantNotification"       //重要消息
#define RemoteNormalNotification        @"RemoteNormalNotification"          //普通消息
#define RemoteThumpUpNotification       @"RemoteThumpUpNotification"         //点赞消息
#define RemoteCommentNotification       @"RemoteCommentNotification"         //评论消息
#define RemoteSystemNotification        @"RemoteSystemNotification"          //系统消息
#define RemotePKNotification            @"RemotePKNotification"              //PK消息
#define RemotePostCommentNotification   @"RemotePostCommentNotification"     //帖子评论
#define RemoteServicerNotification      @"RemoteServicerNotification"        //瘦瘦客服
#define RemotePostThumpUpNotification   @"RemotePostThumpUpNotification"     //帖子点赞


#define BePraiseNoticeChanged               @"BePraiseNoticeChanged"             //被点赞消息数目改变
#define CommentAndSystemNoticeChanged            @"CommentAndSystemNoticeChanged"             //评论消息数目改变
//App 界面已经渲染完成
#define AppInterfaceHadShow             @"AppInterfaceHadShow"
//远程通知的内容
#define RemoteNotificationContent       @"RemoteNotificationContent"
//用来记录每次Http请求重要消息的消息ID
#define HttpImportantNoticeID           @"HttpImportantNoticeID"

//语音搜索
#define iflyUser @"huiych@neusoft.com"
#define iflyPwd @"000635879"
//微博
#if 1
#define XKSinaID @"3164497770"
#define XKSinaName @"熙康瘦瘦"
#else
#define XKSinaID @"3901081584"
#define XKSinaName @"leng_1990_"
#endif


#define msgAppKey   @"7a1f10938d60"
#define msgAppSecret    @"b42e890fa5487379ca087c6673c26b1a"

#define XKSINADEV_APP_KEY @""

#define KeyWindow   [[UIApplication sharedApplication].delegate window]

//定义屏幕尺寸
#define XKScreenBounds                  [[UIScreen mainScreen] bounds]
#define XKScreenFrame                   [[UIScreen mainScreen] applicationFrame]
#define XKAppWidth                      [[UIScreen mainScreen] bounds].size.width
#define XKAppHeight                     [[UIScreen mainScreen] bounds].size.height

#define XKScreenScale                   [UIScreen mainScreen].scale

#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

//画圆
#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)


#define XKSystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

#define K_iOS_System_Version_Gt_7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IOS_7_OR_EARLY ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

/************************************************************************
 颜色相关定义
 ************************************************************************/
//根据十六进制返回颜色
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//文字颜色
#define XKGrayDefaultColor [UIColor colorFromHexString:@"#888888"]


#define RGB(R,G,B,P)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:P]
#define HEXCOLOR(x) [UIColor colorFromHexString:x]

//分割线颜色
#define XKSepDefaultColor [UIColor colorFromHexString:@"#e0e0e0"]

//背静颜色
#define XKBGDefaultColor [UIColor colorFromHexString:@"#ECECEC"]

//透明色
#define XKClearColor [UIColor clearColor]

// 选中色
#define colorSecondary_f0f0f0 [UIColor colorFromHexString:@"#f0f0f0"]

//主色调
#define XKMainToneColor_00b4b4 [UIColor colorFromHexString:@"#00b4b4"]
#define XKMainToneColor_29ccb1 [UIColor colorFromHexString:@"#29ccb1"]
#define XKBtnSelectedColor [UIColor colorFromHexString:@"#b2e8e8"]

//辅助色 由深到浅
#define  colorSecondary_333333 [UIColor colorFromHexString:@"#333333"]//标题字色
#define  colorSecondary_666666 [UIColor colorFromHexString:@"#666666"]//正文字色
#define  colorSecondary_999999 [UIColor colorFromHexString:@"#999999"]
#define  colorSecondary_cccccc [UIColor colorFromHexString:@"#cccccc"]
#define  colorSecondary_ebebeb [UIColor colorFromHexString:@"#ebebeb"]
#define  colorSecondary_f6f6f6 [UIColor colorFromHexString:@"#f6f6f6"]
#define  colorSecondary_fafafa [UIColor colorFromHexString:@"#fafafa"]
#define  colorSecondary_c7c7c7 [UIColor colorFromHexString:@"#c7c7c7"]

//---------------------------4.0版本添加辅助色-------------------------
#define  colorSecondary_c7c7cc [UIColor colorFromHexString:@"#c7c7cc"] //线性图标
#define  colorSecondary_e0e0e0 [UIColor colorFromHexString:@"#e0e0e0"] //辅助线
#define  colorSecondary_e6e6e6 [UIColor colorFromHexString:@"#e6e6e6"] //按下
#define  colorSecondary_f4f4f4 [UIColor colorFromHexString:@"#f4f4f4"] //底色和tab
//---------------------------4.0版本新色调-----------------------------
//标题字色
#define XK_TITLE_COLOR [UIColor colorFromHexString:@"#333333"]
//正文字色
#define XK_TEXT_COLOR [UIColor colorFromHexString:@"#666666"]
//辅助字色
#define XK_ASSIST_TEXT_COLOR [UIColor colorFromHexString:@"#999999"]
//线性图标
#define XK_LINEAR_ICON_COLOR [UIColor colorFromHexString:@"#C7C7CC"]
//辅助线
#define XK_ASSIST_LINE_COLOR [UIColor colorFromHexString:@"#E0E0E0"]
//按下
#define XK_PRESSED_COLOR [UIColor colorFromHexString:@"#E6E6E6"]
//底色和tab
#define XK_BACKGROUND_COLOR [UIColor colorFromHexString:@"#F4F4F4"]

//title底色
#define XKTitleBackColor [UIColor colorFromHexString:@"#00B4B4"]
//button按下时底色
#define XKPressedColor [UIColor colorFromHexString:@"#39BFA9"]
//主色调
#define XKMainSchemeColor [UIColor colorFromHexString:@"#29CCB1"]
//辅色调
#define XKAssistantColor [UIColor colorFromHexString:@"#A1E5DA"]
//警示用色（浅）
#define XKWarningColor [UIColor colorFromHexString:@"#FF6B6B"]
//警示用色（深）
#define XKWarningColorDeep [UIColor colorFromHexString:@"#CC5252"]

//用来表示 吃了别的
#define XKOrangeColor [UIColor colorFromHexString:@"#ffc555"]

//状态用色：
/**
 *  极少 -3
 */
#define XK_STATUS_COLOR_FEW [UIColor colorFromHexString:@"#FF6B6B"]
/**
 *  较少 -2F
 */
#define XK_STATUS_COLOR_LESS [UIColor colorFromHexString:@"#FF7F7F"]
/**
 *  正常 -1
 */
#define XK_STATUS_COLOR_NORMAL [UIColor colorFromHexString:@"#FF884C"]
/**
 *  达标 0
 */
#define XK_STATUS_COLOR_STANDARD [UIColor colorFromHexString:@"#29CCB1"]
/**
 *  优秀 1
 */
#define XK_STATUS_COLOR_GREAT [UIColor colorFromHexString:@"#83CC52"]
/**
 *  完美 2
 */
#define XK_STATUS_COLOR_PERFECT [UIColor colorFromHexString:@"#AAC814"]


//--------------------------------------------------------------------

//文字大小
#define fontSpecial [UIFont systemFontOfSize:([[UIScreen mainScreen] bounds].size.height > 960)? 36 : 32]
#define fontMax [UIFont systemFontOfSize:([[UIScreen mainScreen] bounds].size.height > 960)?19 : 17]
#define fontNormal [UIFont systemFontOfSize:([[UIScreen mainScreen] bounds].size.height > 960)? 16 : 14]
#define fontMin [UIFont systemFontOfSize:([[UIScreen mainScreen] bounds].size.height > 960)? 14 : 12]

//默认按钮大小
#define UI_btnNormalSize CGSizeMake(32, 90)


/************************************************************************
 字体相关定义
 ************************************************************************/
//获取默认字体
#define XKDefaultFontWithSize(fontSize)  [UIFont systemFontOfSize:fontSize]

//默认英文和数字 字体（只有剩余的卡路里）
#define XKDefaultNumEnFontWithSize(fontSize) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) ? [UIFont fontWithName:@"Roboto-Regular" size:fontSize] : [UIFont systemFontOfSize:fontSize]

//正规  标题行数字和英文
#define XKDefaultRegFontWithSize(fontSize) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) ? [UIFont fontWithName:@"Roboto-Regular" size:fontSize] : [UIFont systemFontOfSize:fontSize]

//加粗
#define XKDefaultRudeFontWithSize(fontSize) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) ? [UIFont fontWithName:@"Roboto-Medium" size:fontSize] : [UIFont systemFontOfSize:fontSize]
//名言  方正静蕾体
#define XKDefaultStaticGreyFontWithSize(fontSize) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) ? [UIFont fontWithName:@"STLITI" size:fontSize] : [UIFont systemFontOfSize:fontSize]
////仿宋 字体
//#define XKDefaultSongGreyFontWithSize(fontSize) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) ? [UIFont fontWithName:@"STKaiti" size:fontSize] : [UIFont systemFontOfSize:fontSize]

#define XKDefaultMINISongFontWithSize(fontSize) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ) ? [UIFont fontWithName:@"迷你简仿宋" size:fontSize] : [UIFont systemFontOfSize:fontSize]

//判断版本
#define   IOS_VERSION      [[[UIDevice currentDevice] systemVersion] floatValue]

#define   IOS8               (IOS_VERSION > 8.0 ) ? 1:0 

//加粗字体
#define XKBoldFontWithSize(fontSize)  [UIFont fontWithName:@"System Bold" size:fontSize]

#define XKGender(gender)  ((int)gender == 0) ? @"男" : @"女"

/**********************************************
 *  字体字号大小设置
 **********************************************/
//按钮字体大小
#define XK_BUTTON_FONT_SIZE 16.f



//像素转PT
//#define pxtopt(px)  (144*px)/326
#define pxtopt(px)   px/2

#define Screem  [UIScreen mainScreen]
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define kOneThumb @"-1thumb"
#define kNineThumb @"-9thumb"
#define kCoverThumb @"-cover"
#define kCoverRatio 9.0 / 16.0

#define XKIMG(name) [UIImage imageNamed:name]

//时间戳
#define    timestamps    (int)[[NSDate date] timeIntervalSince1970]

#define  weeksChs   [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil]
//度量单位
#define XKMetricUnit [NSArray arrayWithObjects:@"克",@"盒",@"块",@"千焦",@"千卡",@"毫升",nil]

#define XKURL(url) [NSURL URLWithString:url]
#define XKSTR(...) [NSString stringWithFormat:__VA_ARGS__]
/*早、中、晚、加餐*/
#define XKMealNames  @[@"早餐",@"午餐",@"晚餐",@"加餐"]
/*饮食控制值*/
#define XKDietLimitCalorie @[[NSNumber numberWithInt:330],[NSNumber numberWithInt:550],[NSNumber numberWithInt:880],[NSNumber numberWithInt:1100]]
/*运动控制值-轻体力*/
#define XKSportOfLightLimitCalorie @[[NSNumber numberWithInt:232],[NSNumber numberWithInt:320],[NSNumber numberWithInt:452],[NSNumber numberWithInt:540]]
/*运动控制值-中体力*/
#define XKSportOfNormalLimitCalorie @[[NSNumber numberWithInt:166],[NSNumber numberWithInt:210],[NSNumber numberWithInt:276],[NSNumber numberWithInt:320]]
/*体力对应的PAL*/
//男性PAL
#define XKMalePhysicalLevelOfPal @[[NSNumber numberWithFloat:1.55],[NSNumber numberWithFloat:1.78],[NSNumber numberWithFloat:2.1]]
//女性PAL
#define XKFemalePhysicalLevelOfPal @[[NSNumber numberWithFloat:1.56],[NSNumber numberWithFloat:1.64],[NSNumber numberWithFloat:1.82]]

//#define XKRoundInt(f)  (int)floor(f+0.5f)

#define UID [XKRWUserDefaultService getCurrentUserId]

#define itoa(i) [NSString stringWithFormat:@"%i",i]

#define ftoa(f) [NSString stringWithFormat:@"%f",f]

//应用id
#define XKRWAPPID   @"622478622"
//Appstore评分
#define STR_APPSTORE_URL  [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",XKRWAPPID]

//Appstore评分 iOS7  and later
#define STR_APPSTORE_URL_IOS7  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",XKRWAPPID]

//Appstore更新链接
#define STR_UPDATE_URL    [NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=%@&mt=8",XKRWAPPID]

//Appstore更新链接 iOS7 and later
#define STR_UPDATE_URL_IOS7    [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",XKRWAPPID]

#define LOCAL_INFO_AVAILBALE_VERSION            @"LOCAL_INFO_AVAILBALE_VERSION" //最新版本号

#define LOCAL_INFO_IGNORE_VERSIONS              @"LOCAL_INFO_IGNORE_VERSIONS"   //忽略的版本号

//获取Appstore版本号
#define STR_VERSION_URL [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",XKRWAPPID]

//#define NavigatonBarDefaultColor

//加载.xib
#define LOAD_VIEW_FROM_BUNDLE(x) [[NSBundle mainBundle] loadNibNamed:x owner:self options:nil][0]

#define RESETSCHEME  @"ReSetScheme"


#define THUMPUPNUM      @"thumpUpNum"
#define BEPRAISEDNUM    @"BePraisedNum"
#define BUYSERVERNUM    @"buyServerNum"

#define SCHEMEPAGE  @"schemePage"

#define ANALYZEPAGE  @"analyzePage"

#define ReLoadTipsData @"ReLoadTipsData"
// 能量环接收数据变化通知中心 名称
#define EnergyCircleDataNotificationName @"energyCircleDataChanged"
// 能量环接收数据变化通知中心 object 传值 影响饮食能量环
#define EffectFoodCircle @"food"
// 能量环接收数据变化通知中心 object 传值 影响运动能量环
#define EffectSportCircle @"sport"
// 能量环接收数据变化通知中心 object 传值 影响习惯能量环
#define EffectHabit @"habit"
// 能量环接收数据变化通知中心 object 传值 影响饮食和运动能量环
#define EffectFoodAndSportCircle @"foodAndSport"

#define RecordSchemeData           @"RecordSchemeData"

#define XKRWScaleWidth ([[UIScreen mainScreen] bounds].size.width/375.0)
#define XKRWScaleHeight ([[UIScreen mainScreen] bounds].size.height/667.0)

#define ENTRYFEEDBACK @"entryFeedback"

#endif
