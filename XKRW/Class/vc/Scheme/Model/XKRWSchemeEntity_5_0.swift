//
//  XKRWSchemeEntity_5_0.swift
//  XKRW
//
//  Created by Klein Mioke on 15/6/11.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit
/**
方案类型

- Breakfast:                  早餐
- Lunch:                      午餐
- Dinner:                     晚餐
- Snack:                      加餐 *Not Used in version 5.0
- Sport:                      运动
*/
@objc enum XKRWSchemeType: Int {
    
    case Breakfast = 1, Lunch, Dinner, Snack
    case Sport = 0
    
    func getDescription() -> String {
        switch self {
        case .Breakfast:
            return "早餐"
        case .Lunch:
            return "午餐"
        case .Dinner:
            return "晚餐"
        case .Snack:
            return "加餐"
        case .Sport:
            return "运动"
        }
    }
}

class XKRWSchemeEntity_5_0: NSObject {
    /**
    *  方案ID
    */
    var schemeID: Int = 0
    /**
    *  方案名称
    */
    var schemeName: String = ""
    /**
    *  方案类型
    */
    var schemeType: XKRWSchemeType = .Snack
    /**
    *  份量大小
    */
    var size: Int = 0
    /**
    *  卡路里
    */
    var calorie: Int = 0
    /**
    *  包含的食物类
    */
    var foodCategories: [XKRWFoodCategoryEntity] = []
    /**
    *  详情
    */
    var detail: String = ""
    /**
    *  包含的食物类id字符串，以","连接
    */
    var content: String = ""
    /**
    *  更新时间
    */
    var updateTime: Int = 0
    
    convenience init(argsDictionary: [String: AnyObject]) {
        self.init()
        
    }
    
    func getArgsArray() -> [AnyObject] {
        return [schemeID, schemeType.rawValue, schemeName, size, calorie, detail, content, updateTime]
    }

}
