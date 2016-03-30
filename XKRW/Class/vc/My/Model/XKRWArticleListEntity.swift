//
//  XKRWArticleListEntity.swift
//  XKRW
//
//  Created by 忘、 on 15/10/10.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWArticleListEntity: NSObject {
    //  头像URL
    var headImageUrl:String = ""
    //  文章ID
    var blogId:String = ""
    // 封面图片URL
    var coverImageUrl:String = ""
    // 封面图片是否可用
    var coverEnabled:Int = 1
    // 创建时间
    var createTime:Int = 0
    // 被赞数
    var bePraisedNum:Int = 0
//   最后被赞的时间
    var praisedTime:Int = 0
    // 用户等级图片URL
    var userDegreeImageUrl:String = ""
    // 宣言
    var manifesto:String = ""
    // 昵称
    var userNickname:String = ""
    //  文章是否被删除
    var articleState:XKRWUserArticleStatus = .Draft
    //  文章是否被推荐
    var recommendState:XKRWUserArticleStatus = .Unrecommended
    // 标题
    var title:String = ""
    // 文章浏览数
    var articleViewNums:Int = 0
    // 话题
    var topic: XKRWTopicEntity?
    
}
