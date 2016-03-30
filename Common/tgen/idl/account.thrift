# 熙康Thrift
# 帐户相关服务定义
# v0.74
# Copyright © 2012 Neusoft Xikang Healthcare Technology Co.,Ltd
# liaor@neusoft.com
# 2012/03/25
###############################################################

include "xkcm.thrift"

namespace java com.xikang.channel.base.rpc.thrift.account
// 性别
enum Gender {
	MALE=1, //男
	FEMALE  //女
}

// 用户信息
struct AccountInfo {
    1: string userId,              // 用户ID
	2: string email,               // 电子邮箱
	3: string mobileNum,           // 手机号
    4: string userName,            // 用户名
    5: string figureUrl,           // 用户头像的URL 小头像 50X50
    6: string account,			   // 账号
    7: Gender gender               // 性别
}

// 帐户相关服务
// URL格式：http(s)://host(:port)/base/rpc/thrift/account-service.protocol
service AccountService {

    // 接口名：发送手机验证码
    // 接口描述：发送手机验证码。
    //
    // 是否SSL：是
    // 授权模式：NONE
    //
    // 参数：
    //     commArgs：公共参数
    //     localCode：手机所在地（非必需）
    //     mobileNumber：手机号码
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码如下：
    //         1：手机号非法
    //         2：手机号已经使用过
    //         3：发送需要间隔60秒
    void sendVerifyCode(1: xkcm.CommArgs commArgs,
                        2: string localCode,
                        3: string mobileNumber)
         throws(1: xkcm.AuthException ae,
                2: xkcm.BizException be),

    // 接口名：校验手机验证码
    // 接口描述：校验手机验证码。
    //
    // 是否SSL：是
    // 授权模式：NONE
    //
    // 参数：
    //     commArgs：公共参数
    //     localCode：手机所在地（非必需）
    //     mobileNumber：手机号码
    //     verifyCode：验证码
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码如下：
    //         1：验证码校验失败
    //         2：验证码已过期
    void validateVerifyCode(1: xkcm.CommArgs commArgs,
                            2: string localCode,
                            3: string mobileNumber,
                            4: string verifyCode)
         throws(1: xkcm.AuthException ae,
                2: xkcm.BizException be),

    // 接口名：注册帐户
    // 接口描述：提交注册信息以注册帐户。
    //
    // 注意：
    //     本方法的名字不能采用“register”，因为它是thrift的保留字。
    //
    // 是否SSL：是
    // 授权模式：NONE
    //
    // 参数：
    //     commArgs：公共参数
    //     email：电子邮箱
    //     mobileNum：手机号
    //     password：用户密码
    //     userName：用户名
    // 返回值：所注册帐户的用户信息
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码如下：
    //	      1：电子邮箱格式不合法
    //        2：电子邮箱已经被注册
    //        3： 手机号格式不合法
    //        4：手机号已经被注册
    //        5：用户口令格式不合法
    //        6：用户名格式不合法
    //        7：邮箱、手机号、证件号码、卡号、帐号必填写一个 
    //        8:此证件号码已被注册，请输入其他的证件号码                                       
    //        9:此卡号已被注册，请输入其他的卡号 
    //        10:出生日期不能大于当前时间 
    //        11:解密失败 
    //        12:CAS创建账号异常 
    //        13:此账号已被注册，请输入其他的账号 
    //        14:昵称不能重复 
    //        15:保存会员异常 
	
    AccountInfo registerAccount(1: xkcm.CommArgs commArgs,
                         2: string email,
                         3: string mobileNum,
                         4: string password,
                         5: string userName,
                         6: string account,
                         7: Gender gender)
         throws(1: xkcm.AuthException ae,
                2: xkcm.BizException be),

    // 接口名：保存头像
    // 接口描述：保存头像，支持格式：jpg, jpeg, gif, png
    //
    // 是否SSL：是
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //     selfUserId：头像所属者的id
    //     formatType：头像格式
    //     dataContent：头像数据
    // 返回：头像大图片URL 图片尺寸120X120
    //	   
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码无
    string saveAvatar(1: xkcm.CommArgs commArgs,
                    2: string selfUserId,
                    3: string formatType,
                    4: binary dataContent)
             throws(1: xkcm.AuthException ae,
                    2: xkcm.BizException be),

    // 接口名：验证帐户
    // 接口描述：验证所提出的用户帐户和用户密码是否存在和匹配，如果验证通过则取得基本用户信息。
    //
    // 是否SSL：是
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //     userAccount：用户帐户
    //     password：用户密码
    // 返回值：所验证帐户的用户信息
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，错误码如下：
    //         1：用户帐户或用户密码错误
    AccountInfo validateAccount(1: xkcm.CommArgs commArgs,
                             2: string userAccount,
                             3: string password)
             throws(1: xkcm.AuthException ae,
                    2: xkcm.BizException be)

		    // edit by pengxm@neusoft 2013-04-02
    // 接口名：修改密码
    // 接口描述：修改用户密码
    //
    // 是否SSL：是
    // 授权模式：DIGEST
     //     be：业务例外，错误码如下：
    //         1：用户id不能为空
    //         2：旧密码不能为空
    //         3：新密码不能为空
    //         4：修改密码异常
    //         5：用户不存在
    //         6：帐号被锁定
    //         7：密码校验错
    void    // 返回值：所验证帐户的用户信息
        editPassword(                     // 参数：
            1: xkcm.CommArgs commArgs,    //     commArgs：公共参数
            2: string oldpwd,             //     oldpwd：用户旧口令
            3: string newpwd)             //     newpwd：用户新口令
        throws(                           // 例外：
            1: xkcm.AuthException ae,     //     ae：鉴权例外，错误码参见例外类型定义。
            2: xkcm.BizException be);     //     be：业务例外，错误码如下：
					                      //         1：用户旧密码输入错误
					                      //         2：修改密码失败

}
