//
//  XKRWUserHonorEnity.swift
//  XKRW
//
//  Created by 忘、 on 15/10/9.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWUserHonorEnity: NSObject {
    
    //下一等级荣誉URL
    var nextDegree:String = ""
    
    //当前等级荣誉URL
    var nowDegree:String = ""

    //当前等级已完成的进度
    var nowDegreeProgress:Double = 0.0
    //  当前经验值
    var nowExperience:NSInteger = 0
    //  下一等级所必须达到的经验值
    var nextDegreeExperience:NSInteger = 0
    
    var isMax:Bool = false
}
