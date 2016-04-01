//
//  XKRWOperationArticleListEntity.swift
//  XKRW
//
//  Created by 忘、 on 16/1/27.
//  Copyright © 2016年 XiKang. All rights reserved.
//

import UIKit

class XKRWOperationArticleListEntity: NSObject {
    
    /** 文章星星显示状态 */
    var starState:Int = 0
    /** 文章id */
    var nid:String?
    /** 文章标题 */
    var title:String?
    /** 文章更新时间 */
    var updateTime:String?
    /** 文章日期 */
    var date:String!
    /** 文章阅读量 */
    var pv:Int = 0
    /** 文章展示的模板 */
    var showType:String?
    /** 文章小图URL */
    var smallImageUrl:String?
    /** 文章大图URL */
    var bigImageUrl:String?
    /** 文章分享出去的地址 */
    var url:String?
    
    /// 答题 && 宣誓-------------------------------------
    
    /** 答案选项 */
    var field_answers_value:String?
    /** 问题 */
    var field_question_value:String?
    /** 正确答案 */
    var field_zhengda_value:NSNumber?
    /** 星数 */
    var star:NSNumber?
    

}
