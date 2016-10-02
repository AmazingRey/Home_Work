# 熙康Thrift
# 版本相关服务定义
# v0.61
# Copyright © 2012 Neusoft Xikang Healthcare Technology Co.,Ltd
# liaor@neusoft.com
# 2012/03/25
###############################################################

include "xkcm.thrift"

namespace java com.xikang.channel.base.rpc.thrift.app

// 版本状态
enum VersionStatus {
    RECOMMENDED,                       // 推荐版本
    COMPATIBLE,                        // 兼容版本（非推荐但可使用）
    INCOMPATIBLE                       // 不兼容版本（不可使用）
}

// 版本信息
struct VersionInfo {
    1: VersionStatus currentStatus,    // 当前版本状态
    2: string currentMessage,          // 当前版本状态的提示信息，当前版本为推荐版本时通常缺省
    3: string recommendedVersion,      // 推荐版本的版本号，当前版本为推荐版本时通常缺省
    4: string linkUrl                  // 版本说明相关链接的URL，当前版本为推荐版本时通常缺省
}

// 应用相关服务
// URL格式：http(s)://host(:port)/base/rpc/thrift/app-service.protocol
service AppService {

    // 接口名：验证版本
    // 接口描述：验证当前应用的版本，并给出反馈提示信息。
    //
    // 注意：使用前提为“终端设备类型 + 应用ID + 应用版本”可以唯一标识一个二进制应用程序版本。
    //
    // 是否SSL：否
    // 授权模式：NONE
    //
    // 参数：
    //     commArgs：公共参数
    // 返回值：版本信息
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，目前无错误码。
    VersionInfo validateVersion(1: xkcm.CommArgs commArgs)
                throws(1: xkcm.AuthException ae,
                       2: xkcm.BizException be)

	/**
    * @desc 注册苹果推送通知服务
    * @param deviceToken IOS终端设备的deviceToken
    * @exceptions     ae：鉴权例外，错误码参见例外类型定义。
	*				  be：业务例外，暂无
    * 是否SSL：否
    * 授权模式 DIGEST
    */
    void registerAPNSForIOS(1: xkcm.CommArgs commArgs,
    				  2: string deviceToken)
                throws(1: xkcm.AuthException ae,
                       2: xkcm.BizException be)
    
    /**
    * @desc 注销苹果推送通知服务
    * @param deviceToken IOS终端设备的deviceToken
    * @exceptions     ae：鉴权例外，错误码参见例外类型定义。
	*				  be：业务例外，暂无
    * 是否SSL：否
    * 授权模式 NONE
    */                
    void cancelAPNSForIOS(1: xkcm.CommArgs commArgs,
    				  2: string deviceToken)
                throws(1: xkcm.AuthException ae,
                       2: xkcm.BizException be)
}
