//
//  XKRWFoodCategoryEntity.swift
//  XKRW
//
//  Created by Klein Mioke on 15/6/11.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWFoodCategoryEntity: NSObject {
    /// 分类id
    var categoryId: Int = 0
    /// 食物类名称
    var categoryName: String = String()
    /// 卡路里范围
    var calorie: Int = 0
    /// 重量
    var weight: Int = 0
    /// 禁忌食物字符串
    var banFoodsString: String = String()
    /// 类型
    var type: String = String()
    /// 禁忌食物id组合，以“,”隔开
    var banFoods: String = String()
    /// 图片URL
    var imgUrl: [String] = [String]()
    /// 详情
    var detail: String = String()
    /// 更新时间
    var updateTime: Int = 0

    override init() {
        super.init()
    }
    
    func getArgsArray() -> [AnyObject] {
        return [categoryId, categoryName, calorie, weight, banFoodsString, banFoods, type, NSKeyedArchiver .archivedDataWithRootObject(imgUrl), detail, updateTime]
    }
}
