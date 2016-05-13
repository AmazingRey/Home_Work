//
//  XKRWUserInfoShowEntity.swift
//  XKRW
//
//  Created by 忘、 on 15/10/14.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserInfoShowEntity: NSObject {
    
    // MARK: user info
    
    var address: String = ""
    
    /// 年纪
    var age   = 0
    /// 头像
    var avatar = ""
    /// 生日
    var birthday = ""
    
    var crowd_type: XKGroup = eGroupDay
    
    /// 坚持天数
    var daily: Int = 0
    
    var date_add: String = ""
    
    var date_reset = ""
    
    var date_upd = ""
    
    var disease_type = ""
    
    var accountName = ""
    
    var slim_qa: String = ""
    
    /// 性别
    var sex: XKSex = eSexFemale
    
    /// 身高
    var height = 0
    /// 体力活动水平
    var labor_level : XKPhysicalLabor = eLight
    /// 宣言
    var manifesto = ""
    /// 昵称
    var nickname = ""
    
    var weight: Float = 0
    
    // MARK: 荣誉相关
    
    /// 文章数目
    var blognum = 0
    /// 帖子数
    var post_num = 0
    /// 当前等级
    var level = ""
    /// 喜欢数
    var thumpUpNum = 0
    /// 喜欢的帖子数
    var post_send = 0
    /// 被喜欢数
    var bePraisedNum = 0
    /// 背景图
    var backgroundUrl = ""
    /// 星星数
    var starNum = 0
    // 大的头像
    var avatar_hd = ""
    
    var oldRecordEntity: XKRWRecordEntity4_0 = XKRWRecordEntity4_0()
    
    var schemeReocrds: [XKRWRecordSchemeEntity] = []
    
    func checkInfoComplete() -> Bool {
        if self.weight < 1 || self.birthday.isEmpty || self.slim_qa.isEmpty || self.height < 1 || self.age == 0 {
            return false
        }
        return true
    }
    
    //是否记录
    var isRecordFood = false
    var isRecordSport = false
    var isRecord = false
    //预计瘦  克
    var lossWeight = 0
    //少吃了  卡路里
    var lessEatCalories = 0
    //运动消耗了多少 卡路里
    var sportCalories = 0
    //运动详情 初始化
    var sportArray = []
}
