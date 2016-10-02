# 熙康Thrift
# 通用消息定义
# v0.72
# Copyright © 2012 Neusoft Xikang Healthcare Technology Co.,Ltd
# liaor@neusoft.com
# 2012/03/25
###############################################################

namespace java com.xikang.channel.common.rpc.thrift.message

// ----- 公共请求参数相关开始 ----->
// 设备类型
enum DeviceType {
    WEB = 1,                        // WEB
    XK_WATCH = 101,                 // 熙康行表
    XK_TERMINAL = 201,              // 熙康益体机
    ANDROID = 1001,                 // 安卓设备
    IOS = 1002                      // iOS设备
}

// 终端信息
struct TerminalInfo {
    1: DeviceType deviceType,       // 终端设备类型
    2: string deviceId,             // 终端设备唯一标识
    3: string OsVersion             // 终端OS版本
}

// 应用信息
struct AppInfo {
    1: string appId,                // 应用ID，注意：它和熙康网平台的应用注册中使用的app_id不是一个概念
    2: string appVersion            // 应用版本
}

// 国际化信息-地域
enum Region {
    CN,                              // 中国
    US                               // 美国
}

// 国际化信息-语言
enum Language {
    ZH_CN,                           // 中文（中国）
    EN_US                            // 英语（美国）
}

// 国际化信息
struct I18nInfo {
    1: Region region,                 // 地域
    2: Language language              // 语言
}

// 授权模式
enum AuthMode {
    NONE,                             // 免授权
    DIGEST                            // 摘要
}

// 摘要型鉴权请求用信息
struct DigestAuthenticationReq {
    1: string clientId,               // 客户端ID，注意：它和熙康网平台的应用注册中使用的client_id不是一个概念
    2: i64 clientCount,               // 客户端访问计数
    3: string clientRandom,           // 客户端随机信息
    4: string accessToken             // 访问令牌
}

// 公共请求参数
struct CommArgs {
    1: TerminalInfo terminalInfo,    // 终端信息
    2: AppInfo appInfo,              // 应用信息
    3: string userId,                // 用户ID，即PHR Code，注意：对于授权模式为NONE的接口，除非有特别要求，否则无需设定本参数
    4: I18nInfo i18nInfo,            // 国际化信息
    5: AuthMode authMode,            // 授权模式
    6: DigestAuthenticationReq digestAuthenticationReq, // 摘要型鉴权请求用信息，注意：对于授权模式不为DIGEST的接口，无需设定本参数
    7: bool checkVersion			 // 是否验证版本 默认为false
}
// <----- 公共请求参数相关结束 -----

// 摘要型授权响应用信息
struct DigestAuthorizationRes {
    1: string clientId,       // 客户端ID
    2: string initialToken,   // 起始令牌
    3: i32 initialCount,      // 起始访问计数
    4: string resSign,        // 响应签名
    5: i32 authTtl            // 授权有效期间，单位为秒
}

// 该结构体已废弃，不要再使用，理由；失败的情况下应该用BizException返回错误细节，而不是返回值。
// 返回消息结构体
struct ReturnMessage {
	1: bool   isSucceed,  // true:成功, false:失败
	2: string message,    // 返回的信息
}

// 业务例外
exception BizException {
  1: i32 code,           // 码
  2: string message      // 消息
}

// 鉴权例外
// 错误码如下：
//     1：需要SSL。
//     2：授权过期。（免授权模式不使用该错误码。）
//     3：鉴权不通过。（不包括2的情况，服务端可查知细节，但不向客户端暴露。）
exception AuthException {
  1: i32 code,           // 码
  2: string message      // 消息
}

// 版本例外
// 错误码如下:
//	   1: 当前版本不可用
exception VersionException {
  1: i32 code,           // 码
  2: string message      // 消息
}