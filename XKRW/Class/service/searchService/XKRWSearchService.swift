//
//  XKRWSearchService.swift
//  XKRW
//
//  Created by Klein Mioke on 15/6/25.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

private let sharedInstance = XKRWSearchService()

@objc enum XKRWSearchType: Int {
    case Sport = 0, Food
    case All = 1001
    
    func description() -> String {
        
        switch self {
        case .Sport:
            return "sport"
        case .Food:
            return "food"
        case .All:
            return "all"
        }
    }
}

class XKRWSearchService: XKRWBaseService {
   
    /// 单例
    class var sharedService: XKRWSearchService {
        return sharedInstance
    }
    
    func searchWithKey(key: String, type: XKRWSearchType, page: Int, pageSize: Int) -> [String: AnyObject] {
        
        self.saveSearchKey(key, type: type)
        
        let url = NSURL(string: kNewServer + kSearchURL)
        let param: [NSObject : AnyObject] = ["type": type.description(), "key": key, "page": page, "size": pageSize]
        
        var foodsArray = [XKRWFoodEntity]()
        var sportsArray = [XKRWSportEntity]()
        
        if let rst = self.syncBatchDataWith(url!, andPostForm: param)["data"] as? NSDictionary {
            
            if let foods = rst["food"] as? NSArray {
                
                for temp in foods {
                    
                    let entity = XKRWFoodEntity()
                    XKRWFoodService.shareService().dealFoodDictionary(temp as! [NSObject : AnyObject], inFoodEntity: entity)
                    
                    if entity.foodId != 0 {
                        foodsArray.append(entity)
                    }
                }
            }
            if let sports = rst["sport"] as? NSArray {
                
                for temp in sports {
                    
                    let entity = XKRWSportEntity()
                    XKRWSportService.shareService().dealSportDataWithDictionary(temp as! [NSObject : AnyObject], inEntity: entity)
                    
                    if entity.sportId != 0 {
                        sportsArray.append(entity)
                    }
                }
            }
        }
        return ["food": foodsArray, "sport": sportsArray]
    }
    /**
    保存搜索关键字
    
    - parameter key:  关键字
    - parameter type: 类型
    */
    func saveSearchKey(key: String, type: XKRWSearchType) -> Void {
        
        let path = self.getSearchKeysFilePathWithType(type)
        
        var keys = NSMutableArray(contentsOfFile: path)
        
        if keys == nil {
            keys = NSMutableArray(array: [key])
        } else {
            
            keys!.removeObject(key)
            keys!.insertObject(key, atIndex: 0)
        }
        keys!.writeToFile(path, atomically: false)
    }
    
    
    /**
    按type获取搜索关键字数组
    
    - parameter type: 搜索类型
    
    - returns: 关键字数组
    */
    func getSearchKeysByType(type: XKRWSearchType) -> NSMutableArray {
        
        let path = self.getSearchKeysFilePathWithType(type)
        
        let keys = NSMutableArray(contentsOfFile: path)
        
        if keys != nil {
            return keys!
        } else {
            return NSMutableArray()
        }
    }
    
    /**
    清空搜索关键字记录
    
    - parameter type: 搜索类型
    */
    func cleanSearchKeysByType(type: XKRWSearchType) -> Void {
        
        let path = self.getSearchKeysFilePathWithType(type)
        let keys = NSMutableArray()
        keys.writeToFile(path, atomically: true)
    }
    
    /**
    通过type获取关键字存储文件路径
    
    - parameter type: 搜索类型
    
    - returns: 文件路径
    */
    internal func getSearchKeysFilePathWithType(type: XKRWSearchType) -> String {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        
        if type == .Sport {
            let fileName = "key_sport_\(uid)"
            return XKRWFileManager.getFileFullPathWithName(fileName, inGroup: "SportGroup")
            
        } else if type == .Food {
            let fileName = "key_food_\(uid)"
            return XKRWFileManager.getFileFullPathWithName(fileName, inGroup: "FoodGroup")
        }
        return ""
    }
    
}
