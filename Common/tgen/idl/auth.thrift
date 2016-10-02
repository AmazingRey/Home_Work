# 熙康Thrift
# 授权相关服务定义
# v0.9
# Copyright © 2012 Neusoft Xikang Healthcare Technology Co.,Ltd
# liaor@neusoft.com
# 2012/03/25
###############################################################

include "xkcm.thrift"

namespace java com.xikang.channel.base.rpc.thrift.auth

// 登录时扩展信息
struct LoginExtInfo {
    1: string apnsDeviceToken // 使用APNS(Apple Push Notification Service)服务时用到的Device Token(面向iOS终端)
}

// 第三方用户类型
enum OpenIDType {
    sina,                              // 新浪(sina.com.cn)帐号登录
    qq                                 // 腾讯(qq.com)帐号登录
}

// 第三方用户信息
struct OpenAccountInfo {
    1: OpenIDType openIDType, // 第三方用户类型
    2: string uid,            // 第三方帐号的UID
    3: string userNickName,   // 第三方帐号昵称
    4: string token           // 在第三方登录时返回的token
}

// 注销时扩展信息
struct LogoutExtInfo {
    1: string apnsDeviceToken // 使用APNS(Apple Push Notification Service)服务时用到的Device Token(面向iOS终端)
}

// 认证用户信息
struct AuthUserInfo {
    1: string userId,         // 用户ID
    2: string userName        // 用户名
    3: string figureUrl       // 用户头像的URL 小头像 50X50
    4: string bigImageURL     // 大头像URL 120X120
}

struct LoginResultExtInfo {
    1: string casTgt          // CAS的TGT（熙康别系统认证用）
}

// 登录结果信息
struct LoginResult {
    1: xkcm.DigestAuthorizationRes digestAuthorizationRes, // 摘要型授权响应信息
    2: AuthUserInfo authUserInfo,                          // 认证用户信息
    3: LoginResultExtInfo loginResultExtInfo               // 登录结果扩展信息
}

// 授权鉴权相关服务
// URL格式：http(s)://host(:port)/base/rpc/thrift/auth-service.protocol
service AuthService {

    // 接口名：登录
    // 接口描述：根据用户帐户和用户密码进行登录、获得授权，同时向服务端发送扩展信息。
    //
    // 注意：
    //     参数中的loginExtInfo.apnsDeviceToken只在iOS终端时使用，否则无需设定。
    //
    // 是否SSL：是
    // 授权模式：NONE
    //
    // 参数：
    //     commArgs：公共参数
    //     userAccount：用户帐户
    //     password：用户密码
    //     loginExtInfo：登录时扩展信息
    // 返回值：登录结果信息
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码如下：
    //         1：用户帐户或用户密码错误
    LoginResult login(1: xkcm.CommArgs commArgs,
                      2: string userAccount,
                      3: string password,
                      4: LoginExtInfo loginExtInfo)
                throws(1: xkcm.AuthException ae,
                       2: xkcm.BizException be),

    // 接口名：第三方帐号登录
    // 接口描述：根据第三方帐号登录、获得授权，同时向服务端发送扩展信息。
    //
    // 注意：
    //     参数中的loginExtInfo.apnsDeviceToken只在iOS终端时使用，否则无需设定。
    //
    // 是否SSL：是
    // 授权模式：NONE
    //
    // 参数：
    //     commArgs：公共参数
    //     openAccountInfo：第三方用户信息
    //     loginExtInfo：登录时扩展信息
    // 返回值：登录结果信息
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码无
    LoginResult loginWithOpendID(1: xkcm.CommArgs commArgs,
                                 2: OpenAccountInfo openAccountInfo,
                                 3: LoginExtInfo loginExtInfo)
                throws(1: xkcm.AuthException ae,
                       2: xkcm.BizException be),

    // 接口名：心跳
    // 接口描述：心跳以维持授权状态。
    //
    // 是否SSL：否
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，目前无错误码。
    void heartbeat(1: xkcm.CommArgs commArgs)
         throws(1: xkcm.AuthException ae,
                2: xkcm.BizException be),

    // 接口名：注销
    // 接口描述：注销以废弃授权状态。
    //
    // 注意：参数中的logoutExtInfo.apnsDeviceToken只对iOS终端有意义。
    //
    // 是否SSL：否
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //     logoutExtInfo：注销时扩展信息
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，目前无错误码。
    void logout(1: xkcm.CommArgs commArgs,
                2: LogoutExtInfo logoutExtInfo)
         throws(1: xkcm.AuthException ae,
                2: xkcm.BizException be)

}
