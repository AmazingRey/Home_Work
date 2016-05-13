//
//  HPMealCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class HPMealCell: XKRWUITableViewCellbase {
    @IBOutlet var labCal: UILabel!
    @IBOutlet var labNodata: UILabel!
    @IBOutlet var labEat: UILabel!
    weak var entity: XKRWUserInfoShowEntity?
    
    func setCellContent(entity: XKRWUserInfoShowEntity) -> Void {
 
        self.entity = entity
//        if !entity.isRecordFood {
//            labNodata.hidden = false
//            labCal.hidden = true
//            labEat.hidden = true
//            labNodata.text = "ta今天没有饮食记录哦"
//        }else{
            labNodata.hidden = true
            labNodata.text = ""
            labCal.hidden = false
            labCal.text = "\(entity.lessEatCalories)kcal"
            labEat.hidden = false
//        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}