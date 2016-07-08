//
//  XKRWSchemeService_5_0.swift
//  XKRW
//
//  Created by XiKang on 15/5/29.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

private let sharedInstance = XKRWSchemeService_5_0()

private let SCHEME_TABLE = "scheme_5_0"
private let SCHEME_SPORT_TABLE = "scheme_sport"
private let FOOD_CATEGORY_TABLE = "food_category"

private let CACHE_DURATION: Int = 5

class XKRWSchemeService_5_0: XKRWBaseService {
    
    /// 单例
    class var sharedService: XKRWSchemeService_5_0 {
        return sharedInstance
    }
    /// 标示字符串，以"foodsid,foodsid+timeStamp"为格式存储
    var identifier: String? {
        get {
            let key = "scheme_key_\(XKRWUserService.sharedService().getUserId())"
            return NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
        }
        set {
            let key = "scheme_key_\(XKRWUserService.sharedService().getUserId())"
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    /// 运动方案id标识，“sportId”
    var sportIdentifier: String? {
        
        get {
            let key = "scheme_sport_key_\(XKRWUserService.sharedService().getUserId())"
            return NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
        }
        set {
            let key = "scheme_sport_key_\(XKRWUserService.sharedService().getUserId())"
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    //======================================
    //MARK: - Public Interface
    //======================================
    /**
    公共接口：获取饮食方案
    
    - returns: 方案实体数组
    */
    func getMealScheme() -> [XKRWSchemeEntity_5_0] {
        
        if self.identifier == nil {
            let entities = self.getMealSchemeFromRemoteWithSize(nil, type: nil, dropID: 0)
            var ids = ""
            for temp in entities {
                if ids.isEmpty {
                    ids += "\(temp.schemeID)"
                } else {
                    ids += ",\(temp.schemeID)"
                }
            }
            let timestamp = Int(NSDate().timeIntervalSince1970)
            self.identifier = "\(ids)+\(timestamp)"
            
            return entities
            
        } else {
            var array = self.identifier?.componentsSeparatedByString("+")
        
            if let timeStamp = Int((array!.last)!) {
                if timeStamp < Int(NSDate().offsetDay(-1).timeIntervalSince1970) {
                    // do clean
                    self.cleanSchemeAndFoodCategoryCacheWithTime()
                    // update identifier
                    self.identifier = "\(array![0])+\(timeStamp)"
                }
                // do search
                let idsStringArray = array![0].componentsSeparatedByString(",")
                var ids = [Int]()
                
                for i in 0 ..< idsStringArray.count   {
                    if let idNumber = Int(idsStringArray[i]) {
                        ids.append(idNumber)
                    }
                }
                
                let searchResult = self.searchMealSchemeWithIDs(ids)
                
                var entitiesArray = searchResult["entities"] as! [XKRWSchemeEntity_5_0]
                if searchResult["notFound"]!.count > 0 {
                    // do download and append
                    let download = self.getMealSchemeFromRemoteByIDs(searchResult["notFound"] as! [Int])
                    for entity in download {
                        entitiesArray.append(entity)
                    }
                }
                
                entitiesArray.sortInPlace({ (s1: XKRWSchemeEntity_5_0, s2: XKRWSchemeEntity_5_0) -> Bool in
                    s1.schemeType.rawValue < s2.schemeType.rawValue
                })
                
                for entity in entitiesArray {
                    
                    if entity.foodCategories.count == 0 {
                        let strings = entity.content.componentsSeparatedByString(",")
                        
                        var ids = [Int]()
                        
                        for sub in strings {
                            if let i = Int(sub) {
                                ids.append(i)
                            }
                        }
                        entity.foodCategories = self.getFoodCategoryFromDBWithIds(ids)
                    }
                }
                return entitiesArray
                
            } else {
                //TODO: error
                return []
            }
        }
    }
    /**
    公共接口：获取运动方案
    
    - returns: 方案实体对象
    */
    func getSportScheme(is_m:Int) -> XKRWSchemeEntity_5_0 {

        if let entity = self.getSportSchemeFromDB() {
            
            return entity
            
        } else {
            
            let entity =  self.getSportSchemeFromRemote(1,is_m: is_m)
            
            self.sportIdentifier = "\(entity.schemeID)"
            
            return entity
        }
    }
    
    
    /**
    公共接口：通过食物id批量获取食物详情
    
    - parameter ids: 食物id数组
    
    - returns: 食物实体对象数组x
    */
    func getBanFoodsWithIds(ids: [Int]) -> [XKRWFoodEntity] {
        //TODO: get ban foods
        
        var questIds: [Int] = []
        var returnValue = [XKRWFoodEntity]()
        
        for id in ids {
            
            let foodEntity = XKRWFoodService.shareService().getFoodWithId(id)
            
            if foodEntity.foodId == 0 {
                questIds.append(id)
            } else {
                returnValue.append(foodEntity)
            }
        }
        if !questIds.isEmpty {
            
            returnValue = self.getBanFoodsFromRemote(questIds)! + returnValue
        }
        
        return returnValue
    }
    
    
    /**
    公共接口：换一组功能, 使用之前需判断是否联网
    
    - parameter type: 方案类型
    - parameter size: 方案大小，1、2、3大、中、小、；可传nil，会默认查找该用户默认份量大小
    - parameter dropID: 防止重复、需要屏蔽的方案ID
    
    - returns: 新方案
    */
    func changeSchemeWithType(type: XKRWSchemeType, date: NSDate ,size: Int?, dropID: Int, otherInfo: [String: AnyObject]?) -> XKRWSchemeEntity_5_0 {
        
        if type == .Sport {
          
            let newScheme = self.getSportSchemeFromRemote(dropID, is_m: otherInfo?["is_m"] as? Int)
 
            self.sportIdentifier = "\(newScheme.schemeID)"
//            Date(date, type: RecordType.RecordSportScheme)
            if let entity = XKRWRecordService4_0.sharedService().getSchemeRecordWithDate(date, type: .SportScheme)
            {
                XKRWRecordService4_0.sharedService().deleteRecord(entity)
            }
            return newScheme
            
        } else {
            
            // download new scheme
            let newScheme = self.getMealSchemeFromRemoteWithSize(size, type: type, dropID: dropID).last!
            let loc = type.rawValue - 1
            
            // change identifier of user
            if var array = self.identifier?.componentsSeparatedByString("+").first?.componentsSeparatedByString(",") {
                
                let time = self.identifier!.componentsSeparatedByString("+").last!
                
                if array.count == 3 {
                    array[loc] = "\(newScheme.schemeID)"
                }
                
                self.identifier = (array as NSArray).componentsJoinedByString(",") + "+\(time)"
            }
            // delete scheme records if exist
            if let entity = XKRWRecordService4_0.sharedService().getSchemeRecordWithDate(date, type: .FoodScheme) {
                XKRWRecordService4_0.sharedService().deleteRecord(entity)
            }
            return newScheme
        }
    }
    
    //======================================
    //MARK: - Networking
    //======================================
    
    /**
    从服务器获取饮食方案
    
    - parameter size: 方案份量大小，传nil会自动查找用户数据中对应的份量
    - parameter type: 方案类型，早中晚选一，传nil会自动拉取三餐方案
    
    - returns: 方案实体对象数组
    */
    func getMealSchemeFromRemoteWithSize(var size: Int?, type: XKRWSchemeType?, dropID: Int) -> [XKRWSchemeEntity_5_0] {
        
        let urlString = kNewServer + kGetMealScheme
        let url = NSURL(string: urlString)
        if size == nil {
            // do get custom size
            size = XKRWAlgolHelper.getDailyIntakeSizeNumber()
        }
        let postForm = ["size": NSNumber(integer: size!), "drop": NSNumber(integer: dropID)] as NSMutableDictionary
        
        if type != nil {
            postForm.setValue(NSString(format:"%d", type!.rawValue), forKey: "type")
        }
        var result = self.syncBatchDataWith(url!, andPostForm: postForm as [NSObject : AnyObject])
       
        var returnValue = [XKRWSchemeEntity_5_0]()
        
        for dic in result["data"] as! NSArray {
            
            if dic.isKindOfClass(NSDictionary.classForCoder()) {
                
                let data = dic as! NSDictionary
                returnValue.append(self.dealMealSchemeData(data))
            }
        }
        return returnValue
    }
    /**
    根据id批量下载三餐方案
    
    - parameter ids: 方案id的数组
    
    - returns: 方案实体对象数组
    */
    func getMealSchemeFromRemoteByIDs(ids: [Int]) -> [XKRWSchemeEntity_5_0] {
        
        //TODO: get meal scheme by ids
        let url = NSURL(string: "\(kNewServer)\(kGetMealSchemeByIds)")
        
        var idsString = ""
        for id in ids {
            if idsString.isEmpty {
                idsString += "\(id)"
            } else {
                idsString += ",\(id)"
            }
        }
        let rst = self.syncBatchDataWith(url, andPostForm: ["ids": idsString]) as NSDictionary
        print(rst)
        var returnValue = [XKRWSchemeEntity_5_0]()
        
        for dic in rst["data"] as! NSArray {
         
            if dic.isKindOfClass(NSDictionary.classForCoder()) {
                
                let cookbook = dic as! NSDictionary
                returnValue.append(self.dealMealSchemeData(cookbook))
            }
        }
        return returnValue
    }
    /**
    根据id数组批量获取食物详情
    - parameter ids: 食物的id
    - returns: 食物对象数组
    */
    func getBanFoodsFromRemote(ids: [Int]) -> [XKRWFoodEntity]? {
        
        let url = NSURL(string: kNewServer + kGetBanFoods)
        
        var idsString: String = ""
        for num in ids {
            if idsString.isEmpty {
                idsString += "\(num)"
            } else {
                idsString += ",\(num)"
            }
        }
        let result = self.syncBatchDataWith(url, andPostForm: ["ids": idsString])
        
        let arr = result["data"] as! NSArray
        var returnValue = [XKRWFoodEntity]()
        
        for obj in arr {
            if obj.isKindOfClass(NSDictionary.classForCoder()) {
                let dict = obj as! NSDictionary
                let foodEntity = XKRWFoodEntity()
                XKRWFoodService.shareService().dealFoodDictionary(dict as [NSObject : AnyObject], inFoodEntity: foodEntity)
                
                returnValue.append(foodEntity)
            }
        }
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            self.batchSaveFoodEntity(returnValue)
        })
        return returnValue
    }
    /**
    从服务器获取运动方案
    
    - parameter dropID: ban掉得运动方案id，防止换一组之后出现重复的
    
    - returns: 运动方案实体对象
    */
    func getSportSchemeFromRemote(dropID: Int, is_m: Int?) -> XKRWSchemeEntity_5_0 {
        
        let url = NSURL(string: "\(kNewServer)\(kGetSportScheme)")
        
        var postForm = ["drop": dropID]
        
        if let is_m = is_m {
            postForm["is_m"] = is_m
        }
        let rst = self.syncBatchDataWith(url, andPostForm: postForm)
        
        if rst["data"]!.isKindOfClass(NSDictionary.self) {
            
            let data = rst["data"] as! NSDictionary
            let entity = XKRWSchemeEntity_5_0()
            
            if let desc = data["description"] as? String {
                entity.detail = desc
            } else {
                entity.detail = ""
            }
            entity.schemeID = Int((data["id"] as! String))!
            entity.schemeName = data["name"] as! String
            entity.schemeType = .Sport
            
            if let sports = data["params"] as? NSArray {
                
                var sportIds = ""
                
                for dic in sports {
                    let sport = dic as! NSDictionary
                    
                    let id = sport["sport_id"] as! String
                    if sportIds.isEmpty {
                        sportIds += id
                    } else {
                        sportIds += ",\(id)"
                    }
                    // do insert
                    self.saveSportSchemeDetail(sport, schemeid: entity.schemeID)
                }
                entity.content = sportIds
                
                // download sport detail with ids
                dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                    XKRWSportService.shareService().silenceBatchDownloadSportWithIDs(sportIds)
                })
            }
            self.saveSchemeToDB(entity)
            return entity
        }
        return XKRWSchemeEntity_5_0()
    }
    /**
    解析食物方案数据，传入网络返回的字典，转换成方案实体对象
    
    - parameter data: 网络数据
    
    - returns: 方案实体对象
    */
    func dealMealSchemeData(data: NSDictionary) -> XKRWSchemeEntity_5_0 {
    
        print(data)
        let scheme = XKRWSchemeEntity_5_0()
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        scheme.schemeID = (data["id"] as! NSString).integerValue
        scheme.schemeName = data["cookbook_name"] as! String
        scheme.calorie = (data["total_calory"] as! NSString).integerValue
        scheme.size = Int((data["meals_tag"] as! String))!
        scheme.schemeType = XKRWSchemeType(rawValue: (data["meals_type"] as! NSString).integerValue)!
        scheme.detail = data["description"] as! String
        scheme.content = data["foods"] as! String
        scheme.updateTime = timeStamp
        
        self.saveSchemeToDB(scheme)
        
        for foods in data["data"] as! NSArray {
            
            if foods.isKindOfClass(NSDictionary.classForCoder()) {
                let foodsDict       = foods as! [NSString: AnyObject]
                
                let calorie         = foodsDict["calory"]?.integerValue
                let weight          = foodsDict["weight"]?.integerValue
                let ban_foods_str   = foodsDict["ban_foods_str"] as! String
                let id              = foodsDict["id"]?.integerValue
                let food_pic        = foodsDict["food_pic"] as! NSArray
                let description     = foodsDict["description"] as! String
                let type            = foodsDict["type"] as! String
                let name            = foodsDict["name"] as! String
                let ban_foods       = foodsDict["ban_foods"] as! String
                
                let foodsEntity = XKRWFoodCategoryEntity()
                //TODO: 判断是否为nil，保证安全性
                foodsEntity.categoryName = name
                foodsEntity.calorie = calorie!
                foodsEntity.weight = weight!
                foodsEntity.banFoodsString = ban_foods_str
                foodsEntity.categoryId = id!
                foodsEntity.imgUrl = food_pic as! [String]
                foodsEntity.detail = description
                foodsEntity.type = type
                foodsEntity.banFoods = ban_foods
                foodsEntity.updateTime = timeStamp
                
                scheme.foodCategories.append(foodsEntity)
                self.saveFoodCategoryToDB(foodsEntity)
            }
        }
        return scheme
    }
    
    //======================================
    //MARK: - Local Operation
    //======================================
    /**
    保存方案详情到数据库, *****暂用于食物方案*****
    
    :attention: *****暂用于食物方案*****
    
    - parameter schemeEntity: 方案实体对象
    
    - returns: Bool值，是否成功
    */
    internal func saveSchemeToDB(schemeEntity: XKRWSchemeEntity_5_0) -> Bool {

        var success = false
        let sql = "REPLACE INTO \(SCHEME_TABLE) VALUES (?,?,?,?,?,?,?,?)"
        
        self.writeDefaultDBWithTask { (db, rollback) -> Void in
            if db.executeUpdate(sql, withArgumentsInArray: schemeEntity.getArgsArray()) {
                success = true
            }
        }
        return success
    }
    /**
    保存运动方案详情
    
    - parameter dict:     运动方案字典
    - parameter schemeid: 运动所属方案的方案id
     sportEnergy:1：大姨妈方案，0：非大姨妈方案
    */
    func saveSportSchemeDetail(dict: NSDictionary, schemeid: Int) -> Void {

        var sportid: Int = 0
        
        if dict["sport_id"] is String {
            sportid = Int((dict["sport_id"] as! String))!
        } else if dict["sport_id"] is NSNumber {
            sportid = (dict["sport_id"] as! NSNumber).integerValue
        }
        
        self.executeSqlWithDictionary("DELETE FROM \(SCHEME_SPORT_TABLE) WHERE sportId = \(sportid)", withParameterDictionary: nil)
        
        let sql = "REPLACE INTO \(SCHEME_SPORT_TABLE) VALUES (?,?,?,?,?,?,?)"
        
        self.writeDefaultDBWithTask { (db, rollback) -> Void in
            
            db.executeUpdate(sql, withArgumentsInArray: [dict["sport_mets"]!, dict["sport_id"]!, dict["sport_name"]!, schemeid, dict["anbilituijian"]!, dict["anshijiantuijian"]!, 0])
        }
    }
    
    
    func getCurrentSchemeSportEntities() -> [XKRWSportEntity] {
        
        if let scheme = self.getSportSchemeFromDB() {
            
            let schemeId = self.sportIdentifier ?? "0"
            let array = scheme.content.componentsSeparatedByString(",")
            
            var entitites = [XKRWSportEntity]()
            
            for tempId in array {
                
                let sport = XKRWSportService.shareService().sportDetailWithId(UInt32(Int(tempId)!))
                
                if sport.sportId == 0 {
                    continue
                }
                let sql = "SELECT sportScale, sportTime FROM scheme_sport WHERE schemeId = \(schemeId) AND sportId = \(tempId)"
                
                if let temp = self.query(sql) {
                    
                    if let rst = temp.lastObject as? NSDictionary {
                        
                        if rst["sportScale"] is Int {
                            sport.scale = rst["sportScale"] as! Int
                        } else if rst["sportScale"] is NSString {
                            sport.scale = (rst["sportScale"] as! NSString).integerValue
                        }
                        if rst["sportTime"] is NSString {
                            sport.sportTime =  UInt32((rst["sportTime"] as! NSString).integerValue)
                        } else if rst["sportTime"] is NSNumber {
                            sport.sportTime =  (rst["sportTime"] as! NSNumber).unsignedIntValue
                        }
                    }
                    entitites.append(sport)
                }
            }
            return entitites
        }
        return []
    }

    /**
    清空运动方案详情
    */
    func cleanSportSchemeDetail() -> Void {
    
        let delete = "DELETE FROM \(SCHEME_SPORT_TABLE)"
        self.writeDefaultDBWithTask { (db, rollback) -> Void in
            db.executeUpdate(delete, withArgumentsInArray: nil)
        }
    }
    /**
    删除运动方案
    
    - returns: 是否成功Bool
    */
    internal func deleteSportScheme() -> Bool {
        let sql = "DELETE FROM \(SCHEME_TABLE) WHERE type = 0"
        var success = false
        self.writeDefaultDBWithTask { (db, rollback) -> Void in
            if db.executeUpdate(sql, withArgumentsInArray: nil) {
                success = true
            }
        }
        return success
    }
    
    
    /**
    从数据库获取运动方案
    
    - returns: 运动方案实体
    */
    func getSportSchemeFromDB() -> XKRWSchemeEntity_5_0? {
        
        if let sid = self.sportIdentifier {
            let sql = "SELECT sid AS schemeID, name AS schemeName, type AS schemeType, size, total_calorie AS calorie, detail,  content, insert_date AS updateTime FROM \(SCHEME_TABLE) WHERE type = 0 AND sid = \(sid)"
            
            if let rst = self.query(sql) {
                
                let temp = rst.lastObject as! NSDictionary
                
                let entity = XKRWSchemeEntity_5_0()
                temp.setPropertiesToObject(entity)
                
                return entity
            }
        }
        return nil
    }
    
    
    /**
    保存食物类到数据库
    
    - parameter foodCategory: 食物类实体对象
    
    - returns: Bool值，是否成功
    */
    internal func saveFoodCategoryToDB(foodCategory: XKRWFoodCategoryEntity) -> Bool {
        
        var success = false
        let sql = "REPLACE INTO \(FOOD_CATEGORY_TABLE) VALUES (?,?,?,?,?,?,?,?,?,?)"
        
        self.writeDefaultDBWithTask { (db, rollback) -> Void in
            if db.executeUpdate(sql, withArgumentsInArray: foodCategory.getArgsArray()) {
                success = true
            }
        }
        return success
    }
    
    func getFoodCategoryFromDBWithIds(ids: [Int]) -> [XKRWFoodCategoryEntity] {
        
        var returnValue = [XKRWFoodCategoryEntity]()
        
        for id in ids {
            
            let sql = "SELECT category_id as categoryId, category_name as categoryName, calorie, weight, ban_foods_string as banFoodsString, ban_foods_ids as banFoods, type, img_url, detail, insert_date as updateTime FROM \(FOOD_CATEGORY_TABLE) WHERE category_id = \(id)"
            let rst = self.query(sql)
            
            if rst != nil {
                let dict = rst!.lastObject as! NSDictionary
                let entity = XKRWFoodCategoryEntity()
                (rst!.lastObject as! NSDictionary).setPropertiesToObject(entity)
                
                let data: NSData = dict["img_url"] as! NSData
                let array = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String]
                entity.imgUrl = array
                
                returnValue.append(entity)
            }
        }
        return returnValue
    }
    
    /**
    缓存下载下来的食物详情
    
    - parameter foods: 食物实体对象
    */
    func batchSaveFoodEntity(foods: [XKRWFoodEntity]) -> Void {
        
        for foodEntity in foods {
            
            XKRWFoodService.shareService().saveFoodCache(foodEntity.foodId, withData: NSKeyedArchiver.archivedDataWithRootObject(foodEntity))
            XKRWFoodService.shareService().saveFoodDetail(foodEntity)
        }
    }
    /**
    清除超过缓存时间的方案和食物类
    
    - returns: Bool，是否成功
    */
    internal func cleanSchemeAndFoodCategoryCacheWithTime() -> Bool {
        
        let timeStamp = Int(NSDate().offsetDay(-CACHE_DURATION).timeIntervalSince1970)
        
        let cleanScheme = "DELETE FROM \(SCHEME_TABLE) WHERE insert_date < \(timeStamp) AND type != 0"
        let cleanFoodCategory = "DELETE FROM \(FOOD_CATEGORY_TABLE) WHERE insert_date < \(timeStamp)"
        
        var success = 1
        self.writeDefaultDBWithTask { (db, rollback) -> Void in
            success = success * Int(db.executeUpdate(cleanFoodCategory, withArgumentsInArray: nil))
            success = success * Int(db.executeUpdate(cleanScheme, withArgumentsInArray: nil))
        }
        return Bool(success)
    }

    /**
    通过ids本地搜索食物方案
    
    - parameter ids: 食物方案的id数组
    
    - returns: 是个字典，自己点进来看。
    */
    internal func searchMealSchemeWithIDs(ids: [Int]) -> [String: [AnyObject]] {
    
        var entities = [XKRWSchemeEntity_5_0]()
        var notFound = [Int]()
        
        for id in ids {
            let sql = "SELECT sid AS schemeID, name AS schemeName, type AS schemeType, size, total_calorie AS calorie, detail, insert_date AS updateTime, content FROM \(SCHEME_TABLE) WHERE sid = \(id) AND type != 0"
            
            if let entityDic = self.query(sql) {
                
                let temp = entityDic.lastObject as! NSDictionary
                let entity = XKRWSchemeEntity_5_0()
                temp.setPropertiesToObject(entity)
                
                entities.append(entity)
            } else {
                notFound.append(id)
            }
        }
        return ["entities": entities, "notFound": notFound]
    }
    
    func needShowTipsInHistoryAndProgress() -> Bool {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        
        if let need = NSUserDefaults.standardUserDefaults().objectForKey("\(uid)_TIP_IN_HP") as? NSNumber {
            return need.boolValue
        } else {
            return true
        }
    }
    
    func setNeedShowTipsInHistoryAndProgress(need: Bool) -> Void {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        
        NSUserDefaults.standardUserDefaults().setObject(NSNumber(bool: need), forKey: "\(uid)_TIP_IN_HP")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func needShowTipsInMealAnalyze() -> Bool {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        
        if let need = NSUserDefaults.standardUserDefaults().objectForKey("\(uid)_TIP_IN_MEAL_ANALYZE") as? NSNumber {
            return need.boolValue
        } else {
            return true
        }
    }
    
    func setNeedShowTipsInMealAnalyze(need: Bool) -> Void {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        
        NSUserDefaults.standardUserDefaults().setObject(NSNumber(bool: need), forKey: "\(uid)_TIP_IN_MEAL_ANALYZE")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //======================================
    //MARK: - Fix functions
    //======================================
    
    func v5_0_schemeRecordsFixment() -> Bool {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        
        if self.needFixWithUID(uid, version: "5.0") {
            
            // do request
            if XKRWUserService.sharedService().getUserFlagWithType(UserFlag.TransferSchemeData) {
                self.setNeedFixWithUID(uid, version: "5.0", needFix: false)
                return true
            }
            
            // download all records
            if !XKRWRecordService4_0.sharedService().downloadAllRecords() {
                return false
            }
            
            // search and group
            var schemes: [XKRWRecordSchemeEntity] = []
            
            if !self.isSchemeDataTransferCompleteV5() {
                
                // foods
                var sql = "select sum(calorie) as `cal_total`, `record_type`, `date` from food_record where uid = \(uid) and record_type != 4 group by record_type, date"
                var rst = self.query(sql)
                
                if rst != nil {
                    for temp in rst! {
                        if temp is NSDictionary {
                            let dict = temp as! NSDictionary
                            let dateString = dict["date"] as! String
                            let entity = XKRWRecordSchemeEntity()
                            entity.calorie = dict["cal_total"] as! Int
                            entity.type = RecordType(rawValue: dict["record_type"] as! Int)!
                            entity.date = NSDate(fromString: dateString, withFormat: "yyyy-MM-dd")
                            entity.create_time = Int(entity.date.timeIntervalSince1970) + entity.type.rawValue
                            
                            entity.sync = 1;
                            
                            let recomandCalorie = XKRWAlgolHelper.dailyIntakeRecomEnergyOfDate(entity.date)
                            
                            var compare: Float = 0
                            
                            switch entity.type {
                            case .Breakfirst:
                                compare = 0.3
                            case .Lanch:
                                compare = 0.5
                            case .Dinner:
                                compare = 0.2
                            default:
                                break
                            }
                            if entity.calorie > Int(compare * recomandCalorie) {
                                entity.record_value = 4
                            } else {
                                entity.record_value = 3
                            }
                            schemes.append(entity)
                        }
                    }
                }
                
                // sports
                sql = "select sum(calorie) as `cal_total`, `date` from sport_record where uid = \(uid) group by date"
                rst = self.query(sql)
                
                if rst != nil {
                    for temp in rst {
                        if temp is NSDictionary {
                            
                            let dict = temp as! NSDictionary
                            let dateString = dict["date"] as! String
                            let entity = XKRWRecordSchemeEntity()
                            
                            entity.calorie = dict["cal_total"] as! Int
                            entity.type = RecordType.Sport
                            entity.date = NSDate(fromString: dateString, withFormat: "yyyy-MM-dd")
                            entity.create_time = Int(entity.date.timeIntervalSince1970) + entity.type.rawValue
                            entity.record_value = 3
                            
                            entity.sync = 1;
                            
                            schemes.append(entity)
                        }
                    }
                }
                // insert to db
                var insertSuccess = false
                
                if schemes.count > 100 {
                    
                    let count = schemes.count / 100
                    
                    for var i = 0; i <= count; i += 1 {
                        
                        var len: Int = 100
                        if i == count {
                            len = schemes.count % 100
                        }
                        let save = (schemes as NSArray).subarrayWithRange(NSMakeRange(i * 100, len))
                        
                        insertSuccess = XKRWRecordService4_0.sharedService().batchSaveSchemeRecordsToDB(save)
                    }
                } else {
                    insertSuccess = XKRWRecordService4_0.sharedService().batchSaveSchemeRecordsToDB(schemes)
                }
                if insertSuccess {
                    self.setSchemeDataTransferCompleteV5(true)
                }
                
            } else {
                
                let sql = "select * from record_scheme where uid = \(uid)"
                let rst = self.query(sql)
                
                if rst != nil {
                    for temp in rst {
                        if temp is NSDictionary {
                            
                            let dict = temp as! NSDictionary
                            let entity = XKRWRecordSchemeEntity()
                            dict.setPropertiesToObject(entity)
                            
                            if entity.create_time != 0 {
                                schemes.append(entity)
                            }
                        }
                    }
                }
            }
            // upload to server
            XKRWRecordService4_0.sharedService().batchSaveRecordToRemoteWithEntities(schemes, type: "scheme", isImport: true)
            
            // update mark in local
            self.setNeedFixWithUID(uid, version: "5.0", needFix: false)
            
            return true
        }
        return true
    }
    
    func needFixWithUID(uid: Int, version: String) -> Bool {
        
        let key = "SCHEME_FIX_\(version)_\(uid)"
        
        if let value: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(key) {
            if value is Bool {
                return value as! Bool
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func setNeedFixWithUID(uid: Int, version: String, needFix: Bool) -> Void {
        
        let key = "SCHEME_FIX_\(version)_\(uid)"
        NSUserDefaults.standardUserDefaults().setObject(needFix, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func isSchemeDataTransferCompleteV5() -> Bool {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        let key = "SCHEME_DATA_TRANSFERED_\(uid)"
        
        if let value: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(key) {
            if value is Bool {
                return value as! Bool
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func setSchemeDataTransferCompleteV5(complete: Bool) -> Void {
        
        let uid = XKRWUserDefaultService.getCurrentUserId()
        let key = "SCHEME_DATA_TRANSFERED_\(uid)"
        
        NSUserDefaults.standardUserDefaults().setObject(complete, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    func resetUserScheme(vc:XKRWBaseVC){
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "needResetScheme_\(XKRWUserService.sharedService().getUserId())")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "lateToResetScheme_\(XKRWUserService.sharedService().getUserId())")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        vc.downloadWithTaskID("restSchene") { () -> AnyObject! in
            return XKRWUserService.sharedService().resetUserAllDataByToken()
        }
    }
    
    func dealResetUserScheme(vc:XKRWBaseVC){
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "DailyIntakeSize")
        NSUserDefaults.standardUserDefaults().synchronize()
        XKRWUserService.sharedService().deleteDBDataByUser()
        vc.downloadWithTask { () -> Void in
            XKRWRecordService4_0.sharedService().resetUserRecords()
        }
    }

    //======================================
    // MARK: - Utils 工具
    //======================================
    
    class func getDescriptionBySize(size: Int) -> String {
        
        switch size {
        case 1:
            return "大份"
        case 2:
            return "中份"
        case 3:
            return "小份"
        default:
            break
        }
        return ""
    }
    
    //======================================
    // MARK: - Internal functions 内测功能
    //======================================
    
    // Will not creat function In ObjC
    func getTuple() -> (String, String) {
        
        return ("string", "string 2")
    }
}