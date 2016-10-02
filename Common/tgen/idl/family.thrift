# 熙康Thrift
# 家人相关服务定义
# v0.9
# Copyright © 2013 Neusoft Xikang Healthcare Technology Co.,Ltd
# wei.zhou@neusoft.com
# 2013/03/06
###############################################################

include "xkcm.thrift"
include "account.thrift"

namespace java com.xikang.channel.base.rpc.thrift.family

///**
//* 关系
//*/
//struct Relation  {
//	1: string myId,		// 我的ID
//	2: string folkId,	// 家人的userId
//	3: string iAmCode,	// 我在关系中的正式名称 code 
//	4: string taIsCode,	// 家人在关系中的正式 code
//	5: string callMe,	// 家人对我的爱称 如 小明
//	6: string callTa	// 我对家人的爱称 如 老爸
//}

/** 
*	家人相关服务
*/
// URL格式：http(s)://host(:port)/base/rpc/thrift/family-service.protocol
service FamilyService {
//	/** 
//	* @desc 添加家人关系
//	* @param 关系
//	* @exceptions     ae：鉴权例外，错误码参见例外类型定义。
//	*				  be：业务例外，1=不能重复添加家人
//	* 是否SSL：否
//    * 授权模式 DIGEST
// 	*/
//	void addFolk(1: xkcm.CommArgs commArgs,
//				 2: Relation relation)
//		 throws(1: xkcm.AuthException ae,
//                2: xkcm.BizException be)

    /**
    * @desc 更新与家人的关系爱称
    * @param folkId 家人的userId
    * @param callMe 家人对我的爱称 如 小明
    * @param callTa 我对家人的爱称 如 老爸
    * @exceptions     ae：鉴权例外，错误码参见例外类型定义。
	*				  be：业务例外，暂无
    * 是否SSL：否
    * 授权模式 DIGEST
    */
    void updateFolkNickname(1: xkcm.CommArgs commArgs,
    						2: string folkId,
				 			3: string callMe,	
							4: string callTa)
		 throws(1: xkcm.AuthException ae,
                2: xkcm.BizException be)
                
//    /** 
//	* @desc 注册并添加家人关系
//	* @param 关系
//	* @return 新建家人的phrCode
//	* @exceptions     ae：鉴权例外，错误码参见例外类型定义。
//	*				  be：业务例外，1=不能重复添加家人
//	* 是否SSL：否
//	* 授权模式 DIGEST
//	*	      1：电子邮箱格式不合法
//	*             2：电子邮箱已经被注册
//	*             3： 手机号格式不合法
//	*             4：手机号已经被注册
//	*             5：用户口令格式不合法
//	*             6：用户名格式不合法
//	*             7：邮箱、手机号、证件号码、卡号、帐号必填写一个                                      
//	*             8:此账号已被注册，请输入其他的账号 
//	*             9:昵称不能重复 
//	*   	      10:用户ID不存在
//	*    	      11:家人ID不存在
//	*    	      12:家庭成员ID不能为空
//	*    	      13:用户与家人关系代码不能为空
//	*    	      14:家人与用户关系代码不能为空
//	*    	      15:用户对家人的称呼不能为空
//	*    	      16:家人对用户的称呼不能为空
//	*    	      17:家人关系已存在
//	*    	      18:不能添加自己为家人
//	*    	      19:传入的关系不存在
//	*             20:操作失败
// 	*/
// 	string registerAndAddFolk(1: xkcm.CommArgs commArgs,
//                         2: string email,
//                         3: string mobileNum,
//                         4: string password,
//                         5: string userName,
//                         6: string account,
//                         7: Relation relation)
//         throws(1: xkcm.AuthException ae,
//                2: xkcm.BizException be)
}