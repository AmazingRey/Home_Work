//
//  XKRWHistoryAndProcessModel.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/16.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

enum HPState: Int {
    case Show = 1, ToRecord
}

enum HPTag: Int {
    case None = 0
    case Perfect = 1, Bad, Other
}

class XKRWHistoryAndProcessModel: NSObject {
    
    var needShowTip: Bool? {
        get {
            let key = "HP_SHOW_TIP_\(XKRWUserDefaultService.getCurrentUserId())"
            return NSUserDefaults.standardUserDefaults().objectForKey(key) as? Bool
        }
        set {
            let key = "HP_SHOW_TIP_\(XKRWUserDefaultService.getCurrentUserId())"
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    weak var oldRecord: XKRWRecordEntity4_0?
    
    var breakfast: XKRWRecordSchemeEntity?
    var lunch: XKRWRecordSchemeEntity?
    var dinner: XKRWRecordSchemeEntity?
    var sport: XKRWRecordSchemeEntity?
    
    
    var isToday: Bool = false
    var haveOtherRecord: Bool = false
   
    var summaryTitle: String?
    var canModified: Bool = true
    
    var isShowPredictView: Bool = false
    var predictLoseWeight: String?
    var predictAttention: String?
    
    var intakeCalorie: Int = 0
    var recomandCalorie: Int = 0
    /// 吃了别的的餐次所推荐的热量总值
    var otherIntakeMaxCalorie: Int = 0
    /// 吃了别的的总热量值
    var otherIntakeCalorie: Int = 0
    
    var mealState: HPState?
    var mealTag: HPTag?
    var isShowMealAnalysis: Bool = true//false
    
    var costCalorie: Int = 0
    var sportState: HPState?
    var sportTag: HPTag?
    var sportPercentage: Float?
    
    var numOfHabit: Int = 0
    var amendNumOfHabit: Int = 0
    var habitTag: HPTag?
    
    var nutriPersentage: NSDictionary?
    
    var isSelf: Bool                = true
    lazy var BM: Float              = 0.0
    lazy var PAL: Float             = 0.0
    lazy var sex: XKSex             = eSexFemale
    lazy var age: Int               = 0
    lazy var labor: XKPhysicalLabor = eLight
    
    func dealWithSchemeRecords(inout schemeRecords: [XKRWRecordSchemeEntity],inout oldRecord: XKRWRecordEntity4_0) -> Void {
        
//        assert(!isSelf && BM > 0 && PAL > 0 && age > 0, "view model assert failed")
        
        self.oldRecord = oldRecord
        
        self.isShowMealAnalysis = true//false
        self.mealTag = .Perfect
        self.sportTag = .Perfect
        self.haveOtherRecord = false
        
        self.otherIntakeMaxCalorie = 0
        self.otherIntakeCalorie = 0
        
        func dealDetailInfoWithSchemeRecords(schemeRecords: [XKRWRecordSchemeEntity], oldRecord: XKRWRecordEntity4_0) -> Void {
            
            var totalCalorie: Float = 0
            var sportCost: Float = 0
            
            var recomandCalorie: Float
            if self.isSelf {
                recomandCalorie = XKRWAlgolHelper.dailyIntakeRecomEnergyOfDate(oldRecord.date)
            } else {
                recomandCalorie = XKRWAlgolHelper.dailyIntakeRecommendEnergyWithBM(BM, PAL: PAL, sex: sex, age: age)
            }
            var recomandCalorieRange = recomandCalorie
            
            //当出现三个完美的时候才用这个推荐值
            
            if self.breakfast?.record_value == 2&&self.lunch?.record_value == 2&&self.dinner?.record_value == 2{
                if recomandCalorie <= 1400 {
                    recomandCalorieRange = 1400
                } else if recomandCalorie <= 1800 {
                    recomandCalorieRange = 1800
                } else {
                    recomandCalorieRange = 2200
                }
            }
            
            self.recomandCalorie = Int(recomandCalorie)
            
            var noneNum = 0
            for entity in schemeRecords {
                
                switch (entity.record_value, entity.type) {
                case (0, let x):
                    if x == .Sport {
                        self.sportTag = HPTag.None
                    } else {
                        noneNum += 1
                        if self.mealTag != .Bad {
                            self.mealTag = HPTag.Other
                        }
                    }
                case (1, let x):
                    
                    if x == .Sport {
                        self.sportTag = .Bad
                    } else {
                        if self.mealTag != .Bad {
                            self.mealTag = HPTag.Other
                        }
                    }
                case (2, let x):
                    if x == .Sport {
                        sportCost = Float(entity.calorie)
                    } else if x == .Breakfirst {
                        totalCalorie += recomandCalorieRange * 0.3
                    } else if x == .Lanch {
                        totalCalorie += recomandCalorieRange * 0.5
                    } else if x == .Dinner {
                        totalCalorie += recomandCalorieRange * 0.2
                    }
                case (3, let x):
                    if x == .Sport {
                        
                        if entity.calorie != 0 {
                            sportCost = Float(entity.calorie)
                        } else {
                            sportCost = 0
                            for temp in oldRecord.SportArray {
                                if temp is XKRWRecordSportEntity {
                                    let entity = temp as! XKRWRecordSportEntity
                                    sportCost += Float(entity.calorie)
                                }
                            }
                        }
                        self.sportTag = .Other
                    } else {
                        if self.mealTag == nil || self.mealTag != .Bad {
                            
                            self.mealTag = HPTag.Other
                        }
                        totalCalorie += Float(entity.calorie)
                        
                        self.otherIntakeCalorie += entity.calorie
                        self.otherIntakeMaxCalorie += Int(CGFloat(recomandCalorie) * XKRWAlgolHelper.getSchemeRecomandDietScaleWithType(entity.type))
                        
                        self.isShowMealAnalysis = true
                        self.haveOtherRecord = true
                    }
                case (4, _):
                    self.mealTag = HPTag.Bad
                    self.isShowMealAnalysis = true
                    
                    self.otherIntakeCalorie += entity.calorie
                    self.otherIntakeMaxCalorie += Int(CGFloat(recomandCalorie) * XKRWAlgolHelper.getSchemeRecomandDietScaleWithType(entity.type))
                    
                    totalCalorie += Float(entity.calorie)
                    self.haveOtherRecord = true
                case (5, _):
                    self.mealTag = HPTag.Bad
                    totalCalorie += Float(entity.calorie)
                default:
                    break
                }
            }
            
            if noneNum == 3 {
                self.mealTag = HPTag.None
            }
            
            if self.mealTag != .Bad {
                
                var intakeValue: Float
                if isSelf {
                    intakeValue = XKRWAlgolHelper.dailyIntakEnergy()
                } else {
                    intakeValue = XKRWAlgolHelper.dailyIntakEnergyWithBM(BM, PAL: PAL)
                }
                var predictLosing = CGFloat(intakeValue - totalCalorie + sportCost) / CGFloat(7.7)
                if predictLosing < 0 {
                    predictLosing = 0
                }
                self.predictLoseWeight = String(format: "%0.1fg", predictLosing)
            } else {
                self.predictLoseWeight = "0g"
            }
            
            self.intakeCalorie = Int(totalCalorie)
            self.costCalorie = Int(sportCost)
            
            var sportRecomand: Float
            if isSelf {
                sportRecomand = Float(XKRWAlgolHelper.dailyConsumeSportEnergy())
            } else {
                sportRecomand = Float(XKRWAlgolHelper.dailyConsumeSportEnergyWithPhysicalLabor(labor, BM: BM, PAL: PAL, sex: sex))
            }
            
            if self.sportTag == .Perfect {
                self.sportPercentage = 1
                
            } else if self.sportTag == .Bad && self.sportTag == .None {
                self.sportPercentage = 0
                
            } else {
                if sportRecomand == 0 {
                    if sportCost > 0 || self.sportTag != .Bad {
                        self.sportPercentage = 1
                    } else {
                        self.sportPercentage = 0
                    }
                } else {
                    self.sportPercentage = Float(sportCost) / sportRecomand
                    
                    if self.sportPercentage > 1 {
                        self.sportPercentage = 1
                    }
                }
            }
        }
        
        self.isToday = oldRecord.date.isDayEqualToDate(NSDate())
        
        // MARK: Cannot modify the data of two days ago
        if self.isToday || oldRecord.date.originTimeOfADay() < NSDate().offsetDay(-2).originTimeOfADay() {
            self.canModified = false
        } else {
            self.canModified = true
        }
        
        if self.isToday {
            self.isShowPredictView = true
        } else {
            self.isShowPredictView = false
        }
        
        self.nutriPersentage = XKRWRecordService4_0.sharedService().getFatProteinCarbohydrate(oldRecord.date)
        
        var mealSchemes: [XKRWRecordSchemeEntity] = []
        
        self.sport      = nil
        self.breakfast  = nil
        self.lunch      = nil
        self.dinner     = nil
        
        for entity in schemeRecords {
            
            switch entity.type {
            case .Sport:
                self.sport = entity
            case .Breakfirst:
                self.breakfast = entity
            case .Lanch:
                self.lunch = entity
            case .Dinner:
                self.dinner = entity
            default:
                break
            }
            if entity.type != .Sport {
                mealSchemes.append(entity)
            }
        }
        
        if !self.isToday {
            
            let timeStamp = Int(oldRecord.date.timeIntervalSince1970)
            
            if self.sport == nil {
                
                let entity = XKRWRecordSchemeEntity()
                entity.type = .Sport
                entity.create_time = timeStamp + 100
                
                self.sport = entity
                schemeRecords.append(self.sport!)
            }
            
            if self.dinner == nil {
                
                let entity = XKRWRecordSchemeEntity()
                entity.type = .Dinner
                entity.create_time = timeStamp + 101
                
                self.dinner = entity
                schemeRecords.append(self.dinner!)
            }
            
            if self.breakfast == nil {
                
                let entity = XKRWRecordSchemeEntity()
                entity.type = RecordType.Breakfirst
                entity.create_time = timeStamp + 102
                
                self.breakfast = entity
                schemeRecords.append(self.breakfast!)
            }
            
            if self.lunch == nil {
                
                let entity = XKRWRecordSchemeEntity()
                entity.type = .Lanch
                entity.create_time = timeStamp + 103
                
                self.lunch = entity
                schemeRecords.append(self.lunch!)
            }
        }
        
        self.predictAttention = ""
        if mealSchemes.count == 0 {
            
//            self.isShowMealAnalysis = false
            self.isShowMealAnalysis = true
            self.mealState = HPState.ToRecord
            self.mealTag = HPTag.None
            dealDetailInfoWithSchemeRecords(schemeRecords, oldRecord: oldRecord)
            
            self.predictLoseWeight = "??g"
            
        } else if mealSchemes.count < 3 {
            
            self.mealTag = .Other
            
            dealDetailInfoWithSchemeRecords(schemeRecords, oldRecord: oldRecord)
            self.mealState = HPState.Show
            self.predictAttention = "三餐不合理会降低减肥效率"
            
        } else if mealSchemes.count == 3 {
            dealDetailInfoWithSchemeRecords(schemeRecords, oldRecord: oldRecord)
            self.mealState = HPState.Show
            
            for record in mealSchemes {
                if record.record_value == 1 || record.record_value == 0 {
                    self.predictAttention = "三餐不合理会降低减肥效率"
                    break
                }
            }
        }
        
        if self.sport == nil {
            
            if self.isToday {
                self.sportState = HPState.ToRecord
            } else {
                self.sportState = .Show
            }
            self.sportTag = HPTag.None
        } else {
            self.sportState = HPState.Show
        }
        
        self.numOfHabit = oldRecord.habitArray.count
        
        var amended: Int = 0
        for temp in oldRecord.habitArray {
            if temp is XKRWHabbitEntity {
                let entity = temp as! XKRWHabbitEntity
                if entity.situation == 1 {
                    amended++
                }
            }
        }
        self.amendNumOfHabit = amended
        
        if self.numOfHabit == 0 {
            self.habitTag = .Perfect
        } else if self.amendNumOfHabit == 0 {
            self.habitTag = HPTag.Bad
        } else if self.amendNumOfHabit < self.numOfHabit {
            self.habitTag = HPTag.Other
        } else {
            self.habitTag = HPTag.Perfect
        }
        
        if self.habitTag == .Perfect && self.sportTag == .Perfect && self.mealTag == .Perfect {
            self.summaryTitle = "今天的行动为你的瘦身历程画上完美的一笔，再接再厉"
            
        } else if self.mealTag == .Bad || self.sportTag == .Bad || self.habitTag == .Bad {
            self.summaryTitle = "瘦身的拦路虎随时会出现，你可以克服的！加油！"
            
        } else {
            self.summaryTitle = "今天的行为可圈可点，明天你可以更完美的！加油！"
        }
    }
}
