//
//  XKRWPraiseAndCommitNoticeEntity.swift
//  XKRW
//
//  Created by 忘、 on 15/10/19.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWPraiseAndCommitNoticeEntity: NSObject {
    //头像
    var avater = ""
    //博客ID
    var blogId = ""
    // 评论ID  点赞ID
    var comment_id  = 0
    // 用户等级图片
    var userDegreeUrl = ""
    // 昵称
    var nickName = ""
    // 是否已读
    var read = 0
    // 评论内容
    var content = ""
    //  时间
    var time = ""
    //  点赞  还是 评论的类型
    var type = 0
    //  消息ID
    var nid = 0
    //  MD5 id
    var md5Id = ""
    
}
