//
//  HPPredictCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/7/17.
//  Copyright (c) 2015年 XiKang. All rights reserved.
//

import UIKit

class HPPredictCell: UITableViewCell {


    @IBOutlet weak var loseWeightLabel: UILabel!
    @IBOutlet weak var nonDataLabel: UILabel!
    
    func setContent(entity: XKRWUserInfoShowEntity) -> Void {
        if entity.lossWeight <= 0 {
            self.loseWeightLabel.text = "0g"
        }else{
            self.loseWeightLabel.text = "\(entity.lossWeight)g"
        }
        self.loseWeightLabel.hidden = false
        self.nonDataLabel.hidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
