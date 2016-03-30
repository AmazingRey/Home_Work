//
//  XKRWUserPostEntity.swift
//  XKRW
//
//  Created by 忘、 on 16/1/18.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserPostEntity: NSObject {
    
    /// 帖子内容
    var textContent :String?
    /// 帖子内容中的原图图片数组
    var originalImages: [UIImage] = []
    /// 图片路径，对应content中的imgKey的内容，用于上传图片和出错后的续传
    var imagePath: [String] = []

    /// 帖子GroupID
    var postGroupID :String?
    
    /// 帖子标题
    var postTitle :String?
    
    /// 是否是求助贴
    var helpPost :String?
    
    ///帖子ID
    var postID:String?
    /// 帖子群组名
    var postGroupName:String?
    /// 帖子的创建时间
    var postCreatTime = 0
    /// 分享的帖子URL
    var sharePostUrl :String?
    /// 帖子的被阅读数
    var postViewNums = 0
    /// 帖子被赞数
    var postBePraise = 0
    /// 是否被赞过
    var isThumpUp = false
    
    /// 是否是求助帖
    var isHelpPost = false
    /// 是否是精华帖
    var isEssencePost = false
    /// 是否被置顶
    var isTopPost = false
    /// 用户头像URL
    var userHeadUrl:String?
    /// 用户昵称
    var userName:String?
    /// 用户宣言
    var userManifesto:String?
    /// 用户等级URL
    var levelUrl:String?
    // 用户是否已经加入帖子
    var groupUserJoin:Bool = false
    
    /// 状态
    var status: XKRWPostStatus = .Draft

    func checkComplete() -> Bool {
        if self.postTitle!.length < 1 {
            XKRWCui.showInformationHudWithText("请输入标题")
            return false
        }
        if self.textContent!.length < 6 {
            XKRWCui.showInformationHudWithText("内容不能少于六个字")
            return false
        }
        return true
    }


}


