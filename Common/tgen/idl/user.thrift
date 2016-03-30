# 熙康Thrift
# 用户相关服务定义
# v0.6
# Copyright © 2012 Neusoft Xikang Healthcare Technology Co.,Ltd
# liaor@neusoft.com
# 2012/03/25
###############################################################

include "xkcm.thrift"
include "family.thrift"

namespace java com.xikang.channel.base.rpc.thrift.user
// 用户性别
enum UserGender {
    MALE = 1;                      // 男性
    FEMALE = 2;                    // 女性
}
// 用户信息
struct UserInfo {
    1: string userId,              // 用户ID
	2: string email,               // 电子邮箱
	3: string mobileNum,           // 手机号
    4: string userName,            // 用户名
    5: string figureUrl,           // 用户头像的URL 小头像 50X50
    6: string birthday,          //出生日期 格式：yyyy-MM-dd 
	7: UserGender  gender,			  //性别  male：男性 female：女性 
	8: string telephone,		  //固定电话
	9: string qq				  //qq
}

// 用户腕表相关信息
struct WatchInfo {
    1: bool isBound,              // 用户与腕表的状态 true:已经绑定；false：未绑定
}

// 用户相关服务
// URL格式：http(s)://host(:port)/base/rpc/thrift/user-service.protocol
service UserService {

    // 接口名：查询用户
    // 接口描述：根据指定的查询条件查询用户信息。
    //
    // 是否SSL：否
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //     condition：查询条件
    // 返回值：查询结果的用户信息列表，查询结果不存在时返回空列表。
    // 返回值排序：用户名升序
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，目前无错误码。
    list<UserInfo> searchUsers(1: xkcm.CommArgs commArgs,
                               2: string condition)
                   throws(1: xkcm.AuthException ae,
                          2: xkcm.BizException be)
	
    // 接口名：修改用户名
    // 接口描述：修改用户名为指定的新用户名。
    //
    // 是否SSL：否
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //     newUserName：指定的新用户名
    // 返回值：返回消息结构体
    //
    // 例外：
    //     ae：鉴权例外，错误码参见例外类型定义。
    //     be：业务例外，目前无错误码。
	xkcm.ReturnMessage changeUserName(1: xkcm.CommArgs commArgs,
	                             2: string newUserName)
				  throws(1: xkcm.AuthException ae,
				         2: xkcm.BizException be)
	/**
	* @name 更新指定用户----生日
	* @desc	更新指定用户的生日信息
	* @param userId 指定用户ID(phrCode)
	* @param birthday 出生年月日 格式yyyy-MM-dd
	* @exceptions     ae：鉴权例外，错误码参见例外类型定义。
	*				  be：业务例外，暂无
	* 是否SSL：否
    * 授权模式 DIGEST
	*/
	void updateBirthday(1: xkcm.CommArgs commArgs,
						2: string userId,
	                    3: string birthday)
				  throws(1: xkcm.AuthException ae,
				         2: xkcm.BizException be)
	
	/**
	* @name 更新指定用户----所在地
	* @desc	更新指定用户的所在地信息
	* @param userId 指定用户ID(phrCode)
	* @param districtCode 地区编码,如210100
	* @param district 地区名 如 沈阳
	* @exceptions     ae：鉴权例外，错误码参见例外类型定义。
	*				  be：业务例外，暂无
	* 是否SSL：否
    * 授权模式 DIGEST
	*/		         
	void updateLocation(1: xkcm.CommArgs commArgs,
						2: string userId,
	                    3: string districtCode,
	                    4: string district)
				  throws(1: xkcm.AuthException ae,
				         2: xkcm.BizException be)

	//edit by pengxm@neusoft.com data:2013-04-02		
	// 接口名：修改用户信息
    // 接口描述：修改用户信息
    //
    // 是否SSL：否
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    //     userInfo：用户信息
    // 返回值：返回消息
    //
    // 例外：
    //     1：用户id不能为空
    //     2：邮箱地址不合法
    //     3：请输入正确的手机号
    //     4：用户名过长，请输入1到10个字符
    //     5：用户不存在
    //     6：生日格式不正确
    //     7：邮箱地址重复
    //     8：会员手机号码重复
    //     9：昵称不能重复
    //     10：保存接口错误
	xkcm.ReturnMessage setUserInfo(1: xkcm.CommArgs commArgs,
	                             2: UserInfo userInfo)
				  throws(1: xkcm.AuthException ae,
				         2: xkcm.BizException be)

	//edit by pengxm@neusoft.com data:2013-04-11		
	// 接口名：查询用户信息
    // 接口描述：查询用户信息
    //
    // 是否SSL：否
    // 授权模式：DIGEST
    //
    // 参数：
    //     commArgs：公共参数
    // 返回值：返回消息结构体
    //
    // 例外：
    //     1：用户id不能为空
    //     2：用户不存在
	UserInfo getUserInfo(1: xkcm.CommArgs commArgs)
				  throws(1: xkcm.AuthException ae,
				         2: xkcm.BizException be)

	/**
	* @name 取得用户腕表相关信息
	* @desc	取得用户腕表相关信息,如是否绑定，版本等信息
	* @param userId 指定用户ID(phrCode)
	* @exceptions     ae：鉴权例外，错误码参见例外类型定义。
	*				  be：业务例外，暂无
	* 是否SSL：否
    * 授权模式 DIGEST
	*/		         
	WatchInfo getWatchInfo(1: xkcm.CommArgs commArgs,
				   		   2: string userID)
				  	throws(1: xkcm.AuthException ae,
				           2: xkcm.BizException be)
}